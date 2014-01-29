%% TANA07- Computer assignment 1 (Least squares and orthogonal transformations)

%% Assignment 1a
t = 1:4;
f = 1:4;
A = [ ones(4,1) t' t.^2' t.^3' ];
[Q, R] = qr(A, 0);
x = R\Q'*f';

figure(1);
plot(t, f, 'x');
hold on;
plot(t, t.^3*x(4) + t.^2*x(3) + t*x(2) + x(1), 'r')

%% Assignment 1b
t = 1:1:5;
f = 1:1:5;
A  = [ ones(5,1) t' t.^2' t.^3' ];
[Q, R] = qr(A, 0);
x = R\Q'*f';

figure(2);
plot(t, f, 'x');
hold on;
plot(t, t.^3*x(4) + t.^2*x(3) + t*x(2) + x(1), 'r')

% Skillnaden mellan 1a och 1b �r att b har en extra punkt given. I det h�r 
% fallet p�verkar det inte l�sningen eftersom att alla punkter ligger p�
% linjen.


%% Assignment 2
t = 500.+(1:4);
f = 1:4;
A = [ ones(4,1) t' t.^2' t.^3' ];

% Med den h�r ans�ttningen blir konditionstalet v�ldigt stort
display(cond(A, inf));

[Q, R] = qr(A, 0);
a = R\Q'*f';
display(a);
figure(3);
plot(t, f, 'x');
hold on;
plot(t, t.^3*x(4) + t.^2*x(3) + t*x(2) + x(1), 'g')

% Om vi ist�llet centrerar runt medelv�rdet
m = mean(t);
A = [ ones(4,1) (t - m)' (t - m).^2' (t - m).^3' ];

% Blir konditionstalet mindre
display(cond(A, inf));

% och ger resultatet
[Q, R] = qr(A, 0);
a = R\Q'*f';
plot(t, f, 'x');
hold on;
plot(t, (t - m).^3*a(4) + (t - m).^2*a(3) + (t - m)*a(2) + (t - m)*a(1), 'r');

% Vi ser h�r att det sista resultatet (r�da) passar mycket b�ttre i
% punkterna och �r inte lika k�nslig f�r felr�kningar �n den f�rsta
% ans�ttningen (gr�na)


%% Assignment 3a 
eps = [1 1e-1 1e-2 1e-3 1e-4 1e-5 1e-6 1e-7 1e-8 1e-9];
y = ones(3,1);

cond_qr = zeros(1, 10);
cond_normal = zeros(1, 10);

for i = 1:10
  A = [ [ 1 eps(i) 0]' [1 0 eps(i)]' ];
  b_normal = (A'*A)\(A'*y);
  cond_normal(i) = cond(A'*A);
  display(b_normal);
  [Q, R] = qr(A, 0);
  cond_qr(i) = cond(A);
  b_qr = R\(Q'*y);
  display(b_qr);
end

% F�r diskussion se 3b.


%% Assignment 3b

figure(4);
loglog(eps, cond_qr, '-g');
hold on;
loglog(eps, cond_normal, '-b');
grid on;

% QR versionen �r mer korrekt och inte lika k�nslig f�r st�rningar. Vilket
% kan ses i grafen d�r konditonstalen f�r b�de normalekvationerna (bl�) och
% qr l�sningen (gr�n). Kurvorna �r logaritmiska s� avst�ndet mellan
% kurvorna �r v�ldigt stora. Vilket ocks� kan ses i l�sningarna  d�r
% normalekvationerna inte ger n�gon l�sning (NaN) f�r sm� epsilon.


%% Assignment 4
A = [ ones(3,1) (1:3)' [ 3 7 9]' ];                                                 
x = [1 4 11];                                                                       
[~,R] = qr(A);                                                                      
[~,Rref] = qr([A; x]);                                                              

R = reduce_row(R, x);
 
disp(A);
disp(R);
disp(Rref);


%% Assignment 5
A = [ones(4,1) (1:4)' [1 3 9 14]' ];
[refQ, refR] = qr(A);
[Q, R] = myqr(A);

disp(refQ);
disp(refR);
disp(Q);
disp(R);

disp(norm(A - (refQ*refR), inf));
disp(norm(A - (Q*R), inf));

% B�da funktionerna �r ungef�r lika bra.



