% === Cargo Optimization: Version 4.0 ===

% The concept of delay has been introduced. Items now become ready for transport at different times,
% and the carrier has to pick items in a way that item value versus delay and path cost is minimized.

include "globals.mzn";

% Carrier constraints
int: carrier_space;
int: carrier_weight_limit;
var int: departure_time;

% Cargo item constraints
int: number_of_items;
array[1..number_of_items] of int: weights;
array[1..number_of_items] of int: volume;
array[1..number_of_items] of int: value;
array[1..number_of_items] of int: destinations;
array[1..number_of_items] of int: ready_time;

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

% Destinations of chosen items must be present in chosen destinations(except the start and finish
% locations, which are already fixed). Try ammending later with 'exists' constraint

constraint forall(i in 1..number_of_items where choice[i]=1)(
  sum(j in 2..num_dest where chosen_dest[j] = destinations[i])(chosen_dest[j]) > 0);
  
% Delay constraints
constraint departure_time>=min(ready_time);
constraint departure_time<=max(ready_time);
constraint forall(i in 1..number_of_items where choice[i]=1)(ready_time[i]<=departure_time);

% Total value of chosen items
var int: valuesum;
valuesum = sum(i in 1..number_of_items)(choice[i]*value[i]);

% Total delay of waiting items
var int: delaycost;
delaycost = sum(i in 1..number_of_items where choice[i]=1)(departure_time-ready_time[i]);

% Total travel cost determined from path_cost
var int: travelcost;
travelcost = sum(i in 2..num_dest+1)(path_costs[chosen_dest[i-1],chosen_dest[i]]);

% The actual cost function is the difference of total item value against total travel cost and delay
var int: totalcost;
totalcost = valuesum - travelcost - delaycost;

solve maximize totalcost;


 
 
