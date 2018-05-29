[data,text]  = xlsread('FTSE 100 Historical Data.xlsx');
[a,~] = size(data);
dataxxx = data(2:a,1);
data0 = zeros(a-1,1);
for i=1:a-1
    data0(i) = dataxxx(a-i);
end

Vol0 = zeros(a-1,1);
for i = 1:a-1
    b = char(text(i+2,6));
    c = b(length(b));
    d = str2double(b(1:length(b)-1));
    if c == 'M'
        volu = d*((10)^(6));
    elseif c == 'B'
        volu = d*((10)^(9));
    end
    Vol0(i) = volu;
end
Vol = zeros(a-1,1);
for i=1:a-1
    Vol(i) = Vol0(a-i);
end
xia = 1:1:a-1;
figure(1),clf
plot(xia,data0,'m','LineWidth',2);
set(gca,'FontSize',14);
figure(2),clf
plot(xia,Vol,'c','LineWidth',2);
set(gca,'FontSize',14);