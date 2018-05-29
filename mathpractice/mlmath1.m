x = -sqrt(8):0.001:sqrt(8);
fx = abs((16-(x.^2-4).^2).^(1/2));
subplot(1,2,1);plot(x,fx,'r');
y = (8 - x.^2).^(1/2);
fxy = x.*y;
subplot(1,2,2);plot3(x,y,fxy,x,-y,fxy);
grid on;
