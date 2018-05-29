fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);

%Ntrn = round(N*rand(1));
Ntrn = 400;

[Xtrn,ytrn,Xtst,ytst] = lab5f1(Ntrn,N,housing_data,p1);

[yh,Etrh,K] = lab5fcc(Ntrn,Xtrn,ytrn,10);
[yht,Etsth,Kt] = lab5fcc(N-Ntrn,Xtst,ytst,(N-Ntrn)/K);

disp([ '   1 N','         2 K','         3 K']);

disp([Ntrn (N-Ntrn)]);
disp([K Kt]);
disp([Etrh Etsth]);

figure(1),clf,
plot(ytrn, yh, 'rx', ytst, yht, 'mo','LineWidth', 2), grid on,hold on;
title('RBF Prediction on Training Data', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);