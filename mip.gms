VARIABLES
  z                    profit;

POSITIVE VARIABLES
  x1                   produit1
  x2                   produit2
  x3                   produit3;

BINARY VARIABLES
  y1
  y2                           ;

EQUATIONS
  Objective             Maximize profit
  Ressource
  Upper1                limit on product 1
  Upper2                limit on product 2
  Upper3                limit on product 3;

Objective..
  z =E= 2*x1 + 3*x2 + 0.8*x3 - 3*y1 - 2*y2;

Ressource..
  0.2*x1 + 0.4*x2 + 0.2*x3 =L= 1;

Upper1..
  x1 =L= 3*y1;

Upper2..
  x2 =L= 2*y2;

Upper3..
  x3 =L= 5;

MODEL example /ALL/;

OPTION optcr = 0.05;

SOLVE example USING mip maximizing z;
