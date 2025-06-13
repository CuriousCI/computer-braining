#import "template.typ": *

#show: doc => conf([E.A.5.9 (Meetings)], doc)

== Modellazione

// Dati i parametri $N, K, M, T, S$
// - $cal(N) = {1, ..., N}$ l'insieme di identificatori dei manager
// - $cal(T) = {1, ..., T}$ l'insieme di turni possibili
// - $cal(S) = {1, ..., S}$ l'insieme di stanze possibili
//
// Siano $(X, D, C)$ t.c.
//
// $
//     X = & { X^n_t | n in cal(N) and t in cal(T)} union \
//     & { Y^t_s | t in cal(T) and s in cal(S) }
// $
//
// - $X^n_t$ è la sala a cui è assegnato il manager $n$ al turno $t$
// - $Y^t_s$ vale 1 se e solo se la sala $s$ al turno $t$ viene usata per un meeting
//
// Con i rispettivi domini
//
//
// $
//     D = { D_(X^n_t) | D_(X^n_t) = cal(S) } union { D_(Y^t_s) | D_(Y^t_s) = {0, 1} }
// $
//
// E l'insieme di vincoli
//
// $
//     C = C_M union C_K union C_"ALO"
// $
//
// Per rendere la discussione più efficiente si vogliono organizzare una serie di $M$ incontri
//
// $
//     C_M = { angle.l { Y^t_s | t in cal(T) and s in cal(S) }, sum_(t in cal(T) \ s in cal(S)) = M angle.r }
// $
//
// Gli incontri vedono coinvolti solo $K$ partecipanti
//
//
// $
//     & C_K = { angle.l \
//         & quad { X^n_t | n in cal(N) and t in cal(T) }, \
//         & quad "global_carinality"({ X^n_t | n in cal(N) }, (1, ..., S), (K, ..., K)) \
//         &angle.r, t in cal(T) }
// $
//
// Ogni partecipante deve essere coinvolto in almeno un incontro con ognuno degli altri partner
//
// $
//     C_"ALO" = { angle.l {}, Y^t_s -> angle.r }
// $


// coinvolti K partecipanti
// M incontri

// per ogni turno e ogni persona devo indicare la stanza
// quindi persona n nel turno t sta nella stanza s

// $D = {1, ..., S}$ per tutti le variabili

// - $cal(K) = {1, ..., K}$ l'insieme di posti in una stanza
// == Modellazione
//
// Dati i parametri $N, K, M, T, S$ siano
// - $cal(N) = {1, ..., N}$ l'insieme di identificatori dei manager
// - $R = min(floor(N / K), S)$ il numero massimo di stanze utilizzabili in un turno
// - $cal(R) = {1, ..., R}$
// - $cal(K) = {1, ..., k}$ l'insieme di posti in una stanza
// - $cal(T) = {1, ..., T}$ l'insieme di turni possibili
//
// E sia $(X, D, C)$ l'istanza parametrica di CSP t.c.
//
// $
//     X = { X_(t, r, k) | t in cal(T) and r in cal(R) and k in cal(K) } union { Y_t | t in cal(T) }
// $
//
// - $X_(t, r, k)$ è l'id del manager al posto $k$ nella stanza $r$ al turno $t$
// - $Y_t$ è il numero di stanze usate al $t$-esimo turno
//
// Con i rispettivi domini
//
// $
//     D = { D_(X_(t, r, k)) | D_(X_(t, r, k)) = cal(N) } union { D_(Y_t) = cal(R) }
// $
//
// Ed l'insieme di vincoli
//
// $
//     C = C_M union C_"alldiff" union C_"symmetry" union C_"pairs"
// $
//
// La somma delle stanze usate nei vari turni corrisponde al numero totale di incontri
//
// $
//     C_M = {angle.l { Y_t | t in cal(T) } , sum_(t in cal(T)) Y_t = M angle.r}
// $
//
// (alldifferent) In un dato turno un manager non può stare in due stanze in due posti diversi
//
// $
//     C = { "alldifferent"(X_(t, r, k)) | t in cal(T) }
// $
//
// (symmetry breaking) In una determinata stanza, l'ordine dei manager non conta, quindi se ne può fissare uno
//
// $
//     & C_"symmetry" = { \
//         & quad angle.l {X_(t, r, k), X_(t, r, k + 1)}, X_(t, r, k) < X_(t, r, k + 1) angle.r | \
//         & quad t in cal(T) and r in cal(R) and k in cal(K) \
//         & }
// $
//
// #pagebreak()
//
// Per ogni coppia di manager, ci deve essere un turno e una stanza in cui questi due si incontrano (è un vincolo su tutte le variabili, un po' bruttino... ma fa il suo)
//
// $
//     & C_"pairs" = { \
//         & quad angle.l {X_(t, r, k), X_(t, r, l), Y_t | t in cal(T) and r in cal(R) and k, l in cal(K)}, \
//         & quad forall i, j \
//         & quad quad (i, j in cal(N) and i < j) -> \
//         & quad quad quad exists t, r, k, l quad \
//         & quad quad quad quad t in cal(T) and r in cal(R) and k,l in cal(K) and \
//         & quad quad quad quad k < l and r <= Y_t and X_(t, r, k) = i and X_(t, r, l) = j \
//         & quad angle.r | t in cal(T) and r in cal(R) and k, l in cal(K) and k < l \
//         & }
// $
//
// // Se in un dato turno una certa stanza è utilizzata, allora tutti gli gli incontri in quel turno e in quella stanza sono realizzati
// //
// // $
// //   & C_Z = { \
// //     & quad angle.l { X_(t, r, k), X_(t, r, l), Y_t, Z_(k, l) }, r <= Y_t -> Z_(X_(t, r, k), X_(t, r, l)) angle.r | \
// //     & quad t in cal(T) and r in cal(R) and k, l in cal(K) and k < l \
// //     & }
// // $
// //
// // Tutti gli incontri si devono realizzare
// //
// // $
// //   & C_Delta = { angle.l {Z_(n, m) | n, m in cal(N) and n < m}, and.big_(n, m in cal(N) \ n < m) Z_(n, m) space angle.r }
// // $
//
// == Istanziazione
//
// Istanziazione lasciata al lettore...
//
// #pagebreak()
//
// == Codifica MiniZinc
//
// #align(
//     center,
//     box(width: 130%)[
//         #minizinc[
//             ```c
//             include "globals.mzn";
//
//             int: N = 6;
//             int: K = 3;
//             int: M = 8;
//             int: T = 5;
//             int: S = 6;
//
//             int: R = min(N div K, S);
//
//             array[1..T, 1..R, 1..K] of var 1..N: X;
//             array[1..T] of var 0..R: Y;
//
//             constraint sum(t in 1..T)(Y[t]) = M;
//
//             constraint forall(t in 1..T)(
//               alldifferent([X[t, r, k] | r in 1..R, k in 1..K])
//             );
//
//             constraint forall(t in 1..T, r in 1..R, k in 1..K - 1)(
//               X[t, r, k] < X[t, r, k + 1]
//             );
//
//             constraint forall(i in 1..N - 1, j in i + 1..N)(
//               exists(t in 1..T, r in 1..R, k in 1..K - 1, l in k + 1..K)(
//                 X[t, r, k] = i /\ X[t, r, l] = j /\ r <= Y[t]
//               )
//             );
//
//             output[
//               "turn" ++ show(t) ++ ": | " ++ concat(
//                 [concat([show_int(-2, X[t, r, k]) ++ " " | k in 1..K]) ++ "| " | r in 1..R]
//               ) ++ "\n" | t in 1..T
//             ];
//
//             output [
//               show(Y[t]) ++ " " | t in 1..T
//             ];
//             ```
//         ]
//     ],
// )
//
// // per ogni incontro generlo la conformazione dei posti, e rompo la simmetria etc...
// // Ok, adesso devo garantire di poter distribuire in T turni con al massimo R stanze
// // i vari posti
// //
// // se ho più incontri, li metto tutti in turni diversi,
// // ok, dalla forma degli incontri è possibile derivare una turnazione e un set di aule.
// // constraint: turns / rooms = numero di
// // trovo un assegnamento ai turni e alle stanze
// // in base alle stanze generate
// // che deve essere valido
// // se non è valido, modifica la conformazione
// // Y_(t, s) = M quindi, al turno t, stanza s c'è il meeting M
// // e devo vincolare le stanze
// // ma non so quante s posso avere
// // non posso avere tutto fissato, magari mettendo della ridondanza che conta cose
// // ma non posso avere un insieme fissato di cose (non so esattamente quante stanze uso in ogni turno)
// // HMMM! Idea! Magari posso dire (in questo turno uso esattamente X stanze! Al meno uno al più uno
// // AHHHHH, geniale, mi tengo una variabile per dire quante stanze ho usato al turno i,
// // e mi tengo dei domini, e di co che la somma sia esattamente M
//
// // vorrei fissare in qualche modo le stanze
// // ma devo garantire che le stanze stanno in turni diversi
// //
// // poss
// // dovrei mettere un brutto vincolo, del tipo:
// // - per ogni coppia di stanze che hanno lo stesso turno devo garantire il fatto che le
// //   persone nelle due stanze siano diverse
// // - sennò posso usare un alldifferent in modo matemagico:
// //      - prendo tutte le
//
// // union { Y_m | m in cal(M)}
// // - $Y_m$ è la coppia $("turno", "stanza")$ usata per l'$m$-esimo meeting
//
// // $
// //   D = { D_(X_(t, r, k)) | D_(X_(t, r, k)) = cal(N) } union { D_(Y_m) = cal(T) times cal(R)}
// // $
//
//
// // $
// //   C = C_("alldiff"\_X_t) union C_("alldiff"\_Y)
// //   // C = C_"alldiff" union C_M union C_Delta union C_"ord"
// // $
//
//
// // (alldifferent) Ad un dato turno in ogni posizione c'è un manager diverso
// //
// // $
// //   C_("alldiff"\_X_t) = {"alldifferent"(X_(t, r, k)) | t in cal(T)}
// // $
// //
// // (alldifferent) Tutti gli incontri si svolgono in stanze diverse a turni diversi
// //
// // $
// //   C_("alldiff"\_Y) = {"alldifferent"(Y_m)}
// // $
//
// // Ad ogni turno bisogna prendere almeno un incontro
// //
// // t - m variabili una per stanza (cioè: le prime m variabili di Y devono avere t tutte diverso)
//
// // Gli incontri totali sono esattamente $M$
// //
// // $
// //   C_M = {
// //     angle.l {Z_(t, s) | t in cal(T) and s in cal(S)} angle.r
// //   }
// // $
//
// // no, non mi piace, devo trovare un modo per dire esattamente gli incontri, e riempire ciascun incontro, posso fissare una matrice N $times$ M, e poi riempire quella, non importa come!
//
// // - $cal(P) = {1, ..., k dot.c Delta}$ l'insieme di posizioni possibili per un manager
// // TODO: off by 1
// // - $cal(D) = {1, ..., D}$
// // - $cal$
//
// // 3 stanze -> 2 divisori, però, quello che vorrei, è magari avere un divisore sempre in posizione 0, e uno sempre alla fine che fisso
// // 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
// //
// // ok, 10 persone, 3 persone per incontro
// // floor(10/3) e mi da 3, il numero di gruppi, quindi 3 - 1 il numero di divisori
// // se ho 10 stanze posso sempre e comunque fare al più 2 divisori + 2 quindi 4, e devono stare tutti a distanza 3, perché non è detto che il primo gruppo inizi proprio con il primo divisore, anche se così sto aggiungendo troppe possibilità in più... nah, magari li fisso i divisori, in realtà NON serve renderli mobili, basta che mi rigiro i clienti, tanto ho la permutazione e da quella so in automatico i gruppi, tanto i divisori sono fissi! E vanno ogni k
//
//
// // - $Z_m$ indica la coppia $("turno", "stanza")$ usata per l'$m$-esimo meeting
//
// // X = { X_(t, p) | t in cal(T) and p in cal(P) } union { Z_m | m in cal(M)}
//
// // - $X_(t, p)$ è l'id del manager in posizione $p$ al turno $t$
// // - $Z_m$ indica la coppia $("turno", "stanza")$ usata per l'$m$-esimo meeting
//
// // è vera se al turno $t$ la sala $s$ è stata usata per un incontro
//
// // Anche se questo $Z_(t, s)$ a occhio si può evitare... beh
// //
// // Con i rispettivi domini
// //
// // $
// //   D = { D_(X_(t, p)) | D_(X_(t, p)) = cal(N) } union { D_(Z_m) = cal(T) times Delta}
// // $
//
//
// // - K numero massimo partecipanti per incontro, quindi differenza fra due divisori
// // - M numero di incontri da organizzare, tipo il numero di gruppi? Ma spostato su tutti i turni... che palpebre
// // - T numero di turni entro cui fare gli incontri
// // - S numero di sale
//
// // - $cal(M) = {1, ..., M}$
// // - $cal(S) = {1, ..., S}$
// // - $cal(K) = {1, ..., K}$
// // - $cal(T) = {1, ..., T}$
// // - $cal(P) = cal(N)$
//
// // ogni partecipante coinvolto in almeno un incontro con gli altri partner
// //
// // - $N > 0$ manager di diverse aziende
// // - $M > 0$ incontri
// // - $K <= N$ partecipanti per incontro
// // - $S$ sale affittate
// // - $T$ turni in cui pianificare gli incontri
// //   - più incontri contemporaneamente se l'insieme di partner è disgiunto
//
//
// // - $S$
//
// // M incontri... come mi limitiamo?
//
// // $(N, K, M, T, S)$
//
// // Al posto di solo il divisore in mezzo, posso mettere
// // - 1 (sempre fissato)
// // - quelli in mezzo
// // - quello finale (n)
// //
// // quindi mi basta prendere le coppie di divisori adiacenti per avere un range
// // e dato che ho D + 2 nella lista, allora ho D + 1 variabili di tipo Z, o una cosa del genere
//
//
// // rischia di esplodere tipo troppop
//
//
//
// // - $X = { X_(t, s) | t in cal(T) and s in cal(S) }$
// // - $D = { D_(X_(t, s)) | D_(X_(t, s)) = cal(N) }$
// // - $C = { }$
//
// // devo dire ad un certo turno t, in una certa sala s, c'è un certo manager n (possibilmente in posizione k?)
// //
// // ok, no, devo dire ache ad un certo turno t, in una certa sala s, ad un certo posto m c'è un certo manager n
// //
// // No, neanche questa va bene, perché, perché non ho esattamente m manager, ma al più m manager
// // - M deve far parte di un vincolo di at most
// //
// // - Neanche (t, s) va bene, perché devo dire che c'è un insieme di manager, NON un manager solo...
// //   - potrei fare n variabili e fare una cosa booleana, per cui dico se un certo manager sta in una certa sala ad un certo
// //     turno oppure no, e a quel punto basta che li conto con gli at most constraints
// //   - dovrei dire che una persona non sta in più sale contemporaneamente... hmmm...
// //
// // #pagebreak()
// //
// // Fermo, idea!!! Sfruttiamo le permutazioni...
// //
// // - prendiamo i manager
// // - li mettiamo in fila
// // - generiamo una permutazione
// // - mettiamo dei divisori in mezzo
// // - (questi divisori devono stare a distanza m)
// // - rompiamo la simmetria all'interno dei divisori
// // - al meno un incotro, quindi così va bene, no?
// // \
// // - alldifferent delle permutazioni
// // - si scriverebbe forall n1, n2 exists s exists t n1 and n2 in s
// // - divisori a distanza al più $M$
// // - quanti divisori metto? Beh, se ho $S$ stanze, e in ogni meeting ci possono essere al massimo $M$ persone probabilmente
// //   i divisori devono essere $min(floor(N / M), S - 1)$
// // - e i restanti basta ignorarli!
// // - ok, voglio un'altra variabile per dirmi se un certo incontro lo prendo oppure no
// // - e devo dire che il numero di questo tipo di variabili vere è esattamente M
//
//
//
//
