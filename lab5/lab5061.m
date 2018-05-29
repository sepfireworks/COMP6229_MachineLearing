fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);

kn = 10;
Nn = 5;
Etrn = zeros(75,1);
Etst = zeros(75,1);
tt = 1:1:75;
for tis = 1:75

    Ntrn = 60 + Nn*tis;
    [Xtrn,ytrn,Xtst,ytst] = lab5f1(Ntrn,N,housing_data,p1);

    [yh,Etrh] = lab5f2(Ntrn,Xtrn,ytrn,kn);
    [yht,Etsth] = lab5f2(N-Ntrn,Xtst,ytst,kn);
    Etrn(tis) = Etrh;
    Etst(tis) = Etsth; 

end
figure(1),clf,
plot(tt, Etrn, 'r', tt, Etst, 'b','LineWidth', 2), grid on,hold on;
axis([1 75 0 0.5]);




