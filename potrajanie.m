clear all;

BER_Score = zeros(1, 100);  
E_Score = zeros(1, 100);
length = 1000;
%sigma = 0:0.05:4.95;
sigma = 0:0.01:0.99;
psuj=0;

for n = 1:100

%Generowanie danych
x=rand(1,length);    %wygenerowanie wektora dziesieciu losowych liczb z przedzialu od 0 do 1
x=round(x);     %zaokraglenie liczb albo do 0 albo do 1



%Kodowanie danych
y=ones(1,3*length);   %wygenerowanie wektora od dlugosci 3 razy wiekszej od wektora wejsciowego
for i=1:length              %petla w ktorej potraja sie kazdy bit
    y(3*i-2)=x(i);
    y(3*i-1)=x(i);
    y(3*i)=x(i);
end
test = ones(1,3*length);
%Kanal transmisyjny
    w=ones(1, 3*length);
    for i=1:3*length
        test(i)=unifrnd(0,1);
        w(i)=y(i);
        y(i)=unifrnd(0,1); %tutaj spinka---------------------------------------------------
    if y(i)>psuj        %zaokraglenie albo do zera albo do jedynki (punkt podzialu to liczba 0.5)
        y(i)=w(i);
    else
        if w(i)==1 % tutaj by³ y zamiast w
            y(i)=0;
        else
            y(i)=1;
        end    
    end
    end



%Dekoder
z=ones(1,length);           %wygenerowanie kolejnego wektora, wyjsciowego, o dlugosci wektora wejsciowego
for i=1:length
    a=y(3*i-2)+y(3*i-1)+y(3*i);         %dodanie trzech skladowych bitow skladajacych sie na jeden wyjsciowy
    if a<2                              %rozstrzygniecie czy bit ktory odbieramy ma byc zerem czy jedynka
        z(i)=0;                         %jezeli ma byc zerem to zapisujemy na danym miejscu wektora wyjsciowego 0
    end
end

%porownanie poszczegolnych wektorow
%x nadanego
%y zakodowanego a nastepnie zakloconego
%z odebranego
errors = 0; %zmienna przechowujaca ilosc blednie przeslanych bitow


x = (x ~= z); %XOR bitow na wyslanych i odebranych, dostajemy 1 tam, gdzie bit zostal zle przeslany
for i=1:length
 %  if x(i)~=z(i)
 %       errors=errors+1;
 %  else
 %       errors=errors;
 %   end
     errors = errors + x(i); %zlicznie bledow
end
BER_Score(n) = errors/length; 
E_Score(n) = (length-errors)/(3*length);
%E_Score(n) = (length-errors)/(length); % na zmianê z tym u góry
psuj=psuj+0.01;
end

figure(3);
subplot(2,2,1);
plot(sigma, BER_Score); 
xlabel('Sigma');
ylabel('BER');

subplot(2,2,2);
plot(sigma, E_Score);
xlabel('Sigma');
ylabel('E');

subplot(2,2,3);
plot(BER_Score, E_Score);
xlabel('BER');
ylabel('E');

