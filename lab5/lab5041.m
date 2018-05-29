fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);

Ntrn = 400;
[Xtrn,ytrn,Xtst,ytst] = lab5f1(Ntrn,N,housing_data,p1);

kn = 10;
TIMES = 5;

Etrn = zeros(TIMES,1);
Etst = zeros(TIMES,1);
for tis = 1:TIMES
    [yh,Etrh] = lab5f2(Ntrn,Xtrn,ytrn,kn*tis);
    [yht,Etsth] = lab5f2(N-Ntrn,Xtst,ytst,kn*tis);
    Etrn(tis) = Etrh;
    Etst(tis) = Etsth; 
    figure(tis),clf,
    plot(ytrn, yh, 'rx', ytst, yht, 'mo','LineWidth', 2), grid on,hold on;
    axis([-3 3 -3 3]);
    title('RBF Prediction on Training Data', 'FontSize', 16);
    xlabel('Target', 'FontSize', 14);
    ylabel('Prediction', 'FontSize', 14);
end
E = [Etrn Etst];
figure(TIMES+1),clf,
bar(E);


