C1 = [2,1;1,2];
C2 = [2,1;1,2];
m1 = [0;2];
m2 = [1.7;2.5];
N = 200;
TIMES = 500;
rocResolution = 50;
auc = zeros(1,TIMES);
aucr = zeros(1,TIMES);
aucC = zeros(1,TIMES);

for tis = 1:TIMES

    X1 = mvnrnd(m1, C1, N);
    X2 = mvnrnd(m2, C2, N);


    wF = inv(C1+C2)*(m1-m2);
    xx = -6:0.1:6;
    yy = xx*wF(2)/wF(1);

    wr = zeros(2,1);
    wr(1) = rand(1)*2 - 1;wr(2) = rand(1)*2 - 1;
    xr = -6:0.1:6;
    yr = xr*wr(2)/wr(1);

    wC = zeros(2,1);
    wC(1) = m1(1)-m2(1); wC(2) = m1(2)-m2(2);
    xc = -6:0.1:6;
    yc = xc*wC(2)/wC(1);




    [ROC, acc, thRange] = lab3f1(N,X1,X2,wF,rocResolution);
    [ROCr, accr] = lab3f1(N,X1,X2,wr,rocResolution);
    [ROCC, accC] = lab3f1(N,X1,X2,wC,rocResolution);

    auc(tis) = abs(trapz(ROC(:,1),ROC(:,2))/10000);
    aucr(tis) = abs(trapz(ROCr(:,1),ROCr(:,2))/10000);
    aucC(tis) = abs(trapz(ROCC(:,1),ROCC(:,2))/10000);
end
Xx = 1:1:TIMES;
figure(1),clf,
plot(Xx,auc,'r', 'LineWidth', 1);grid on;hold on;
plot(Xx,aucC,'g', 'LineWidth', 1);hold on;
plot(Xx,aucr,'b', 'LineWidth', 1);hold on;
xlabel('Fisher - red   Between means - green   Random - blue', 'FontSize', 14);
axis([1 TIMES 0 1]);
avgf = sum(auc)/TIMES;
avgr = sum(aucr)/TIMES;
avgc = sum(aucC)/TIMES;
disp([avgf avgr avgc]);

