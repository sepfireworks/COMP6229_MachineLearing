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

ii = randperm(N);
np = 50;
i = 0;
Etrn = zeros(10,1);
for i = 0:9
    Ytst = [housing_data(ii(np*i + 1:np*(i+1)),1:p) ones(50,1)];
    ftst = housing_data(ii(np*i + 1:np*(i+1)),p1);
    if i == 0
        Ytrn = [housing_data(ii(np*(i+1)+1:N),1:p)  ones(N-50,1)];
        ftrn = housing_data(ii(np*(i+1)+1:N),p1);
    else
        Ytrn0 = [housing_data(ii(1:np*i),1:p) ; housing_data(ii(np*(i+1)+1:N),1:p)];
        Ytrn = [Ytrn0 ones(N-50,1)];
        ftrn = [housing_data(ii(1:np*i),p1) ; housing_data(ii(np*(i+1)+1:N),p1)];
    end
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
    Etrn(i+1) = ((norm(Ytst*wtrn-ftst))^2)/np;
end

avgEtrn = sum(Etrn)/10;
stdEtrn = std(Etrn);
figure(3), clf,
bar(Etrn);
disp(['avg         ' 'std'])
disp([avgEtrn stdEtrn]);


