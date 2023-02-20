%Tutorial BN in Opencossan
%import packages
import opencossan.bayesiannetworks.BayesianNetwork
import opencossan.bayesiannetworks.DiscreteNode

opencossan.OpenCossan.getInstance(); %INitilize OpenCoassan addd bnt toolbox to the path

n= 0;
%cloudy; state = True, state2= False
n=n+1;
CPD_cloudy = cell(1,2);
CPD_cloudy(1,[1,2]) = {0.8 0.2};
Nodes(1,n) = DiscreteNode ('Name', 'Cloudy', 'CPD', CPD_cloudy );
%Rain; state1=True, State2 = False
n= n+1;
CPD_rain = cell(2,2); %parent state, child state
CPD_rain (1,[1,2]) = {0.85 0.15};
CPD_rain (2,[1,2]) = {0.01 0.99};
Nodes(1,n) = DiscreteNode('Name', 'Rain', 'CPD', CPD_rain, 'parents', "Cloudy");

%Sprinkler; state1=True, State2 = False 
n=n+1;
CPD_sprinkler = cell(2,2);
CPD_sprinkler (1,[1,2]) = {0.1 0.9};
CPD_sprinkler (2,[1,2]) = {0.4 0.6};
Nodes(1,n) = DiscreteNode('Name', 'Sprinkler', 'CPD', CPD_sprinkler, 'Parents', "Cloudy");

%WetGrass; state1=True(1); State2= False(2), cell(rain,sprinkler,wetgrass)
n=n+1;
CPD_wetgrass = cell(2,2,2);
CPD_wetgrass(1,1,[1,2]) = {0.99 0.01};
CPD_wetgrass(2,1,[1,2]) = {0.9 0.1};
CPD_wetgrass(1,2,[1,2]) = {0.9 0.1};
CPD_wetgrass(2,2,[1,2]) = {0.001 0.999};

Nodes(1,n) = DiscreteNode('Name', 'WetGrass', 'CPD', CPD_wetgrass, 'Parents', ["Rain","Sprinkler"]);

% Build net
wetgrass_net = BayesianNetwork ('Nodes', Nodes);

%Visualize net
wetgrass_net.makeGraph

%inference (prognostic)"the probability of the grass being wet"
wetgrass_true = wetgrass_net.computeBNInference('MarginalProbability', "WetGrass",...
    'useBNT',false,'Algorithm', "Variable Elimination");

%inference (diagnosis)"Evedance: What about the Probability of wetgrass when coudy is 'True'"

cloudy_wetgrass = wetgrass_net.computeBNInference('MarginalProbability', "Cloudy",...
    'useBNT',false, 'ObservedNode', "WetGrass", 'Evidence',0,...
    'Algorithm', "Variable Elimination");