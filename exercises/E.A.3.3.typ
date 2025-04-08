#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.circle, shapes.diamond
#import "math.typ": *

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

= E.A.3.3 (ProteinFolding)

== Modello

Data una sequenza di amminoacidi $a_1, ..., a_n$ (fissata per il problema), l'idea è quella di modellare uno *stato* come segue:

#definition(title: "Stato")[
Uno stato è un assegnamento $p_1, .., p_k "con" 0 <= k <= n space.en t.c.$ 
- $p_i in ZZ^2$ (posizionamento nel piano) //(l'amminoacido è posizionato nel piano)
- $"dist"(p_i, p_(i + 1)) = 1$ (adiacenza)
- $exists.not p_i, p_j space.en i != j and p_i = p_j$ (sovrapposizione)
]

#definition(title: "Obiettivo")[Uno stato è obiettivo quando $k = n$.]

#definition(title: "Azioni")[
    Dato uno stato *non obiettivo* (quindi $k < n$), l'insieme di azioni consiste nei possibili assegnamenti per $p_(k + 1)$ che rispettano le condizioni di _adiacenza_ e _sovrapposizione_.
]

Da questa modellazione del problema deriva un'importante osservazione, che permette di ottimizzare gli algoritmi di ricerca:

// - $p_0 = (0, 0)$ (origine)
//ai primi $k$ amminoacidi, con $0 <= k <= n$

#observation[
    Il grafo di ricerca per *ProteinFolding* è un *albero*.

\
    Per dimostrarlo bisogna far vedere che non è possibile raggiungere lo stesso stato con sequenze di azioni diverse. Per assurdo, se fosse possibile, vorrebbe dire che uno stato $p_1, ..., p_k$ è stato raggiunto partendo da due stati *diversi* $q_1, ..., q_(k - 1)$ e $r_1, ..., r_(k - 1)$. 
    // - $q_i = r_i$ per ogni $0 <= i <= k - 1$, e sono stati dati assegnamenti diversi a $q_k$ e $r_k$, ma ciò non è possibile, perché $q_k = p_k = r_k$
    // - $exists q_i != r_i$ per un qualche $0 <= i <= k - 1$, ma questo non è possibile, perché si avrebbe $q_i != p_i = r_i$, ma la sequenza $q_1, ..., q_k$ è uguale a $p_1, ..., p_k$
]

\
A questo punto si può ottimizzare la ricerca, perché non serve controllare se uno stato è già stato esplorato o sta già in frontiera (ogni stato generato a seguito dell'applicazione di un'azione allo stato "in esplorazione" è nuovo).


Dato che il problema presenta forti simmetrie, si può cercare di ottimizzare la ricerca evitando le azioni che generano stati equivalenti.  

- la prima azione è sempre in alto
- primo giro sempre a destra
- per tutti gli altri casi tutte le azioni valide


// *Obs*

