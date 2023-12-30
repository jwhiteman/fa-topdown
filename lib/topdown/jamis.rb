class Jamis
  class ParseError < StandardError; end

  # NOTE: this 'works' - but it isn't LL(1)!
  # entry: key ":" value entry'
  # 
  # entry' : AND entry entry'
  #        | OR entry entry'
  #        | Ɛ
  # 
  # key: atom
  # 
  # value: word
  #      | ( value-list )
  # 
  # word: atom
  #     | quoted-string
  # 
  # value-list: word trailer
  # 
  # trailer: AND value-list
  #        | OR value-list
  #        | Ɛ

  class Expression < Struct.new(:op, :left, :right); end
  class Field < Struct.new(:name, :value); end

  attr_reader :scanner

  OPERATOR  = /(and|or)/i
  QUOTE     = /"/
  NOT_QUOTE = /[^"]+/
  COLON     = /:/
  WORD      = /\w+/
  LPAREN    = /\(/
  RPAREN    = /\)/

  def self.parse(str)
    new(str).parse
  end

  def initialize(str)
    @scanner = StringScanner.new(str)
  end

  def parse
    entry.tap { verify_eos }
  end

  def entry
    skip_whitespace
    field = Field.new(key, value)

    skip_whitespace
    op = match(OPERATOR)

    if op
      Expression.new(op, field, entry)
    else
      field
    end
  end

  def key
    atom.tap { match!(COLON) }
  end

  def atom
    match!(WORD)
  end

  def value
    if match(LPAREN)
      value_list.tap { match!(RPAREN) }
    else
      word
    end
  end

  def word
    skip_whitespace

    if match(QUOTE)
      match(NOT_QUOTE).tap { match!(QUOTE) }
    else
      atom
    end
  end

  def value_list
    wrd = word
    skip_whitespace

    op = match(OPERATOR)

    if op
      Expression.new(op, wrd, value_list)
    else
      wrd
    end
  end

  private

  def verify_eos
    scanner.eos? || raise(ParseError)
  end

  def match(regex)
    scanner.scan(regex)
  end

  def match!(regex)
    match(regex) || raise(ParseError)
  end

  def skip_whitespace
    scanner.skip(/\s+/)
  end
end
