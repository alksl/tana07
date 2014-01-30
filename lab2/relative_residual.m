function r = relative_residual(U, z, norm_type)
  if nargin < 3
    norm_type = 2;
  end
  
  [n, ~] = size(U);
  r = norm((eye(n) - U*U')*z, norm_type)/norm(z, norm_type);
end