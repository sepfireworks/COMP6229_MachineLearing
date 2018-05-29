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

Etrn1 = zeros(500,1);
ii = randperm(N);
for np1 = 1:500     
    Ytrn1 = [housing_data(ii(1 : np1), 1:p) ones(np1,1)];
    Ytst1 = [housing_data(ii(np1 + 1: N),1:p) ones(N-np1,1)];
    ftrn1 = housing_data(ii(1 : np1), p1);
    ftst1 = housing_data(ii(np1 + 1 : N), p1);
    for j=1:p
        Ytrn1(:,j)=Ytrn1(:,j)-mean(Ytrn1(:,j));
        Ytrn1(:,j)=Ytrn1(:,j)/std(Ytrn1(:,j));
    end
    for j=1:p
        Ytst1(:,j)=Ytst1(:,j)-mean(Ytst1(:,j));
        Ytst1(:,j)=Ytst1(:,j)/std(Ytst1(:,j));
    end

    ftrn1 = ftrn1 - mean(ftrn1);
    ftrn1 = ftrn1/std(ftrn1);
    wtrn1 = inv(Ytrn1'*Ytrn1)*Ytrn1'*ftrn1;

    ftst1 = ftst1 - mean(ftst1);
    ftst1 = ftst1/std(ftst1);
    wtst1 = inv(Ytst1'*Ytst1)*Ytst1'*ftst1;


    Etrn1(np1) = ((norm(Ytst1*wtrn1-ftst1))^2)/(N-np1);
end

xx = 1:1:500;
figure(3),clf,
plot(xx,Etrn1,'k','LineWidth',2);grid on;hold on;
axis([0 N 0 1]);

disp('org');
disp(E);

