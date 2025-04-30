#import "template.typ": *

#show: doc => conf([E.A.6.2 (Risoluzione 2)], doc)

== CNF


$
  (A -> (B and not (C or D))) or [(B or not (A equiv B)) -> D] = \
  {"app. di" A -> B equiv not A or B} \
  (not A or (B and not (C or not D))) or [not (B or not (A equiv B)) or D] =\
  {"app. di" (A equiv B) equiv (A and B) or (not A and not B)} \
  (not A or (B and not (C or not D))) or [not (B or not ((A and B) or (not A and not B))) or D] =\
  {"app. di De Morgan"} \
  (not A or (B and (not C and not D))) or [not B and ((A and B) or (not A and not B)) or D] =\
  {"assoc. di " and} \
  (not A or (B and not C and not D)) or [not B and ((A and B) or (not A and not B)) or D] =\
  {"distrib. di " or} \
  ((not A or B) and (not A or not C) and (not A or not D))) or [not B and ((A and B) or (not A and not B)) or D] =\

  // {"app. di De Morgan"} \
  // (not A or (B and (not C and not D))) or [not (B or not ((A and B) or (not A and not B))) or D] =\

  // {"app. di De Morgan"} \
  // (not A or (B and not C and not D)) or [not (B or ((not A or not B) and (A or B))) or D] =\
  // {"app. di De Morgan"} \
  // (not A or (B and not C and not D)) or [not (B or ((not A or not B) and (A or B))) or D] =\

  // (A -> (B and not (C or D))) or [(B or not (A equiv B)) -> D] = \
  // {"app. di De Morgan"} \
  // (not A or (B and not C and not D)) or [not (B or not (A equiv B)) or D] = \
$
// {"assoc. di " or} \
