% Resource Constrained Project Scheduling Problem (RCPSP) using
% Differential Evolution Algorithm (DE) or DERCPSP

clc;
clear;
close all;
global NFE;
NFE=0;

%% Problem 
model=CreateModel2();
CostFunction=@(x) MyCost(x,model);        % Cost Function
nVar=model.N;             % Number of Decision Variables
VarSize=[1 nVar];   % Size of Decision Variables Matrix
VarMin=0;         % Lower Bound of Variables
VarMax=1;         % Upper Bound of Variables

%% DE Parameters
MaxIt = 100;      % Maximum Number of Iterations
nPop = 20;        % Population Size
beta_min = 0.2;   % Lower Bound of Scaling Factor
beta_max = 0.8;   % Upper Bound of Scaling Factor
pCR = 0.2;        % Crossover Probability

%% Start
empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Sol = [];
BestSol.Cost = inf;
pop = repmat(empty_individual, nPop, 1);
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
[pop(i).Cost pop(i).Sol] = CostFunction(pop(i).Position);
if pop(i).Cost<BestSol.Cost
BestSol = pop(i);
end
end
BestCost = zeros(MaxIt, 1);

%% DE
for it = 1:MaxIt
for i = 1:nPop
x = pop(i).Position;
A = randperm(nPop);
A(A == i) = [];
a = A(1);
b = A(2);
c = A(3);

% Mutation
%beta = unifrnd(beta_min, beta_max);
beta = unifrnd(beta_min, beta_max, VarSize);
y = pop(a).Position+beta.*(pop(b).Position-pop(c).Position);
y = max(y, VarMin);
y = min(y, VarMax);
% Crossover
z = zeros(size(x));
j0 = randi([1 numel(x)]);
for j = 1:numel(x)
if j == j0 || rand <= pCR
z(j) = y(j);
else
z(j) = x(j);
end
end
NewSol.Position = z;
[NewSol.Cost NewSol.Sol] = CostFunction(NewSol.Position);
if NewSol.Cost<pop(i).Cost
pop(i) = NewSol;
if pop(i).Cost<BestSol.Cost
BestSol = pop(i);
end
end
end
% Update Best Cost
BestCost(it) = BestSol.Cost;
nfe(it)=NFE;
% Show Iteration Information
disp(['Iteration ' num2str(it) ': DE Best Cost = ' num2str(BestCost(it))]);
end
% Show 

plot(nfe,BestCost,'-og','linewidth',1,'MarkerSize',4,'MarkerFaceColor',[0.9,0.1,0.1]);
title(' Train','FontSize', 17);
%xlabel(' Iteration Number','FontSize', 17);
ylabel(' Best Cost Value','FontSize', 17);
xlim([0 inf])
xlim([0 inf])
ax = gca; 
ax.FontSize = 17; 
set(gca,'Color','k')
legend({'DERCPSP'},'FontSize',12,'TextColor','yellow');
