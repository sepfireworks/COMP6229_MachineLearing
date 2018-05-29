function [w] = lab5fLE(N,p,f,Y)

%p = p1-1;

Y1 = [Y(:,1:p) ones(N,1)];
for j=1:p
    Y1(:,j)=Y1(:,j)-mean(Y1(:,j));
    Y1(:,j)=Y1(:,j)/std(Y1(:,j));
end

% Y1 = Y(:,1:p);

f1 = f;
f1 = f1 - mean(f1);
f1 = f1/std(f1);

w = inv(Y1'*Y1)*Y1'*f1;


