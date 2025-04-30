#import "template.typ": *

#show: doc => conf([E.A.6.3 (DPLL)], doc)

== CNF

$
  (A -> (B and not (C or D))) or [(B or not (A equiv B)) -> D] = \
  {"app. di" A -> B equiv not A or B} \
  (not A or (B and not (C or not D))) or [not (B or not (A equiv B)) or D] =\
  {"app. di" (A equiv B) equiv (not A or B) and (A or not B)} \
  (not A or (B and not (C or not D))) or [not (B or not ((not A or B) and (A or not B))) or D] =\
  {"app. di De Morgan"} \
  (not A or (B and (not C or D))) or [(not B and ((not A or B) and (A or not B))) or D] =\
  {"distrib. di" or} \
  ((not A or B) and (not A or not C or D)) or ((not B or D) and (not A or B or D) and (A or not B or D)) =\
  {"distrib. di" or} \
  (((not A or B) and (not A or not C or D)) or (not B or D)) and \
  (((not A or B) and (not A or not C or D)) or (not A or B or D)) and \
  (((not A or B) and (not A or not C or D)) or (A or not B or D) =\
  {"distrib. di" or} \
  (not A or B or not B or D) and (not A or not C or D or not B or D) and \
  (not A or B or not A or B or D) and (not A or not C or D or not A or B or D) and \
  (not A or B or A or not B or D) and (not A or not C or D or A or not B or D) =\
  {"semplificazione"} \
  (not A or not B or not C or D) and (not A or B or D) and (not A or B or not C or D) \
$

== DPLL

- $phi.alt = (not A or not B or not C or D) and (not A or B or D) and (not A or B or not C or D)$

- $phi.alt | not A = ()$

\

Il risultato è ragionevole, considerando che nella formula iniziale basta assegnare $A = F$, la prima implicazione diventa vera, e il resto della formula è in $or$

