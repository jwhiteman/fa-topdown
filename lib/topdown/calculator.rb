class Calculator
  class ParseError < StandardError; end

  # LL(1):
  #  E  -> TE'
  #  E' -> +TE' | e
  #  T  -> FT'
  #  T' -> *FT' | e
  #  F  -> (E)  | id

  ADD_OR_SUB   = /[+-]/
  MUL_OR_DIV   = /[*\/]/
  LPAREN       = /\(/
  RPAREN       = /\)/
  NUM          = /\d+/
  END_OF_INPUT = /^$/

  attr_reader :scanner

  def self.parse(str)
    new(str).parse
  end

  def initialize(str)
    @scanner = StringScanner.new(str)
  end

  def parse
    e.tap { match!(END_OF_INPUT) }
  end

  def e
    x  = t
    op = match(ADD_OR_SUB)

    if op
      x.__send__(op, e)
    else
      x
    end
  end

  def t
    x  = f
    op = match(MUL_OR_DIV)

    if op
      x.__send__(op, t)
    else
      x
    end
  end

  def f
    if match(LPAREN)
      e.tap { |e| match!(RPAREN) }
    else
      match(NUM).to_i
    end
  end

  private

  def match(regex)
    scanner.skip(/\s+/) # skip whitespace

    scanner.scan(regex)
  end

  def match!(regex)
    match(regex) || raise(ParseError)
  end
end
