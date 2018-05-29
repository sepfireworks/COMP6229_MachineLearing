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
figure(1), clf,
plot(f, fh, 'r.', 'LineWidth', 2);
%plot(f, fh, 'r', 'LineWidth', 2);
grid on;
xlabel('True House Price','FontSize', 14);
ylabel('Prediction', 'FontSize', 14);
title('Linear Regression', 'FontSize', 14);
nn = 1:1:506;
figure(2), clf,
% plot( nn, f,'b.',nn,fh,'r.' ,'LineWidth', 2);
plot( nn, f,'b',nn,fh,'r' ,'LineWidth', 1);
grid on;
E = ((norm(Y*w-f))^2)/N;

TIMES = 100;
avgEtrn = zeros(TIMES,1);
stdEtrn = zeros(TIMES,1);

for tis = 1:TIMES

    Etrn = zeros(10,1);
    indices=crossvalind('Kfold',Y(1:506,14),10);
    for i = 1:10
        list_tst = (indices == i); list_trn = ~list_tst;
        Ytrn0 = housing_data(list_trn,1:p); Ytst0 = housing_data(list_tst,1:p);
        [a,~] = size(Ytst0);
        Ytrn = [Ytrn0 ones(N-a,1)]; Ytst = [Ytst0 ones(a,1)];
        ftrn = housing_data(list_trn,p1); ftst = housing_data(list_tst,p1);
    
        for j=1:p
            Ytrn(:,j)=Ytrn(:,j)-mean(Ytrn(:,j));
            Ytrn(:,j)=Ytrn(:,j)/std(Ytrn(:,j));
        end
        for j=1:p
            Ytst(:,j)=Ytst(:,j)-mean(Ytst(:,j));
            Ytst(:,j)=Ytst(:,j)/std(Ytst(:,j));
        end
        ftrn = ftrn - mean(ftrn);
        ftrn = ftrn/std(ftrn);
        wtrn = inv(Ytrn'*Ytrn)*Ytrn'*ftrn;
    
        ftst = ftst - mean(ftst);
        ftst = ftst/std(ftst);
        wtst = inv(Ytst'*Ytst)*Ytst'*ftst;
        Etrn(i) = ((norm(Ytst*wtrn-ftst))^2)/a;
    end
    avgEtrn(tis) = sum(Etrn)/10;
    stdEtrn(tis) = std(Etrn);
end
xx = 1:1:TIMES;
figure(3), clf,
plot(xx, avgEtrn, 'r', xx, stdEtrn, 'b', 'LineWidth', 2);

avgEtrn=avgEtrn(~isnan(avgEtrn));
stdEtrn=stdEtrn(~isnan(stdEtrn));
[p_avg,~] = size(avgEtrn); [p_std,~] = size(stdEtrn);
AavgEtrn = sum(avgEtrn)/p_avg;
AstdEtrn = sum(stdEtrn)/p_std;

disp(['avg         ' 'std'])
disp([AavgEtrn AstdEtrn]);


