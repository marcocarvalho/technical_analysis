require 'time'

class ImportBovespa
  attr_reader :filename

  def initialize(file)
    @filename = file
    raise 'file name must be string' unless @filename.is_a?(String)
    raise 'file dont exists'         unless File.exists? @filename
  end

  def block?
    @block_given
  end

  Layout = {
    tipreg: [2, 0..1,      :fixnum],
    data:   [8,  2..9,     :date],
    codbdi: [2,  10..11,   :string],
    codneg: [12, 12..23,   :string],
    tpmerc: [3,  24..26,   :market_type],
    nomres: [12, 27..38,   :string],
    especi: [10, 39..48,   :string],
    prazot: [3,  49..51,   :string],
    modref: [4,  52..55,   :string],
    preabe: [13, 56..68,   :float],
    premax: [13, 69..81,   :float],
    premin: [13, 82..94,   :float],
    premed: [13, 95..107,  :float],
    preult: [13, 108..120, :float],
    preofc: [13, 121..133, :float],
    preofv: [13, 134..146, :float],
    totneg: [5,  147..151, :fixnum],
    quatot: [18, 152..169, :fixnum],
    voltot: [18, 170..187, :float],
    preexe: [13, 188..200, :float],
    indopc: [1,  201..201, :string],
    datven: [8,  202..209, :date],
    fatcot: [7,  210..216, :fixnum],
    ptoexe: [13, 217..229, :decimal],
    codisi: [12, 230..241, :string],
    dismes: [3,  242..244, :fixnum] 
  }

  def import
    arr = []
    file = File.open(filename, 'r')
    file.readlines.each do |line|
      result = split_line line
      next if result.nil?
      if block_given?
         yield result
      else
        arr << result
      end
    end
    return arr unless block_given?
  end

  def market_type(str)
    case str.to_i
    when 10 
      :vista
    when 12 
      :call_exercise
    when 13 
      :put_exercise
    when 17
      :auction
    when 20
      :fractional
    when 30
      :term
    when 50 
      :future_1 # Futuro com movimentação retida
    when 60 
      :future_2 # FUTURO COM MOVIMENTAÇÃO CONTÍNUA
    when 70 
      :call
    when 80 
      :put
    end
  end

  def decimal(str)
    str.to_i / 1000000.0
  end

  def float(str)
    str.to_i / 100.0
  end

  def date(str)
    str =~ /(....)(..)(..)/
    # Time.parse("$1/$2/$3")
    [$1, $2, $3].join('-')
  end

  def fixnum(str)
    str.to_i
  end

  def string(str)
    str.strip
  end

  def split_line(line)
    return if line[0..1] == '00' or line[0..1] == '99'
    ret = {}
    Layout.each do |k, v|
      ret[k] = send(v.last, line[v[1]])
    end
    ret
  end
end