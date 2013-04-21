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
      log("Getting CVM_ID for #{symbol}")
      cvm_id = get_cvm_id(symbol)
      next unless cvm_id
      raw = raw_company_info(cvm_id)

      log("Found #{cvm_id} for #{symbol}")
    end
  end

  def raw_company_info
    Nokogiri::HTML(open("http://www.bmfbovespa.com.br/cias-listadas/empresas-listadas/ResumoEventosCorporativos.aspx?codigoCvm=#{cvm_id}&tab=3&idioma=pt-br"))
  end

  def company_movements(raw)
    first, second = raw.search('table.MasterTable_SiteBmfBovespa')

    trs = first.search('tr')
    (1..(trs.size - 1)).each do |idx|
      tds = trs[idx].search('td')
      type           = tds[0].content.to_sym
      deliberated_at = parse_date(tds[1].content)
      ex_at          = parse_date(tds[2].content)
      quantity       = parse_quantity(tds[3].search('.label').first.content, type)
      credit_at      = parse_date(tds[4].content)
      obs            = tds[5].search('.label').first.content
    end 
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
      ''
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