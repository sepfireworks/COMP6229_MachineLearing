C1 = [1,0;0,1];
C2 = [1.5,0;0,1.5];
m1 = [0;3];
m2 = [2;1];

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
N1 = 100; N2 = 100;
X1 = mvnrnd(m1, C1, N1);
X2 = mvnrnd(m2, C2, N2);
X = [X1;X2];
y1 = zeros(N1,1);
y2 = ones(N2,1);
y = [y1;y2];

[net] = feedforwardnet(20);
[net] = train(net, X', y');
[output] = net(X');

plotroc(y',output);
[auc_nn] = AUC(y',output);
rocResolution = 50;

% plot(1:1:N1+N2, output, 'r', 'LineWidth', 2);

% [ROC, acc, thRange] = lab3f1(N1+N2,X1,X2,wF,rocResolution);
% 
% figure(3), clf,
% plot(ROC(:,1), ROC(:,2), 'r', 'LineWidth', 2);
% axis([0 100 0 100]);
% grid on, hold on
