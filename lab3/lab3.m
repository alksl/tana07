%% Ladda MedRel (korrekta resultat)
% Jag gjorde om de korrekta resultaten lite s� att de �r l�ttare att
% hantera. De �r sparade i 30 celler som ineh�ller en vektor med tr�ffar
% f�r varje fr�ga.
load('medrel.mat');

%% Generera TDM och ta ut artiklar och fr�gor
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

% Genom att �ndra min_local_freq och min_global_freq s� tas mer eller
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

% F�rst normalisera matrisen
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

% Antal iterationer f�r k_means
display(iterations)





