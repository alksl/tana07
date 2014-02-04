function [recall, precision] = calculate_performance(distances, tol, medRel)
  [num_queries, n] = size(distances);
    
  precision = cell(num_queries, 1);
  recall = cell(num_queries, 1);
  for u = 1:length(tol)
    matches = cell(num_queries, 1);
    for i=1:num_queries
      for j=1:n
        if distances(i,j) >= tol(u)
          matches{i} = [matches{i} j];
        end
      end

      Dr = length(intersect(matches{i}, medRel{i}));
      if Dr > 0
        precision{i} = [precision{i} 100*Dr/length(matches{i})];
        recall{i} = [recall{i} 100*Dr/length(medRel{i})];
      end
    end
  end
end