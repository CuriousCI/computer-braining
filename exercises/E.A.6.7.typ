#import "template.typ": *

#show: doc => conf([E.A.6.7 (HC-VIP)], doc)

#let casa = emph(math.italic[casa])
#let bus = emph(math.italic[bus])

// possibili ottimizzazioni: levare i cappi dai #bus, tanto sono inutili nella soluzione

== Modellazione

Dati i parametri $I, V, G = (I, "bus")$ t.c.
- $#casa in I$
- $V subset.eq I \/ {#casa}$
- $#bus subset.eq I times I$
- $|V| <= (|I|) / 2$

Si definiscono le seguenti variabili:

// c -> c1 -> c2 -> c3 -> c

- $P = |I|$ è il numero di #bus da prendere in un percorso che parte da #casa, visita tutti gli indirizzi esattamente una volta e ritorna a #casa
  - servono $|I| - 1$ #bus per visitare tutti gli indirizzi esattamente una volta più $1$ #bus per tornare a casa a fine giornata
- $cal(P) = {1, ..., P}$
- $cal(I) = {1, ..., |I|}$ l'insieme di identificatori per cui esiste una funzione $id$ biettiva t.c. $id : cal(I) -> I$ e $id(1) = #casa$
// - $cal(V) subset.eq cal(I)$ t.c. esiste un $v$ tale che $v_i in cal(v)$ è l'identificatore
- $cal(V) = { i | i in cal(I) and exists v space v in V and id(i) = v}$
- $X = { X_(i, j)^p | (i, j) in #bus and p in cal(P)}$ l'insieme di variabili dove
  - $X_(i, j)^p$ è vera se l'arco $(i, j) in #bus$ è stato percorso al $p$-esimo passo

// $I$ t.c. $id(1) = "casa"$




// TODO: non posso ripercorrere lo stesso arco più volte

\

$
  phi.alt = & phi.alt_"almeno_un_arco_per_passo" and \
  & phi.alt_"al_più_un_arco_per_passo" and \
  & phi.alt_"almeno_un_arco_per_indirizzo" and \
  & phi.alt_"al_più_un_arco_per_indirizzo" and \
  & phi.alt_"client_VIP_nella_prima_metà" and \
  & phi.alt_"partenza_da_casa" and \
  & phi.alt_"arrivo_a_casa"
$

\

TODO: non mi piace tanto "passo", ma non è che "istante" sia meglio, stiamo parlando di una lunghezza, non di una durata

\

$
  phi.alt_"almeno_un_arco_per_passo" & = and.big_(l in cal(L)) or.big_((i, j) in "bus") X_(i, j)^l \
  phi.alt_"al_più_un_arco_per_passo" & = and.big_(l in cal(L)) or.big_( (i_1, j_1), (i_2, j_2) in "bus" \ i_1 < i_2 or \ (i_1 = i_2 and j_1 < j_2) ) X_(i_1, j_1)^l -> not X_(i_2, j_2)^l \ // qui mi sa che ho toppato gravemente
  phi.alt_"almeno_un_arco_per_indirizzo" & = and.big_(j in I \ j != "casa") or.big_(i in I \ l in cal(L) \ (i, j) in "bus" ) X_(i, j)^l \
  phi.alt_"al_più_un_arco_per_indirizzo" & = and.big_(j, i_1, i_2 in I \ l in cal(L) \ (i_1, j), (i_2, j) in "bus" \ ) X_(i, j_1)^l -> not X_(i, j_2)^l\
  phi.alt_"client_VIP_nella_prima_metà" & = and.big_(v in cal(V) ) or.big_(i in cal(I) \ l in cal(L) \ l < L / 2 \ (i, v) in "bus") X_(i, v)^l\
  phi.alt_"partenza_da_casa" & = or.big_(i in cal(I) \ i != 1 \ (1, i) in "bus") X_(1, i)^1 \
  phi.alt_"arrivo_a_casa" & = or.big_(i in cal(I) \ i != 1 \ (i, 1) in "bus") X_(i, 1)^L
$

// - $"bus" subset.eq I times I$
// - $G = (I, "bus")$ è un grafo diretto
//
// $f : cal(I) -> I$
//
// Dato $I$ l'insieme di indirizzi da raggiungere, e $V subset.eq I - {"casa"}$ sia
// - $cal(I) = {1, ..., |I|}$ dove $i in cal(I)$ identifica l'$i$-esimo indirizzo ($1$ è la casa di partenza e arrivo)

== Istanziazione

il bro deve visitare una serire di clienti
- parte da casa sua
- li visita tutti
- torna a casa sua

- usa l'autobus
- l'ordine non conta
- ha solo biglietti per corsa semplice
  - quindi può raggiungere il cliente successivo usando un solo autobus

- trovare un itinerario tale che
  1. parte di casa la mattina
  2. torna a casa a fine giornata
  3. Raggiungere il cliente successivo (o casa sua, a fine giornata) dalla sua postazione corrente utilizzando un unico autobus;
  4. Visita un sottoinsieme $V$ dei clienti nella prima metà del percorso

- ho un mega elenco di tutte le linee autobus della città
  - ricavo tutte le coppie (A, B) t.c. esiste un unico autobus che collega A, B


pazzerello, quindi:
- mi devo visistare questo bel grafo diretto
- devo visitare ogni indirizzo al più una volta
- non solo, gli indirizzi in V li devo visitare nella prima metà...

un bel parto, ok, ma forse ci siamo
- forse dovrei creare una variabile per ogni arco di "bus"
- in più devo tenere in considerazione il tempo
- quindi avrei tipo una variabile per ogni arco per ogni istante di tempo
- e supponiamo che il tempo massimo sia $T = |I| + 1$
  - non lo supponiamo, è così, ci deve mettere esattamente questo tempo
    - non ci può mettere di meno, perché vorrebbe dire che non ha visitato tutti
    - non ci può mettere di più, perché vorrebbe dire che ha fatto doppio giro
    - così è facile anche scrivere vincoli del tipo i clienti $V$ stanno nella prima metà $T / 2$
    - posso forzare che la casa iniziale sia a true? No, devo forzare che l'arco iniziale sia per forza con la casa a sinistra, tipo $X_(1, v)^1$ è true per ogni v (che poi sarebbe $i in cal(I)$, non v)

1. in un dato istante di tempo un solo arco è preso
2. in un dato istante di tempo al più un arco è preso
3. devo aver visitato tutti i nodi a fine giornata (hm...)
  - vabbeh, l'idea sarebbe "esiste almeno un arco attivo che porta in quel nodo" per ogni nodo, e non importa quando
  - in più rafforzo dicendo che se questo arco esiste, per i clienti vip deve essere nella prima metà
  - ah, non visito un arco più di una volta (questo va a due a due)
4. mi manca altro?

=== Variabili

=== Vincoli

== Codifica SATCodec

=== ...

=== ...
