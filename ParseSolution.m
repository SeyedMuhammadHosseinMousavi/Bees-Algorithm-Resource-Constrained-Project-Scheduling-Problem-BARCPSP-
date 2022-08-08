function sol=ParseSolution(x,model)

N=model.N;
t=model.t;
PredList=model.PredList;
R=model.R;

[~, q]=sort(x);

q=RepairSchedule(q,model);

ST=zeros(1,N);
FT=zeros(1,N);

T=sum(model.t);

AR=repmat(model.Rmax,T,1);
RR=AR;
UR=zeros(size(RR));

for i=q
if ~isempty(PredList{i})
t1=max(FT(PredList{i}));
else
t1=0;
end

for tt=t1:T
RR_is_enough=true;

for d=1:t(i)
if any(RR(tt+d,:)<R(i,:))
RR_is_enough=false;
break;
end
end

if RR_is_enough
t2=tt;
break;
end
end

ST(i)=t2;

for d=1:t(i)
RR(ST(i)+d,:)=RR(ST(i)+d,:)-R(i,:);
UR(ST(i)+d,:)=UR(ST(i)+d,:)+R(i,:);
end

FT(i)=ST(i)+t(i);
end

Cmax=max(FT);

AR=AR(1:Cmax,:);
RR=RR(1:Cmax,:);
UR=UR(1:Cmax,:);

sol.q=q;
sol.ST=ST;
sol.FT=FT;
sol.Cmax=Cmax;
sol.AR=AR;
sol.RR=RR;
sol.UR=UR;

end