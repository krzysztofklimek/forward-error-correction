clear all

sigma = 0:1:99;
length = 1000;
wartosc_stanu= 0;

zmienna_stanu=0; %
dlugosc_kanalu_zlego=2;
dlugosc_kanalu_dobrego=2;

x=rand(1,length);    %wygenerowanie wektora losowych liczb z przedzialu od 0 do 1
x=round(x);  

%w=ones(1, length);

for i=1:length
    w(i)=x(i);
end

for calosc=1:100
for i=1:dlugosc_kanalu_dobrego+dlugosc_kanalu_zlego:length
zmienna_stanu=unifrnd(0,1);

    %jeœli zmienna stanu wiêksza od wartoœci stanu to trafiamy do z³ego stanu
    if zmienna_stanu > wartosc_stanu
        for q=1:dlugosc_kanalu_zlego
            if w(i+q-1) ==1
                x(i+q-1)=0;
            else
                x(i+q-1)=1;
             end
        end
    else
        for q=1:dlugosc_kanalu_dobrego
            x(i+q-1)=w(i+q-1);
        end
    end
end
errors=0;
x = (x ~= w); 
for i=1:length
     errors = errors + x(i); %zlicznie bledow
end
wartosc_stanu= wartosc_stanu +0.01;
wynik(calosc)=errors/length;
end

figure(1);
%subplot(2,2,1);
plot(sigma, wynik); 
