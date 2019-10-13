% === Cargo Optimization: Version 1.0 ===
%
% A single carrier is available, providing constraints 'carrier_space' and 'carrier_weight_limit'.
% A certain number of items are required to be transported.
% Items are defined by three properties: {value, weight, volume}
% The goal is to maximize total value, considering space and weight constraints.


include "globals.mzn";

int: carrier_space;
int: carrier_weight_limit;
int: number_of_items;

array[1..number_of_items] of int: weights;
array[1..number_of_items] of int: volume;
array[1..number_of_items] of int: value;

% Choosing which item to take
array[1..number_of_items] of var 0..1: choice;

% Enforcing carrier constraints
constraint sum(i in 1..number_of_items)(choice[i]*volume[i]) <= carrier_space;
constraint sum(i in 1..number_of_items)(choice[i]*weights[i]) <= carrier_weight_limit;

% The optimization objective is the total carriable value
var int: valuesum;
valuesum = sum(i in 1..number_of_items)(choice[i]*value[i]);
  
solve maximize valuesum;
 
 
