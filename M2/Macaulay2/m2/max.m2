--		Copyright 1993-1999,2004 by Daniel R. Grayson
InfiniteNumber = new Type of BasicList
InfiniteNumber.synonym = "infinite number"
infinity = new InfiniteNumber from {1}
neginfinity = new InfiniteNumber from {-1}
- InfiniteNumber := x -> if x === infinity then neginfinity else infinity
setAttribute(infinity,ReverseDictionary,symbol infinity)
setAttribute( infinity,PrintNames, "infinity")
setAttribute(-infinity,PrintNames, "-infinity")
toString InfiniteNumber := net InfiniteNumber := x -> getAttribute(x,PrintNames)

IndeterminateNumber = new Type of BasicList
IndeterminateNumber.synonym = "indeterminate number"
indeterminate = new IndeterminateNumber from {}
setAttribute(indeterminate,ReverseDictionary,symbol indeterminate)
toString IndeterminateNumber := net IndeterminateNumber := x -> "indeterminate"

InfiniteNumber ? InfiniteNumber := (x,y) -> x#0 ? y#0
InfiniteNumber + InfiniteNumber := (x,y) -> if x === y then x else indeterminate
InfiniteNumber - InfiniteNumber := (x,y) -> if x =!= y then x else indeterminate
InfiniteNumber * InfiniteNumber := (x,y) -> if x === y then infinity else neginfinity
InfiniteNumber / InfiniteNumber :=
InfiniteNumber // InfiniteNumber := (x,y) -> indeterminate
InfiniteNumber ^ InfiniteNumber := (x,y) -> (
  if y < 0 then
    0
  else if x > 0 then
    infinity
  else
    indeterminate
)
InfiniteNumber ..< InfiniteNumber := 
InfiniteNumber .. InfiniteNumber := (i,j) -> if i < j then error "infinite range specified" else ()
InfiniteNumber == InfiniteNumber := (x,y) -> x === y

InfiniteNumber + Number := (i,j) -> (
  if isFinite j then
    i
  else if isANumber j then
    if ((i > 0 and j > 0) or (i < 0 and j < 0)) then i else indeterminate
  else
    indeterminate
)
Number + InfiniteNumber := (i,j) -> j + i
InfiniteNumber - Number := (i,j) -> i + (-j)
Number - InfiniteNumber := (i,j) -> i + (-j)
InfiniteNumber * RR := 
InfiniteNumber * QQ := 
InfiniteNumber * ZZ := (i,j) -> (
  if isANumber j then
    if j > 0 then i else if j < 0 then -i else indeterminate
  else
    indeterminate
)
RR * InfiniteNumber := 
QQ * InfiniteNumber := 
ZZ * InfiniteNumber := (i,j) -> j * i
Number // InfiniteNumber := Number / InfiniteNumber := (i,j) -> if isFinite i then 0 else indeterminate
InfiniteNumber // RR := InfiniteNumber / RR := 
InfiniteNumber // QQ := InfiniteNumber / QQ :=
InfiniteNumber // ZZ := InfiniteNumber / ZZ := (i,j) -> if (isFinite j and j > 0) then i else if (isFinite j and j < 0) then -i else indeterminate
InfiniteNumber ^ ZZ := (x,n) -> (
  if (n > 0 and even n) then infinity
  else if (n > 0 and odd n) then x
  else if n < 0 then 0
  else indeterminate
)
InfiniteNumber ^ QQ := (x,q) -> if (odd denominator q or x > 0) then x ^ (numerator q) else indeterminate
InfiniteNumber ^ RR := (x,r) -> (
  if (x > 0 and r > 0) then
    x
  else if (x > 0 and r < 0) then
    0
  else
    indeterminate
)
ZZ ^ InfiniteNumber := (n,x) -> (
  if n==1 then 
    1
  else if n==0 and x > 0 then
    0
  else if n==0 and x < 0 then
    indeterminate
  else if n == -1 then
    indeterminate
  else if x < 0 then
    0
  else if n > 1 then
    infinity
  else
    indeterminate
)
RR ^ InfiniteNumber := (r,x) -> (
  if (0. < r and r < 1. and x > 0) then
    0.
  else if (r > 1. and x > 0) then
    infinity
  else if (0. < r and r < 1. and x < 0) then
    infinity
  else if (r > 1. and x < 0) then
    0.
  else if r == 1. then
    1.
  else
    indeterminate
)
QQ ^ InfiniteNumber := (r,x) -> (
  if (0 < r and r < 1 and x > 0) then
    0
  else if (r > 1 and x > 0) then
    infinity
  else if (0 < r and r < 1 and x < 0) then
    infinity
  else if (r > 1 and x < 0) then
    0
  else if r == 1 then
    1
  else
    indeterminate
)
InfiniteNumber == Number := 
Number == InfiniteNumber := (x,y) -> false
Thing ? InfiniteNumber := (x,y) -> if y === infinity then symbol < else symbol >
InfiniteNumber ? Thing := (x,y) -> if x === infinity then symbol > else symbol <

RR == InfiniteNumber := (x,y) -> isInfinite x and ( x < 0 and y < 0 or x > 0 and y > 0 )
InfiniteNumber == RR := (x,y) -> y == x

texMath InfiniteNumber := i -> if i === infinity then "\\infty" else "{-\\infty}"

max VisibleList := x -> (
     m := neginfinity;
     scan(x, n -> if n > m then m = n);
     m)
min VisibleList := x -> (
     m := infinity;
     scan(x, n -> if m > n then m = n);
     m)

-- Local Variables:
-- compile-command: "make -C $M2BUILDDIR/Macaulay2/m2 "
-- End:
