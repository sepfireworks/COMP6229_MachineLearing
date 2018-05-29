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

figure(1),clf,

% %bayes
% wb = 2*inv(C1)*(m2-m1);
% % bb = m1'*inv(C1)*m1 - m2'*inv(C1)*m2;
% bb = (-1)*(m1'*inv(C1)*m1 - m2'*inv(C1)*m2)/wb(2);
% % bb = (-1)*(m1'*inv(C1)*m1 - m2'*inv(C1)*m2);
% kb = (-1)*wb(1)/wb(2);
% 
% 
% xb=linspace(-6,6,20);
% yb = xb*kb + bb;
% figure(1),
% plot(xb,yb,'m','LineWidth', 2); 
% 
% w0 = m1'*inv(C1)*m1 - m2'*inv(C1)*m2;


%  draw Bayes boundary

% PP1 = zeros(N1,N1);PP2 = zeros(N2,N2);
% xB=linspace(-6,6,N1);yB=linspace(-6,6,N1);
% for i = 1:N1
%     for j = 1:N1
%         G1 = ([xB(i);yB(j)]-m1)'*inv(C1)*([xB(i);yB(j)]-m1);
%         G2 = ([xB(i);yB(j)]-m2)'*inv(C2)*([xB(i);yB(j)]-m2);
%         PP1(i,j) = 1/(1 + (det(C1)/det(C2))^(1/2)*exp(1/2*(G1-G2)));
%     end
% end
% [XB1,YB1]=meshgrid(xB,yB);
% 
% for i = 1:N2
%     for j = 1:N2
%         G1 = ([xB(i);yB(j)]-m1)'*inv(C1)*([xB(i);yB(j)]-m1);
%         G2 = ([xB(i);yB(j)]-m2)'*inv(C2)*([xB(i);yB(j)]-m2);
%         PP2(i,j) = 1/(1 + (det(C2)/det(C1))^(1/2)*exp(1/2*(G2-G1)));
%     end
% end
% [XB2,YB2]=meshgrid(xB,yB);
% 
% surf(XB1,YB1,PP1);hold on;
% surf(XB2,YB2,PP2);hold on;
% colormap winter;shading interp;




plot(X1(:,1),X1(:,2),'bx',X2(:,1),X2(:,2),'ro');grid on;hold on;

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


%axis([-4 4 -4 4 0 1]);

xc=-6:0.01:2.8;
%f = [x-m1(1),y-m1(2)]*inv(C1)*[x-m1(1),y-m1(2)]'-[x-m2(1),y-m2(2)]*inv(C2)*[x-m2(1),y-m2(2)]';
YYC = zeros(881,1);
YC = @(xc) fzero(@(yc) [xc-m1(1),yc-m1(2)]*inv(C1)*[xc-m1(1),yc-m1(2)]'-[xc-m2(1),yc-m2(2)]*inv(C2)*[xc-m2(1),yc-m2(2)]',1);
for i = 1:881
    YYC(i) = YC(-6+i*0.01);
end

figure(2),clf,
plot(xc,YYC);
axis([-6 5.5 -6 5.4]);grid on;hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tpos = 0;tneg = 0;fpos = 0;fneg = 0;
classOut1 = zeros(N1,1);
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
auc_bs = (tpos + tneg)/(N1 + N2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = [X1;X2];
y1 = zeros(N1,1);
y2 = ones(N2,1);
y = [y1;y2];

[net1] = feedforwardnet(20);
[net1] = train(net1, X', y');
[output1] = net1(X');

[net2] = feedforwardnet(10);
[net2] = train(net2, X', y');
[output2] = net2(X');

figure(3),clf,
plotroc(y',output1);
[auc_nn1] = AUC(y',output1);
figure(4),clf,
plotroc(y',output2);
[auc_nn2] = AUC(y',output2);

disp([auc_bs, auc_nn1, auc_nn2]);