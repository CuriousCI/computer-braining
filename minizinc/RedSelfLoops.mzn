int: size;
int: edges_size;
array[1..edges_size] of var tuple(1..size, 1..size): edges;

array[1..size] of var 1..3: nodes;

constraint forall(e in edges)(e.1 = e.2 -> nodes[e.1] = 1);

constraint forall(e in edges)(e.1 != e.2 -> nodes[e.1] != nodes[e.2]);