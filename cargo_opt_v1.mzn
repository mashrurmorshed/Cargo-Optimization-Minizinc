% Cargo Optimization: Version 1.0

include "globals.mzn";

int: carrier_space;
int: carrier_weight_limit;
int: number_of_items;

array[1..number_of_items] of int: weights;
array[1..number_of_items] of int: volume;
array[1..number_of_items] of int: value;

array[1..number_of_items] of var 0..1: choice;

var int: valuesum;
valuesum = sum(i in 1..number_of_items)(choice[i]*value[i]);
constraint sum(i in 1..number_of_items)(choice[i]*volume[i]) <= carrier_space;
constraint sum(i in 1..number_of_items)(choice[i]*weights[i]) <= carrier_weight_limit;
  
solve maximize valuesum;