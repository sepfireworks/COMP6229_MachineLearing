%a=xlsread('FTSE 100 Historical Data.xlsx');
%[data,text]  = xlsread('FTSE 100 Historical Data.xlsx', 'sheet1', 'A2:D10');
[data,text]  = xlsread('FTSE 100 Historical Data.xlsx');
[a,~] = size(data);
dataxxx = data(2:a,1);
data0 = zeros(a-1,1);
for i=1:a-1
    data0(i) = dataxxx(a-i);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p = 20;
N = a - 2;
%[XS,sts] = lab5fSTD(data0);
X = data0;
%%% 填充正规化矩阵 timeSeriesS 
timeSeriesS = zeros(N-p+1,p);
for i = 1:p
    k = 1;
    for j = i:N-p+i
        timeSeriesS(k,i) = X(j);
        k = k+1;
    end
end

%%% 训练神经网络
f1 = X(p+1:N+1);
[net] = feedforwardnet(20);
[net] = train(net, timeSeriesS', f1');

%%% 循环次数u = 20
u = 20;

outSeries2 = zeros(u,1);
for i = 1:u
    if i == 1
        Xn = X(N-p+i:N+i-1);
    else
        Xn = [Xn(2:p);nn_out];
    end
    [nn_out] = net(Xn);
    outSeries2(i) = nn_out;
end


%%% 图5  
xi  = 1:1:u;
figure(5),clf
plot(xi,outSeries2(1:u),'b','LineWidth',3);
set(gca,'FontSize',14);