% Load Boston Housing Data from UCI ML Repository
% into an array housing_data; Normalize the data to have
% zero mean and unit standard deviation
%
fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);
p = p1-1;
Y = [housing_data(:,1:p) ones(N,1)];
for j=1:p
    Y(:,j)=Y(:,j)-mean(Y(:,j));
    Y(:,j)=Y(:,j)/std(Y(:,j));
end


f = housing_data(:,p1);
f = f - mean(f);
f = f/std(f);

% You  can  predict  the  response  variable  (output  variable)f,  the  house  price,  from  the
% covariates (input variable) by estimating a linear regression:

% Least squares regression as pseudo inverse
% %
w = inv(Y'*Y)*Y'*f;
fh = Y*w;
% figure(1), clf,
% plot(f, fh, 'r.', 'LineWidth', 2);
% %plot(f, fh, 'r', 'LineWidth', 2);
% grid on;
% xlabel('True House Price','FontSize', 14);
% ylabel('Prediction', 'FontSize', 14);
% title('Linear Regression', 'FontSize', 14);
% nn = 1:1:506;
% figure(2), clf,
% % plot( nn, f,'b.',nn,fh,'r.' ,'LineWidth', 2);
% plot( nn, f,'b',nn,fh,'r' ,'LineWidth', 1);
% grid on;
E = ((norm(Y*w-f))^2)/N;

Ntr = round(506*rand(1));

ii = randperm(N);
Xtr = [housing_data(ii(1 : Ntr), 1:p) ones(Ntr,1)];
Xtst = [housing_data(ii(Ntr + 1: N),1:p) ones(N-Ntr,1)];
ytr = housing_data(ii(1 : Ntr), p1);
ytst = housing_data(ii(Ntr + 1 : N), p1);
for j=1:p
    Xtr(:,j)=Xtr(:,j)-mean(Xtr(:,j));
    Xtr(:,j)=Xtr(:,j)/std(Xtr(:,j));
end
for j=1:p
    Xtst(:,j)=Xtst(:,j)-mean(Xtst(:,j));
    Xtst(:,j)=Xtst(:,j)/std(Xtst(:,j));
end

ytr = ytr - mean(ytr);
ytr = ytr/std(ytr);
wtrn = inv(Xtr'*Xtr)*Xtr'*ytr;

ytst = ytst - mean(ytst);
ytst = ytst/std(ytst);
wtst = inv(Xtst'*Xtst)*Xtst'*ytst;


Etrn = ((norm(Xtst*wtrn-ytst))^2)/(N-Ntr);



sig = norm(Xtr(ceil(rand*Ntr),:)-Xtr(ceil(rand*Ntr),:));

sigt = norm(Xtst(ceil(rand*(N-Ntr)),:)-Xtst(ceil(rand*(N-Ntr)),:));

% disp([ '   Ntr','         Etrn','    sig']);
% disp([Ntr Etrn sig]);
K = Ntr/10;
[Idx, C] = kmeans(Xtr, round(K));

Kt = (N-Ntr)/10;
[Idxt, Ct] = kmeans(Xtst, round(Kt));

A = zeros(Ntr,round(K));
At = zeros(N - Ntr,round(Kt));

for i=1:Ntr
    for j=1:K
        A(i,j)=exp(-norm(Xtr(i,:) - C(j,:))/sig^2);
    end
end
KK =round(K);
lambda = A \ ytr;

for i=1:(N-Ntr)
    for j=1:Kt
        At(i,j)=exp(-norm(Xtst(i,:) - Ct(j,:))/sigt^2);
    end
end
KKt =round(Kt);
lambdat = At \ ytst;

yh = zeros(Ntr,1);
u = zeros(KK,1);
for n=1:Ntr
    for j=1:KK
        u(j) = exp(-norm(Xtr(n,:) - C(j,:))/sig^2);
    end
    yh(n) = lambda'*u;
end

yht = zeros(N-Ntr,1);
ut = zeros(KKt,1);
for n=1:(N-Ntr)
    for j=1:KKt
        ut(j) = exp(-norm(Xtst(n,:) - Ct(j,:))/sigt^2);
    end
    yht(n) = lambdat'*ut;
end

Etrh = ((norm(yh-ytr))^2)/(N);
Etsth = ((norm(yht-ytst))^2)/(N-Ntr);

disp([ '   Etrh','         Etsth']);
disp([Etrh Etsth]);
disp([ '   Ntr','         Ntst']);
disp([Ntr (N-Ntr)]);

figure(1),clf,
plot(ytr, yh, 'rx', ytst, yht, 'mo','LineWidth', 2), grid on,hold on;
title('RBF Prediction on Training Data', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);

