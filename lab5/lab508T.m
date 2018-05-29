fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);
% AVG = zeros(10,3);
wp = 1;
% W = zeros(10,6);
figure(1),clf,
for tis1 = 1:10
    TIMES = 50;
    diff = zeros(TIMES,1);
    Etrh = zeros(TIMES,1);
    Etsth = zeros(TIMES,1);

    for tis2 = 1:TIMES
        Ntrn = 400;
        K = 2*tis2;
        [Xtrn,ytrn,Xtst,ytst] = lab5f1(Ntrn,N,housing_data,p1);

        [yh,Etrh(tis2)] = lab5fnl(Ntrn,Xtrn,ytrn,K);
        [yht,Etsth(tis2)] = lab5fnl(N-Ntrn,Xtst,ytst,K);
%         if abs(Etsth(tis2))>0.5
%             W(tis1,wp) = tis2; 
%             wp = wp+1;
%         end
        diff(tis2) = Etrh(tis2) - Etsth(tis2);
        disp([tis1 tis2/TIMES*100]);
    end
%     AVG(tis1,1) = sum(Etrh)/10;
%     AVG(tis1,2) = sum(Etsth)/10;
%     AVG(tis1,3) = sum(diff)/10;
    tt = 1:1:TIMES;
    plot(tt, Etrh, 'r', 'LineWidth', 2), grid on,hold on;
    plot(tt, Etsth, 'b', 'LineWidth', 2), grid on,hold on;
    plot(tt, diff, 'k', 'LineWidth', 2), grid on,hold on;
    title('RBF Prediction on Training Data', 'FontSize', 16);
    xlabel('Target', 'FontSize', 14);
    ylabel('Prediction', 'FontSize', 14);
end
