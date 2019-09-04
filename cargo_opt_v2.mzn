% Cargo Optimization: Version 2.0
% Multiple trucks are now available

include "globals.mzn";
int: number_of_trucks;
array[1..number_of_trucks] of int: carrier_spaces;
array[1..number_of_trucks] of int: weight_limits;

int: number_of_items;
array[1..number_of_items] of int: weights;
array[1..number_of_items] of int: volume;
array[1..number_of_items] of int: value;
array[1..number_of_items] of var 1..number_of_trucks: index;

var int: valuesum;
var int: maxvalue;
valuesum = sum(i in 1..number_of_trucks)(sum(j in 1..number_of_items where index[j]=i)(value[j]));

constraint forall(i in 1..number_of_trucks)(
  sum(j in 1..number_of_items where index[j]=i)(volume[j]) <= carrier_spaces[i]);
constraint forall(i in 1..number_of_trucks)(
  sum(j in 1..number_of_items where index[j]=i)(weights[j]) <= weight_limits[i]);

solve maximize valuesum;