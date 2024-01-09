class PrattParser
  def initialize(input)
    @tokens = input.scan(/[+\-*\/()]|\d+/)
    @current_token_index = 0
  end

  def parse(precedence = 0)
    token = current_token
    advance
    left = nud(token)

    while precedence < token_precedence(current_token)
      token = current_token
      advance
      left = led(left, token)
    end

    left
  end

  private

  # null denotation: i.e nothing to the left that is interesting
  # "what are the firsts() of an expression" (?)
  def nud(token)
    case token
    when /-/
      0 - parse
    when /\d/
      token.to_i
    when "("
      expr = parse

      if current_token == ")"
        advance
      else
        raise "...error?"
      end

      expr
    else
      raise "Syntax Error"
    end
  end

  # left denotation: i.e the left is interesting
  def led(left, token)
    case token
    when "+"
      left + parse(10)
    when "-"
      left - parse(10)
    when "*"
      left * parse(20)
    when "/"
      left / parse(20)
    else
      raise "Syntax Error"
    end
  end

  def advance
    @current_token_index += 1
  end

  def current_token
    @tokens[@current_token_index]
  end

  def token_precedence(token)
    puts "token-precedence request: #{token}"
    case token
    when "+", "-"
      10
    when "*", "/"
      20
    else
      0
    end
  end
end

require "pry"
require "minitest/autorun"

def parse(exp); PrattParser.new(exp).parse; end

Class.new(Minitest::Test) do
  def test_negative
    assert_equal -1, parse("-1")
    assert_equal 1, parse("-(-1)")
  end

  def test_pratt
    assert_equal 12, parse("2 * (1 + 1) * 3")

    assert_equal 2, parse("2")
    assert_equal 3, parse("1 + 2")
    assert_equal 1, parse("3 - 1 - 1")

    assert_equal 10, parse("1 + 3 + 5 + 7 * 0 + 1")
    assert_equal 21, parse("(1 + 2) * (3 + 4)")

    assert_equal 9, parse("1 + 2 * 4")
    assert_equal 17, parse("3 * 4 + 5")

    assert_equal 6, parse("2 * 2 + 2")
    assert_equal 6, parse("2 + 2 * 2")
  end
end
