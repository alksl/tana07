
function [recall,precision]=aver(rec1,prec1,kind)
% Compute the average precision
% rec1{k}  -  recall for query k
% prec1{k}  - precision for query k
% The values of rec1 and prec1 have been generated as in the following
% example:
%
%  >>    [recall,precision]=recprec(k,med_rel,cosines,ndocs);
%  >>    % Compute recall and precision for query k, using the vector of
%        % cosines for ndocs documents
%        % Store the recall and precision in the cell arrays rec1 and prec1
%  >>    rec1{k}=recall; prec1{k}=precision;
%
% kind  - Indices of the queries that have been tested
% 

recall=5:5:90;  % Recall levels for average
for j=1:length(kind)
    kk=kind(j);
    [rec,prec]=modrec(rec1{kk},prec1{kk});      % Modify recall
    pri(:,j)=interp1(rec,prec,recall,'linear');  % Interpolate
end
for i=1:length(recall)
    jj=find(pri(i,:)>0);
    if length(jj) == 0
        precision(i)=nan;
    else
        precision(i)=sum(pri(i,jj))/length(jj);
    end
end
