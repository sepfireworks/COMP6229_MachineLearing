c = [2,1;1,2];
a = chol(c);
t = a'*a;
X=randn(1000,2);
Y = X*a;
plot(X(:,1),X(:,2),'c.',Y(:,1),Y(:,2),'mx');