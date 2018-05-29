function [f,fstd] = lab5fSTD(f)


% st = std(f);
% f = f - mean(f);
% f = f/std(f);

[a,~] = size(f);
mean = sum(f)/a;
fst = zeros(a,1);
for i = 1:a
    fst(i) = (f(i) - mean)^2;
end
fstd = (sum(fst)/a)^(1/2);

for i = 1:a
    f(i) = (f(i) - mean)/fstd;
end

