function [ROC, acc, thRange] = lab3f1(N,X1,X2,w,rocResolution)

p1 = X1*w;
p2 = X2*w;

[~, xx1] = hist(p1);
[~, xx2] = hist(p2);


thmin = min([xx1 xx2]);
thmax = max([xx1 xx2]);
thRange = linspace(thmin, thmax, rocResolution);
ROC = zeros(rocResolution,2);
acc = zeros(rocResolution,1);
for jThreshold = 1:rocResolution
    threshold = thRange(jThreshold);
    tPos = length(find(p1 > threshold))*100 / N;
    fPos = length(find(p2 > threshold))*100 / N;
    ROC(jThreshold,:) = [fPos tPos];
    acc(jThreshold) = 1/2 + (tPos - fPos)/200;
end
