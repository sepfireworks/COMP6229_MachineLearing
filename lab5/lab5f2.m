function [yhs,Es] = lab5f2(Ns,Xs,ys,kn)

sig = norm(Xs(ceil(rand*Ns),:)-Xs(ceil(rand*Ns),:));

K = Ns/kn;
[Idx, C] = kmeans(Xs, round(K));

A = zeros(Ns,round(K));

for i=1:Ns
    for j=1:K
        A(i,j)=exp(-norm(Xs(i,:) - C(j,:))/sig^2);
    end
end
KK =round(K);
lambda = A \ ys;

yhs = zeros(Ns,1);
u = zeros(KK,1);
for n=1:Ns
    for j=1:KK
        u(j) = exp(-norm(Xs(n,:) - C(j,:))/sig^2);
    end
    yhs(n) = lambda'*u;
end

Es = ((norm(yhs-ys))^2)/Ns;