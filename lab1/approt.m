function X = approt(c, s, i, j, X)
    X([i,j],i:end) = [c s; -s c] * X([i,j], i:end);