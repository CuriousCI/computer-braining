#import "math.typ": *

#set text(font: "New Computer Modern", lang: "it", weight: "light", size: 11pt)
#set page(margin: 1.75in)
// #set par(leading: 0.55em, spacing: 0.85em, first-line-indent: 1.8em, justify: true)
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

#definition(title: [conformazione (stato)])[
Una conformazione è un assegnamento $p_1, .., p_k "con" 1 <= k <= n space.en t.c.$ 
- $p_i in ZZ^2$ // _(posizione)_
- $"dist"(p_i, p_(i + 1)) = 1$ _(adiacenza)_
- $exists.not p_i, p_j space.en i != j and p_i = p_j$ _(non sovrapposizione)_
Una conformazione è detta _parziale_ se $k < n$, _completa_ altrimenti (una conformazione completa è considerata uno stato obiettivo per la ricerca).
]

#definition(title: [modello di transizione])[
  Data una conformazione $p_1, ..., p_k$, l'insieme delle azioni $A^p_k$ è definito come segue: $A^p_k = emptyset "se" k = n$, altrimenti se $k < n$

$
& A^p_k = {(x, y) | \
& quad (x, y) in ZZ^2 and \
& quad exists x_k, y_k \ 
& quad quad p_k = (x_k, y_k) and \
& quad quad ( \
& quad quad quad ((x = x_k + 1 or x = x_k - 1) and y = y_k) or\
& quad quad quad ((y = y_k + 1 or y = y_k - 1) and x = x_k) \
& quad quad ) and \
& quad quad exists.not p_i space.en p_i = (x, y) \
& }
$
]

Dato uno stato $p_1, ..., p_k$ e data un'azione $alpha_(k + 1) in A^p_k$, lo stato generato è $p'_1, ..., p'_(k + 1)$ t.c. 

$
p'_i = cases(
  p_i & "se" i <= k \
  alpha_(k + 1)  & "se" i = k + 1
)
$

(Tecnicamente dovrei dimostrare che $p'_1, ..., p'_(k + 1)$ rispetta l'adiacenza e la non sovrapposizione. L'adiacenza vale dato che una sola delle due coordiante cambia, e cambia esattamente di 1, quindi la distanza euclidea fra $p_(k + 1)$ e $p_k$ è esattamente 1. La non sovrapposizione è garantita dal fatto che non esiste nessun $i != k + 1 "t.c." p_i = (x, y)$)

Si considera che, indipendentemente dalla percezione, lo stato iniziale è $p_1 = (0, 0)$ (per evitare conformazioni equivalenti ma traslate). Da questa modellazione del problema deriva un'importante osservazione, che permette di ottimizzare gli algoritmi di ricerca:

// Dato che $A^p_0$ non è mai definito (non c'è un amminoacido "precedente" da cui continuare, quindi non esistono $x_0, y_0$), 

#observation[
Il grafo di ricerca per *ProteinFolding* è un *albero*.

\
*Dim.* Per dimostrarlo bisogna far vedere che non è possibile raggiungere lo stesso stato con sequenze di azioni diverse. Per assurdo, si supponga che lo stato $p_1, ..., p_k$ sia stato raggiunto con due sequenze di azioni $alpha_1, ..., alpha_k$ e $beta_1, ..., beta_k$ diverse, per cui esiste $i "t.c." alpha_i != beta_i$, quindi, per il modello di transizione, $p_i = alpha_i != beta_i = p_i => p_i != p_i$, contraddizione. _(forse viene meglio per induzione su $k$, ma devo impostare meglio cosa voglio dimostrare, inoltre credo che dovrei usare in qualche modo la definizione di azione)_
]

L'*Oss. 1* permette di ottimizzare la ricerca, perché se dopo una transizione ogni stato è garantito nuovo, non serve controllare se questo è già stato esplorato o sta già in frontiera.

Dato che il problema presenta forti *simmetrie*, si può ridurre lo spazio di ricerca evitando le azioni che generano conformazioni simmetriche o ruotate, permettendo solo le seguenti azioni:

1. $A^p_1 = {(0, 1)}$ (rotazioni)
2. per $p_1, ..., p_k$ con $k > 1$
    1. se $forall j space.en j <= k space.en exists y_j space.en p_j = (0, y_j)$ (la conformazione non ha nessuna piega), allora $A^p_k = {(0, y_k + 1), (1, y_k)}$
    2. altrimenti $A^p_k$ è la stessa in *Def. 2*

#observation[
  Nel caso 2.1 le nuove azioni garantiscono la non sovrapposizione. In particolare:
  - per l'azione $(1, y_k)$ la garanzia deriva dal fatto che la conformazione ha tutte $x = 0$ 
  - per l'azione $(0, y_k + 1)$ l'argomentazione è un po' più complicata, ma sostanzialmente bisogna usare l'_adiacenza_ della conformazione per far vedere che non è possibile che ci sia un amminoacido in quella posizione (se tutte le $x$ sono 0), perché altrimenti si avrebbero due amminoacidi adiacenti nella sequenza ma con distanza 2 nella conformazione (bisognerebbe anche far vedere che $y_(k + 1$ non torna indietro, quindi che la conformazione è formata da $y_i >= 0$

  Questo è particolarmente vantaggioso, perché, se la non sovrapposizione è garantita di base, non serve controllare se le azioni la rispettano (un controllo che normalmente è in $O(k)$, qui sto provando a spremere la performance in tutti i modi possibili)
]

Tecnicamente bisognerebbe dimostrare che le nuove definizioni per $A^p_k$ rispettano tutte il modello di transizione, quindi che *Oss. 1* è ancora valida:
- per il caso 1., dato che $p_1 = (0, 0)$ per *Def. 2*, l'azione $(0, 1)$ è proprio una delle 4 azioni possibili
- per il caso 2.1 la non sovrapposizione è stata dimostrata sopra, e vale anche l'adiacenza (al massimo cambia una sola delle due coordinate, e cambia esattamente di 1)
- per il caso 2.2. si usa proprio *Def. 2*, quindi la situazione non cambia


#observation[
  Usando le regole sopra non si generano conformazioni simmetriche o ruotate _(intuitivamente regge, ma è un po' più ostica da dimostrare)._

  \
  *Dim*. Per induzione su $k$

  - $k = 1$: ...
  - $k = 2$: ...

  *Passo induttivo*
  1. se non c'è una piega
      - allora la conformazione è dritta, dato che la conformazione precedente non ha simmetrie o rotazioni, non si può generare roba simmetrica andando avanti, e facendo il giro a destra non c'è roba ruotata o simmetrica
  2. se c'è una piega
      - usare in qualche modo modo l'ipotesi induttiva per far vedere che partendo da una sequenza senza simmetrie le nuove azioni non possono generare stati simmetrici
]

== Euristica

Due parole veloci sul come l'idea di fondo è che proteine H vicine nella sequenza devono stare vicine nella proteina finale, o, in generale gli stati più "promettenti" sono quelli che hanno "meno contatti non realizzati" per ora.

#definition(title: "Costo")[
    Tocca dare ad un certo punto la definizione di costo. Ad alto livello il costo è dato dal "numero di contatti H non realizzati", e l'obiettivo è minimizzarlo.
]

Per ora ho provato diverse euristiche, ma per nessuna era perfettamente chiaro il funzionamento (anche se i risultati erano molto promettenti, queste euristiche misuravano parametri che non erano legati a come viene effettivamente misurato il costo), e non era chiaro se fosse garantita la consistenza. 

Dopo un po' di riflessione queste sono alcune idee per un'euristica che sulla carta dovrebbe funzionare benissimo (modulo i dettagli implementativi) 

- solo l'amminoacido finale e quello iniziale possono avere 3 contatti, un amminoacido H in mezzo ne può avere al massimo 2 (devo capire bene perché, ma questa osservazione velocizza i tempi in un modo assurdo, forse per come vengono influenzati i costi... devo sempre verificare se è corretta; inoltre questa osservazione non è legata all'euristica, influenza direttamente il costo)

- data una conformazione serve un modo veloce per poter calcolare, per tutti gli amminoacidi H non assegnati, il numero di contatti che non verranno sicuramente realizzati, ma che altrimenti sarebbero stati possibili (non quelli dovuti a causa delle distanze, ad esempio per la proteina H P P P H non è possibile avere un contatto a prescindere... dovrei dimostrare che per poter avere un contatto il numero di amminoacidi in mezzo deve essere pari)

- sarebbe interessante vedere se questo numero è memorizzabile all'interno dello stato, e se c'è un modo per aggiornarlo ad ogni transizione, senza doverlo ricalcolare da capo (velocizzerebbe di molto i calcoli)

// 3 non made contacts only for the first and final
// amminoacid, otherwise an amminoacid in the middle can make
// only two contacts
//
// heuristic... think of it as
// "minimize the number of 'not made contacts'"
//
// given a conformation, the heuristic is the
// "number of contacts I don't expect to make"
// (and it should be smaller than the actual
// contacts I don't make, so I have to be certain
// that a certain contact can be made... I also
// need to check I don't count twice the same contact,
// or at least consider the fact that they are mutually exclusive,
// maybe a contact can't be made if ANY of the previous already assigned
// proteins can't be reached)
// at this point the problem is the same, but inverted, how can I simplify it?
// and in some way keep it in the state (with a low overhead) without needing
// to recalculate again? (does it depend on the whole protein or just the
// new amminoacid added?)
//
// Given an H not yet assigned, a contact can be made iff
// - I have an H with an even distance
// - I have enough spots for it
// Not enough... there's a limited number of H
// I can consider for "non made contacts" at most the 2 previous candidates
// So I can basically look at the last 3 H at even distance
// from the current H (not assigned), and check if a contact can be made for
// those amminoacids, and it can't be made if
// - the distance needed to touch is greater than 1/2 the distance
// - the amminoacid has no empty neighbours covered
//
// ...thechnically one should store the empty
// precalc the "next H"

#observation(title: [Ammissibilità])[

]


#observation(title: [Consistenza])[
]

#observation(title: [Critical ratio])[
    Per la critical ration il discorso è ancora un po' fumoso: ho provato diverse esecuzioni sul cluster, in un caso fissando $n$ e generando le H in modo casuale (anche il numero di H è deciso in modo uniforme)... ma i risultati non erano consistenti (c'erano diversi picchi e ogni volta cambiavano per numero di H diversi). Quindi ipotizzo che la critical ratio non dipenda solo dal rapporto fra $n$ e il numero di H.

    Provando con H tutte adiacenti, invece, si vede come per poche H c'è un solo picco, ed è sempre nello stesso posto. Ma il problema è che queste H sono tutte adiacenti, e non sono rappresentative del caso medio.

    Servirebbe provare a trovare un valore che dipenda non solo dal numero di H, ma anche dalla loro disposizione.
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

- verificare in modo più intelligente la non sovrapposizione di un'azione senza dover scorrere tutta la proteina
- alternativamente, trovare una conformazione in memoria per gli stati in modo da tenere vicini gli stati visti più di frequente, e quelli "inutili" lasciarli in fondo
- trovare un modo per eliminare dalla memoria gli stati una volta che sono stati esplorati: ad ogni esplorazione verrebbe eliminato uno stato, e, nel caso peggiore, ne verrebbero aggiunti 3

// #observation[
//   Le azioni nel caso 1. rispettano sempre la non sovrapposizione (rispettano la posizione e sono adiacenti per costruzione)
//   - l'azione $(0, y_(i - 1) + 1)$:
//     - possibile perché se ci fosse un nodo in quella posizione questo avrebbe distanza euclidea 2, in contrasto con l'adiacenza (magari lo dovrei fare induttivamente?)
//   - l'azione $(1, y_(i - 1))$ è sempre possibile perché $forall y_j, j <= i - 1$ si ha $x_j = 0$
//
// ]


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

// Per assurdo, se fosse possibile, vorrebbe dire che uno stato $p_1, ..., p_k$ è stato raggiunto partendo da due stati $q_1, ..., q_(k - 1)$ e $r_1, ..., r_(k - 1)$, in uno di due modi:
//     1. $q_i = r_i$ per ogni $0 <= i <= k - 1$, e $q_k != r_k$, quindi, per come sono definite le azioni, $p_k = q_k != r_k = p_k => p_k != p_k -><-$  
//     2. $exists q_i != r_i$ per un qualche $0 <= i <= k - 1 ==> p_i = q_i != r_i = p_i$, ma questo non è possibile, perché non ci sono azioni che riassegnano una posizione già assegnata $-><-$

  // , ma questo non è possibile, perché si avrebbe $q_i != p_i = r_i$, ma la sequenza $q_1, ..., q_k$ è uguale a $p_1, ..., p_k$

    // - $q_i = r_i$ per ogni $0 <= i <= k - 1$, e sono stati dati assegnamenti diversi a $q_k$ e $r_k$, ma ciò non è possibile, perché $q_k = p_k = r_k$
    // - $exists q_i != r_i$ per un qualche $0 <= i <= k - 1$, ma questo non è possibile, perché si avrebbe $q_i != p_i = r_i$, ma la sequenza $q_1, ..., q_k$ è uguale a $p_1, ..., p_k$
    
    // *diversi* 


  // $
  // A^p_k = cases(
  //   emptyset & "se " k = n \
  //   {(x, y) | (x, y) in ZZ^2 and exists x_k, y_k space.en p_k = (x_k, y_k) }
  // )
  // $

  // Dato uno stato *non obiettivo* (quindi $k < n$), l'insieme di azioni consiste nei possibili assegnamenti per $p_(k + 1)$ che rispettano le condizioni di _adiacenza_ e _sovrapposizione_.
  // Un'insieme di azioni $A = { alpha in ZZ^2 }$.

// - $p_0 = (0, 0)$ (origine)
//ai primi $k$ amminoacidi, con $0 <= k <= n$

// TODO: conviene rappresentarlo come un grafo? Come conviene rappresentarlo per fare la dimostrazione

//, l'idea è quella di modellare uno *stato* come segue:
// (l'amminoacido è posizionato nel piano)

// #definition(title: [conformazione completa (obiettivo)])[Uno stato è obiettivo quando $k = n$.]

    // , dati $p_(i - 1) = (0, y_(i - 1))$ le azioni possibili sono $(0, y_(i - 1) + 1)$ (andare avanti) e $(1, y_(i - 1))$ girare a destra (queste due sono sempre possibili per come è costruita la catena, TODO: ottimizzare questo caso per non controllare se sono valide, altrimenti andare avanti, metterlo sotto forma di osservazione / teorema)
    // - altrimenti permetti solo l'azione che va avanti o a destra

      // ma dato che non sono simmetriche quelle sotto non è simmetrica neanche quella sopra, come riottengo l'ipotesi induttiva $k$ per una proteina lunga $k + 1$
