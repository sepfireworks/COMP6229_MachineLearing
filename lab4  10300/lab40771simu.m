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
    ii = randperm(N);
    np = 50;
    i = 0;
    Etrn = zeros(10,1);
    for i = 0:9
        Ytst = Y(ii(np*i + 1:np*(i+1)),:);
        ftst = f(ii(np*i + 1:np*(i+1)));
        if i == 0
            Ytrn = Y(ii(np*(i+1)+1:N),:);
            ftrn = f(ii(np*(i+1)+1:N));
        else
            Ytrn = [Y(ii(1:np*i),:) ; Y(ii(np*(i+1)+1:N),:)];
            ftrn = [f(ii(1:np*i)) ; f(ii(np*(i+1)+1:N))];
        end

        ftrn = ftrn - mean(ftrn);
        ftrn = ftrn/std(ftrn);
        wtrn = inv(Ytrn'*Ytrn)*Ytrn'*ftrn;


        ftst = ftst - mean(ftst);
        ftst = ftst/std(ftst);
        wtst = inv(Ytst'*Ytst)*Ytst'*ftst;

        Etrn(i+1) = ((norm(Ytst*wtrn-ftst))^2)/np;
    end
    avgEtrn(tis) = sum(Etrn)/10;
    stdEtrn(tis) = (std(Etrn))^2;
end
xx = 1:1:TIMES;
figure(3), clf,
plot(xx, avgEtrn, 'm', xx, stdEtrn, 'y', 'LineWidth', 2);
AavgEtrn = sum(avgEtrn)/TIMES;
AstdEtrn = sum(stdEtrn)/TIMES;
disp(['avg         ' 'std'])
disp([AavgEtrn AstdEtrn]);
axis([0 100 0 0.35]);

