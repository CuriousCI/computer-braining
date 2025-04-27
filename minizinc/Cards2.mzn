include "globals.mzn";

any: cards_values = [1, 1, 2, 2, 3, 3, 4];
int: n = 7;
int: m = 4;
int: d = 4;

array[1..n] of var 1..n: card_at_position;
var 1..n - 2: peak_1_pos; 
var 1..n - 1: valley_pos;
var 1..n: peak_2_pos;

constraint peak_1_pos < valley_pos /\ valley_pos < peak_2_pos;
constraint peak_2_pos - peak_1_pos = d;

constraint alldifferent(card_at_position);

constraint forall(i in 1..peak_1_pos - 1)(cards_values[card_at_position[i]] < cards_values[card_at_position[i + 1]]);
constraint forall(i in peak_1_pos..valley_pos - 1)(cards_values[card_at_position[i]] > cards_values[card_at_position[i + 1]]);
constraint forall(i in valley_pos..peak_2_pos - 1)(cards_values[card_at_position[i]] < cards_values[card_at_position[i + 1]]);
constraint forall(i in peak_2_pos..n - 1)(cards_values[card_at_position[i]] > cards_values[card_at_position[i + 1]]);


output ["peak 1 - " ++ show(peak_1_pos) ++ "\nvalley - " ++ show(valley_pos) ++ "\npeak 2 - " ++ show(peak_2_pos) ++ "\n"];
output [show(cards_values[card_at_position[i]]) ++ " " | i in 1..n];