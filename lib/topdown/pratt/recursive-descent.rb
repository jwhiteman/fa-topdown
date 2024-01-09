class RecursiveDescentParser
  def initialize(input)
    @tokens = input.scan(/[+\-*\/()]|\d+/)
    @current_token_index = 0
  end

  def parse
    expression
  end

  private

  def expression
    term = multiply_divide

    if %w(+ -).include?(current_token)
      operator = current_token
      advance
      term = operator == '+' ? term + multiply_divide : term - multiply_divide
    end

    term
  end

  def multiply_divide
    factor = number

    if %w(* /).include?(current_token)
      operator = current_token
      advance
      factor = operator == '*' ? factor * number : factor / number
    end

    factor
  end

  def number
    advance.to_i
  end

  def advance
    token = current_token
    @current_token_index += 1
    token
  end

  def current_token
    @tokens[@current_token_index]
  end
end

require "pry"
require "minitest/autorun"

Class.new(Minitest::Test) do
  def test_rd
    assert_equal 2, RecursiveDescentParser.new("2").parse
    assert_equal 2, RecursiveDescentParser.new("3 - 1 - 1").parse
    assert_equal 6, RecursiveDescentParser.new("2 + 2 * 2").parse
  end
end
