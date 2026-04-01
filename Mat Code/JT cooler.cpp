// JT_cooler.cpp
#include <cmath>
#include <iomanip>
#include <iostream>
#include <limits>
#include <string>

using namespace std;

double ask(const string& name) {
    cout << "Enter the value of '" << name << "': ";
    double v;
    cin >> v;
    return v;
}

int main() {
    cout << "Select stream type:\n";
    cout << "1. Cold Stream\n";
    cout << "2. Hot Stream\n";
    cout << "Choice: ";

    int choice;
    cin >> choice;

    const double pi = 22.0 / 7.0;
    cout << fixed << setprecision(6);

    if (choice == 1) {
        // Cold stream inputs (from MATLAB code + missing vars used there)
        double di = ask("di");
        double n = ask("n");
        double g_f = ask("g_f");
        double d_of = ask("d_of");
        double d_ofb = ask("d_ofb");
        double meu_c = ask("meu_c");
        double Pr_c = ask("Pr_c");
        double k_c = ask("k_c");
        double rho_c = ask("rho_c");
        double L_f = ask("L_f");
        double K_f = ask("K_f");
        double tf = ask("tf");
        double neta_oh = ask("neta_oh");
        double C_c = ask("C_c");
        double C_h = ask("C_h");
        double T_co = ask("T_co");
        double T_ci = ask("T_ci");
        double T_hi = ask("T_hi");
        double T_ho = ask("T_ho");
        double C1 = ask("C1");
        double Dc = ask("Dc");
        double Dm = ask("Dm");
        double m0 = ask("m0");

        // Needed in MATLAB formula but undefined there:
        double x = ask("x (quality, from hot stream)");
        double h_h = ask("h_h (hot-side heat transfer coefficient)");

        double Dh = (Dc + Dm) / 2.0;
        double Nf = pi * Dh * n;
        double G_c = m0 / ((d_of - d_ofb) * g_f * Nf);
        double A_w = (((pi / 4.0) * (d_of * d_of - d_ofb * d_ofb) * 2.0) + pi + d_ofb * g_f) * Nf;
        double V_fr = (pi / 4.0) * (d_of * d_of - d_ofb * d_ofb) * g_f * Nf;
        double De_c = 4.0 * (V_fr / A_w);
        double Re_c = (De_c * G_c) / meu_c;
        double Nu_c = 0.118 * pow(Re_c, 0.7) * pow(Pr_c, 0.333);
        double h_c = (k_c * Nu_c) / De_c;
        double f_c = 1.902 * pow(Re_c, -0.3);
        double Z_c = (4.0 * f_c * G_c * G_c) / (2.0 * De_c * rho_c);

        double A_f = (pi / 4.0) * (d_of * d_of - d_ofb * d_ofb) * 2.0 + (pi * d_of * tf);
        double V_f = (pi / 4.0) * (d_of * d_of - d_ofb * d_ofb) * tf;
        double delta = V_f / A_f;
        double b = h_c / (K_f * delta);
        double M = sqrt(b);

        // Preserving MATLAB precedence exactly: (tanh(M*L_f)/M)*L_f
        double neta_f = (tanh(M * L_f) / M) * L_f;

        double A_oc = A_w;
        double A_oh = pi * di * pi * Dh;
        double U1 = (1.0 / (neta_f * h_c)) + ((A_oc / A_oh) / (neta_oh * h_h));
        double U = 1.0 / U1;

        double r = C_c / (C_h * (1.0 - x));
        double e = (T_co - T_ci) / (T_hi - T_ci);
        double NTU = (1.0 / (1.0 - r)) * log((1.0 - (r * e)) / (1.0 - e));
        double C_min = min(C_c, C_h);
        double NTU_eff = C1 * NTU;
        double A_req = (m0 * NTU_eff * C_min) / U;
        double N = A_req / A_w;
        double L = pi * Dh * N;
        double L1 = L + 12.0;

        cout << "Dh = " << Dh << "\n";
        cout << "Nf = " << Nf << "\n";
        cout << "G_c = " << G_c << "\n";
        cout << "A_w = " << A_w << "\n";
        cout << "V_fr = " << V_fr << "\n";
        cout << "De_c = " << De_c << "\n";
        cout << "Re_c = " << Re_c << "\n";
        cout << "Nu_c = " << Nu_c << "\n";
        cout << "h_c = " << h_c << "\n";
        cout << "f_c = " << f_c << "\n";
        cout << "Z_c = " << Z_c << "\n";
        cout << "A_f = " << A_f << "\n";
        cout << "V_f = " << V_f << "\n";
        cout << "delta = " << delta << "\n";
        cout << "M = " << M << "\n";
        cout << "neta_f = " << neta_f << "\n";
        cout << "A_oc = " << A_oc << "\n";
        cout << "A_oh = " << A_oh << "\n";
        cout << "U = " << U << "\n";
        cout << "r = " << r << "\n";
        cout << "e = " << e << "\n";
        cout << "NTU = " << NTU << "\n";
        cout << "C_min = " << C_min << "\n";
        cout << "NTU_eff = " << NTU_eff << "\n";
        cout << "Area required = " << A_req << "\n";
        cout << "N = " << N << "\n";
        cout << "L = " << L << "\n";
        cout << "L' = " << L1 << "\n";
    } else if (choice == 2) {
        // Hot stream inputs
        double di = ask("di");
        double m0 = ask("m0");
        double meu_h = ask("meu_h");
        double Dc = ask("Dc");
        double Dm = ask("Dm");
        double Pr_h = ask("Pr_h");
        double k_h = ask("k_h");
        double rho_h = ask("rho_h");
        double S_vap = ask("S_vap");
        double S = ask("S");
        double Sliq = ask("Sliq");
        double H_lp_out = ask("H_lp_out");
        double H_lp_in = ask("H_lp_in");
        double H_hp_in = ask("H_hp_in");
        double H_vap = ask("H_vap");
        double H_liq = ask("H_liq");

        double delta_H_max = H_lp_out + H_lp_in;
        double H_hp_out = H_hp_in - delta_H_max;
        double x_num = S_vap - S;
        double x_den = S_vap - Sliq;
        double x = x_num / x_den;
        double Q_r = m0 * x * delta_H_max;
        double delta_H = H_vap - H_liq;

        double Ah = (pi / 4.0) * (di * di);
        double G_h = m0 / Ah;
        double Dh = (Dc + Dm) / 2.0;
        double De_h = di;
        double Re_h = (De_h * G_h) / meu_h;
        double Nu_h = 0.023 * pow(Re_h, 0.8) * pow(Pr_h, 0.4) * (1.0 + 3.5 * (De_h / Dh));
        double h_h = (k_h * Nu_h) / De_h;
        double f_h = 0.046 * pow(Re_h, -0.25);
        double Z_h = (4.0 * f_h * (G_h * G_h)) / (2.0 * De_h * rho_h);

        cout << "delta_H_max = " << delta_H_max << "\n";
        cout << "H_hp_out = " << H_hp_out << "\n";
        cout << "x = " << x << "\n";
        cout << "Q_r = " << Q_r << "\n";
        cout << "delta_H = " << delta_H << "\n";
        cout << "Ah = " << Ah << "\n";
        cout << "G_h = " << G_h << "\n";
        cout << "Dh = " << Dh << "\n";
        cout << "Re_h = " << Re_h << "\n";
        cout << "Nu_h = " << Nu_h << "\n";
        cout << "h_h = " << h_h << "\n";
        cout << "f_h = " << f_h << "\n";
        cout << "deltaP/L (Z_h) = " << Z_h << "\n";
    } else {
        cerr << "Invalid choice.\n";
        return 1;
    }

    return 0;
}
