% Z = ∆P/L 
% x = x_num / x_den
% input = di , m0 , meu_h , Dc , Dm , Pr_h , k_h , rho_h , S_vap , S ,
% Sliq , H_lp_out , H_lp_in , H_hp_in , H_vap , H_liq

di = input("Enter the value of 'di' : ") ;
m0 = input("Enter the value of 'm0' : ") ;
meu_h = input("Enter the value of 'meu (h)' : ") ;
Dc = input("Enter the value of 'Dc' : ") ;
Dm = input("Enter the value of 'Dm' : ") ;
Pr_h = input("Enter the value of 'Pr (h)' : ") ;
k_h = input("Enter the value of 'k (h)' : ") ;
rho_h = input("Enter the value of 'rho (h)' : ") ;
S_vap = input("Enter the value of 'S (vap)' : ") ;
S = input("Enter the value of 'S' : ") ;
Sliq = input("Enter the value of 'S (liq)' : ") ;
H_lp_out = input("Enter the value of ' H (lp,out)' : ");
H_lp_in = input("Enter the value of ' H (lp,in)' : ");
H_hp_in = input("Enter the value of ' H (hp,in)' : ");
H_vap = input("Enter the value of ' H (vap)' : ");
H_liq = input("Enter the value of ' H (liq)' : ");
pi = 22/7 ;


delta_H_max = H_lp_out + H_lp_in ;
H_hp_out = H_hp_in - delta_H_max ;
x_num = S_vap - S ;
x_den = S_vap - Sliq ;
x = x_num / x_den ;
Q_r = m0 * x * delta_H_max ;
delta_H = H_vap - H_liq ;

%  for the hot stream

Ah = (pi/4)* (di^2) ;
G_h = m0 / Ah ;
Dh = (Dc + Dm)/2 ;
De_h = di ;

Re_h = (De_h * G_h) / meu_h ;


Nu_h = (0.023)*(Re_h^0.8)*(Pr_h^0.4)*(1+3.5*(De_h/Dh)) ;
h_h = (k_h * Nu_h)/De_h ;
a = -0.25 ;
f_h = 0.046 * (Re_h^a) ;
Z_h = (4 * f_h * (G_h^2)) / (2 * De_h * rho_h) ;

fprintf("The Value of ∆P/L is : %d \n",Z_h) ;