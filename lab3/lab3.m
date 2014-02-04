%% Ladda MedRel (korrekta resultat)
% Jag gjorde om de korrekta resultaten lite så att de är lättare att
% hantera. De är sparade i 30 celler som inehåller en vektor med träffar
% för varje fråga.
load('medrel.mat');

%% Generera TDM och ta ut artiklar och frågor
[A, dictionary] = tmg(...
        '/Users/anton/Documents/MATLAB/tana07/lab3/MED.Q.and.A.txt',...
        struct(...
             'stemming',1,...
             'stoplist',...
             '/Users/anton/Documents/MATLAB/tana07/lab3/common_words.txt',...
             'min_local_freq',1,...
             'min_global_freq',2,...
             'global_weight', 'f'));
           
n = size(A,2);
num_queries = 30;
queries = A(:, 1:num_queries);
articles = A(:, num_queries+1:n);

% Genom att ändra min_local_freq och min_global_freq så tas mer eller
% mindre termer med i matrisen, dvs. kolumnerna i matrisen blir olika
% stora.

%% Full vector space model
n = size(articles,2);
distances = zeros(num_queries, n);
for i=1:num_queries
  for j=1:n
    distances(i,j) = cosine_distance(queries(:,i), articles(:,j));
  end
end

[recall, precision] = calculate_performance(distances, 0:0.1:1, medRel);

figure(1);
[avg_recall, avg_precision] = aver(recall, precision, 1:num_queries);
clf;
plot(avg_recall, avg_precision);
axis([0 100 0 100]);
hold on;
title('Average performance - Vector space (blue), LSI (red), Clustering (green)');
xlabel('Recall');
ylabel('Precision');


%% Latent Semantic Indexing

% Först normalisera matrisen
n = size(articles, 2);
normalized_articles = articles;
for i = 1:n
  normalized_articles(:,i) = normalized_articles(:,i) /... 
                              norm(normalized_articles(:,i),2);
end


[U, S, V] = svds(normalized_articles, 100);
H = S*V';

distances = zeros(num_queries, n);
for i = 1:num_queries
  q = U'*queries(:,i);
  for j = 1:n
    h = H(:,j);
    distances(i,j) = cosine_distance(q, h);
  end
end

[recall, precision] = calculate_performance(distances, 0:0.1:1, medRel);
[avg_recall, avg_precision] = aver(recall, precision, 1:num_queries);
plot(avg_recall, avg_precision, 'r');
hold on;


%% Centroids med K-means
[centroids,iterations] = k_means(articles, 50, 1);
[Q, R] = qr(centroids, 0);
G = Q'*articles;

distances = zeros(num_queries, n);
n = size(articles, 2);
for i = 1:num_queries
  q = Q'*queries(:,i);
  for  j = 1:n
    distances(i,j) = cosine_distance(q, G(:,j));
  end
end

[recall, precision] = calculate_performance(distances, 0:0.1:1, medRel);
[avg_recall, avg_precision] = aver(recall, precision, 1:num_queries);
plot(avg_recall, avg_precision, 'g');
hold on;

% Antal iterationer för k_means
display(iterations)





