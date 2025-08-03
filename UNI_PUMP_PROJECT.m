clc,clear
close all

%data_32_125
data_32_125= xlsread('Family_32_125.xlsx');
x_32_125 = data_32_125(:,1);
y_32_125 = data_32_125(:,2);

%data_32_160
data_32_160 = xlsread('Family_32_160.xlsx');
x_32_160 = data_32_160(:,1);
y_32_160 = data_32_160(:,2);

%data_40_125
data_40_125= xlsread('Family_40_125.xlsx');
x_40_125 = data_40_125(:,1);
y_40_125 = data_40_125(:,2);

%data_40_160
data_40_160 = xlsread('Family_40_160.xlsx');
x_40_160 = data_40_160(:,1);
y_40_160 = data_40_160(:,2);

%data_40_200
data_40_200 = xlsread('Family_40_200.xlsx');
x_40_200 = data_40_200(:,1);
y_40_200 = data_40_200(:,2);

%data_50_125
data_50_125 = xlsread('Family_50_125.xlsx');
x_50_125 = data_50_125(:,1);
y_50_125 = data_50_125(:,2);

%data_50_160
data_50_160 = xlsread('Family_50_160.xlsx');
x_50_160 = data_50_160(:,1);
y_50_160 = data_50_160(:,2);

%data_50_200
data_50_200 = xlsread('Family_50_200.xlsx');
x_50_200 = data_50_200(:,1);
y_50_200 = data_50_200(:,2);

%Enter flow rate(Q)
Q = input('Please enter the flow rate(Q) (m^3/h) :\n');
%Enter head pump(h)
h = input('Please enter the pump head(h) (m) :\n');

if inpolygon(Q,h,x_32_125,y_32_125)
disp(' Recommended pump is : 32_125')
family = 'Family_32_125.xlsx';
elseif inpolygon(Q,h,x_32_160,y_32_160)
disp(' Recommended pump is : 32_160 ')
family = 'Family_32_160.xlsx';
elseif inpolygon(Q,h,x_40_125,y_40_125)
disp(' Recommended pump is : 40_125 ')
family = 'Family_40_125.xlsx';
elseif inpolygon(Q,h,x_40_160,y_40_160)
family = 'Family_40_160.xlsx';
disp(' Recommended pump is : 40_160 ')
elseif inpolygon(Q,h,x_40_200,y_40_200)
family = 'Family_40_200.xlsx';
disp(' Recommended pump is : 40_200 ')
elseif inpolygon(Q,h,x_50_125,y_50_125)
disp(' Recommended pump is : 50_125 ')
family = 'Family_50_125.xlsx';
elseif inpolygon(Q,h,x_50_160,y_50_160)
disp(' Recommended pump is : 50_160 ')
family = 'Family_50_160.xlsx';
elseif inpolygon(Q,h,x_50_200,y_50_200)
disp(' Recommended pump is : 50_200 ')
family = 'Family_50_200.xlsx';
end
%Diameter
i = 1; j = 1; ff = 0;
data_qotr = xlsread(family,'Diameter');
while data_qotr(i,1)<=Q
       xmin = data_qotr(i+1,1);
       i = i+1;
end
j=i;
while ff == 0
    if data_qotr(j,1)>=xmin && data_qotr(j,2)>=h
       fprintf(' Diameter : %d \n',data_qotr(j,3))
        ff=1;
        end
    j=j+1;
end
qotr_nahaei = data_qotr(j,3);

%Efficiency
bazdeh_data = xlsread(family,'Efficiency');
Q_bazdeh = bazdeh_data(:,1);
h_bazdeh = bazdeh_data(:,2);
bazdeh = bazdeh_data(:,3);
f = scatteredInterpolant(Q_bazdeh,h_bazdeh,bazdeh,'natural','none');

eff = f(Q,h);
if isnan(eff)
    fprintf(' kharej az mahdoode ast.\n')
else
    fprintf(' Efficiency : %.3f \n',eff)
end

%Power
data_tavan = xlsread(family,'Power');
Q_tavan = data_tavan(:,1);
p_tavan = data_tavan(:,2);
qotr_tavan = data_tavan(:,3);
idx = qotr_tavan == qotr_nahaei;
Q_i = Q_tavan(idx);
P_i = p_tavan(idx);
pp = polyfit(Q_i,P_i,3);
hh = polyval(pp,Q);
fprintf(' Recommended Power = %.3f (kw) \n',hh)
