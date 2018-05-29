fopen ('housing.data', 'rt');
housing_data = importdata('housing.data');
[N, p1] = size(housing_data);

TIMES = 50;kk = 50;

% ZPoint = zeros(TIMES,1);
% zp = zeros(TIMES,1);

Etrn = zeros(TIMES,kk);
Etst = zeros(TIMES,kk);
diff = zeros(TIMES,kk);
for tis = 1:TIMES
    for kis = 1:kk
        Ntrn = 400;
        K = 2*kis;
        [Xtrn,ytrn,Xtst,ytst] = lab5f1(Ntrn,N,housing_data,p1);

        [yh,Etrn(tis,kis)] = lab5fnl(Ntrn,Xtrn,ytrn,K);
        [yht,Etst(tis,kis)] = lab5fnl(N-Ntrn,Xtst,ytst,K);
%         if isnan(Etst(tis,kis))
%             ZPoint(tis,zp(tis)+1) = kis; %每条线的零点位置
%             zp(tis) = zp(tis) + 1;  %每条线有多少零点
%         end
        diff(tis,kis) = Etrn(tis,kis) - Etst(tis,kis);
        disp(tis/TIMES*100+kis/kk*(100/TIMES)-1);
    end

end
% %除零点
% for i = 1:zp(tis)
%    Etrn(ZPoint(i),:)=[];
%    Etst(ZPoint(i),:)=[];
%    diff(ZPoint(i),:)=[];
% end
[~,zp1] = find(isnan(Etst)==1);
[~,zp2] = find(isnan(Etrn)==1);
zpp = [zp1;zp2];
[zp,~] = unique(zpp);

Etst(:,zp) = [];Etrn(:,zp) = [];diff(:,zp) = [];
KF = kk-length(zp);
AEtrn = zeros(KF,1);
AEtst = zeros(KF,1);
diffA = zeros(KF,1);
for kis = 1:KF
    AEtrn(kis) = sum(Etrn(:,kis))/(KF);
    AEtst(kis) = sum(Etst(:,kis))/(KF);
    diffA(kis) = sum(diff(:,kis))/(KF);
end
tt = 1:1:KF;
figure(1),clf,
plot(tt, AEtrn, 'r', 'LineWidth', 2), grid on,hold on;
plot(tt, AEtst, 'b', 'LineWidth', 2), grid on,hold on;
plot(tt, diffA, 'k', 'LineWidth', 2), grid on,hold on;
title('RBF Prediction on Training Data', 'FontSize', 16);
xlabel('Target', 'FontSize', 14);
ylabel('Prediction', 'FontSize', 14);
