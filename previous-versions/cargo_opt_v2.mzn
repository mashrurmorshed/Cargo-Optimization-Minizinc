% === Cargo Optimization: Version 2.0 ===
%
% A certain number of carriers are available.
% Each carrier has its own space and weight limit.
% A certain number of items are required to be transported.
% Items are defined by four properties: {value, weight, volume, carrier_index}
% The goal is to maximize total value, by assigning items to carriers optimally,
% under weight and space constraints.


include "globals.mzn";

% Carrier constraints
int: number_of_trucks;
array[1..number_of_trucks] of int: carrier_spaces;
array[1..number_of_trucks] of int: weight_limits;

% Item constraints
int: number_of_items;
array[1..number_of_items] of int: weights;
array[1..number_of_items] of int: volume;
array[1..number_of_items] of int: value;
array[1..number_of_items] of var 0..number_of_trucks: index;

% Implementing constraints for multiple trucks at once
constraint forall(i in 1..number_of_trucks)(
  sum(j in 1..number_of_items where index[j]=i)(volume[j]) <= carrier_spaces[i]
  );
  
constraint forall(i in 1..number_of_trucks)(
  sum(j in 1..number_of_items where index[j]=i)(weights[j]) <= weight_limits[i]
  );

% Maximizing the sum of values of all items in all trucks
var int: valuesum;
valuesum = sum(i in 1..number_of_trucks)(sum(j in 1..number_of_items where index[j]=i)(value[j]));
solve maximize valuesum;
