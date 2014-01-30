function [Q, R] = myqr(A)
  [m, n] = size(A);
  R = A;
  Q = eye(m);
  for i = 1:n
    u = househ(R(i:m, i));
    R(i:m, i:n) = apphouse(u, R(i:m, i:n));
    Q(i:m, 1:m) = apphouse(u, Q(i:m, 1:m));
  end
  Q=Q'
end

