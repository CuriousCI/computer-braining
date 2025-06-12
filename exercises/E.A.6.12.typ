#import "template.typ": *

#show: doc => conf([E.A.6.12 (Rostering)], doc)

Si consideri il seguente problema combinatorio:

- In un ospedale vi è la necessità di definire i turni settimanali del personale infermieristico.
- In particolare, vi sono I infermieri che devono essere assegnati ai diversi turni lavorativi, per tutti i giorni della settimana (dal lunedì alla domenica).

- Ogni giornata è divisa in T turni (ad es., il turno 1 va dalle 8:00 alle 14:00, il secondo dalle 14:00 alle 20:00, ecc.). Alcuni tra i T turni sono “notturni”.

- Si può assumere, senza perdita di generalità, che questi siano i turni identificati dagli interi tra 1 e N, per un dato $N <= T$.

- Si vuole assegnare, ad ogni turno di ogni giorno della settimana, un insieme di infermieri in modo che:
    1. Ogni turno sia coperto da almeno C infermieri;
    2. Ogni infermiere, dopo aver lavorato per un turno diurno, abbia almeno R turni di riposo, e dopo aver lavorato per un turno notturno, non lavori fino alla fine del giorno successivo;
    3. Ogni infermiere deve lavorare per almeno L turni nell’arco della settimana; in caso contrario, deve essere messo completamente a riposo (in altri termini, ogni infermiere deve lavorare per almeno L turni nella settimana, oppure mai).

Si osservi che lo schema di turnazione è periodico.

== Modellazione

Dati i parametri $(I, T, N, C, R, L)$ siano

- lunedì, ..., domenica
    - $T$ turni per giornata
        - i primi $N$ turni sono notturni

- ad ogni turno $t$ di ogni giorno $g$ va assegnato un insieme ${i_1, ..., i_s}$ di infermieri
    - in ogni turno ci sono almeno $C$ infermieri

$I$ infermieri
- ogni infermiere, dopo aver lavorato un turno $t >= N$ ha almeno $R$ turni di riposo
- se il turno $t < N$ non lavora fino alla fine del giorno dopo
- ogni infermiere lavora per almeno $L$ turni (oppure per $0$ turni quella settimana)

voglio un mega tabellone

#box(
    width: 150%,
    table(
        columns: (auto, auto, auto, auto, auto, auto, auto, auto),
        [], [lunedì], [ martedì], [ mercoledì], [ giovedì], [ venerdì], [ sabato], [ domenica],
        [$t_1$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
        [$t_2$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
        [$t_3$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
        [$t_4$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
        [$t_5$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
        [$t_6$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
        [$t_7$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
        [$t_8$], [${i_1, i_2, i_3}$], [], [], [], [], [], [],
    ),
)

