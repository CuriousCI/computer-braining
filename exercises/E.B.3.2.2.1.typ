#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.ellipse, shapes.diamond, shapes.rect
#import "template.typ": *

#show: doc => conf([E.B.3.2.2.1 (I Rossi, Modelling)], doc)

== Variabili casuali

- RossiInCasa $in {T, F}$: i Rossi sono in casa
- CaneNelCortile $in {T, F}$: il cane è nel cortile
- CaneAbbaia $in {T, F}$: il cane abbaia
- LuceGarageAccesa $in {T, F}$: la luce del garage è accesa
- CaneProblemiIntestinali $in {T, F}$: il cane ha problemi intestinali

== Rete Bayesiana

\

#align(center)[
  #diagram(
    node-stroke: .5pt,
    node-shape: ellipse,
    node-inset: 1em,
    edge-stroke: .5pt,
    spacing: 1.5em,
    label-sep: .5pt,

    node((1, 1), [RossiInCasa], name: <RC>),
    edge(<CF>, "-|>"),
    edge(<LGA>, "-|>"),

    node((2, 1), [CaneProblemiIntestinali], name: <CPI>),
    edge(<CF>, "-|>"),

    node((1, 2), [CaneNelCortile], name: <CF>),
    edge(<CA>, "-|>"),

    // node((2, 3), [QualcunoSiAvvicinaAllaCasa], name: <QAC>),
    // edge(<CA>, "-|>"),

    node((1, 3), [CaneAbbaia], name: <CA>),

    node((0, 2), [LuceGarageAccesa], name: <LGA>),
  )
]
