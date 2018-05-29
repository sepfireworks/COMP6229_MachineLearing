fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);
TIMES = 50;
ZPoint = zeros(TIMES,1);
zp = 1;
diff = zeros(TIMES,1);
Etrn = zeros(TIMES,1);
Etst = zeros(TIMES,1);
for tis = 1:TIMES
    Ntrn = 400;
    K = 2*tis;
    [Xtrn,ytrn,Xtst,ytst] = lab5f1(Ntrn,N,housing_data,p1);

    [yh,Etrn(tis)] = lab5fnl(Ntrn,Xtrn,ytrn,K);

    [yht,Etst(tis)] = lab5fnl(N-Ntrn,Xtst,ytst,K);
    if isnan(Etst(tis))
        ZPoint(zp) = tis;
        zp = zp + 1;
    end
    diff(tis) = Etrn(tis) - Etst(tis);
    disp(tis/50*100);
end
for i = 1:zp-1
    Etrn(ZPoint(i),:)=[];
    Etst(ZPoint(i),:)=[];
    diff(ZPoint(i),:)=[];
end
tt = 1:1:50-zp+1;
figure(1),clf,
plot(tt, Etrn, 'r', 'LineWidth', 2), grid on,hold on;
plot(tt, Etst, 'b', 'LineWidth', 2), grid on,hold on;
plot(tt, diff, 'k', 'LineWidth', 2), grid on,hold on;
title('RBF Prediction on Training Data', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);