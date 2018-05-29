C1 = [2,1;1,2];
C2 = [1,0;0,1];
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


figure(1),clf,

contour(xRange, yRange, P1, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 2);
hold on;
plot(m1(1),m1(2), 'b*', 'LineWidth', 4);
contour(xRange, yRange, P2, [0.1*Pmax 0.5*Pmax 0.8*Pmax], 'LineWidth', 2);
plot(m2(1),m2(2), 'r*', 'LineWidth', 4);


syms x y
f = [x-m1(1),y-m1(2)]*inv(C1)*[x-m1(1),y-m1(2)]'-[x-m2(1),y-m2(2)]*inv(C2)*[x-m2(1),y-m2(2)]';
h = ezplot(f, [-6 6] , [-6 6]);
axis([-6 5.5 -6 5.4]);
set(h,'Color','k','LineWidth',2);

xc=-6:0.01:2.8;
YYC = zeros(881,1);
YC = @(xc) fzero(@(yc) [xc-m1(1),yc-m1(2)]*inv(C1)*[xc-m1(1),yc-m1(2)]'-[xc-m2(1),yc-m2(2)]*inv(C2)*[xc-m2(1),yc-m2(2)]',1);
for i = 1:881
    YYC(i) = YC(-6+i*0.01);
end

figure(2),clf,
plot(xc,YYC);
axis([-6 5.5 -6 5.4]);grid on;hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TIMES = 200;
r1 = 0;r2 = 0;

for tis = 1:TIMES
    
    N1 = 100; N2 = 100;
    X1 = mvnrnd(m1, C1, N1);
    X2 = mvnrnd(m2, C2, N2);
    tpos = 0;tneg = 0;fpos = 0;fneg = 0;
    
    for i = 1:N1
        ii = round((X1(i,1)+6)/0.01);
        if (X1(i,1) > 2.8)
            fpos = fpos+1;
            continue;
        elseif X1(i,2)>YYC(ii)
            tpos = tpos + 1;
        else
            fpos = fpos+1;
        end
    end
    for i = 1:N2
        ii = round((X2(i,1)+6)/0.01);
        if (X2(i,1) > 2.8)
            tneg = tneg + 1;
            continue;
        elseif X2(i,2)<YYC(ii)
            tneg = tneg + 1;
        else
            fneg = fneg + 1;
        end
    end
    auc_bys = (tpos + tneg)/(N1 + N2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    X = [X1;X2];
    y1 = zeros(N1,1);
    y2 = ones(N2,1);
    y = [y1;y2];

    [net1] = feedforwardnet(10);
    [net1] = train(net1, X', y');
    [output1] = net1(X');

    [net2] = feedforwardnet(20);
    [net2] = train(net2, X', y');
    [output2] = net2(X');
    
    [net3] = feedforwardnet(30);
    [net3] = train(net3, X', y');
    [output3] = net3(X');

    [auc_nn1] = AUC(y',output1);
    [auc_nn2] = AUC(y',output2);
    [auc_nn3] = AUC(y',output3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if auc_nn1 > auc_bys
        r1 = r1 + 1;
    end
    if (auc_nn2 > auc_nn1) && (auc_nn3 > auc_nn2)
        r2 = r2 + 1;
    end
end

ratio1 = r1/TIMES;ratio2 = r2/TIMES;
disp([ratio1, ratio2]);
