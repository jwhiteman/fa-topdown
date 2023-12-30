class Jamis
  class LL1
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

    # first(entry):      { ATOM }
    # first(entry'):     { AND, OR, Ɛ }
    # first(key):        { ATOM }
    # first(value):      { ATOM, QUOTED-STRING, LPAREN }
    # first(word):       { ATOM, QUOTED-STRING }
    # first(value-list): { ATOM, QUOTED-STRING }
    # first(trailer):    { AND, OR, Ɛ }

    # follow(entry):     { $, AND, OR  }
    #    constraint:first(entry')
    #    constraint:follow(entry')
    # follow(entry'):    { $, AND, OR }
    #    constraint:follow(entry)
    # follow(key)        { COLON }
    # follow(value)      { $, AND, OR}
    #    constraint:first(entry')
    #    constraint:follow(entry')
    # follow(word)       { $, AND, OR }
    #    constraint:follow(value)
    #    constraint:first(trailer)
    # follow(value-list) { RPAREN }
    #   constraint:follow(trailer)
    # follow(trailer)    { RPAREN }
    #   constraint:follow(value-list)

    # doesn't appear to be LL(1)
    # example: first(entry') and follow(entry') contain similar elements
  end
end
