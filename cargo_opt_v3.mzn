% === Cargo Optimization: Version 3.0 ===
%
% Multiple destinations are now available.
% Each item needs to be delivered to its own destination.
% Path costs between different locations are given.
% The goal is to pick items in a way such that,
% (total item value - travel cost) is maximized. 


include "globals.mzn";

% Carrier constraints
int: carrier_space;
int: carrier_weight_limit;

% Cargo item constraints
int: number_of_items;
array[1..number_of_items] of int: weights;
array[1..number_of_items] of int: volume;
array[1..number_of_items] of int: value;
array[1..number_of_items] of int: destinations;

% Available destinations
int: num_dest;

% Adjacency matrix of path costs
array[1..num_dest,1..num_dest] of int: path_costs;

% The destinations the carrier chooses to go to
array[1..num_dest+1] of var 1..num_dest: chosen_dest;

% The starting location is the same as the final destination
constraint chosen_dest[1] = 1;
constraint chosen_dest[num_dest+1] = 1;

% Choosing which items are to be taken
array[1..number_of_items] of var 0..1: choice;

% Weight and space constraints
constraint sum(i in 1..number_of_items)(choice[i]*volume[i]) <= carrier_space;
constraint sum(i in 1..number_of_items)(choice[i]*weights[i]) <= carrier_weight_limit;

% Total value of chosen items
var int: valuesum;
valuesum = sum(i in 1..number_of_items)(choice[i]*value[i]);

% Destinations of chosen items must be present in chosen destinations(except the start and finish
% locations, which are already fixed)
% **Try ammending later with 'exists' constraint

constraint forall(i in 1..number_of_items where choice[i]=1)(
  sum(j in 2..num_dest where chosen_dest[j] = destinations[i])(chosen_dest[j]) > 0);
  
% Total travel cost determined from path_cost
var int: travelcost;
travelcost = sum(i in 2..num_dest+1)(path_costs[chosen_dest[i-1],chosen_dest[i]]);

% The actual cost function is the difference of total item value and total travel cost
var int: totalcost;
totalcost = valuesum - travelcost;

solve maximize totalcost;


 
 