// algoritmi a miglioramento iterativo

pub fn steepest_ascent() {} // descent

// function steepest_ascent(problema): stato ottimo locale
//2 nodo_corrente ← crea_nodo(problema.stato_iniziale);
//3 while true do
//4 vicino ← uno a caso dei ‘vicini’ migliori di nodo_corrente;
//5 if nodo_corrente è migliore o della stessa qualità di vicino then
//6 return nodo_corrente.stato; /* ottimo locale, poss. piatto */
//7 else nodo_corrente ← vicino ;

pub fn hill_climping() {} //

//Variante: Hill-climbing con prima scelta
//1 function hill_climbing(problema): stato ottimo locale
//2 nodo_corrente ← crea_nodo(problema.stato_iniziale);
//3 while true do
//4 mossa_trovata ← false;
//5 while mossa_trovata = false and nodo_corrente ha ancora vicini
//da considerare do
//6 vicino ← prossimo ‘vicino’ di nodo_corrente;
//7 if vicino è migliore o della stessa qualità di nodo_corrente then
// /* nota: effettua mosse laterali */
//8 nodo_corrente ← vicino;
//9 mossa_trovata ← true;
//10 if mossa_trovata = false then
//11 return nodo_corrente.stato;

pub fn simulated_annealing() {}

//function
//simulated_annealing(problema, velocità_raffredd): stato ottimo locale
//2 input velocità_raffredd, una corrisp.: tempo → “temperatura”
//3 nodo_corrente ← crea_nodo(problema.stato_iniziale);
//4 for t from 0 to ∞ do
//5 T ← velocità_raffredd[t];
//6 if T = 0 then return nodo_corrente;
//7 vicino ← un ‘vicino’ random di nodo_corrente;
//8 if vicino è migliore di nodo_corrente then
// /* esegui sempre mosse migliorative */
//9 nodo_corrente ← vicino;
//10 else
// /* valuta se eseguire mosse peggiorative */
//11 ∆E ← abs(differenza di qualità tra nodo_corrente e vicino);
//12 nodo_corrente ← vicino con probabilità e−∆E /T;

pub fn local_beam() {}

//1 function local_beam(problema, k): stato ottimo locale
//2 popolazione_corrente ← lista di k stati random di problema;
//3 while true do
//4 successori ← insieme vuoto;
//5 foreach s in popolazione_corrente do
//6 aggiungi a successori tutti gli stati vicini di s;
//7 if successori contiene uno stato soluzione sol then
//8 return sol;
//9 else
//10 popolazione_corrente ← i k elementi migliori di successori

pub fn genetic_algorithms() {}

//function genetic_algorithm(problema, k, pmut): stato ottimo locale
//2 pop_corr ← insieme di k stati random di problema;
//3 while true do
//4 if pop_corr contiene soluzioni suff. buone or tempo scaduto then
//5 return la migliore soluzione in pop_corr;
//6 successori ← insieme vuoto;
//7 while |successori| < k do
//8 gen1 ← stato random di pop_corr, favorendo i migliori;
//9 gen2 ← stato random di pop_corr, favorendo i migliori;
//10 xover ← intero random tra 1 ed S;
//11 substr1 ← sottostringa di gen1 fino a xover − 1;
//12 substr2 ← sottostringa di gen2 da xover in poi;
//13 figlio ← concatena substr1 e substr2;
//14 con probabilità pmut, effettua una modifica random del valore di
//un gene random di figlio;
//15 aggiungi figlio a successori;
//16 pop_corr ← successori;
