# Jamis' Recursive Descent Parser
[https://weblog.jamisbuck.org/2015/7/30/writing-a-simple-recursive-descent-parser.html](original)
  
## original grammar

```
   expr := term
        | term AND expr
        | term OR expr
  term := value
        | atom ':' value
  atom := word+
        | quoted_string
  value := atom
        | '(' expr ')'
```

## notes
1. it's a line-by-line format, so maybe having the parser
   only consider a line-at-a-time is sensible
2. cautiously, my grammar seems to work - but it's also a little
   more wonky creating the AST
3. so to that end, maybe start w/ the aggressively left-factored &
   left recursion eliminated grammar, and implement it verbatim.
   afterwards, collapse some of the 'prime NT functions into their parent
   to make AST generation easier.
4. use of 'tap' because at most steps we want to check or clean things up,
   but ultimately return a result from earlier in the block (e.g the ast parts)
