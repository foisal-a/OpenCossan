% create a directed graph to represent the structure of the Bayesian network
DAG = zeros(3,3);
DAG(1,2) = 1;
DAG(1,3) = 1;

% create a cell array to specify the names of the nodes
names = {'A', 'B', 'C'};

% create a Bayesian network object
bn = BayesianNetwork(DAG, 'names', names);

% specify the conditional probability tables (CPTs) for each node
bn.CPD{1} = tabularCPD(bn, 1, [0.5 0.5]);
bn.CPD{2} = tabularCPD(bn, 2, [0.7 0.3 0.4 0.6], 'prior', [0.5 0.5]);
bn.CPD{3} = tabularCPD(bn, 3, [0.1 0.9 0.6 0.4], 'prior', [0.6 0.4]);

% plot the Bayesian network
view(bn);
