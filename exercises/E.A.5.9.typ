#import "template.typ": *

#show: doc => conf([E.A.5.9 (Meetings)], doc)

#let scr(it) = text(
  features: ("ss01",),
  box($cal(it)$),
)

== Modellazione

Dati i parametri $N, K, M, T, S$ siano
- $cal(N) = {1, ..., N}$ l'insieme di *id* dei manager
- $cal(P) = cal(N)$ l'insieme di *posizioni* possibili per un manager
- $D = min(N / M, S)$ il numero di divisori per separare gli incontri // TODO: off by 1
- $cal(D) = {1, ..., D}$
- $cal$

E sia $(X, D, C)$ l'istanza parametrica di CSP t.c.
- $X = { X_(t, p) | t in cal(T) and p in cal(P) } union { Y_d | d in cal(D) } union { Z_(t, s) | t in cal(T) and s in cal(S) }$

  - $X_(t, p)$ è l'id del manager in posizione $p$ al turno $t$

  - $Y_d$ è la posizione del $d$-esimo divisore

  - $Z_(t, d)$ è vera se al turno $t$ è stato effettuato l'incontro $d$

- $D = { D_(X_(t, n)) | D_(X_(t, n)) = cal(N) }$

- $C = { }$


// - K numero massimo partecipanti per incontro, quindi differenza fra due divisori
// - M numero di incontri da organizzare, tipo il numero di gruppi? Ma spostato su tutti i turni... che palpebre
// - T numero di turni entro cui fare gli incontri
// - S numero di sale

// - $cal(M) = {1, ..., M}$
// - $cal(S) = {1, ..., S}$
// - $cal(K) = {1, ..., K}$
// - $cal(T) = {1, ..., T}$
// - $cal(P) = cal(N)$

// ogni partecipante coinvolto in almeno un incontro con gli altri partner
//
// - $N > 0$ manager di diverse aziende
// - $M > 0$ incontri
// - $K <= N$ partecipanti per incontro
// - $S$ sale affittate
// - $T$ turni in cui pianificare gli incontri
//   - più incontri contemporaneamente se l'insieme di partner è disgiunto


// - $S$

// M incontri... come mi limitiamo?

// $(N, K, M, T, S)$

// Al posto di solo il divisore in mezzo, posso mettere
// - 1 (sempre fissato)
// - quelli in mezzo
// - quello finale (n)
//
// quindi mi basta prendere le coppie di divisori adiacenti per avere un range
// e dato che ho D + 2 nella lista, allora ho D + 1 variabili di tipo Z, o una cosa del genere


// rischia di esplodere tipo troppop



// - $X = { X_(t, s) | t in cal(T) and s in cal(S) }$
// - $D = { D_(X_(t, s)) | D_(X_(t, s)) = cal(N) }$
// - $C = { }$

devo dire ad un certo turno t, in una certa sala s, c'è un certo manager n (possibilmente in posizione k?)

ok, no, devo dire ache ad un certo turno t, in una certa sala s, ad un certo posto m c'è un certo manager n

No, neanche questa va bene, perché, perché non ho esattamente m manager, ma al più m manager
- M deve far parte di un vincolo di at most

- Neanche (t, s) va bene, perché devo dire che c'è un insieme di manager, NON un manager solo...
  - potrei fare n variabili e fare una cosa booleana, per cui dico se un certo manager sta in una certa sala ad un certo
    turno oppure no, e a quel punto basta che li conto con gli at most constraints
  - dovrei dire che una persona non sta in più sale contemporaneamente... hmmm...

#pagebreak()

Fermo, idea!!! Sfruttiamo le permutazioni...

- prendiamo i manager
- li mettiamo in fila
- generiamo una permutazione
- mettiamo dei divisori in mezzo
- (questi divisori devono stare a distanza m)
- rompiamo la simmetria all'interno dei divisori
- al meno un incotro, quindi così va bene, no?
\
- alldifferent delle permutazioni
- si scriverebbe forall n1, n2 exists s exists t n1 and n2 in s
- divisori a distanza al più $M$
- quanti divisori metto? Beh, se ho $S$ stanze, e in ogni meeting ci possono essere al massimo $M$ persone probabilmente
  i divisori devono essere $min(floor(N / M), S - 1)$
- e i restanti basta ignorarli!
- ok, voglio un'altra variabile per dirmi se un certo incontro lo prendo oppure no
- e devo dire che il numero di questo tipo di variabili vere è esattamente M




