#import "template.typ": *

#show: doc => conf([E.A.5.8 (Social Golfers)], doc)

== Modello

- $P$ soci
- $W$ settimane
- $G$ gruppi
- $S = (|P|) / G$

Si vuole incrementare la socialità (si vuole fare in modo che ogni coppia di soci giochi nello stesso gruppo al più una volta)

Ok, potrei aver bisogno di identificare i soci, quindi definisco
- $P = {1, ..., n}$
- Il mio output dovrebbe essere una cosa tipo $G dot.c W$ insiemi:
  - per ogni settimana devo dire quali sono i gruppi
  - in una data settimana ci sono $G$ gruppi, tutti di dimensione $S$

  - vincolo, una cosa del tipo:
    - data la settimana $i$, non esiste un gruppo nelle settimane \
      $i < j <= W$ per cui due giocatori di quel gruppo stanno in uno dei gruppi successivi

$(X, D, C)$

Siano
- $cal(G) = {1, ..., G}$
- $cal(W) = {1, ..., W}$
- $cal(S) = {1, ..., S}$
- $cal(P) = {1, ..., P}$

$
  X = { X_(w, g, s) | g in cal(G) and w in cal(W) and s in cal(S)}
$

ok, non basta, perché a questo punto $X$ è un insieme di valori, ma non posso avere un insieme di valori, ma non posso avere domini che sono insiemi (lol, che razza di dominio è???), a questo punto mi serve

$
  D = { D_X_(w, g, s) | D_X_(w, g, s) = cal(P)}
$

Vincoli?

- dentro a tutti i gruppi di una certa settimana i giocatori devono essere tutti diversi!

$
  C_1 = {"alldifferent"(X_(w, g, s)) | w in cal(W)}
$

- ok, e a questo punto?

"ho bisogno di 2 coppie di soci?, in qualche modo x e y identificano il socio?"
$
  C_2 = {angle.l {X_(w, i, x), X_(w, j, y), X_(w, i, x), X_(w, j, y) }, angle.r | \
    w in cal(W) and i in cal(G) and j in cal(G) and i < j}
$

- magari un socio, se stava nel gruppo 1 la settimana 1, non può stare nel gruppo nella settimana 2? Questo non funziona, perché non impedisce che non giochi con lo stesso giocatore
- in più lui potrebbe rimanere nel gruppo 1, e si spostano tutti gli altri

- ma scusate un attimo, non posso vedere come una settimana come una permutazione dei soci, quindi ho una funzione tipo $f : cal(P) -> P$ suriettiva e iniettiva, e a quel punto basta un alldifferent sulla permutazione; e per controllare il vincolo, controllo i bordi o una cosa del genere; tanto devo sempre paragonare con la settimana successiva

si torna momentamentamente a fare TPFI
