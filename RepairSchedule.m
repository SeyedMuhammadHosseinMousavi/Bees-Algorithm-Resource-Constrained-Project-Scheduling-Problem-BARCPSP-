function p=RepairSchedule(q,model)
PredList=model.PredList;
p=[];
while ~isempty(q)
for i=q
if all(ismember(PredList{i},p))
break;
end
end
p=[p i]; % Add i to New List
q(q==i)=[]; % Remove i from Old List
end
end