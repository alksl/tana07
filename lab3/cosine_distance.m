function d = cosine_distance(query, article)
  d = abs((query' * article)/(norm(query,2)*norm(article,2)));
end