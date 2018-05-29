fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);

Ntrn = round(N*rand(1));

[Xtrn,ytrn,Xtst,ytst] = lab5f1(Ntrn,N,housing_data,p1);

[yh,Etrh,lambda] = lab5fnlpp(Ntrn,Xtrn,ytrn,round(Ntrn/10));
[yht,Etsth] = lab5fnlx(N-Ntrn,Xtst,ytst,round(Ntrn/10),lambda);

disp([ '   1 N','         2 K','         3 K']);

disp([Ntrn (N-Ntrn)]);
disp(round(Ntrn/10));
disp([Etrh Etsth]);

figure(1),clf,
plot(ytrn, yh, 'rx','LineWidth', 2), grid on,hold on;
title('RBF Prediction on Training Data', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);

figure(2),clf,
plot(ytrn, yh, 'rx', ytst, yht, 'mo','LineWidth', 2), grid on,hold on;
title('RBF Prediction on Both Data sets', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);