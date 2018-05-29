function [yh,Enl] = lab5fnl(N,Y,f,K)

sig = norm(Y(ceil(rand*N),:)-Y(ceil(rand*N),:));

% K = N/kn;
[Idx, C] = kmeans(Y, K);

A = zeros(N,K);

for i=1:N
    for j=1:K
        A(i,j)=exp(-norm(Y(i,:) - C(j,:))/sig^2);
    end
end
% KK =round(K);
lambda = A \ f;

yh = zeros(N,1);
u = zeros(K,1);
for n=1:N
    for j=1:K
        u(j) = exp(-norm(Y(n,:) - C(j,:))/sig^2);
    end
    yh(n) = lambda'*u;
end

Enl = ((norm(yh-f))^2)/N;