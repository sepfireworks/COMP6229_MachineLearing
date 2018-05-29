function [X1,y1,X2,y2] = lab5f1(N1,N,housing_data,p1)

p = p1-1;

ii = randperm(N);
X1 = [housing_data(ii(1 : N1), 1:p) ones(N1,1)];
X2 = [housing_data(ii(N1 + 1: N),1:p) ones(N-N1,1)];
y1 = housing_data(ii(1 : N1), p1);
y2 = housing_data(ii(N1 + 1 : N), p1);
for j=1:p
    X1(:,j)=X1(:,j)-mean(X1(:,j));
    X1(:,j)=X1(:,j)/std(X1(:,j));
end
for j=1:p
    X2(:,j)=X2(:,j)-mean(X2(:,j));
    X2(:,j)=X2(:,j)/std(X2(:,j));
end

y1 = y1 - mean(y1);
y1 = y1/std(y1);
%wtrn = inv(Xtr'*Xtr)*Xtr'*ytr;

y2 = y2 - mean(y2);
y2 = y2/std(y2);
%wtst = inv(Xtst'*Xtst)*Xtst'*ytst;

% sig = norm(Xs(ceil(rand*Ns),:)-Xs(ceil(rand*Ns),:));
% 
% K = Ns/10;
% [Idx, C] = kmeans(Xs, round(K));
% 
% A = zeros(Ns,round(K));
% 
% for i=1:Ns
%     for j=1:K
%         A(i,j)=exp(-norm(Xs(i,:) - C(j,:))/sig^2);
%     end
% end
% KK =round(K);
% lambda = A \ ys;
% 
% yhs = zeros(Ns,1);
% u = zeros(KK,1);
% for n=1:Ns
%     for j=1:KK
%         u(j) = exp(-norm(Xs(n,:) - C(j,:))/sig^2);
%     end
%     yhs(n) = lambda'*u;
% end
% 
% Es = ((norm(yhs-ys))^2)/Ns;
