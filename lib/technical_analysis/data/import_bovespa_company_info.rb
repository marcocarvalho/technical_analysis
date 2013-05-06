require 'logger'
require 'nokogiri'
require 'open-uri'

class ImportBovespaCompanyInfo
  attr_reader :options, :companies

  def initialize(companies, opts = {})
    @companies = companies
    @options = { verbose: true, logger: STDOUT }.merge opts
  end

  def verbose
    @options[:verbose]
  end

  def log(message, opts = {})
    severity = opts[:severity] || :info
    logger.send(severity, message)
  end

  def logger
    @logger ||= Logger.new(options[:logger])
  end

  def scrap
    if !companies.is_a?(Array) or (companies.is_a?(Array) and companies.empty?)
      log('No companies informed', :error)
      return false
    end

    companies.each do |symbol|
      symb = CompanySymbols.where(symbol: symbol).first
      if symb
        if (symb.updated_at || Time.new) > (Time.new - (60 * 60 * 24 * 30))
          log("#{symbol} was updated_at recently (30 days of cool down)")
          next
        end
        cya = symb.company
      else
        log('New symbol, scraping...')
        log("Getting CVM_ID for #{symbol}")
        cvm_id = get_cvm_id(symbol)
        next unless cvm_id
        cia = Company.where(cvm_id: cvm_id).first_or_create
      end
      unless cia.new_record?
        cia.movements.destroy_all
        cia.dividends.destroy_all
        cia.company_symbols.destroy_all
      end
      raw      = raw_company_info(cvm_id)
      name      = company_name(raw)
      symbols   = company_symbols(raw)
      symbols << symbol unless symbols.include?(symbol)
      raw       = raw_company_movements(cvm_id)
      log("Found #{cvm_id} for #{symbol}")
      movements = company_movements(raw)
      log("Found #{movements.count} movements for #{symbol}")
      dividends = company_dividends(raw)
      log("Found #{dividends.count} dividends for #{symbol}")
      cia.name = name
      movements.each { |v| cia.movements.new(v) }
      dividends.each { |v| cia.dividends.new(v) }
      symbols.each { |c| cia.add_symbol(c)}
      cia.save
    end
  end

  def get_company_by_ticker(symbol)
    Company.where(ticker: company_ticker).first_or_create
  end

  def company_ticker(symbol)
    if symbol.to_s =~ /^([A-Z]{4})(\d)$/
      $1
    end
  end

  def self.update_all
    dt  = HistoricalQuote.last.date
    hash = Hash.new
    HistoricalQuote.select(:symbol).where('date >= ?', dt.strftime('%Y-%m-%d')).uniq.each do |a|
      if a.symbol =~ /^([A-Z]{4})(\d)$/
        hash[$1] = $1 + $2
      end
    end
    obj = new(hash.values)
    obj.scrap
  end

  def raw_company_info(cvm_id)
    f = Nokogiri::HTML(open("http://www.bmfbovespa.com.br/cias-listadas/empresas-listadas/ResumoEmpresaPrincipal.aspx?codigoCvm=#{cvm_id}&idioma=pt-br"))
    src = f.search('iframe').first.get_attribute('src')
    Nokogiri::HTML(open("http://www.bmfbovespa.com.br#{src.sub('../..', '')}"))
  end

  def raw_company_movements(cvm_id)
    Nokogiri::HTML(open("http://www.bmfbovespa.com.br/cias-listadas/empresas-listadas/ResumoEventosCorporativos.aspx?codigoCvm=#{cvm_id}&tab=3&idioma=pt-br"))
  end

  def company_name(raw)
    raw.search('div.tabelaSemBorda table').search('tr').first.search('td.Dado').first.content.strip
  end

  def company_symbols(raw)
    raw.search('a.LinkCodNeg').map { |i| i.content }.uniq
  end

  def company_movements(raw)
    first = raw.search('div#divBonificacao').first
    return [] if first.nil?

    first = first.search('table.MasterTable_SiteBmfBovespa')

    movs = []

    trs = first.search('tr')
    (1..(trs.size - 1)).each do |idx|
      tds = trs[idx].search('td')
      type           = tds[0].content.downcase.to_sym
      deliberated_at = parse_date(tds[1].content)
      ex_at          = parse_date(tds[2].content)
      quantity       = parse_quantity(tds[3].search('.label').first.content, type)
      credit_at      = parse_date(tds[4].content)
      obs            = tds[5].search('.label').first.content
      movs << { earning_type: type, deliberated_at: deliberated_at, ex_at: ex_at, factor: quantity, credit_at: credit_at, obs: obs }
    end
    movs
  end

  def company_dividends(raw)
    second = raw.search('div#divDividendo').first
    return [] if second.nil?
    second = second.search('table.MasterTable_SiteBmfBovespa')
    movs = []
    trs = second.search('tr')
    (1..(trs.size - 1)).each do |idx|
      tds            = trs[idx].search('td')
      type           = tds[0].content.downcase.to_sym
      deliberated_at = parse_date(tds[1].content)
      ex_at          = parse_date(tds[2].content)
      ordinarias     = parse_float(tds[3].content)
      preferencias   = parse_float(tds[4].content)
      related_at     = tds[5].content
      credit_at      = parse_date(tds[6].content)
      obs            = tds[7].search('.label').first.content
      movs << { earning_type: type, deliberated_at: deliberated_at, ex_at: ex_at, ordinary_payment: ordinarias, prefered_payment: preferencias, related_at: related_at, credit_at: credit_at, obs: obs }
    end
    movs
  end

  def parse_float(str)
    return 0.0 if str.empty?
    str.sub(',', '.').to_f
  end

  def parse_date(date)
    if date =~ /(\d{2}+)\/(\d{2}+)\/(\d{4}+)/
      [$3, $2, $1].join('-')
    else
      date
    end
  end

  def parse_quantity(str, type)
    case type
    when :desdobramento
      (1 + (str.to_i / 100))
    when :bonificação
      (1 + (str.to_i / 100.0))
    when :grupamento
      div, num = str.split('/')
      num.to_f / div.to_f
    end
  end

  def get_cvm_id(symbol)
    symbol = symbol.to_s.upcase
    doc = Nokogiri::HTML(open("http://www.bmfbovespa.com.br/cias-listadas/empresas-listadas/BuscaEmpresaListada.aspx?Nome=#{symbol}&idioma=pt-br"))

    # check if symbol exists.
    unless doc.xpath('//*[@id="ctl00_contentPlaceHolderConteudo_BuscaNomeEmpresa1_lblMensagem"]').first.nil?
      log("#{symbol} not found")
      return nil
    end

    p = doc.search('table.MasterTable_SiteBmfBovespa td').first
    unless p
      log("MasterTable_SiteBmfBovespa table not found")
      return nil
    end

    link = p.search('a').first
    unless p
      log("link with cvm id inside MasterTable_SiteBmfBovespa table not found")
      return nil
    end

    link = link.get_attribute('href')

    link.split('=').last
  end
end