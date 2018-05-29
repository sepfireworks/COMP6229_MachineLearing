fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);

%Ntrn = round(N*rand(1));
Ntrn = 400;

[Xtrn,ytrn,Xtst,ytst] = lab5f1(Ntrn,N,housing_data,p1);

[yh,Etrh] = lab5f2(Ntrn,Xtrn,ytrn,10);
[yht,Etsth] = lab5f2(N-Ntrn,Xtst,ytst,10);

disp([ '   Etrh','         Etsth']);
disp([Etrh Etsth]);
disp([ '   Ntr','         Ntst']);
disp([Ntrn (N-Ntrn)]);

figure(1),clf,
plot(ytrn, yh, 'rx', ytst, yht, 'mo','LineWidth', 2), grid on,hold on;
title('RBF Prediction on Training Data', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);