
% for hot stream
% Z = ∆P/L 
% x = x_num / x_den
% input = di , m0 , meu_h , Dc , Dm , Pr_h , k_h , rho_h , S_vap , S ,
% Sliq , H_lp_out , H_lp_in , H_hp_in , H_vap , H_liq

T2 = 300;
P_high = input("Enter the value of High Pressure in bar : ");
isoth1 = readtable("krp_pressure.xlsx");
pressure = isoth1.Pressure;
rowIndex = find(pressure == P_high);
fprintf("%d\n",rowIndex);
H2 = isoth1{rowIndex,"Enthalpy"};
fprintf("The value of H2 is : %d\n",H2);

T1 = 295;
P_low = 1.2;
H1 = 151.49;
fprintf("The value of H1 is : %d\n",H1);

H_liq = 1.1548;
H_vap = 107.43;
T5 = 121.94;
H5 = H_vap;
fprintf("The value of H5 is : %d\n", H5);

delta_H_max = H1 - H5 ;
fprintf("The Value of ∆H max is : %d \n",delta_H_max) ;
H3 = H2 - delta_H_max ;
fprintf("The Value of H3 is : %d \n",H3) ;


% extract the filtrered rows and return the corresponding row number
data = readtable('Krypton.xlsx');

filteredIdx = find(data.Pressure == P_high);

if isempty(filteredIdx)
    disp('Pressure value not found');
else
    enthalpyValues = data.Enthalpy(filteredIdx);
    [~, rowNumber] = min(abs(enthalpyValues - H3));
    rowNumber = filteredIdx(rowNumber);
    
    fprintf('Nearest value found at row: %d\n', rowNumber);
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
fprintf("The Value of ∆H is : %d \n",delta_H) ;
m0 = Qr / (x * delta_H * 1000);
fprintf("The value of 'Mass flow rate (mͦ) ' in Kg/s is : %d\n",m0);


temperature = data.Temperature(filteredIdx);
[~, idx1] = min(abs(temperature - Th_mean));
idx1 = filteredIdx(idx1);

fprintf('Nearest value found at row: %d\n', idx1);

fprintf("row num is %d\n",idx1);

rho_h = data{idx1,"Density"};
fprintf("The value of 'Density at mean temperature ρ (h)' in Kg/m^3 : %d\n",rho_h);

Cp_h = data{idx1,"Cp"};
fprintf("The value of 'Cp of Hot Stream at mean temperature' in KJ/Kg-K : %d\n",Cp_h);

meu_h = 10^-6 * (data{idx1,"Viscosity"}); % converted to Pa-s
% meu_h = Pa-s
fprintf("The value of 'co-efficient of viscosity of hot stream at mean temperature μ (h)' in μPa-s : %d\n",meu_h * 10^6);% meu_h converted to uPa-s

k_h = 10^-3 * (data{idx1,"ThermCond"}); % converted to SI Unit
fprintf("The value of 'Thermal conductivity at mean  temperature k (h)' in mW/m-K : %d\n",k_h * 10^3); % converted to mW/m-k

Pr_h = (meu_h * Cp_h)/k_h ;

fprintf("The value of 'Prandtl Number at mean tempertaure Pr (h)' : %d\n",Pr_h) ;

di = 10^-3 * input("Enter the value of 'inner diameter of Bare fin tube (di)' in mm : ") ;

Dc = 10^-3 * input("Enter the value of 'Cooler diameter (Dc)' in mm  : ") ;
Dm = 10^-3 * input("Enter the value of 'Mandrel Diameter (Dm)' in mm  : ") ;

pi = 22/7 ;

% matlab
while true
    check = input("Did you enter any wrong value? (y/n): ", 's');
    if strcmpi(check, 'n')
        break;
    end
    fprintf("1:di, \n 2:Dc, \n 3:Dm, \n");
    choice = input("Enter the number of the variable you want to correct: ");
    switch choice
        case 1, di = 10^-3 * input("Enter the value of 'inner dia of Bare fin tube (di)' in mm : ");
        case 2, Dc = 10^-3 * input("Enter the value of 'Cooler diameter (Dc)' in mm  : ");
        case 3, Dm = 10^-3 * input("Enter the value of 'Mandrel Diameter (Dm)' in mm  : ");
    end
end
         
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

if Re_h < 2300  
    fprintf("The flow is Laminar.\n ");
    Nu_h = 3.66 ;
    fprintf("The value of Nu_h is : %d \n",Nu_h);
else
    fprintf("The flow is Turbulent.\n");
    Nu_h = (0.023)*(Re_h^0.8)*(Pr_h^0.4)*(1+(3.5*(De_h/Dh))) ;
    fprintf("The Value of Nu_h is : %d \n",Nu_h) ;
end

 
 h_h = (k_h * Nu_h)/De_h ;
fprintf("The Value of h_h is : %d \n",h_h) ;
a = -0.25 ;
f_h = 0.046 * (Re_h^a) ;
fprintf("The Value of f_h is : %d \n",f_h) ;
Z_h = (4 * f_h * (G_h^2)) / (2 * De_h * rho_h) ;

fprintf("The Value of ∆P/L is : %d \n",Z_h) ;
           
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

         
          
 n = 10^3 * input("Enter the value of 'Number of fins per mm '  in mm : ") ;
g_f = 10^-3 *input("Enter the value of 'Gap between two fins ' in mm  : ") ;
 d_of = 10^-3 *input("Enter the value of ' Outer diameter of finned tubes ' in mm  : ") ;
d_ofb = 10^-3 *input("Enter the value of 'Outer diameter of finned tube without fins'  in mm : ") ;
meu_c = 10^-6 * 18.121 ;
Cp_c = 0.25188 ;

 k_c = 10^-3 * 6.7592 ;
 rho_c = 5.8446 ;
 Pr_c = (meu_c * Cp_c) / k_c ;
 L_f = 10^-3 *input("Enter the value of 'L_f'  in mm : ") ;
 K_f = input("Enter the value of 'K_f' in W/mK : ") ;
tf = 10^-3 *input("Enter the value of 'tf'  in mm : ") ;
neta_oh = 1 ;
 C1 = 1.03 ;



while true
    check = input("Did you enter any wrong value? (y/n): ", 's');
    if strcmpi(check, 'n')
        break;
    end
    fprintf("1:n,\n 2:g_f,\n 3:d_of,\n 4:d_ofb,\n 5:L_f,\n 6:K_f, \n 7:tf \n");
    choice = input("Enter the number of the variable you want to correct: ");
    switch choice
        case 1, n = 10^-3 * input("Enter the value of 'Number of fins per mm '  in mm : ");
        case 2, g_f = 10^-3 * input("Enter the value of 'Gap between two fins ' in mm  : ");
        case 3, d_of = 10^-3 * input("Enter the value of ' Outer diameter of finned tubes ' in mm  : ");
        case 4, d_ofb = 10^-3 * input("Enter the value of 'Outer diameter of finned tube without fins'  in mm : ");
        case 5, L_f = 10^-3 * input("Enter the value of 'L_f'  in mm : ");
        case 6, K_f = input("Enter the value of 'K_f' in W/mK : ");
        case 7, tf = 10^-3 * input("Enter the value of 'tf'  in mm : ");
    end
end


pi = 22/7 ;
            
 Dh = (Dc + Dm) / 2 ;
fprintf("The Value of Dh is : %d \n",Dh) ;
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

if Re_c < 2300
    fprintf("The flow is Laminar.\n");
    Nu_c = 3.66 ;
    fprintf("The valuee of Nu_c is : %d\n",Nu_c);
    
else
    fprintf("The flow is Turbulent.\n")
    Nu_c = (0.118) * (Re_c^0.7) * (Pr_c^0.333) ;

    fprintf("The Value of Nu_c is : %d \n",Nu_c) ;
end
h_c = (k_c * Nu_c)/De_c ;
 fprintf("The Value of h_c is : %d \n",h_c) ;
f_c = 1.902 * (Re_c^-0.3) ;
fprintf("The Value of f_c is : %d \n",f_c) ;
Z_c = (4 * f_c * G_c^2 ) / ( 2 * De_c * rho_c ) ;
fprintf("The Value of Z_c is : %d \n",Z_c) ;
            
 A_f = ((pi/4)*(d_of^2 - d_ofb^2)*2 ) + (pi* d_of* tf);
fprintf("The Value of A_f is : %d \n",A_f) ;
V_f = (pi/4)* (d_of^2 - d_ofb^2)*tf;
fprintf("The Value of V_f is : %d \n",V_f) ;
 delta = V_f / A_f ;
fprintf("The Value of delta is : %d \n",delta) ;
b = h_c / (K_f * delta) ;
            
            
M = sqrt(b) ;
fprintf("The Value of M is : %d \n",M) ;
neta_f = ( tanh(M*L_f) ) / M*L_f ;
fprintf("The Value of neta_f is : %d \n",neta_f) ;
A_oc = A_w ;
fprintf("The Value of A_oc is : %d \n",A_oc) ;
% look for A_oh
A_oh = pi* di* pi* Dh ;
fprintf("The Value of A_oh is : %d \n",A_oh) ;
            
U1 = ( 1 /( neta_f * h_c) ) + ( (A_oc / A_oh) / (neta_oh * h_h) ) ;
 U = 1/U1 ;
 fprintf("The Value of U is : %d \n",U) ;
Cp_min = min(((1-x)*Cp_c),Cp_h);
Cp_max = max(((1-x)*Cp_c),Cp_h);
 r = Cp_min / Cp_max;
 fprintf("The Value of r is : %d \n",r) ;
 e = (T1 - T5) / (T2 - T5) ;
 fprintf("The Value of e is : %d \n",e) ;
 NTU = (1/ (1-r)) * log((1-(r*e)) / (1-e )) ;
fprintf("The Value of NTU is : %d \n",NTU) ;
C_min = min(Cp_c,Cp_h) ;
fprintf("The Value of C_min is : %d \n",C_min) ;
            
NTU_eff = C1 * NTU ;
fprintf("The Value of NTU_eff is : %d \n",NTU_eff) ;
A_req = ( m0 * NTU_eff * C_min) / U ;
N = A_req / A_w ;
 L = pi * Dh * N ;
 L1 = L + 12 ;
 fprintf("The Value of L' is : %d \n",L1) ;
fprintf("The Value of N is : %d \n",N) ;
fprintf("The Value of L is : %d \n",L) ;
fprintf("The Value of Area required is : %d \n",A_req) ;

temperature = data.Temperature(filteredIdx);
[~, idx2] = min(abs(temperature - T3));
idx2 = filteredIdx(idx2);

meu_h3 = 10^-6 * (data{idx2,"Viscosity"}); % converted to Pa-s
fprintf("The value of 'co-efficient of viscosity of hot stream at T3 μ (h)' in μPa-s : ");

Re_h3 = (De_h * G_h) / meu_h3 ;
fprintf("The Value of Re_h at T3 is : %d \n",Re_h3) ;

C_d = 0.9199 - (0.14256 * log(Re_h3)) + (0.016185 * (log(Re_h3))^2 ) ;
fprintf("The value of Discharge - Coefficient Cd is : %d\n",C_d ) ;

cp3 = data{idx2,"Cp"};
fprintf("The value of 'Cp of Hot Stream at T3 ' in KJ/Kg-K : %d\n",cp3);

cv3 = data{idx2,"Cv"};
fprintf("The value of 'Cp of Hot Stream at T3 ' in KJ/Kg-K : %d\n",cv3);

gamma = cp3 / cv3;
fprintf("The value of r at T3 is : %d\n",gamma);

R = 8.314 ;
P1 = 10^5 * P_high ;

pwr = (gamma + 1)/(gamma - 1);
r2 = ((gamma + 1)/ 2)^ pwr ;
r1 = gamma / (R * T3 * r2 );
c = sqrt(r1);
c2 = C_d * P1 * c ;
d2 = (m0 * 4)/(pi * c2) ;
d = sqrt(d2);
fprintf("The diameter of the orifice is : %d\n",d);