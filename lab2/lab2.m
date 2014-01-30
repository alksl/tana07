% dzip:     dzip(i) is the (correct) digit in column i of azip
% azip:     the matrix of traning digits
% dtest:    the (correct) test digits
% testzip:  the test digits
load dzip;
load azip;
load dtest;
load testzip;

%% F�rarbete

% Dela upp tr�ningsdata
training = cell(10,1);
for i = 0:9
  training{i+1} = azip(:, find(dzip == i));
end

%% Singularv�rden

% Rita ut singul�rv�rden f�r all siffror
for i=1:10
  [~, S, ~] = svd(training{i}, 0);
  [m, ~] = size(S);
  figure(1)
  plot(1:m, diag(S));
  hold on;
end
hold off;

% Ur figuren g�r det att se att singul�rv�rderna f�ljer liknande form f�r
% alla siffror. �ven om det �r m�jligt att f� vissa f�rb�ttringar genom att
% anv�nda olika k f�r olika siffror s� borde nog optimeringar fokuseras p�
% andra h�ll.


%% Klassificering

% Iterera �ver olika  k = 5-20 approximationer
correct = zeros(16,10);
for k = 5:20
  % R�kna ut svd f�r alla siffror
  U = cell(10,1);
  S = cell(10,1);
  V = cell(10,1);
  for i=1:10
    [U{i}, S{i}, V{i}] = svds(training{i}, k);
  end

  z = testzip(:,1);
  [~, columns] = size(testzip);
  figure(1);
  for i = 1:columns
    residuals = zeros(1,10);
    z = testzip(:,i);
    for j=1:10
      residuals(j) = relative_residual(U{j},z);
    end

    [value, index] = min(residuals);
    if dtest(i) == (index - 1)
      correct(k-4,index) = correct(k-4,index) + 1;
    end
  end
end

% f�r�ndra antalet korrekta tr�ffar till procent
[~, columns] = size(testzip);
accuracy_k = zeros(1,16);
for i = 1:16
  accuracy_k(i) = sum(correct(i,:))/columns;
end

accuracy_digit = zeros(1,10);
for i = 1:10
  [~, num_digits] = size(find(dtest == (i-1)));
  accuracy_digit(i) = sum(correct(:,i)) / (16*num_digits);
end


% Rita ut tr�ffs�kerheten f�r olika k
figure(2)
plot(5:20, accuracy_k);

% Ur figuren g�r det att se att att vid ungef�r k = 15 s� planar
% tr�ffs�kerheten. Ur figuren g�r det enkelt att avv�ga vilket k som ger
% b�st resultat om det tex. finns begr�nsningar p� minne och/eller
% ber�kningar.

% Rita ut tr�ffs�kerheten f�r varje siffra
figure(3)
plot(0:9, accuracy_digit);

% Det g�r att se ur figuren att vissa siffror �r l�ttare att klassificera
% �n andra, tex. det g�r v�ldigt bra att att klassificera 0 och 1 medans
% det �r sv�rar att klassificera 5 och 3.

