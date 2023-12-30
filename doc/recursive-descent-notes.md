# example 1

trivial case showing recursive descent

S -> A
A -> B
B -> c

```
def S; A; end
def A; B; end
def B; match(/c/); end
```

# example 2

use lookahead to determine the correct production
might need k lookahead (hopefully 1) to do so; left factoring & eliminating
left recursion can help

S -> A | B
A -> az
B -> bz

```
def S
  if next == "a"
    A
  elsif next == "b"
    B
  else
    error
  end
end
```

# example 3

a production with a string of grammar symbols

S -> ABC

```
def S
  A
  B
  C
end
```

# example 4

with epsilon

S -> Ax
A -> b | epsilon

```
def S
  A
  match(/x/)
end

def A
  if next == "b"
    match(/b/)
  else
    return # no-op: don't return shit for epsilon
  end
end
```

# example 5

combining some of the actions, maybe to make things easier
using previous example:

S -> Ax
A -> b | epsilon

```
def S
  A
  match(/x/)

  # inlining the body of A:
  if next == "b"
    match(/b/)
  else
    return # no-op: don't return shit for epsilon
  end
end
```
