function [centroids, iterations, belongs_to] = k_means(articles, k, tol)
  [m, n] = size(articles);
  centroids = zeros(m, k);
  belongs_to = zeros(1, n);
  iterations = 0;
  
  % Initial clusters (random)
  for i = 1:n
    index = randi(k,1);
    belongs_to(i) = index;
  end
  
  % Until convergence
  prev_coherence = 0;
  coherence = n;
  while 1
    % Centroids
    for i = 1:k
      indexes = find(belongs_to == i);
      if isempty(indexes) == 0
        centroids(:, i) = mean(articles(:,indexes)');
      end
    end
    
    % Overall coherence
    prev_coherence = coherence;
    coherence = 0;
    for i = 1:k
      indexes = find(belongs_to == i);
      for j = 1:length(indexes)
        coherence = coherence +...
          norm(articles(:,belongs_to(indexes(j))) - centroids(:, i))^2;
      end
    end
    
    % Good enough?
    if abs(prev_coherence - coherence) < tol
      break;
    end
    
    % Do the Clustering
    for i = 1:n
      nearest = 1;
      nearest_value = 0;
      for j = 1:k
        distance = cosine_distance(centroids(:,j), articles(:,i));
        if distance > nearest_value
          nearest_value = distance;
          nearest = j;
        end
      end
      
      % Move object
      belongs_to(i) = nearest;
    end
    iterations = iterations + 1;
  end
end