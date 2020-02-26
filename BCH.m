clear all;

BER_Score = zeros(1, 100);
E_Score = zeros(1, 100);
length = 1024;
%sigma = 0:0.05:4.95;
sigma=0:0.01:0.99;
m = 5;
n = 2^m-1;                          % suma bitow realnej wiadomosci i bitow korekcji
k = 16;                             % ilosc bitow realnej wiadomosci
total_len = n * length/k;           % dlugosc ciagu z bitami korekcji
[genpoly,t] = bchgenpoly(n,k);      % generowanie wielomianu
psuj = 0.0;
w=ones(1, total_len);

for p = 1:100
    %Generowanie danych
    x = rand(1,length);             % wygenerowanie wektora losowych liczb z przedzialu od 0 do 1
    x = round(x);                   % zaokraglenie liczb albo do 0 albo do 1
    
    %Kodowanie danych
    y = ones(1, total_len);
    s = 0;
    for i = [1:k:length-1]    
        partial = x(i:i+k-1);                % pobranie bitow do zakodowania co k       
        code = bchenc(gf(partial),n,k);      % kodowanie wiadomosci co k - bitów <1,16>, <17,32> itd...         
        y(s*n+1:(s+1)*n) = code.x;           % zakodowany ciag (code.x) ma dlugosc n, wpisujemy go do y co n bitow zaczynajac od 1       
        s = s + 1;                           
    end 
    
    %Kanal transmisyjny
    %y = y + normrnd(0,sigma(p),1,total_len);  % zaklocenie zakodowanego sygnalu
    for i=1:total_len
        w(i)=y(i);
        y(i)=unifrnd(0,1);
    if y(i)>psuj        %zaokraglenie albo do zera albo do jedynki (punkt podzialu to liczba 0.5)
        y(i)=w(i);
    else
        if w(i)==1  %tutaj by³ y zamiast w
            y(i)=0;
        else
            y(i)=1;
        end    
    end
    end

    %Dekoder
    out = ones(1,length);                                   % wygenerowanie wektora wyjsciowego
    s = 0;
    for i = [1:n:total_len-1]                               
        partial_out = y(i:i+n-1);                           % pobieranie ciagow o dlugosci n (bity informacji + bity korekcji)
        [newmsg,err,ccode] = bchdec(gf(partial_out),n,k);   % odkodowanie
        out(s*k+1:(s+1)*k) = newmsg.x;                      % wpisanie do wektora wyjsciowego co k bitow
        s = s + 1;
    end

    %porownanie poszczegolnych wektorow
    %x nadanego
    %y zakodowanego a nastepnie zakloconego
    %out odebranego
    errors = 0;                             %zmienna przechowujaca ilosc blednie przeslanych bitow
    x = (x ~= out);                         %XOR bitow na wyslanych i odebranych, dostajemy 1 tam, gdzie bit zostal zle przeslany
    for i=1:length
        errors = errors + x(i);             %zlicznie bledow
    end
    BER_Score(p) = errors/length; 
    E_Score(p) = (length-errors)/(total_len);   
    %E_Score(p) = (length-errors)/(length); 
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