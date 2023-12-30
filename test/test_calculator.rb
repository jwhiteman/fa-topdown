# frozen_string_literal: true

require "test_helper"

class TestCalculator < Minitest::Test
  def test_calculator
    res = Calculator.new("1").parse
    assert_equal 1, res

    res = Calculator.new("7 + 2").parse
    assert_equal 9, res

    res = Calculator.new("7 - 2").parse
    assert_equal 5, res

    res = Calculator.new("2 * 3").parse
    assert_equal 6, res

    res = Calculator.new("(2 + 2) * 2").parse
    assert_equal 8, res

    res = Calculator.new("(2)").parse
    assert_equal 2, res

    res = Calculator.new("((2 + 4) / (2 * 1)) + 39").parse
    assert_equal 42, res
  end
end
