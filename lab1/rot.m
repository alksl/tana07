function [c,s] = rot(x,y)
    sq = sqrt(x^2 + y^2);
    c = x/sq;
    s = y/sq;