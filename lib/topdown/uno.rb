module Uno
  class ParseError < StandardError; end
  class RecursiveDescent
    # S -> 0S1 | 01

    # LEFT FACTOR:
    # S  -> 0S'
    # S' -> 1 | S1

    # example of valid inputs:
    # 01
    # 00001111

    attr_reader :scanner

    def initialize(str)
      @input = StringScanner.new(str)
    end

    def parse
      s

      @input.eos? || (raise ParseError)
    end

    def s
      match("0")

      sprime
    end

    def sprime
      if next?("1")
        match("1")
      else
        s
        match("1")
      end
    end

    private

    def match(c)
      @input.scan(c) || (raise ParseError)
    end

    def next?(c)
      @input.peek(1) == c
    end
  end

  class LL1
    # S -> 0S1 | 01

    # LEFT FACTOR:
    # S  -> 0S'
    # S' -> 1 | S1

    # first(S)    : {0}
    # first(S')   : {1, 0}
    # follow(S)   : {$, 1}
    # follow(S')  : {$, 1}

    #         0            1          $
    # S     S -> 0S'
    # S'    S'-> S1       S'->1

    T = {
      S:      { "0" => ["0", :SPRIME]              },
      SPRIME: { "0" => [:S, "1"],     "1" => ["1"] }
    }.freeze

    attr_reader :stack
    attr_reader :input
    attr_reader :lookahead

    def initialize(str, verbose = false)
      @input     = StringIO.new(str)
      @stack     = %i(S)
      @verbose   = verbose

      set_lookahead
    end

    def verbose?; @verbose; end

    def set_lookahead
      @lookahead = @input.getc
    end
    alias_method :advance_lookahead, :set_lookahead

    def next_is_non_terminal?
      stack[-1].kind_of?(Symbol)
    end

    # QUESTIONS: not sure how to handle "$"; maybe leave it out if no rules?
    def parse
      while !stack.empty?
        puts "STACK: #{stack.inspect}" if verbose?

        if next_is_non_terminal?
          nt = stack.pop

          if T[nt][lookahead]
            production = T[nt][lookahead]

            stack.push(*production.reverse)
          else
            raise ParseError
          end
        else
          t = stack.pop

          if lookahead == t
            advance_lookahead
          else
            raise ParseError
          end
        end
      end

      true
    end
  end
end
