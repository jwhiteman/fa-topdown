# frozen_string_literal: true

require "test_helper"

class TestJamis < Minitest::Test
  def test_simple_entry
    res = Jamis.parse("foo:bar")

    assert_equal "foo", res.name
    assert_equal "bar", res.value
  end

  def test_or_compound_entry
    res = Jamis.parse("foo:bar OR baz:buzz")

    assert_equal "OR", res.op
    assert_equal "foo", res.left.name
    assert_equal "bar", res.left.value
    assert_equal "baz", res.right.name
    assert_equal "buzz", res.right.value
  end

  def test_and_compound_entry
    res = Jamis.parse("foo:bar AND baz:buzz")

    assert_equal "AND", res.op
  end

  def test_compound_entry_moar
    res = Jamis.parse("a:b AND c:d OR e:f")

    assert_equal "AND", res.op
    assert_equal "a", res.left.name
    assert_equal "b", res.left.value
    assert_equal "OR", res.right.op
    assert_equal "c", res.right.left.name
    assert_equal "d", res.right.left.value
    assert_equal "e", res.right.right.name
    assert_equal "f", res.right.right.value
  end

  def test_value_as_string
    res = Jamis.parse(%q{company:"ACME Products"})

    assert_equal "company", res.name
    assert_equal "ACME Products", res.value
  end

  def test_value_compound_or
    res = Jamis.parse("state:(texas OR ok)")

    assert_equal "state", res.name
    assert_equal "OR", res.value.op
    assert_equal "texas", res.value.left
    assert_equal "ok", res.value.right
  end

  def test_value_compound_or_with_and
    res = Jamis.parse(%q{country:(ru OR cn AND "South Korea")})

    assert_equal "country", res.name
    assert_equal "OR", res.value.op
    assert_equal "ru", res.value.left
    assert_equal "AND", res.value.right.op
    assert_equal "cn", res.value.right.left
    assert_equal "South Korea", res.value.right.right
  end
end
