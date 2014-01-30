% dzip:     dzip(i) is the (correct) digit in column i of azip
% azip:     the matrix of traning digits
% dtest:    the (correct) test digits
% testzip:  the test digits
load dzip;
load azip;
load dtest;
load testzip;

%% Förarbete

% Dela upp träningsdata
training = cell(10,1);
for i = 0:9
  training{i+1} = azip(:, find(dzip == i));
end

%% Singularvärden

% Rita ut singulärvärden för all siffror
for i=1:10
  [~, S, ~] = svd(training{i}, 0);
  [m, ~] = size(S);
  figure(1)
  plot(1:m, diag(S));
  hold on;
end
hold off;

% Ur figuren går det att se att singulärvärderna följer liknande form för
% alla siffror. Även om det är möjligt att få vissa förbättringar genom att
% använda olika k för olika siffror så borde nog optimeringar fokuseras på
% andra håll.


%% Klassificering

% Iterera över olika  k = 5-20 approximationer
correct = zeros(16,10);
for k = 5:20
  % Räkna ut svd för alla siffror
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

% förändra antalet korrekta träffar till procent
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


% Rita ut träffsäkerheten för olika k
figure(2)
plot(5:20, accuracy_k);

% Ur figuren går det att se att att vid ungefär k = 15 så planar
% träffsäkerheten. Ur figuren går det enkelt att avväga vilket k som ger
% bäst resultat om det tex. finns begränsningar på minne och/eller
% beräkningar.

% Rita ut träffsäkerheten för varje siffra
figure(3)
plot(0:9, accuracy_digit);

% Det går att se ur figuren att vissa siffror är lättare att klassificera
% än andra, tex. det går väldigt bra att att klassificera 0 och 1 medans
% det är svårar att klassificera 5 och 3.

