# Cargo Optimization
An advanced application of the knapsack problem, implemented in Minizinc.

## Tools used:

* MiniZinc 2.2.3

## Team Members:
* Mashrur Mahmud
* Hasan Tanvir Iqbal
* Farhan M Nafis Momin

## Overview:
Cargo Optimization is a model comprised of several theoretical problem domains; it makes use of combinatorial optimization, scheduling schemes, as well as weighted paths. The figure below provides an outlook of the multifaceted nature of the optimization objective:

<img src="https://github.com/ID56/Cargo-Optimization-Minizinc/blob/master/Workflow.png">

## The Cargo Environment:
The problem can be defined in the following way:
* Items are defined by the properties value, weight and volume.
* Each item has a specific destination.
* Not all items are ready to be transported at the same time; they have their own arrival times.
* A carrier has a specific amount of weight and space limit to carry items.
* An adjacency matrix represents the graph of path costs between various destinations.
* The amount of time an item has to wait since its arrival defines its delay.
* Sensitivity paramters may affect the delivery; it could be time sensitive or value sensitive or on-road time sensitive.

The objective is to maximize total value under the constraints, while taking travel paths and time-delay into consideration.

## Previous Versions:
We initially defined the problem in a simple manner and gradually added constraints to increase the scope and complexity.

* Version 1: Simple m-dimensional knapsack problem that maximized value versus weight and volume.
* Version 2: m-dimensional multiple knapsack problem.
* Version 3: Added weighted path graph and introduced travelcost into the objective.
* Version 4: Added the temporal concept of delay and arrival and departure time, adding totaldelay into the objective.
* Final Version: Added a weighting factor to the optimization objective.

## Setting up and running:
* MiniZinc IDE must be installed.
* Clone or download the repository.
* Browse the project explorer, and right click the 'Data' section, and choose 'Add existing file.'
* Select the desired data file from the data folder, named according to the corresponding version.
* Right click on the newly added data file, and run the .mzn file with it.
