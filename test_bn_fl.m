%BN model for UAV faultin FL 
%import packages
import opencossan.bayesiannetworks.BayesianNetwork
import opencossan.bayesiannetworks.DiscreteNode

opencossan.OpenCossan.getInstance(); %Initilize OpenCoassan addd bnt toolbox to the path

% root nodes operatinal condition (oper_cond), Alpha particle (Alpha), Temperature (Temp), Chemical (Chem), Flight profile (Fli_prof)



%%%%%%
n= 0;
%%%%%%%%%%%%%%%%%
%oper_cond; state1 = True, state2= False
n=n+1;
CPD_Oper_cond = cell(1,2);
CPD_Oper_cond(1,[1,2]) = {exp(-6) 1-exp(-6)};
Nodes(1,n) = DiscreteNode ('Name', 'Oper_cond', 'CPD', CPD_Oper_cond);

%%%%%%%%%%
%Flight Profile; state1=True, State2 = False
n= n+1;
CPD_Flight = cell(1,2); %parent state, child state
CPD_Flight (1,[1,2]) = {exp(-6) 1-exp(-6)};
Nodes(1,n) = DiscreteNode('Name', 'Flight', 'CPD', CPD_Flight);


%%%%%%%%%%%%%===Motor====%%%%%%%; state1=True, State2 = False
%Bearing state1=True, State2 = False, cell(Flight, operatinal_condi,Bearing)
n= n+1;
CPD_Bearing = cell(2,2,2); %parent state, child state
CPD_Bearing (1,1,[1,2]) = {exp(-6) 1-exp(-6)};
CPD_Bearing (2,1,[1,2]) = {exp(-3) 1-exp(-3)};
CPD_Bearing (1,2,[1,2]) = {exp(-5) 1-exp(-5)};
CPD_Bearing (2,2,[1,2]) = {0.01 0.99};
Nodes(1,n) = DiscreteNode('Name', 'Bearing', 'CPD', CPD_Bearing, 'Parents', ["Flight","Oper_cond"]);

%Winding; state1=True, State2 = False, cell(Flight, operatinal_condi, Winding)
n= n+1;
CPD_Winding = cell(2,2,2); %parent state, child state
CPD_Winding (1,1,[1,2]) = {exp(-15) 1-exp(-15)};
CPD_Winding (2,1,[1,2]) = {exp(-3)  1-exp(-3)};
CPD_Winding (1,2,[1,2]) = {exp(-2) 1-exp(-2)};
CPD_Winding (2,2,[1,2]) = {0.1 0.9};
Nodes(1,n) = DiscreteNode('Name', 'Winding', 'CPD', CPD_Winding, 'Parents', ["Flight","Oper_cond"]);

%Motor; state1=True(1); State2= False(2), cell(Shutter,Lens,Camera)
n=n+1;
CPD_Motor = cell(2,2,2);
CPD_Motor(1,1,[1,2]) = {exp(-3) 1-exp(-3)};
CPD_Motor(2,1,[1,2]) = {exp(-2) 1-exp(-2)};
CPD_Motor(1,2,[1,2]) = {exp(-5) 1-exp(-5)};
CPD_Motor(2,2,[1,2]) = {0.99 0.01};

Nodes(1,n) = DiscreteNode('Name', 'Motor', 'CPD', CPD_Motor, 'Parents', ["Bearing","Winding"]);


%Build net
UAV_net = BayesianNetwork ('Nodes', Nodes);

%Visualize net

UAV_net.makeGraph
%% inference (prognostic)"the probability of the UAV fault"
UAV_fault_true = UAV_net.computeBNInference('MarginalProbability', "Motor",...
    'useBNT',false,'Algorithm', "Variable Elimination");

