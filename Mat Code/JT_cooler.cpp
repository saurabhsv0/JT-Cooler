#include <iostream>
#include <cmath>
#include <string>
#include <algorithm>

using namespace std;

void coldStream() {
    double di, n, g_f, d_of, d_ofb, meu_c, Pr_c, k_c, rho_c, L_f, K_f, tf, neta_oh, C_c, C_h, T_co, T_ci, T_hi, T_ho, C1, Dc, Dm, m0;
    double x, h_h;

    cout << "--- Cold Stream Selected ---" << endl;
    cout << "Enter the value of 'di' : "; cin >> di;
    cout << "Enter the value of 'n' : "; cin >> n;
    cout << "Enter the value of 'g_f' : "; cin >> g_f;
    cout << "Enter the value of 'd_of' : "; cin >> d_of;
    cout << "Enter the value of 'd_ofb' : "; cin >> d_ofb;
    cout << "Enter the value of 'meu_c' : "; cin >> meu_c;
    cout << "Enter the value of 'Pr_c' : "; cin >> Pr_c;
    cout << "Enter the value of 'k_c' : "; cin >> k_c;
    cout << "Enter the value of 'rho_c' : "; cin >> rho_c;
    cout << "Enter the value of 'L_f' : "; cin >> L_f;
    cout << "Enter the value of 'K_f' : "; cin >> K_f;
    cout << "Enter the value of 'tf' : "; cin >> tf;
    cout << "Enter the value of 'neta_oh' : "; cin >> neta_oh;
    cout << "Enter the value of 'C_c' : "; cin >> C_c;
    cout << "Enter the value of 'C_h' : "; cin >> C_h;
    cout << "Enter the value of 'T_co' : "; cin >> T_co;
    cout << "Enter the value of 'T_ci' : "; cin >> T_ci;
    cout << "Enter the value of 'T_hi' : "; cin >> T_hi;
    cout << "Enter the value of 'T_ho' : "; cin >> T_ho;
    cout << "Enter the value of 'C1' : "; cin >> C1;
    cout << "Enter the value of 'Dc' : "; cin >> Dc;
    cout << "Enter the value of 'Dm' : "; cin >> Dm;
    cout << "Enter the value of 'm0' : "; cin >> m0;

    cout << "Enter the value of 'x' (vapor quality for cold stream) : "; cin >> x;
    cout << "Enter the value of 'h_h' (heat transfer coefficient of hot stream) : "; cin >> h_h;

    double pi = 22.0 / 7.0;

    double Dh = (Dc + Dm) / 2.0;
    cout << "The Value of Dh is : " << Dh << endl;
    
    double Nf = pi * Dh * n;
    cout << "The Value of Nf is : " << Nf << endl;
    
    double G_c = m0 / ((d_of - d_ofb) * g_f * Nf);
    cout << "The Value of G_c is : " << G_c << endl;
    
    double A_w = ((pi/4.0) * (pow(d_of, 2) - pow(d_ofb, 2)) * 2.0 + pi + d_ofb * g_f) * Nf;
    cout << "The Value of A_w is : " << A_w << endl;
    
    double V_fr = (pi/4.0) * (pow(d_of, 2) - pow(d_ofb, 2)) * g_f * Nf;
    cout << "The Value of V_fr is : " << V_fr << endl;
    
    double De_c = 4.0 * (V_fr / A_w);
    cout << "The Value of De_c is : " << De_c << endl;
    
    double Re_c = (De_c * G_c) / meu_c;
    cout << "The Value of Re_c is : " << Re_c << endl;
    
    double Nu_c = 0.118 * pow(Re_c, 0.7) * pow(Pr_c, 0.333);
    cout << "The Value of Nu_c is : " << Nu_c << endl;
    
    double h_c = (k_c * Nu_c) / De_c;
    cout << "The Value of h_c is : " << h_c << endl;
    
    double f_c = 1.902 * pow(Re_c, -0.3);
    cout << "The Value of f_c is : " << f_c << endl;
    
    double Z_c = (4.0 * f_c * pow(G_c, 2)) / (2.0 * De_c * rho_c);
    cout << "The Value of Z_c is : " << Z_c << endl;
    
    double A_f = (pi/4.0) * (pow(d_of, 2) - pow(d_ofb, 2)) * 2.0 + (pi * d_of * tf);
    cout << "The Value of A_f is : " << A_f << endl;
    
    double V_f = (pi/4.0) * (pow(d_of, 2) - pow(d_ofb, 2)) * tf;
    cout << "The Value of V_f is : " << V_f << endl;
    
    double delta = V_f / A_f;
    cout << "The Value of delta is : " << delta << endl;
    
    double b = h_c / (K_f * delta);
    
    double M = sqrt(b);
    cout << "The Value of M is : " << M << endl;
    
    // In original code: neta_f = (tanh(M*L_f)) / M*L_f ; -> usually tanh(M*L_f) / (M*L_f) Let's keep original math as much as possible but fixing precedence:
    double neta_f = tanh(M * L_f) / (M * L_f);
    cout << "The Value of neta_f is : " << neta_f << endl;
    
    double A_oc = A_w;
    cout << "The Value of A_oc is : " << A_oc << endl;
    
    double A_oh = pi * di * pi * Dh; // Original matlab: pi* di* pi* Dh
    cout << "The Value of A_oh is : " << A_oh << endl;
    
    double U1 = (1.0 / (neta_f * h_c)) + ((A_oc / A_oh) / (neta_oh * h_h));
    
    double U = 1.0 / U1;
    cout << "The Value of U is : " << U << endl;
    
    double r = C_c / (C_h * (1.0 - x));
    cout << "The Value of r is : " << r << endl;
    
    double e = (T_co - T_ci) / (T_hi - T_ci);
    cout << "The Value of e is : " << e << endl;
    
    double NTU = (1.0 / (1.0 - r)) * log((1.0 - (r * e)) / (1.0 - e));
    cout << "The Value of NTU is : " << NTU << endl;
    
    double C_min = min(C_c, C_h);
    cout << "The Value of C_min is : " << C_min << endl;
    
    double NTU_eff = C1 * NTU;
    cout << "The Value of NTU_eff is : " << NTU_eff << endl;
    
    double A_req = (m0 * NTU_eff * C_min) / U;
    double N = A_req / A_w;
    double L = pi * Dh * N;
    double L1 = L + 12.0;
    
    cout << "The Value of L' is : " << L1 << endl;
    cout << "The Value of N is : " << N << endl;
    cout << "The Value of L is : " << L << endl;
    cout << "The Value of Area required is : " << A_req << endl;
}

void hotStream() {
    double di, m0, meu_h, Dc, Dm, Pr_h, k_h, rho_h, S_vap, S, Sliq, H_lp_out, H_lp_in, H_hp_in, H_vap, H_liq;

    cout << "--- Hot Stream Selected ---" << endl;
    cout << "Enter the value of 'di' : "; cin >> di;
    cout << "Enter the value of 'm0' : "; cin >> m0;
    cout << "Enter the value of 'meu (h)' : "; cin >> meu_h;
    cout << "Enter the value of 'Dc' : "; cin >> Dc;
    cout << "Enter the value of 'Dm' : "; cin >> Dm;
    cout << "Enter the value of 'Pr (h)' : "; cin >> Pr_h;
    cout << "Enter the value of 'k (h)' : "; cin >> k_h;
    cout << "Enter the value of 'rho (h)' : "; cin >> rho_h;
    cout << "Enter the value of 'S (vap)' : "; cin >> S_vap;
    cout << "Enter the value of 'S' : "; cin >> S;
    cout << "Enter the value of 'S (liq)' : "; cin >> Sliq;
    cout << "Enter the value of ' H (lp,out)' : "; cin >> H_lp_out;
    cout << "Enter the value of ' H (lp,in)' : "; cin >> H_lp_in;
    cout << "Enter the value of ' H (hp,in)' : "; cin >> H_hp_in;
    cout << "Enter the value of ' H (vap)' : "; cin >> H_vap;
    cout << "Enter the value of ' H (liq)' : "; cin >> H_liq;

    double pi = 22.0 / 7.0;

    double delta_H_max = H_lp_out + H_lp_in;
    double H_hp_out = H_hp_in - delta_H_max; // Not used in output but kept as original
    double x_num = S_vap - S;
    double x_den = S_vap - Sliq;
    double x = x_num / x_den;
    double Q_r = m0 * x * delta_H_max; // Not used in output
    double delta_H = H_vap - H_liq; // Not used in output

    double Ah = (pi / 4.0) * pow(di, 2);
    double G_h = m0 / Ah;
    double Dh = (Dc + Dm) / 2.0;
    double De_h = di;

    double Re_h = (De_h * G_h) / meu_h;

    double Nu_h = 0.023 * pow(Re_h, 0.8) * pow(Pr_h, 0.4) * (1.0 + 3.5 * (De_h / Dh));
    double h_h = (k_h * Nu_h) / De_h;
    double a = -0.25;
    double f_h = 0.046 * pow(Re_h, a);
    double Z_h = (4.0 * f_h * pow(G_h, 2)) / (2.0 * De_h * rho_h);

    cout << "The Value of ∆P/L is : " << Z_h << endl;
}

int main() {
    cout << "JT Cooler Stream Selector" << endl;
    cout << "Select the stream type :" << endl;
    cout << "1. Cold Stream" << endl;
    cout << "2. Hot Stream" << endl;
    cout << "Enter choice (1 or 2): ";
    
    int choice;
    if (cin >> choice) {
        if (choice == 1) {
            coldStream();
        } else if (choice == 2) {
            hotStream();
        } else {
            cout << "Invalid choice." << endl;
        }
    }
    
    cout << "Press Enter to exit...";
    cin.ignore();
    cin.get();
    
    return 0;
}
