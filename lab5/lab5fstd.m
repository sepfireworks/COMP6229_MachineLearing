function [Y,w,f] = lab5fstd(N,p1,housing_data)

p = p1-1;

Y = [housing_data(:,1:p) ones(N,1)];
for j=1:p
    Y(:,j)=Y(:,j)-mean(Y(:,j));
    Y(:,j)=Y(:,j)/std(Y(:,j));
end

f = housing_data(:,p1);
f = f - mean(f);
f = f/std(f);

w = inv(Y'*Y)*Y'*f;

