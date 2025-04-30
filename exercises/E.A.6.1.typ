#import "template.typ": *

#show: doc => conf([E.A.6.1 (Risoluzione 1)], doc)

== CNF

$
  (B -> (A or C)) and not (B and C) and (not C -> not A) = \
  {"app. di" A -> B equiv not A or B} \
  (not B or (A or C)) and not (B and C) and (C or not A) = \
  {"app. di De Morgan"} \
  (not B or (A or C)) and (not B or not C) and (C or not A) = \
  {"assoc. di " or} \
  (not B or A or C) and (not B or not C) and (C or not A)
$

== Risoluzione

Le clausole sono riordinate per semplificare un minimo il lavoro e evitare errori
1. clausole = ${(A or not B or C), (not A or C), (not B or not C)}$
  - $(A or not B or C) and (not A or C) tack.r.double (not B or C)$
  - $(A or not B or C) and (not B or not C) tack.r.double (A or not B )$
  - $(not A or C) and (not B or not C) tack.r.double (not A or not B)$

2. clausole = ${(A or not B or C), (not A or C), (not B or not C), (A or not B), (not A or not B), (not B or C)}$
  - $(A or not B or C) and (not A or not B) tack.r.double (not B or C)$
  - $(not A or C) and (A or not B) tack.r.double (not B or C)$
  - $(not B or not C) and (not B or C) tack.r.double (not B)$
  - $(A or not B) and (not A or not B) tack.r.double (not B)$

3. clausole = ${(A or not B or C), (not A or C), (not B or not C), (A or not B), (not A or not B), (not B or C), (not B)}$
  - non ci sono nuove clausole e non è stata trovata la clausola vuota, quindi la formula è soddisfacibile

Un esempio di modello è $A = T, B = F, C = T$
