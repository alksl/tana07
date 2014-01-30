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

% Skillnaden mellan 1a och 1b är att b har en extra punkt given. I det här 
% fallet påverkar det inte lösningen eftersom att alla punkter ligger på
% linjen.


%% Assignment 2
t = 500.+(1:4);
f = 1:4;
A = [ ones(4,1) t' t.^2' t.^3' ];

% Med den här ansättningen blir konditionstalet väldigt stort
display(cond(A, inf));

[Q, R] = qr(A, 0);
a = R\Q'*f';
display(a);
figure(3);
plot(t, f, 'x');
hold on;
plot(t, t.^3*x(4) + t.^2*x(3) + t*x(2) + x(1), 'g')

% Om vi istället centrerar runt medelvärdet
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

% Vi ser här att det sista resultatet (röda) passar mycket bättre i
% punkterna och är inte lika känslig för felräkningar än den första
% ansättningen (gröna)


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

% För diskussion se 3b.


%% Assignment 3b

figure(4);
loglog(eps, cond_qr, '-g');
hold on;
loglog(eps, cond_normal, '-b');
grid on;

% QR versionen är mer korrekt och inte lika känslig för störningar. Vilket
% kan ses i grafen där konditonstalen för både normalekvationerna (blå) och
% qr lösningen (grön). Kurvorna är logaritmiska så avståndet mellan
% kurvorna är väldigt stora. Vilket också kan ses i lösningarna  där
% normalekvationerna inte ger någon lösning (NaN) för små epsilon.


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

% Båda funktionerna är ungefär lika bra.



