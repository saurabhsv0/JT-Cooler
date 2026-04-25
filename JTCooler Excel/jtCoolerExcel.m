 
% for hot stream
% Z = ∆P/L 
% x = x_num / x_den
% input = di , m0 , meu_h , Dc , Dm , Pr_h , k_h , rho_h , S_vap , S ,
% Sliq , H_lp_out , H_lp_in , H_hp_in , H_vap , H_liq


fprintf("1:Argon, \n 2:Krypton, \n 3:Nitrogen, \n 4:Oxygen,\n 5:Xenon \n");
choice = input("Please select the gas: ");
switch choice
    case 1, gas = "Argon" ; isoth1 = readtable("argon_pressure.xlsx");
    case 2, gas = "Krypton" ;  isoth1 = readtable("krp_pressure.xlsx");
    case 3, gas = "Nitrogen" ; isoth1 = readtable("n2_pressure.xlsx");
    case 4, gas = "Oxygen" ; isoth1 = readtable("o2_pressure.xlsx");
    case 5,  gas = "Xenon" ; isoth1 = readtable("xenon_pressure.xlsx");
end


T2 = 300; % K
P_high = input("Enter the value of High Pressure in bar : ");
pressure = isoth1.Pressure;
rowIndex = find(pressure == P_high);
fprintf("%d\n",rowIndex);
H2 = isoth1{rowIndex,"Enthalpy"};
fprintf("The value of H2 in KJ/Kg : %d\n",H2);

if gas == "Argon"
    H1 = 153.23 ;
    H5 = 44.205 ;
    H_liq = -115.68 ;
    T5 = 88.936 ;
    R = 208.13 ;
    meu_c = 10^-6 * 15.42 ;
    C_c = 0.52477 * 10^3 ;
    k_c = 10^-3 * 12.091 ;
    rho_c = 3.0153 ;
    data = readtable('Argon.xlsx');

elseif gas == "Krypton"
    H1 = 151.49 ;
    H5 = 107.43 ;
    H_liq = 1.1548 ;
    T5 = 121.94 ;
    R = 99.2 ;
    meu_c = 10^-6 * 18.121 ;
    C_c = 0.25188 * 10^3;
    k_c = 10^-3 * 6.7592 ;
    rho_c = 5.8446 ;
    data = readtable('Krypton.xlsx');

elseif gas == "Nitrogen"
    H1 = 305.94 ;
    H5 = 78.25 ;
    H_liq = -119.01 ;
    T5 = 78.9 ;
    R = 296.8 ;
    meu_c = 10^-6 * 12.246 ;
    C_c = 10^3 * 1.0453 ;
    k_c = 10^-3 * 17.678 ;
    rho_c = 2.1634 ;
    data = readtable('Nitrogen.xlsx');

elseif gas == "Oxygen"
    H1 = 268.07 ;
    H5 = 80.872 ;
    H_liq = -130.55 ;
    T5 = 91.837 ;
    R = 259.84 ;
    meu_c = 10^-6 * 14.299 ;
    C_c = 0.91583 * 10^3 ;
    k_c = 10^-3 * 17.680 ;
    rho_c = 2.3973 ;
    data = readtable('Oxygen.xlsx');

elseif gas == "Xenon"
    H1 = 116.84 ;
    H5 = 95.918 ;
    H_liq = 1.0245 ;
    T5 = 168.06 ;
    R = 63.33 ;
    meu_c = 10^-6 * 17.888 ;
    C_c = 0.16326 * 10^3 ;
    k_c = 10^-3 * 4.265 ;
    rho_c = 8.2937 ;
    data = readtable('Xenon.xlsx');
end


T1 = 295;

P_low = 1.2;



H_vap = H5;

delta_H_max = H1 - H5 ;

H3 = H2 - delta_H_max ;



% extract the filtrered rows and return the corresponding row number

filteredIdx = find(data.Pressure == P_high);

if isempty(filteredIdx)
    disp('Pressure value not found');
else
    enthalpyValues = data.Enthalpy(filteredIdx);
    [~, rowNumber] = min(abs(enthalpyValues - H3));
    rowNumber = filteredIdx(rowNumber);

end

T3 = data{rowNumber,"Temperature"};
fprintf("T3 is : %d\n",T3);
Th_mean = (T2 + T3)/2 ;
fprintf("Hot Stream mean temperature : %d\n", Th_mean);
Tc_mean = (T1 + T5)/2 ;
fprintf("Cold Stream mean temperature : %d\n",Tc_mean);
x_num = H_vap - H3 ;
x_den = H_vap - H_liq ;
x = x_num / x_den ;
fprintf("The value of x is : %d\n",x);
Qr = 2.5;
delta_H = H_vap - H_liq ;
fprintf("The Value of ∆H in KJ/Kg : %d \n",delta_H) ;
m0 = Qr / (x * delta_H * 1000);
fprintf("The value of 'Mass flow rate (mͦ) ' in Kg/s is : %d\n",m0);


temperature = data.Temperature(filteredIdx);
[~, idx1] = min(abs(temperature - Th_mean));
idx1 = filteredIdx(idx1);


rho_h = data{idx1,"Density"};
fprintf("The value of 'Density at mean temperature ρ (h)' in Kg/m^3 : %d\n",rho_h);

 C_h = 10^3 * data{idx1,"Cp"}; % J/Kg-K
fprintf("The value of 'Cp of Hot Stream at mean temperature' in KJ/Kg-K : %d\n",C_h * 10^-3);

meu_h = 10^-6 * (data{idx1,"Viscosity"}); % converted to Pa-s
% meu_h = Pa-s
fprintf("The value of 'co-efficient of viscosity of hot stream at mean temperature μ (h)' in μPa-s : %d\n",meu_h * 10^6);% meu_h converted to uPa-s

k_h = (data{idx1,"ThermCond"}); % converted to SI Unit
fprintf("The value of 'Thermal conductivity at mean  temperature k (h)' in mW/m-K : %d\n",k_h * 10^3); % converted to mW/m-k

Pr_h = (meu_h * C_h)/k_h ;

fprintf("The value of 'Prandtl Number at mean tempertaure Pr (h)' : %d\n",Pr_h) ;

di = 0.303 * 10^-3 ;

fprintf("1:Dc = 10.3mm , Dm = 8.16mm \n 2:Dc = 11.2mm , Dm = 9.06mm\n");
choice = input("Enter the number of the variable you want to correct: ");
switch choice
    case 1, Dc = 10^-3 * 10.3 ; Dm = 10^-3 * 8.16 ;
    case 2, Dc = 10^-3 * 11.2 ; Dm = 10^-3 * 9.06 ;
end

% matlab
   
            %  for the hot stream

            
Ah = (pi/4)* (di^2) ;
fprintf("The Value of Ah is : %d \n",Ah) ;
G_h = m0 / Ah ;
fprintf("The Value of Gh is : %d \n",G_h) ;

De_h = di ;
Dh = (Dc + Dm)/2 ;
fprintf("The Value of Dh is : %d \n",Dh) ;            
Re_h = (De_h * G_h) / meu_h ;
fprintf("The Value of Re_h is : %d \n",Re_h) ;

%if Re_h < 2300  
 %   fprintf("The flow is Laminar.\n ");
  %  Nu_h = 3.66 ;
   % fprintf("The value of Nu_h is : %d \n",Nu_h);
%else
 %   fprintf("The flow is Turbulent.\n");
  %  Nu_h = (0.023)*(Re_h^0.8)*(Pr_h^0.4)*(1+(3.5*(De_h/Dh))) ;
   % fprintf("The Value of Nu_h is : %d \n",Nu_h) ;
%end
Nu_h = (0.023)*(Re_h^0.8)*(Pr_h^0.4)*(1+(3.5*(De_h/Dh))) ;
fprintf("The Value of Nu_h is : %d \n",Nu_h) ;
 
 h_h = (k_h * Nu_h)/De_h ;
fprintf("The Value of h_h is : %d \n",h_h) ;
a = -0.25 ;
f_h = 0.046 * (Re_h^a) ;
fprintf("The Value of f_h is : %d \n",f_h) ;
Z_h = (4 * f_h * (G_h^2)) / (2 * De_h * rho_h) ;

fprintf("The Value of ∆P/L (Pressure drop per unit length) in bar/m : %d \n",Z_h * 10^-5) ;
           
input("press Enter to continue ......")                    
        
       
            % for Cold stream 
            
            
            % Z = ∆P/L
            % p = ρ
            % U1 = 1/U
            % e = ε
            % r = gamma
            % input = n , g_f ,d_of , d_ofb , meu_c , Pr_c , k_c , rho_c , L_f , K_f
            % ,tf , neta_oh , C_c , C_h , T_co , T_ci , T_hi , T_ho , C1
            % ,Dc ,h_h

         
          
 n = 10^3 * 4.13 ;
g_f = 10^-3 * 0.167 ;
 d_of = 10^-3 * 1.07 ;
d_ofb = 10^-3 * 0.46 ;

 Pr_c = (meu_c * C_c) / k_c ;
fprintf("The Value of Pr_c is : %d \n",Pr_c) ; 
 L_f = 10^-3 * 0.305 ;
 K_f = 400 ;
tf = 10^-3 * 0.075 ;
neta_oh = 1 ;
 C1 = 1.03 ;

  
 Nf = pi * Dh * n  ;
 fprintf("The Value of Nf is : %d \n",Nf) ;
 G_c = m0 / ((d_of - d_ofb) * g_f * Nf ) ;
fprintf("The Value of G_c is : %d \n",G_c) ;
 A_w = (((pi/4) * (d_of^2 - d_ofb^2) * 2) + (pi * d_ofb * g_f )) * Nf ;
fprintf("The Value of A_w is : %d \n",A_w) ;
V_fr = (pi/4) * (d_of^2 - d_ofb^2) * g_f * Nf ;
 fprintf("The Value of V_fr is : %d \n",V_fr) ;
De_c = 4 * (V_fr / A_w) ;
 fprintf("The Value of De_c is : %d \n",De_c) ;
 Re_c = (De_c * G_c) / meu_c ;
 fprintf("The Value of Re_c is : %d \n",Re_c) ;

%if Re_c < 2300
 %   fprintf("The flow is Laminar.\n");
  %  Nu_c = 3.66 ;
   % fprintf("The valuee of Nu_c is : %d\n",Nu_c);
    
%else
 %   fprintf("The flow is Turbulent.\n")
  %  Nu_c = (0.118) * (Re_c^0.7) * (Pr_c^0.333) ;
%
 %   fprintf("The Value of Nu_c is : %d \n",Nu_c) ;
%end
 Nu_c = (0.118) * (Re_c^0.7) * (Pr_c^0.333) ;
fprintf("The Value of Nu_c is : %d \n",Nu_c) ;

h_c = (k_c * Nu_c)/De_c ;
 fprintf("The Value of h_c is : %d \n",h_c) ;
f_c = 1.902 * (Re_c^-0.3) ;
fprintf("The Value of f_c is : %d \n",f_c) ;
Z_c = (4 * f_c * G_c^2 ) / ( 2 * De_c * rho_c ) ;
fprintf("The Pressure drop per unit length ( ∆P/L ) in bar/m : %d \n",Z_c * 10^-5) ;
            
 A_f = ((pi/4)*(d_of^2 - d_ofb^2)*2 ) + (pi* d_of* tf);
fprintf("The Value of A_f is : %d \n",A_f) ;
V_f = (pi/4)* (d_of^2 - d_ofb^2)*tf;
fprintf("The Value of V_f is : %d \n",V_f) ;
 delta = V_f / A_f ;
fprintf("The Value of delta is : %d \n",delta) ;
b = h_c / (K_f * delta) ;
            
            
M = sqrt(b) ;
fprintf("The Value of M is : %d \n",M) ;
i = M * L_f ;
neta_f = (tanh(i)) / (i) ;
fprintf("The Value of neta_f is : %d \n",neta_f) ;
A_oc = A_w ;
fprintf("The Value of A_oc in mm^2 : %d \n",A_oc * 10^6) ;
A_oh = pi* di* pi* Dh ;
fprintf("The Value of A_oh in mm^2 : %d \n",A_oh * 10^6) ;
            
U1 = ( 1 /( neta_f * h_c) ) + ( (A_oc / A_oh) / (neta_oh * h_h) ) ;
fprintf("The value of 1/U is : %d\n",U1); 
 U = 1/U1 ;
 fprintf("The Value of U in W/m^2-K : %d \n",U) ;
Cp_min = min((C_c),(1-x)*C_h);
Cp_max = max((C_c),(1-x)*C_h);
 r = Cp_min / Cp_max;
 fprintf("The Value of r is : %d \n",r) ;
 e = (T1 - T5) / (T2 - T5) ;
 fprintf("The Value of e is : %d \n",e) ;
 NTU = (1/ (1-r)) * log((1-(r*e)) / (1-e )) ;
fprintf("The Value of NTU is : %d \n",NTU) ;
C_min = min(C_c,C_h) ;
fprintf("The Value of C_min is : %d \n",C_min) ;
            
NTU_eff = C1 * NTU ;
fprintf("The Value of NTU_eff is : %d \n",NTU_eff) ;
A_req = ( m0 * NTU_eff * C_min) / U ;
N = A_req / A_w ;
 L = pi * Dh * N ;
 L1 = L + 0.012 ;
fprintf("The Value of Area required in m^2 : %d \n",A_req) ;
fprintf("The Value of N is : %d \n",N) ;
fprintf("The Value of L in mm : %d \n",L * 10^3) ;
fprintf("The Value of L' in mm : %d \n",L1 * 10^3) ;


temperature = data.Temperature(filteredIdx);
[~, idx2] = min(abs(temperature - T3));
idx2 = filteredIdx(idx2);

meu_h3 = 10^-6 * (data{idx2,"Viscosity"}); % converted to Pa-s
fprintf("The value of 'co-efficient of viscosity of hot stream at T3 μ (h)' in μPa-s : %d\n",meu_h3 * 10^6);

Re_h3 = (De_h * G_h) / meu_h3 ;
fprintf("The Value of Reynolds Number at T3 is : %d \n",Re_h3) ;
j = log10(Re_h3);
j2 = j^2;
j3 = 0.016185 * j2 ;
j4 = 0.14256 * j ;
C_d = (0.9199) - (j4) + (j3 ) ;
fprintf("The value of Discharge - Coefficient Cd is : %d\n",C_d ) ;

cp3 = 10^3 * data{idx2,"Cp"};
fprintf("The value of 'Cp of Hot Stream at T3 ' in KJ/Kg-K : %d\n",cp3 * 10^-3);

cv3 = 10^3 * data{idx2,"Cv"};
fprintf("The value of 'Cp of Hot Stream at T3 ' in KJ/Kg-K : %d\n",cv3 * 10^-3);

gamma = cp3 / cv3;
fprintf("The value of r at T3 is : %d\n",gamma);

P1 = 10^5 * P_high ;

pwr = (gamma + 1)/(gamma - 1);
r2 = ((gamma + 1)/ 2)^ pwr ;
r1 = gamma / (R * T3 * r2 );
c = sqrt(r1);
c2 = C_d * P1 * c ;
d2 = (m0 * 4)/(pi * c2) ;
d = sqrt(d2);
fprintf("The diameter of the orifice is : %d\n",d);

newRow = table(m0,P_high, Z_h, Z_c,N, L1 , d ,'VariableNames', {'m0','Pressure', 'P_Drop_Hot','P_Drop_Cold', 'Turns','L','Diameter'});

filename = 'output.xlsx';

% Check if file exists
if isfile(filename)
    % Read existing data
    oldData = readtable(filename);
    
    % Append new row
    updatedData = [oldData;  newRow];
else
    % First time create file
    updatedData = newRow;
end

% Write back to Excel
writetable(updatedData, filename);