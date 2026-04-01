function JT_Cooler_stream_selecter
    
    % Create UI Figure
    fig = uifigure('Position', [500 300 400 250], 'Name', 'JT Cooler Stream Selector');
    
    % Create Label
    lbl = uilabel(fig);
    lbl.Position = [50 150 300 30];
    lbl.Text = 'Select the stream type :';
    
    % Create Dropdown
    dd = uidropdown(fig);
    dd.Position = [50 120 200 30];
    dd.Items = {'Select a value','Cold Stream', 'Hot Stream'};
    
    % Callback function
    dd.ValueChangedFcn = @(dd,event) selectionChanged(dd, lbl);
end


function selectionChanged(dd,~)

    switch dd.Value

        
        case 'Cold Stream'
            % for Cold stream 
            
            
            % Z = ∆P/L
            % p = ρ

            
            % U1 = 1/U
            % e = ε
            % r = gamma
            % input = n , g_f ,d_of , d_ofb , meu_c , Pr_c , k_c , rho_c , L_f , K_f
            % ,tf , neta_oh , C_c , C_h , T_co , T_ci , T_hi , T_ho , C1
            % ,Dc ,h_h
            di = input("Enter the value of 'di' : ") ;
            n = input("Enter the value of 'n' : ") ;
            g_f = input("Enter the value of 'g_f' : ") ;
            d_of = input("Enter the value of 'd_of' : ") ;
            d_ofb = input("Enter the value of 'd_ofb' : ") ;
            meu_c = input("Enter the value of 'meu_c' : ") ;
            Pr_c = input("Enter the value of 'Pr_c' : ") ;
            k_c = input("Enter the value of 'k_c' : ") ;
            rho_c = input("Enter the value of 'rho_c' : ") ;
            L_f = input("Enter the value of 'L_f' : ") ;
            K_f = input("Enter the value of 'K_f' : ") ;
            tf = input("Enter the value of 'tf' : ") ;
            neta_oh = input("Enter the value of 'neta_oh' : ") ;
            C_c = input("Enter the value of 'C_c' : ") ;
            C_h = input("Enter the value of 'C_h' : ") ;
            T_co = input("Enter the value of 'T_co' : ") ;
            T_ci = input("Enter the value of 'T_ci' : ") ;
            T_hi = input("Enter the value of 'T_hi' : ") ;
            T_ho = input("Enter the value of 'T_ho' : ") ;
            C1 = input("Enter the value of 'C1' : ") ;
            Dc = input("Enter the value of 'Dc' : ") ;
            Dm = input("Enter the value of 'Dm' : ") ;
            m0 = input("Enter the value of 'm0' : ") ;

            pi = 22/7 ;
            
            Dh = (Dc + Dm) / 2 ;
            fprintf("The Value of Dh is : %d \n",Dh) ;
            Nf = pi * Dh * n  ;
            fprintf("The Value of Nf is : %d \n",Nf) ;
            G_c = m0 / ((d_of - d_ofb) * g_f * Nf ) ;
            fprintf("The Value of G_c is : %d \n",G_c) ;
            A_w = ((pi/4) * (d_of^2 - d_ofb^2) * 2 + pi + d_ofb * g_f ) * Nf ;
            fprintf("The Value of A_w is : %d \n",A_w) ;
            V_fr = (pi/4) * (d_of^2 - d_ofb^2) * g_f * Nf ;
            fprintf("The Value of V_fr is : %d \n",V_fr) ;
            De_c = 4 * (V_fr / A_w) ;
            fprintf("The Value of De_c is : %d \n",De_c) ;
            Re_c = (De_c * G_c) / meu_c ;
            fprintf("The Value of Re_c is : %d \n",Re_c) ;
            
            Nu_c = (0.118) * (Re_c^0.7) * (Pr_c^0.333) ;
            fprintf("The Value of Nu_c is : %d \n",Nu_c) ;
            h_c = (k_c * Nu_c)/De_c ;
            fprintf("The Value of h_c is : %d \n",h_c) ;
            f_c = 1.902 * (Re_c^-0.3) ;
            fprintf("The Value of f_c is : %d \n",f_c) ;
            Z_c = (4 * f_c * G_c^2 ) / ( 2 * De_c * rho_c ) ;
            fprintf("The Value of Z_c is : %d \n",Z_c) ;
            
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
            r = C_c / (C_h * (1-x )) ;
            fprintf("The Value of r is : %d \n",r) ;
            e = (T_co - T_ci) / (T_hi - T_ci) ;
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



        case 'Hot Stream'
            
            % for hot stream

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
           
                    
    end

end

JT_Cooler_stream_selecter