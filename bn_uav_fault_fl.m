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

%Shutter; state1=True, State2 = False
n= n+1;
CPD_Shutter = cell(2,2); %parent state, child state
CPD_Shutter (1,[1,2]) = {exp(-12) 1-exp(-12)};
CPD_Shutter (2,[1,2]) = {0.80 0.20};
Nodes(1,n) = DiscreteNode('Name', 'Shutter', 'CPD', CPD_Shutter, 'parents', "Oper_cond");

%Lens; state1=True, State2 = False
n= n+1;
CPD_Lens = cell(2,2); %parent state, child state
CPD_Lens (1,[1,2]) = {exp(-13) 1-exp(-13)};
CPD_Lens (2,[1,2]) = {0.90 0.10};
Nodes(1,n) = DiscreteNode('Name', 'Lens', 'CPD', CPD_Lens, 'parents', "Oper_cond");

%Camera; state1=True(1); State2= False(2), cell(Shutter,Lens,Camera)
n=n+1;
CPD_Camera = cell(2,2,2);
CPD_Camera(1,1,[1,2]) = {exp(-5) 1-exp(-5)};
CPD_Camera(2,1,[1,2]) = {0.60 0.40};
CPD_Camera(1,2,[1,2]) = {0.55 0.45};
CPD_Camera(2,2,[1,2]) = {0.90 0.10};

Nodes(1,n) = DiscreteNode('Name', 'Camera', 'CPD', CPD_Camera, 'Parents', ["Shutter","Lens"]);

%%%%%%%%%%

%Temp; state1 = True, state2= False

n=n+1;
CPD_Temp = cell(1,2);
CPD_Temp(1,[1,2]) = {0.07 0.93};
Nodes(1,n) = DiscreteNode ('Name', 'Temp', 'CPD', CPD_Temp );

%Dealy_var; state1=True, State2 = False
n= n+1;
CPD_Delay_var = cell(2,2); %parent state, child state
CPD_Delay_var (1,[1,2]) = {exp(-6) 1-exp(-6)};
CPD_Delay_var (2,[1,2]) = {0.99 0.01};
Nodes(1,n) = DiscreteNode('Name', 'Delay_var', 'CPD', CPD_Delay_var, 'parents', "Temp");

%Alpha; state1 = True, state2= False
n=n+1;
CPD_Alpha = cell(1,2);
CPD_Alpha(1,[1,2]) = {0.04 1-0.04};
Nodes(1,n) = DiscreteNode ('Name', 'Alpha', 'CPD', CPD_Alpha );

%SEU; state1=True, State2 = False
n= n+1;
CPD_SEU = cell(2,2); %parent state, child state
CPD_SEU (1,[1,2]) = {exp(-5) 1-exp(-5) };
CPD_SEU (2,[1,2]) = {0.95 0.05};
Nodes(1,n) = DiscreteNode('Name', 'SEU', 'CPD', CPD_SEU, 'parents', "Alpha");

%FPGA; state1=True(1); State2= False(2), cell(SEU,Delay_ver,FPGA)
n=n+1;
CPD_FPGA = cell(2,2,2);
CPD_FPGA(1,1,[1,2]) = {exp(-10) 1-exp(-5)};
CPD_FPGA(2,1,[1,2]) = {0.80 0.20};
CPD_FPGA(1,2,[1,2]) = {0.75 0.25};
CPD_FPGA(2,2,[1,2]) = {0.99 0.01};

Nodes(1,n) = DiscreteNode('Name', 'FPGA', 'CPD', CPD_FPGA, 'Parents', ["Delay_var","SEU"]);


%Chemical; state1=True, State2 = False
n= n+1;
CPD_Che = cell(1,2); %parent state, child state
CPD_Che (1,[1,2]) = {exp(-6) 1-exp(-6)};
Nodes(1,n) = DiscreteNode('Name', 'Che', 'CPD', CPD_Che);

%Flight Profile; state1=True, State2 = False
n= n+1;
CPD_Flight = cell(1,2); %parent state, child state
CPD_Flight (1,[1,2]) = {exp(-6) 1-exp(-6)};
Nodes(1,n) = DiscreteNode('Name', 'Flight', 'CPD', CPD_Flight);

%Thermal Runway; state1=True(1); State2= False(2), cell(Flight,Che,Oper_cond)
n=n+1;
CPD_Thermal = cell(2,2,2,2);
CPD_Thermal(1,1,1,[1,2]) = {exp(-5) 1-exp(-5)};
CPD_Thermal(1,1,2,[1,2]) = {0.6 0.4};
CPD_Thermal(1,2,1,[1,2]) = {exp(-6) 1-exp(-6)};
CPD_Thermal(1,2,2,[1,2]) = {0.85 0.15};
CPD_Thermal(2,1,1,[1,2]) = {exp(-3) 1-exp(-3)};
CPD_Thermal(2,1,2,[1,2]) = {0.75 0.25};
CPD_Thermal(2,2,1,[1,2]) = {exp(-3) 1-exp(-3)};
CPD_Thermal(2,2,2,[1,2]) = {0.95 0.05};

Nodes(1,n) = DiscreteNode('Name', 'Thermal', 'CPD', CPD_Thermal, 'Parents', ["Oper_cond","Flight","Che"]);

%%%%%%%===Battery===%%%%%%%

%SOC; state1=True, State2 = False, cell(Flight,Oper_cond,SOC)
n= n+1;
CPD_SOC = cell(2,2,2); %parent state, child state
CPD_SOC (1,1,[1,2]) = {exp(-12) 1-exp(-12)};
CPD_SOC (2,1,[1,2]) = {0.55 0.45};
CPD_SOC (1,2,[1,2]) = {0.45 0.55};
CPD_SOC (2,2,[1,2]) = {0.99 0.01};
Nodes(1,n) = DiscreteNode('Name', 'SOC', 'CPD', CPD_SOC, 'parents', ["Flight","Oper_cond"]);

%SOC; state1=True, State2 = False, cell(Flight,Oper_cond,SOH)
n= n+1;
CPD_SOH = cell(2,2,2); %parent state, child state
CPD_SOH (1,1,[1,2]) = {exp(-6)  1-exp(-6)};
CPD_SOH (2,1,[1,2]) = {0.7 0.3};
CPD_SOH (1,2,[1,2]) = {0.3 0.7};
CPD_SOH (2,2,[1,2]) = {0.9 0.1};
Nodes(1,n) = DiscreteNode('Name', 'SOH', 'CPD', CPD_SOH, 'parents', ["Flight","Oper_cond"]);

%Battery; state1=True(1); State2= False(2), cell(Shutter,Lens,Camera)
n=n+1;
CPD_Battery = cell(2,2,2,2);
CPD_Battery(1,1,1,[1,2]) = {exp(-6) 1-exp(-6)};
CPD_Battery(1,1,2,[1,2]) = {0.25 0.75};
CPD_Battery(1,2,1,[1,2]) = {0.23 0.77};
CPD_Battery(1,2,2,[1,2]) = {0.40 0.60};
CPD_Battery(2,1,1,[1,2]) = {0.20 0.80};
CPD_Battery(2,1,2,[1,2]) = {0.50 0.50};
CPD_Battery(2,2,1,[1,2]) = {0.50 0.50};
CPD_Battery(2,2,2,[1,2]) = {0.95 0.05};

Nodes(1,n) = DiscreteNode('Name', 'Battery', 'CPD', CPD_Battery, 'Parents', ["SOC","SOH","Thermal"]);

%%%%%%%%%%%%%===Motor====%%%%%%%; state1=True, State2 = False
%Bearing state1=True, State2 = False, cell(Flight, operatinal_condi,Bearing)
n= n+1;
CPD_Bearing = cell(2,2,2); %parent state, child state
CPD_Bearing (1,1,[1,2]) = {exp(-6) 1-exp(-6)};
CPD_Bearing (2,1,[1,2]) = {exp(-3) 1-exp(-3)};
CPD_Bearing (1,2,[1,2]) = {exp(-5) 1-exp(-5)};
CPD_Bearing (2,2,[1,2]) = {0.01 0.99};
Nodes(1,n) = DiscreteNode('Name', 'Bearing', 'CPD', CPD_Bearing, 'parents', ["Flight","Oper_cond"]);

%Winding; state1=True, State2 = False, cell(Flight, operatinal_condi, Winding)
n= n+1;
CPD_Winding = cell(2,2,2); %parent state, child state
CPD_Winding (1,1,[1,2]) = {exp(-15) 1-exp(-15)};
CPD_Winding (2,1,[1,2]) = {exp(-3)  1-exp(-3)};
CPD_Winding (1,2,[1,2]) = {exp(-2) 1-exp(-2)};
CPD_Winding (2,2,[1,2]) = {0.1 0.9};
Nodes(1,n) = DiscreteNode('Name', 'Winding', 'CPD', CPD_Winding, 'parents', ["Flight","Oper_cond"]);

%Motor; state1=True(1); State2= False(2), cell(Shutter,Lens,Camera)
n=n+1;
CPD_Motor = cell(2,2,2);
CPD_Motor(1,1,[1,2]) = {exp(-3) 1-exp(-3)};
CPD_Motor(2,1,[1,2]) = {exp(-2) 1-exp(-2)};
CPD_Motor(1,2,[1,2]) = {exp(-5) 1-exp(-5)};
CPD_Motor(2,2,[1,2]) = {0.90 0.1};

Nodes(1,n) = DiscreteNode('Name', 'Motor', 'CPD', CPD_Motor, 'Parents', ["Bearing","Winding"]);


%%%%%%%%%%%%%%%%%%%%==Final output==%%%%%%%%%%%%%%%%%%%%%%%%%%
%UAV; state1=True(1); State2= False(2), cell(FPGA,Camera,UAV)
n=n+1;
CPD_UAV = cell(2,2,2,2,2);
CPD_UAV(1,1,1,1,[1,2]) = {exp(-7) 1-exp(-7)};
CPD_UAV(1,1,1,2,[1,2]) = {0.25 0.75};
CPD_UAV(1,1,2,1,[1,2]) = {0.25 0.75};
CPD_UAV(1,1,2,2,[1,2]) = {0.50 0.50};
CPD_UAV(1,2,1,1,[1,2]) = {0.25 0.75};
CPD_UAV(1,2,1,2,[1,2]) = {0.50 0.50};
CPD_UAV(1,2,2,1,[1,2]) = {0.50 0.50};
CPD_UAV(1,2,2,2,[1,2]) = {0.75 0.25};
CPD_UAV(2,1,1,1,[1,2]) = {0.25 0.75};
CPD_UAV(2,1,1,2,[1,2]) = {0.50 0.50};
CPD_UAV(2,1,2,1,[1,2]) = {0.50 0.50};
CPD_UAV(2,1,2,2,[1,2]) = {0.75 0.25};
CPD_UAV(2,2,1,1,[1,2]) = {0.50 0.50};
CPD_UAV(2,2,1,2,[1,2]) = {0.50 0.50};
CPD_UAV(2,2,2,1,[1,2]) = {0.50 0.50};
CPD_UAV(2,2,2,2,[1,2]) = {0.99 0.01};


Nodes(1,n) = DiscreteNode('Name', 'UAV_faulty', 'CPD', CPD_UAV, 'Parents', ["FPGA","Camera","Motor","Battery"]);

% Build net
UAV_net = BayesianNetwork ('Nodes', Nodes);

%Visualize net

UAV_net.makeGraph
%inference (prognostic)"the probability of the UAV fault"
UAV_fault_true = UAV_net.computeBNInference('MarginalProbability', "UAV_faulty",...
    'useBNT',false,'Algorithm', "Variable Elimination");

