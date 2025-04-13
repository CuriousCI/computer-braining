#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.circle, shapes.diamond

#set text(font: "New Computer Modern", lang: "it", weight: "light", size: 11pt)
#set page(margin: 1.75in)
#set par(leading: 0.55em, spacing: 0.85em, first-line-indent: 1.8em, justify: true)
#set math.equation(numbering: "(1)")

#show figure: set block(breakable: true)
#show figure.caption: set align(center)
#show heading: set block(above: 1.4em, below: 1em)
#show outline.entry.where(level: 1): it => { show repeat : none; v(1.1em, weak: true); text(size: 1em, strong(it)) }
#show raw: set text(font:"CaskaydiaCove NFM", lang: "it", weight: "light", size: 9pt)
#show sym.emptyset : sym.diameter 

#let reft(reft) = box(width: 8pt, place(dy: -8pt, 
  box(radius: 100%, width: 9pt, height: 9pt, inset: 1pt, stroke: .5pt, // fill: black,
    align(center + horizon, text(font: "CaskaydiaCove NFM", size: 7pt, repr(reft)))
  )
))

#set heading(numbering: "1.1")
#set raw(lang: "Rust")
#set table(stroke: 0.25pt)

= E.A.6.1

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
