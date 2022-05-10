function u = u(C,p)
%Рассчитывает волновые функции u по формуле с параметрами C в точках p

C = reshape(C,1,[]);
p = reshape(p,[],1);

n = numel(C) + 1;
j = 1:n;
m = 0.231607 + (j-1).*0.9;
C(n) = -sum(C);
u = sqrt(2./pi).*sum(C./(p.^2+m.^2),2);