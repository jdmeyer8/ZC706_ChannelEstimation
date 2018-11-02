%% Setup

load('testsig1.mat');
nruns = 100;

runs = 1:nruns;
noise_var = 0.0005*runs;

rx_i_base = rx_i;
rx_q_base = rx_q;
nrx = size(rx_i_base,1);

chApplied = zeros(nruns, 1);
chEst_m = zeros(nruns, 1);
chEst_s = zeros(nruns, 1);

rmax = linspace(1, 0.2, nruns);
rmin = linspace(0.8, 0, nruns);
pmin = linspace(-1*pi + 0.5, pi, nruns);
pmax = linspace(-1*pi, pi - 0.5, nruns);

%% Run loop

for i = 1:nruns
    fprintf('Starting run %d of %d\n', i, nruns);
    
    %ch_i = rand_unif(rmin(i), rmax, nrx, 1);
    %ch_q = rand_unif(rmin(i), rmax, nrx, 1);
    
    ch_r = rand_unif(rmin(i), rmax(i));
    ch_p = rand_unif(pmin(i), pmax(i));
    
    %ch_r = rand_unif(rmin(i), rmax(i), nrx, 1);
    %ch_p = rand_unif(pmin(i), pmax(i), nrx, 1);
    
    ch_i = ch_r.*cos(ch_p);
    ch_q = ch_r.*sin(ch_p);
    
    rxi = rx_i_base(:,2);
    rxq = rx_q_base(:,2);
    
    rx_i(:,2) = ch_i.*rxi - ch_q.*rxq;
    rx_q(:,2) = ch_i.*rxq + ch_q.*rxi;
    
    estimate_channel;
    chEst_m(i) = chEst;
    
    warning off;
    sim('ChannelEst_tb')
    chEst_s(i) = chEst_i_sim + 1i*chEst_q_sim;
    warning on;
    
    chApplied(i) = mean(ch_i) + 1i*mean(ch_q);
end

%% Plot 1

figure(1); 
subplot(231); plot(abs(chApplied), '.-k'); 
%subplot(231); hold all; plot(rmin, '.-k'); plot(rmax, '.-k');
subplot(232); plot(abs(chEst_m), '.-b'); 
subplot(233); plot(abs(chEst_s), '.-r');
subplot(234); plot(angle(chApplied), '.-k');
%subplot(234); hold all; plot(pmin, '.-k'); plot(pmax, '.-k');
subplot(235); plot(angle(chEst_m), '.-b');
subplot(236); plot(angle(chEst_s), '.-r');

%subplot(231); title('Applied Channel Bounds', 'fontweight', 'bold', 'fontsize', 16); ylabel('Channel Magnitude', 'fontweight', 'bold', 'fontsize', 16);
subplot(231); title('Applied Channel', 'fontweight', 'bold', 'fontsize', 16); ylabel('Channel Magnitude', 'fontweight', 'bold', 'fontsize', 16);
subplot(232); title('Channel Estimation (MATLAB)', 'fontweight', 'bold', 'fontsize', 16);
subplot(233); title('Channel Estimation (Simulink)', 'fontweight', 'bold', 'fontsize', 16);
subplot(234); ylabel('Channel Angle [rad]', 'fontweight', 'bold', 'fontsize', 16); xlabel('Sample Number', 'fontweight', 'bold', 'fontsize', 16);
subplot(235); xlabel('Sample Number', 'fontweight', 'bold', 'fontsize', 16);
subplot(236); xlabel('Sample Number', 'fontweight', 'bold', 'fontsize', 16);

subplot(231); set(gca, 'ylim', [0 1]);
subplot(232); set(gca, 'ylim', [0 1]);
subplot(233); set(gca, 'ylim', [0 1]);
subplot(234); set(gca, 'ylim', [-4 4]);
subplot(235); set(gca, 'ylim', [-4 4]);
subplot(236); set(gca, 'ylim', [-4 4]);

%% Plot 2

figure(2);
subplot(221); hold all; plot(abs(chEst_m), '.-b', 'markersize', 10, 'linewidth', 1.5); plot(abs(chEst_s), '.-r', 'markersize', 10, 'linewidth', 1.5); legend('MATLAB', 'Simulink', 'location', 'northeast');
subplot(222); plot(abs(chEst_m) - abs(chEst_s), '.-', 'markersize', 10, 'linewidth', 1.5);
subplot(223); hold all; plot(angle(chEst_m), '.-b', 'markersize', 10, 'linewidth', 1.5); plot(angle(chEst_s), '.-r', 'markersize', 10, 'linewidth', 1.5); legend('MATLAB', 'Simulink', 'location', 'northwest');
subplot(224); plot(angle(chEst_m) - angle(chEst_s), '.-', 'markersize', 10, 'linewidth', 1.5);

subplot(221); title('Channel Estimation Comparison', 'fontsize', 20); ylabel('Channel Estimate Magnitude', 'fontweight', 'bold', 'fontsize', 16);
subplot(222); title('Channel Estimation Difference', 'fontsize', 20); ylabel('Magnitude Difference', 'fontweight', 'bold', 'fontsize', 16)
subplot(223); ylabel('Channel Estimate Angle [rad]', 'fontweight', 'bold', 'fontsize', 16);
subplot(224); ylabel('Angle Difference [rad]', 'fontweight', 'bold', 'fontsize', 16);

subplot(221); set(gca, 'fontsize', 14);
subplot(222); set(gca, 'fontsize', 14);
subplot(223); set(gca, 'fontsize', 14);
subplot(224); set(gca, 'fontsize', 14);
