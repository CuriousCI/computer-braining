#import "math.typ": *

#set text(font: "New Computer Modern", lang: "it", weight: "light", size: 11pt)
#set page(margin: 1.75in)
#set par(leading: 0.55em, spacing: 0.85em, first-line-indent: 1.8em, justify: true)
#set math.equation(numbering: "(1)")
#set heading(numbering: "1.1")
#set raw(lang: "Rust")

#show figure.caption: set align(center)
#show heading: set block(above: 1.4em, below: 1em)
#show raw: set text(font:"CaskaydiaCove NFM", lang: "it", weight: "light", size: 9pt)
#show sym.emptyset : sym.diameter 


= E.A.3.3 (ProteinFolding)

== Modello

Una proteina è una sequenza di amminoacidi $a_1, ..., a_n space.en t.c. space.en a_i in {H, P}$.

//, l'idea è quella di modellare uno *stato* come segue:
// (l'amminoacido è posizionato nel piano)

#definition(title: [conformazione (stato)])[
Una conformazione è un assegnamento $p_1, .., p_k "con" 0 <= k <= n space.en t.c.$ 
- $p_i in ZZ^2$ _(posizione)_
- $"dist"(p_i, p_(i + 1)) = 1$ _(adiacenza)_
- $exists.not p_i, p_j space.en i != j and p_i = p_j$ _(non sovrapposizione)_
]

#definition(title: [conformazione completa (obiettivo)])[Uno stato è obiettivo quando $k = n$.]

#definition(title: [azione])[
    Dato uno stato *non obiettivo* (quindi $k < n$), l'insieme di azioni consiste nei possibili assegnamenti per $p_(k + 1)$ che rispettano le condizioni di _adiacenza_ e _sovrapposizione_.
  Un'insieme di azioni $A = { alpha in ZZ^2 }$.
]

Da questa modellazione del problema deriva un'importante osservazione, che permette di ottimizzare gli algoritmi di ricerca:

// - $p_0 = (0, 0)$ (origine)
//ai primi $k$ amminoacidi, con $0 <= k <= n$

// TODO: conviene rappresentarlo come un grafo? Come conviene rappresentarlo per fare la dimostrazione

#observation[
    Il grafo di ricerca per *ProteinFolding* è un *albero*.

*Dim.* Per dimostrarlo bisogna far vedere che non è possibile raggiungere lo stesso stato con sequenze di azioni diverse. Per assurdo, se fosse possibile, vorrebbe dire che uno stato $p_1, ..., p_k$ è stato raggiunto partendo da due stati $q_1, ..., q_(k - 1)$ e $r_1, ..., r_(k - 1)$, in uno di due modi:
    1. $q_i = r_i$ per ogni $0 <= i <= k - 1$, e $q_k != r_k$, quindi, per come sono definite le azioni, $p_k = q_k != r_k = p_k => p_k != p_k -><-$  
    2. $exists q_i != r_i$ per un qualche $0 <= i <= k - 1 ==> p_i = q_i != r_i = p_i$, ma questo non è possibile, perché non ci sono azioni che riassegnano una posizione già assegnata $-><-$

  // , ma questo non è possibile, perché si avrebbe $q_i != p_i = r_i$, ma la sequenza $q_1, ..., q_k$ è uguale a $p_1, ..., p_k$

    // - $q_i = r_i$ per ogni $0 <= i <= k - 1$, e sono stati dati assegnamenti diversi a $q_k$ e $r_k$, ma ciò non è possibile, perché $q_k = p_k = r_k$
    // - $exists q_i != r_i$ per un qualche $0 <= i <= k - 1$, ma questo non è possibile, perché si avrebbe $q_i != p_i = r_i$, ma la sequenza $q_1, ..., q_k$ è uguale a $p_1, ..., p_k$
    
    // *diversi* 
]

\
L'*Oss. 1* permette di ottimizzare la ricerca, perché non serve controllare se uno stato è già stato esplorato o sta già in frontiera (ogni stato generato è nuovo, quindi non sta né in frontiera né nell'isieme degli esplorati).

Dato che il problema presenta forti *simmetrie*, si può ridurre lo spazio di ricerca evitando le azioni che generano stati simmetrici o ruotati, permettendo solo le seguenti azioni:

- $p_0 = (0, 0)$ 
- $p_1 = (0, 1)$
- per $p_i$ con $i > 1$
    1. se $exists y_j forall j space.en j <= i and p_j = (0, y_j)$, dati $p_(i - 1) = (0, y_(i - 1))$ le azioni possibili sono $(0, y_(i - 1) + 1)$ (andare avanti) e $(1, y_(i - 1))$ girare a destra (queste due sono sempre possibili per come è costruita la catena, TODO: ottimizzare questo caso per non controllare se sono valide, altrimenti andare avanti, metterlo sotto forma di osservazione / teorema)
    2. altrimenti, $A = {}$ 
    // - altrimenti permetti solo l'azione che va avanti o a destra

#observation[
  Le azioni nel caso 1. rispettano sempre la non sovrapposizione (rispettano la posizione e sono adiacenti per costruzione)
  - l'azione $(0, y_(i - 1) + 1)$:
    - possibile perché se ci fosse un nodo in quella posizione questo avrebbe distanza euclidea 2, in contrasto con l'adiacenza (magari lo dovrei fare induttivamente?)
  - l'azione $(1, y_(i - 1))$ è sempre possibile perché $forall y_j, j <= i - 1$ si ha $x_j = 0$

]

#observation[
  Usando le regole sopra non si generano stati simmetrici, ruotati o traslati.

  *Dim*. Per induzione su $k$

  // *Caso Base*
  - $k = 0$: ...
  - $k = 1$: ...
  - $k = 2$: ...

  *Passo induttivo*
  - se c'è un giro
      - allora la proteina è una retta, dato che non ci sono cose simmetriche sotto, non può generare roba simmetrica andando avanti, e facendo il giro a destra non c'è roba ruotata
  - se non c'è un giro
      - eh, bella per me, ma dato che non sono simmetriche quelle sotto non è simmetrica neanche quella sopra, come riottengo l'ipotesi induttiva $k$ per una proteina lunga $k + 1$
]

== Euristica

Due parole veloci sul come l'idea di fondo è che proteine H vicine nella sequenza devono stare vicine nella proteina finale, o, in generale gli stati più "promettenti" sono quelli che hanno "più contatti" per ora.

TODO:
- euristica 2 (e calcolo dell'euristica)

#observation(title: [Ammissibilità])[

]


#observation(title: [Consistenza])[
]

#observation(title: [Critical ratio])[

]

== Possibili miglioramenti

- levare l'```rust Rc<AminoAcid>``` (il reference counter), ma servirebbe modificare l'interfaccia per il ```rust Problem```. L'obiettivo sarebbe possibilmente usare un ```rust usize``` per riferirsi allo stato.

// https://doc.rust-lang.org/reference/items/unions.html

#align(center)[
```rust
pub struct AminoAcid {
    pos: Pos,
    prev: Option<Rc<AminoAcid>>,
    depth: usize,
    first_turn: bool,
}
```
]

- verificare in modo più intelligente l'ammissibilità di un'azione senza dover scorrere tutta la proteina
- alternativamente, trovare una conformazione in memoria per gli stati in modo da tenere vicini gli stati visti più di frequente, e quelli "inutili" lasciarli in fondo

// *Obs*
// - il primo amminoacido è in posizione $(0, 0)$ la prima azione è sempre in alto
// - primo giro sempre a destra
// - per tutti gli altri casi tutte le azioni valide


// #show figure: set block(breakable: true)
// #show outline.entry.where(level: 1): it => { show repeat : none; v(1.1em, weak: true); text(size: 1em, strong(it)) }
// #let reft(reft) = box(width: 8pt, place(dy: -8pt, 
//   box(radius: 100%, width: 9pt, height: 9pt, inset: 1pt, stroke: .5pt, // fill: black,
//     align(center + horizon, text(font: "CaskaydiaCove NFM", size: 7pt, repr(reft)))
//   )
// ))
// #set table(stroke: 0.25pt)
// #import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge, shapes.circle, shapes.diamond
