% == Cargo Optimization: Version 4.0 =========================================================== %
%                                                                                                %
% -> A carrier is available, providing constraints 'carrier_space' and 'carrier_weight_limit'.   %
% -> A certain number of items are required to be transported.                                   %     
% -> Items are defined by three intrinsic properties: {value, weight, volume}.                   %  
% -> They also have two extrinsic properties: {destination and ready_time}. Each item has its    %  
%    target destination, and a certain time at which it becomes 'available' for transportation.  % 
% -> A weighted, undirected graph is provided in the form of an adjacency matrix, containing     %  
%    travel costs between different locations.                                                   %                   
% -> A trip made by the carrier is a cyclic path, that begins and ends at destination 1, which   %
%    is the starting point.                                                                      %                
% -> The delivery can have different objectives. It could be a time sensitive delivery, where    %              
%    items delay needs to be minimized more. It could also be value sensitive, or even travel    %            
%    sensitive, ie, aiming to have a minimal amount of travelling.                               %                     
% ============================================================================================== %
% -> The goal is to maximize total value, considering value versus space and weight constraints, %                 
%    while also keeping item delay and travel costs in mind. The problem combines concepts       %           
%    from combinatorial optimization, weighted path selection, and optimal scheduling domains.   %
% ============================================================================================== %                 
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

% Delivery-type priority weights
int: time_sensitivity;
int: value_sensitivity;
int: travel_sensitivity;

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

% The optimization objective is weighted to consider the urgency of time, value or travel-time. If all
% weights are set to 1, all sub-objectives are equally prioritized.

% For example, if travel sensitivity is set to 1, item 3 and 5 are taken(to be delivered at destinations 3 and 4).
% However, if it is set to 2, the truck wants to spend less time on the road. Then items 2 and 3 are picked by the
% optimizer, both of which are delivered to destination 3. So the truck ends up travelling less, as intended.

totalcost = (value_sensitivity * valuesum) - (travel_sensitivity * travelcost) - (time_sensitivity * delaycost);

solve maximize totalcost;

% Adjacency Matrix
%    1   2   3   4
% 1 |0  |30 |10 |40
% 2 |30 | 0 |20 |30
% 3 |10 |20 |0  |50
% 4 |40 |30 |50 |0