# frozen_string_literal: true

require "test_helper"

class TestUno < Minitest::Test
  def test_recursive_descent
    parser = Uno::RecursiveDescent.new("01")
    assert parser.parse

    parser = Uno::RecursiveDescent.new("00001111")
    assert parser.parse

    parser = Uno::RecursiveDescent.new("0")
    assert_raises(Uno::ParseError) do
      parser.parse
    end
  end

  def test_ll1_with_table
    parser = Uno::LL1.new("01")
    assert parser.parse

    parser = Uno::LL1.new("000000111111")
    assert parser.parse

    parser = Uno::LL1.new("0")
    assert_raises(Uno::ParseError) do
      parser.parse
    end

    parser = Uno::LL1.new("00000011111")
    assert_raises(Uno::ParseError) do
      parser.parse
    end
  end
end
