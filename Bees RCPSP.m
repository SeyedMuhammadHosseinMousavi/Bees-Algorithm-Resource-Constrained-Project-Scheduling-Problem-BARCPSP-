% Resource Constrained Project Scheduling Problem (RCPSP) using Bees
% Algorithm (BA) or BARCPSP

clc;
clear;
close all;
global NFE;
NFE=0;

% Problem
model=CreateModel2();
CostFunction=@(x) MyCost(x,model);        % Cost Function
nVar=model.N;             % Number of Decision Variables
VarSize=[1 nVar];   % Size of Decision Variables Matrix
VarMin=0;         % Lower Bound of Variables
VarMax=1;         % Upper Bound of Variables

%% Bees Algorithm Parameters

MaxIt = 100;          % Maximum Number of Iterations
nScoutBee = 20;                           % Number of Scout Bees
nSelectedSite = round(0.5*nScoutBee);     % Number of Selected Sites
nEliteSite = round(0.4*nSelectedSite);    % Number of Selected Elite Sites
nSelectedSiteBee = round(0.5*nScoutBee);  % Number of Recruited Bees for Selected Sites
nEliteSiteBee = 2*nSelectedSiteBee;       % Number of Recruited Bees for Elite Sites
r = 0.1*(VarMax-VarMin);	% Neighborhood Radius
rdamp = 0.95;             % Neighborhood Radius Damp Rate

%% Start
% Empty Bee Structure
empty_bee.Position = [];
empty_bee.Cost = [];
empty_bee.Sol = [];

% Initialize Bees Array
bee = repmat(empty_bee, nScoutBee, 1);
% Create New Solutions
for i = 1:nScoutBee
bee(i).Position = unifrnd(VarMin, VarMax, VarSize);
[bee(i).Cost bee(i).Sol] = CostFunction(bee(i).Position);
end

% Sort
[~, SortOrder] = sort([bee.Cost]);
bee = bee(SortOrder);
% Update Best Solution Ever Found
BestSol = bee(1);
% Array to Hold Best Cost Values
BestCost = zeros(MaxIt, 1);
%% Bees Algorithm Main Loop
for it = 1:MaxIt
% Elite Sites
for i = 1:nEliteSite
bestnewbee.Cost = inf;
for j = 1:nEliteSiteBee
newbee.Position = Dance(bee(i).Position, r);
[newbee.Cost newbee.Sol] = CostFunction(newbee.Position);
if newbee.Cost<bestnewbee.Cost
bestnewbee = newbee;
end
end
if bestnewbee.Cost<bee(i).Cost
bee(i) = bestnewbee;
end
end
% Selected Non-Elite Sites
for i = nEliteSite+1:nSelectedSite
bestnewbee.Cost = inf;
for j = 1:nSelectedSiteBee
newbee.Position = Dance(bee(i).Position, r);
[newbee.Cost newbee.Sol] = CostFunction(newbee.Position);
if newbee.Cost<bestnewbee.Cost
bestnewbee = newbee;
end
end
if bestnewbee.Cost<bee(i).Cost
bee(i) = bestnewbee;
end
end
% Non-Selected Sites
for i = nSelectedSite+1:nScoutBee
bee(i).Position = unifrnd(VarMin, VarMax, VarSize);
[bee(i).Cost bee(i).Sol] = CostFunction(bee(i).Position);
end
% Sort
[~, SortOrder] = sort([bee.Cost]);
bee = bee(SortOrder);
% Update Best Solution Ever Found
BestSol = bee(1);
% Store Best Cost Ever Found
BestCost(it) = BestSol.Cost;
nfe(it)=NFE;
% Display Iteration Information
disp(['Iteration ' num2str(it) ': BA Best Cost = ' num2str(BestCost(it))]);
% Damp Neighborhood Radius
r = r*rdamp;
end
% Plot
plot(nfe,BestCost,'-og','linewidth',1,'MarkerSize',4,'MarkerFaceColor',[0.9,0.1,0.1]);
title(' Train','FontSize', 17);
%xlabel(' Iteration Number','FontSize', 17);
ylabel(' Best Cost Value','FontSize', 17);
xlim([0 inf])
xlim([0 inf])
ax = gca; 
ax.FontSize = 17; 
set(gca,'Color','k')
legend({'BARCPSP'},'FontSize',12,'TextColor','yellow');


