# Cargo Optimization Minizinc
An advanced application of the knapsack problem, implemented in Minizinc.

<h2>Tools used</h2>
<ul>
  <li> MiniZinc 2.2.3 </li>
</ul>

<h2>Team Members</h2>
<ul>
  <li> Mashrur Mahmud</li>
  <li> Hasan Tanvir Iqbal</li>
  <li> Farhan M Nafis Momin</li>
  </ul>
  
<h2>Problem Versions</h2>

<h3> Version 1: </h3> 
<p>A single carrier is available, providing constraints 'carrier_space' and 'carrier_weight_limit'. A certain number of items are required to be transported. Items are defined by three properties: {value, weight, volume}. The goal is to maximize total value, considering space and weight constraints.</p>

<h3> Version 2: </h3>
<p>A number of carriers are available, each having its own space and weight limit. A certain number of items require transportation. Items are defined by four properties: {value, weight, volume, carrier_index}. The goal is to maximize total value, by assigning items to carriers optimally, under weight and space constraints of those individual carriers.</p>

<h3> Version 3: </h3>
<p> The concept of destinations is introduced. Multiple destinations are available. Each item needs to be delivered to its own destination. Path costs between different locations are given. The goal is to pick items in a way such that, (total item value - travel cost) is maximized. </p>

<h3> Version 4: </h3>
<p> The concept of delay time is introduced. In all previous scenarios, an item which is sub-optimal in terms of value vs other costs would remain unchosen across many iterations as long as better items are available. However, the delay or waiting time of an item is now factored into the cost function. An item which has been waiting too long will result in an overall bad solution. So, delay cost provides a scheduling effect on the problem scenario.</p>


