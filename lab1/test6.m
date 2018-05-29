c = [2,-1;-1,2];
a = chol(c);
t = a.'*a;
X=randn(1000,2);
Y = X*a;
theta = 0.25;
u = [sin(theta);cos(theta)];
yp = Y*u;
var_empirical = var(yp);
var_theoretical = u'*c*u;

N = 50;
plotArray = zeros(N,1);
thRange = linspace(0,2*pi,N);
uu = zeros(N,2);
i = 0;


for n=1:N
    uu(n,1) = sin(thRange(n));
    uu(n,2) = cos(thRange(n));
    k = [uu(n,1);uu(n,2)];
    var_e = var(Y*k);
    var_t = k'*c*k;
    plotArray(n,1) = var_e - var_t;
end    
plot(plotArray);