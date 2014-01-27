function R = reduce_row(R, x)
  R = [R; x];                                                                         
  [m,n] = size(R);                                                                    
  for i = 1:n                                                                         
   [c, s] = rot(R(i,i), R(m,i));                                                   
   R = approt(c, s, i, m, R);                                                      
  end
end