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
avgEtrn = sum(Etrn)/10;
stdEtrn = std(Etrn);
figure(3),clf,
bar(Etrn);

disp(['avg         ' 'std'])
disp([avgEtrn stdEtrn]);

cvx_begin quiet
    variable w1( p+1 );
    minimize norm( Y*w1 - f )
cvx_end
fh1 = Y*w1;

figure(4),clf,
plot(w,w1,'mx','LineWidth', 2);
mm = 1 : 1 :14;
grid on;hold on;

figure(5),clf,
plot(mm,w,'bo', mm,w1,'rx','LineWidth', 2);
grid on;hold on;

figure(6),clf,
grid on;hold on;

gama = 8.0;
cvx_begin quiet
    variable w2( p+1 );
    minimize( norm(Y*w2-f) + gama*norm(w2,1) );
cvx_end
fh2 = Y*w2;
plot(f, fh1, 'co', 'LineWidth', 2),
legend('Regression', 'Sparse Regression');

[iNzero] = find(abs(w2) > 1e-5);
disp('Relevant variables');
disp(iNzero);

pz = zeros(100,1);
gmRange = linspace(0.01,40,100);
INZ = zeros(100,20);
for tis = 1:100
    cvx_begin quiet
        variable w2( p+1 );
        minimize( norm(Y*w2-f) + gmRange(tis)*norm(w2,1) );
    cvx_end
    [iNzero] = find(abs(w2) > 1e-5);
    [z,~] = size(iNzero);
    pz(tis) = z;
    INZ(tis,1:z) = iNzero;
end

figure(7),clf,
grid on;hold on;
%time=1:100;
plot(gmRange,pz,'r','LineWidth',2);

figure(8),clf,
grid on;hold on;
plot(gmRange,INZ,'rx','LineWidth',2);
axis([0 40 0.1 15]);
