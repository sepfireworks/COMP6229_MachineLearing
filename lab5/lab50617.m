fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);

kn = 10;
Nn = 5;
TIMES = 10;
AEtrn = zeros(75,1);
AEtst = zeros(75,1);
for tis1 = 1:75
    Ntrn = 60 + Nn*tis1;
    Etrn = zeros(TIMES,1);
    Etst = zeros(TIMES,1);
    for tis2 = 1:TIMES
        [Xtrn,ytrn,Xtst,ytst] = lab5f1(Ntrn,N,housing_data,p1);
        [yh,Etrh] = lab5f2(Ntrn,Xtrn,ytrn,kn);
        [yht,Etsth] = lab5f2(N-Ntrn,Xtst,ytst,kn);
        Etrn(tis2) = Etrh;
        Etst(tis2) = Etsth; 
    end
    AEtrn(tis1) = sum(Etrn)/TIMES;
    AEtst(tis1) = sum(Etst)/TIMES;
    disp(tis1/75*100);
end
tt = 1:1:75;
figure(1),clf,
plot(tt, AEtrn, 'r', tt, AEtst, 'b','LineWidth', 2), grid on,hold on;
axis([1 75 0 0.5]);