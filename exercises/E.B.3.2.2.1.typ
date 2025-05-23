#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.ellipse, shapes.diamond, shapes.rect
#import "template.typ": *

#show: doc => conf([E.B.3.2.2.1 (I Rossi, Modelling)], doc)

\

// Modellare il seguente frammento di conoscenza mediante una rete bayesiana:
// Vogliamo effettuare del ragionamento sulla presenza o meno dei nostri vicini
// di casa, i Rossi.
// La famiglia Rossi ha un cane che viene tenuto dentro casa. Quando sono
// fuori, lasciano il cane nel cortile. Il cane soffre di sporadici problemi intesti-
// nali: in queste circostanze, viene lasciato spesso nel cortile anche quando i
// Rossi sono in casa. Se il cane è in cortile, lo sentiamo spesso abbaiare quan-
// do qualcuno si avvicina alla casa. Quando i Rossi escono, lasciano spesso
// accesa la luce di fronte al garage.
//
// Variabili casuali
// - I rossi sono a casa? (RossiACasa)
// - CaneNelCortile
// - ProblemiIntestinaliDelCane (IlCaneHaProblemiIntestinali)
// - LuceGarageAccesa
// - CaneAbbaia
//   - lo sento solo se sta nel cortile
//   - abbaia ogni tanto
//   - abbaia quando qualcuno si avvicina
// - QualcunoSiAvvicinaAllaCasa

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
