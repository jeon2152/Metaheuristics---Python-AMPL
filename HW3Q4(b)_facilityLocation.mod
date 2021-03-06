#AMPL model for "Facility Location" Problem (Q4(b) of Assignment #3)

reset;

#OPTIONS ------------------------------------------------

#option solver cplex;


#SETS AND PARAMETERS ------------------------------------

set I;			#set of districts
set J;			#set of potential sites

param p{I} >=0;		#population in each district
param d{I,J} >=0;	#distance in km from district to site
param f{J} >=0;		#fixed cost of site
param c{J} >=0;		#variable cost associated with site
param B >= 0;		#budget


#DECISION VARIABLES --------------------------------------

var x{I,J} >= 0, binary;	#district i is assigned to site j
var y{J} >= 0, binary;		#site j is selected
var z >= 0, binary;		#binary variable for site(1,2,3,4) selection 
var s{J} >= 0;			#population served by site j

var D >= 0;			#worst-case distances (max distance b/w the district and the site)


#OBJECTIVE -----------------------------------------------

minimize distance: D;


#CONSTRAINTS ---------------------------------------------

subject to district_firehouse {i in I}: sum {j in J} x[i,j] = 1;		#every district is assigned to exactly one firehouse
subject to unused_site {j in J}: 	sum {i in I} x[i,j] <= y[j]*45;		#no district is assigned to unused site, for big number M=I=45
subject to site_condition1:		y[1] + y[2] >= 2*z;			#either at least sites 1 and 2 or
subject to site_condition2:		y[3] + y[4] >= 2*(1-z);			#sites 3 and 4 are selected

subject to population_site {j in J}:	s[j] = sum {i in I} p[i]*x[i,j];	#population that would be served by that site
subject to budget_limit:		sum {j in J} (c[j]*s[j] + f[j]*y[j]) <= B;	

subject to worstcase_distance {i in I}:	D >= sum {j in J} d[i,j]*x[i,j];	#definition of worst-case D


#DATA -----------------------------------------------------

#data firehouse-d2.dat;


#COMMANDS -------------------------------------------------

#solve;

#display D, sum {j in J} (c[j]*s[j] + f[j]*y[j]);
#display x, y;

