#import "template.typ": *

#show: doc => conf([E.A.6.12 (Rostering)], doc)

// Si consideri il seguente problema combinatorio:
//
// - In un ospedale vi è la necessità di definire i turni settimanali del personale infermieristico.
// - In particolare, vi sono I infermieri che devono essere assegnati ai diversi turni lavorativi, per tutti i giorni della settimana (dal lunedì alla domenica).
//
// - Ogni giornata è divisa in T turni (ad es., il turno 1 va dalle 8:00 alle 14:00, il secondo dalle 14:00 alle 20:00, ecc.). Alcuni tra i T turni sono “notturni”.
//
// - Si può assumere, senza perdita di generalità, che questi siano i turni identificati dagli interi tra 1 e N, per un dato $N <= T$.
//
// - Si vuole assegnare, ad ogni turno di ogni giorno della settimana, un insieme di infermieri in modo che:
//     1. Ogni turno sia coperto da almeno C infermieri;
//     2. Ogni infermiere, dopo aver lavorato per un turno diurno, abbia almeno R turni di riposo, e dopo aver lavorato per un turno notturno, non lavori fino alla fine del giorno successivo;
//     3. Ogni infermiere deve lavorare per almeno L turni nell’arco della settimana; in caso contrario, deve essere messo completamente a riposo (in altri termini, ogni infermiere deve lavorare per almeno L turni nella settimana, oppure mai).
//
// Si osservi che lo schema di turnazione è periodico.

// -- test

// - lunedì, ..., domenica
//     - $T$ turni per giornata
//         - i primi $N$ turni sono notturni
//
// - ad ogni turno $t$ di ogni giorno $g$ va assegnato un insieme ${i_1, ..., i_s}$ di infermieri
//     - in ogni turno ci sono almeno $C$ infermieri
//
// $I$ infermieri
// - ogni infermiere, dopo aver lavorato un turno $t >= N$ ha almeno $R$ turni di riposo
// - se il turno $t < N$ non lavora fino alla fine del giorno dopo
// - ogni infermiere lavora per almeno $L$ turni (oppure per $0$ turni quella settimana)
//
// voglio un mega tabellone
//
//
// #box(
//     width: 150%,
//     table(
//         columns: (auto, auto, auto, auto, auto, auto, auto, auto),
//         [], [lunedì], [martedì], [mercoledì], [giovedì], [venerdì], [sabato], [domenica],
//         [$t_1$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
//         [$t_2$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
//         [$t_3$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
//         [$t_4$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
//         [$t_5$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
//         [$t_6$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
//         [$t_7$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
//         [$t_8$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
//     ),
// )

== Modellazione

Dati i parametri $(I, T, N, C, R, L)$ siano
- $cal(I) = {1, ..., I}$ l'insieme di infermieri
- $cal(T) = {1, ..., T}$ l'insieme di turni possibilli in una giornata
- $cal(D) = {1, ..., 7}$ l'insieme di giorni della settimana

$"LP" = { X^i_(d, t) | i in cal(I) and d in cal(D) and t in cal(T)}$ t.c.
- $X^i_(d, t)$ è vera se l'infermiere $i$ è assegnato al turno $t$ il giorno $d$

Il problema si può modellare tramite una serie di vincoli

#let phi = sym.phi.alt

$
    phi = phi_(C"_infermieri")
$

// che funzione sto rappresentando?
// f(d, t) = i
// non è una funzione, è più una relazione
// ok, dovrei prendere un sottoinsieme degli infermieri, e dire che quel sottoinsieme è attivo o pure no?
// Nope, non conviene
// e se negassimo? Prendo tutti i sottoinsiemi < di C, e dico "non è possibile che queste siano vere e le altre false!"
// non conviene
//
// ho tutti and di or, a meno che non faccio una cosa tipo
//
// not (not x and not y and not z and not q) = (x or y or z or q)
// per ogni sottoinsieme più piccolo di che almeno una ci deve essere

Ad ogni turno vengono assegnati almeno $C$ infermieri

$
    phi_(C"_infermieri") =
    and.big_(d in cal(D) \ t in cal(T))
    or.big_(J subset.eq I \ |J| = C)
    and.big_(j in J) X^j_(d, t)
$

x y z

(x and y) or (x and z) or (y and z)

how do I make it CNF? un parto!

Devo negare! Come si può fare?

ogni turno ha almeno C infermieri
- prendo i sottoinsiemi di infermieri grossi C
- e dico che almeno uno di questi ha tutti gli infermieri a true

not exists J not J subset.eq I and |J| = C and ...

// Non ci sono turni con meno di C infermieri
//
// dovrei prendere tutti gli infermieri
// prenderne un sottoinsieme < C
// mettere quelle a true etc...
//
// not (not x and not y and not z)
// (x or y or z)
//
// not ((not x and not y) and (not x and not z) and (not y and not z))
//
// not (not x and not y) or not (not x and not z) or not (not y and not z)
// (x or y) or (x or z) or (y or z)
//
// (not x and not y and not z)
//
// Ah, prendo I - C infermieri, e dico "non è possibile che più I - C infermieri siano false)


// not and.big_(j in J) not X^j_(d, t)
// equiv
// and.big_(d in cal(D) \ t in cal(T) \ J subset.eq I \ |J| = C)
// or.big_(j in J) X^j_(d, t)
