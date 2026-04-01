
% for hot stream
% Z = ∆P/L 
% x = x_num / x_den
% input = di , m0 , meu_h , Dc , Dm , Pr_h , k_h , rho_h , S_vap , S ,
% Sliq , H_lp_out , H_lp_in , H_hp_in , H_vap , H_liq

filename = ['output_' datestr(now,'yyyymmdd_HHMMSS') '.txt'];
diary(filename);

 m0 = input("Enter the value of 'Mass flow rate (mͦ) ' in Kg/s : ") ;
 di = 10^-3 * input("Enter the value of 'inner dia of Bare fin tube (di)' in mm : ") ;
 meu_h = 10^-6 * input("Enter the value of 'co-efficient of viscosity of hot stream at mean temperature μ (h)' in μPa-s : ") ;
 Dc = 10^-3 * input("Enter the value of 'Cooler diameter (Dc)' in mm  : ") ;
Dm = 10^-3 * input("Enter the value of 'Mandrel Diameter (Dm)' in mm  : ") ;
k_h = 10^-3 * input("Enter the value of 'Thermal conductivity at mean temperature k (h)' in mW/m-K : ") ;
rho_h = input("Enter the value of 'Density at mean temperature ρ (h)' in Kg/m^3 : ") ;
H1 = input("Enter the value of ' H1 ' in KJ/Kg : ");
H5 = input("Enter the value of ' H5 ' in KJ/Kg  : ");
H2 = input("Enter the value of ' H2 '  in KJ/Kg : ");
 C_h = input("Enter the value of 'C_h' in KJ/Kg-K : ") ;

H_liq = input("Enter the value of ' H (liq)'  in KJ/Kg : ");
pi = 22/7 ;

% matlab
while true
    check = input("Did you enter any wrong value? (y/n): ", 's');
    if strcmpi(check, 'n')
        break;
    end
    fprintf("1:m0, \n 2:di, \n 3:meu_h, \n 4:Dc, \n 5:Dm, \n 6:Pr_h, \n 7:k_h, \n 8:rho_h, \n 9:H1, \n 10:H5, \n 11:H2, \n 12:H_liq\n 13: C_h");
    fprintf("Enter the number of the variable you want to correct: ", 's');
    switch input('')
        case 1, m0 = input("Enter the value of 'Mass flow rate (mͦ) ' in Kg/s : ");
        case 2, di = 10^-3 * input("Enter the value of 'inner dia of Bare fin tube (di)' in mm : ");
        case 3, meu_h = 10^-6 * input("Enter the value of 'co-efficient of viscosity of hot stream at mean temperature μ (h)' in μPa-s : ");
        case 4, Dc = 10^-3 * input("Enter the value of 'Cooler diameter (Dc)' in mm  : ");
        case 5, Dm = 10^-3 * input("Enter the value of 'Mandrel Diameter (Dm)' in mm  : ");
        case 7, k_h = 10^-3 * input("Enter the value of 'Thermal conductivity at mean temperature k (h)' in mW/m-K : ");
        case 8, rho_h = input("Enter the value of 'Density at mean temperature ρ (h)' in Kg/m^3 : ");
        case 9, H1 = input("Enter the value of ' H1 ' in KJ/Kg : ");
        case 10, H5 = input("Enter the value of ' H5 ' in KJ/Kg  : ");
        case 11, H2 = input("Enter the value of ' H2'  in KJ/Kg : ");
        case 12, H_liq = input("Enter the value of ' H (liq)'  in KJ/Kg : ");
        case 13, C_h = input("Enter the value of 'C_h' in KJ/Kg-K : ") ;
    end
end
fprintf("\n");
H_vap = H5 ;
delta_H_max = H1 - H5 ;
fprintf("The Value of ∆H max is : %d \n",delta_H_max) ;
H3 = H2 - delta_H_max ;
fprintf("The Value of H3 is : %d \n",H3) ;
x_num = H_vap - H3 ;
x_den = H_vap - H_liq ;
x = x_num / x_den ;
fprintf("The Value of x is : %d \n",x) ;

delta_H = H_vap - H_liq ;
fprintf("The Value of ∆H is : %d \n",delta_H) ;
Q_r = m0 * x * delta_H_max ;
fprintf("The Value of Qr is : %d \n",Q_r) ;

            
            %  for the hot stream
 Pr_h = (meu_h * C_h)/k_h ;
 fprintf("The value of 'Prandtl Number at mean tempertaure Pr (h)' : %d\n",Pr_h) ;
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

fprintf("The Value of ∆P/L (Pressure drop per unit length) is : %d \n",Z_h) ;
           
input("press Enter to continue ......") 
fprintf("\n");
        
       
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
meu_c = 10^-6 *input("Enter the value of 'co-efficient of viscosity of cold stream at mean temperature μ (c)' in μPa-s : ") ;
 k_c = 10^-3 *input("Enter the value of 'Thermal conductivity at mean temperature k (c)' in mW/m-K: ") ;
 rho_c = input("Enter the value of 'Density at mean temperature ρ (c)' in Kg/m^3 : ") ;
 L_f = 10^-3 *input("Enter the value of 'L_f'  in mm : ") ;
 K_f = input("Enter the value of 'K_f' in W/mK : ") ;
tf = 10^-3 *input("Enter the value of 'tf'  in mm : ") ;
neta_oh = input("Enter the value of 'neta_oh' : ") ;
C_c = input("Enter the value of 'C_c' in KJ/Kg-K : ") ;
 
 T1 = input("Enter the value of 'T1 ' in K : ") ;
 T5 = input("Enter the value of 'T5 ' in K : ") ;
T2 = input("Enter the value of 'T2 ' in K : ") ;
 T3 = input("Enter the value of 'T3 ' in K : ") ;
 C1 = input("Enter the value of ' C' ' : ") ;



while true
    check = input("Did you enter any wrong value? (y/n): ", 's');
    if strcmpi(check, 'n')
        break;
    end
    fprintf("1:n, 2:g_f, 3:d_of, 4:d_ofb, 5:meu_c, 7:k_c, 8:rho_c, 9:L_f, 10:K_f, \n11:tf, 12:neta_oh, 13:C_c, 15:T1, 16:T5, 17:T2, 18:T3, 19:C1\n");
    choice = input("Enter the number of the variable you want to correct: ");
    switch choice
        case 1, n = 10^3 * input("Enter the value of 'Number of fins per mm '  in mm : ");
        case 2, g_f = 10^-3 * input("Enter the value of 'Gap between two fins ' in mm  : ");
        case 3, d_of = 10^-3 * input("Enter the value of ' Outer diameter of finned tubes ' in mm  : ");
        case 4, d_ofb = 10^-3 * input("Enter the value of 'Outer diameter of finned tube without fins'  in mm : ");
        case 5, meu_c = 10^-6 * input("Enter the value of 'co-efficient of viscosity of cold stream at mean temperature μ (c)' in μPa-s : ");
        case 7, k_c = 10^-3 * input("Enter the value of 'Thermal conductivity at mean temperature k (c)' in mW/m-K: ");
        case 8, rho_c = input("Enter the value of 'Density at mean temperature ρ (c)' in Kg/m^3 : ");
        case 9, L_f = 10^-3 * input("Enter the value of 'L_f'  in mm : ");
        case 10, K_f = input("Enter the value of 'K_f' in W/mK : ");
        case 11, tf = 10^-3 * input("Enter the value of 'tf'  in mm : ");
        case 12, neta_oh = input("Enter the value of 'neta_oh' : ");
        case 13, C_c = input("Enter the value of 'C_c' in KJ/Kg-K : ") ;
        case 15, T3 = input("Enter the value of 'T1' in K : ");
        case 16, T5 = input("Enter the value of 'T5' in K : ");
        case 17, T2 = input("Enter the value of 'T2' in K : ");
        case 18, T3 = input("Enter the value of 'T3' in K : ");
        case 19, C1 = input("Enter the value of ' C' ' : ");
    end
end
 
fprintf("\n");
pi = 22/7 ;

Pr_c = (meu_c * C_c)/k_c ;
 fprintf("The value of 'Prandtl Number at mean tempertaure Pr (c)' : %d\n",Pr_c) ;
 Dh = (Dc + Dm) / 2 ;
fprintf("The Value of Dh is : %d \n",Dh) ;
 Nf = pi * Dh * n  ;
 fprintf("The Value of Nf is : %d \n",Nf) ;
 G_c = m0 / ((d_of - d_ofb) * g_f * Nf ) ;
fprintf("The Value of G_c is : %d \n",G_c) ;
 A_w = (((pi/4) * (d_of^2 - d_ofb^2) * 2) + pi * d_ofb * g_f ) * Nf ;
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
fprintf("The Pressure drop per unit length ( ∆P/L ) is : %d \n",Z_c) ;
            
 A_f = (pi/4)* (d_of^2 - d_ofb^2)*2 + (pi* d_of* tf);
fprintf("The Value of A_f is : %d \n",A_f) ;
V_f = (pi/4)* (d_of^2 - d_ofb^2)*tf;
fprintf("The Value of V_f is : %d \n",V_f) ;
 delta = V_f / A_f ;
fprintf("The Value of delta is : %d \n",delta) ;
b = h_c / (K_f * delta) ;
            
            
M = sqrt(b) ;
fprintf("The Value of M is : %d \n",M) ;
neta_f = (tanh(M*L_f)) / M*L_f ;
fprintf("The Value of neta_f is : %d \n",neta_f) ;
A_oc = A_w ;
fprintf("The Value of A_oc is : %d \n",A_oc) ;
A_oh = pi* di* pi* Dh ;
fprintf("The Value of A_oh is : %d \n",A_oh) ;
            
U1 = ( 1 /( neta_f * h_c) ) + ( (A_oc / A_oh) / (neta_oh * h_h) ) ;
 U = 1/U1 ;
 fprintf("The Value of U is : %d \n",U) ;
Cp_min = min(((1-x)*C_c),C_h);
Cp_max = max(((1-x)*C_c),C_h);
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
 L1 = L + 12 ;
 fprintf("The Value of L' is : %d \n",L1) ;
fprintf("The Value of N is : %d \n",N) ;
fprintf("The Value of L is : %d \n",L) ;
fprintf("The Value of Area required is : %d \n",A_req) ;

fprintf("\n");

meu_h3 = input("Enter the value of 'co-efficient of viscosity of hot stream at T3 μ (h)' in μPa-s : ");

Re_h3 = (De_h * G_h) / meu_h3 ;
fprintf("The Value of Re_h at T3 is : %d \n",Re_h3) ;

C_d = 0.9199 - (0.14256 * log(Re_h3)) + (0.016185 * (log(Re_h3))^2 ) ;
fprintf("The value of Discharge - Coefficient Cd is : %d\n",C_d ) ;

cp3 = input("Enter Cp of Hot Stream at T3 : ");
cv3 = input("Enter Cv of Hot Stream at T3 : ");
gamma = cp3 / cv3;
fprintf("The value of r at T3 is : %d\n",gamma);

R = 8.314 ;
P1 = 10^5 * input("Enter the High Pressure in bar : ");

pwr = (gamma + 1)/(gamma - 1);
r2 = ((gamma + 1)/ 2)^ pwr ;
r1 = gamma / (R * T3 * r2 );
c = sqrt(r1);
c2 = C_d * P1 * c ;
d2 = (m0 * 4)/(pi * c2) ;
d = sqrt(d2);
fprintf("The diameter of the orifice in : %d\n",d);


diary off