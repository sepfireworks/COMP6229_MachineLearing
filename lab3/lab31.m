C1 = [2,1;1,2];
C2 = [2,1;1,2];
m1 = [0;2];
m2 = [1.7;2.5];

numGrid = 50;
xRange = linspace(-6.0, 6.0, numGrid);
yRange = linspace(-6.0, 6.0, numGrid);
P1 = zeros(numGrid, numGrid);
P2 = P1;
for i = 1:numGrid
    for j = 1:numGrid
        x = [yRange(j) xRange(i)]';
        P1(i,j) = mvnpdf(x', m1', C1);
        P2(i,j) = mvnpdf(x', m2', C2);
    end
end
Pmax = max(max([P1 P2]));
figure(1),clf,
contour(xRange, yRange, P1, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 2);
hold on;
plot(m1(1),m1(2), 'b*', 'LineWidth', 4);
contour(xRange, yRange, P2, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 2);
plot(m2(1),m2(2), 'r*', 'LineWidth', 4);

N = 200;
X1 = mvnrnd(m1, C1, N);
X2 = mvnrnd(m2, C2, N);
plot(X1(:,1),X1(:,2),'bx',X2(:,1),X2(:,2),'ro');grid on;

wF = inv(C1+C2)*(m1-m2);
xx = -6:0.1:6;
yy = xx*wF(2)/wF(1);

wr = zeros(2,1);
wr(1) = rand(1,1) * 2 - 1; wr(2) = rand(1,1) * 2 - 1;
xr = -6:0.1:6;
yr = xx*wr(2)/wr(1);
plot(xx,yy,'r',xr,yr,'b', 'LineWidth', 2);
rocResolution = 50;

[ROC, acc] = lab3f1(N,X1,X2,wF,rocResolution);

figure(3), clf,
plot(ROC(:,1), ROC(:,2), 'b', 'LineWidth', 2);
axis([0 100 0 100]);
grid on, hold on
plot(0:100, 0:100, 'b-');
xlabel('False Positive', 'FontSize', 16);
ylabel('True Positive', 'FontSize', 16);
title('Receiver Operating Characteristic Curve', 'FontSize', 20);

auc = abs(trapz(ROC(:,1),ROC(:,2)))/10000;
accx = linspace(1, rocResolution, rocResolution);
figure(4),clf,
plot(accx,acc,'b','LineWidth', 2);



[ROCr, accr] = lab3f1(N,X1,X2,wr,rocResolution);

figure(5), clf,
plot(ROCr(:,1), ROCr(:,2), 'b', 'LineWidth', 2);
axis([0 100 0 100]);
grid on, hold on
plot(0:100, 0:100, 'b-');
xlabel('False Positive', 'FontSize', 16);
ylabel('True Positive', 'FontSize', 16);
title('Receiver Operating Characteristic Curve', 'FontSize', 20);

aucr = abs(trapz(ROCr(:,1),ROCr(:,2)))/10000;
accx = linspace(1, rocResolution, rocResolution);
figure(6),clf,
plot(accx,accr,'b','LineWidth', 2);
disp([auc aucr]);

% X = [X1;X2];
% N1 = size(X1,1);
% N2 = size(X2,1);
% y = [ones(N1,1); -1*ones(N2,1)];
% d = zeros(N1+N2-1,1);
% nCorrect = 0;
% for jtst = 1:(N1+N2)
%     xtst = X(jtst,:);
%     ytst = y(jtst);
%     
%     jtr = setdiff(1:N1+N2, jtst);
%     Xtr = X(jtr,:);
%     ytr = y(jtr,1);
%     
%     for i = 1:(N1+N2-1)
%         d(i) = norm(Xtr(i,:)-xtst);
%     end
%     
%     [imin] = find(d == min(d));
%     
%     if(ytr(imin(1))*ytst>0)
%         nCorrect = nCorrect + 1;
%     else
%         disp('Incorrect classification');
%     end
% end
% 
% pCorrect = nCorrect*100/(N1+N2);
% disp(['Nearest neighbour accuracy: ' num2str(pCorrect)]);