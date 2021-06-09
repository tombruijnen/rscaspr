%% Dual-density Cartesian Spiral sampling scheme generation
% Script to reproduce the sampling schemes used in the paper:
% ""
%
% Most of the code is based upon the paper:
% "Prieto, C., Doneva, M., Usman, M., Henningsson, M., Greil, G., Schaeffter, T., & Botnar, R. M. (2015).
% Highly efficient respiratory motion compensated free-breathing coronary MRA using golden-step Cartesian acquisition.
% Journal of Magnetic Resonance Imaging, 41(3), 738746. https://doi.org/10.1002/jmri.24602"
%
% Author: t.bruijnen
% Contact: t.bruijnen@umcutrecht.nl

%% Create figure 1-A - Conventional CASPR
Y   = 64;      % Y Matrix size
Z   = 64;       % Z Matrix size
Sl  = 55;       % Spiral interleaf length
Ns  = 100;     % Number of spiral interleaves
Yh  = 1;        % Half scan in Y
Zh  = 1;        % Half scan in Z

% Dual density region
dd_Sl = 1;       % Number of point on the interleaf for central density part
dd_Ns = 1;       % Number of shots required to fill the central density part
Ys    = 1;        % Sense in Y
Zs    = 1;        % Sense in Z

% Sampling scheme generation
samp_scheme_caspr = generate_ddcaspr_samp_scheme(Y,Z,Yh,Zh,Ys,Zs,Sl,dd_Sl,Ns,dd_Ns);

% Visualization
Ns_thr = 17; 
cm = flip(brewermap(100,'blues'),1);
cm(1,:) = [0 0 0];
Cart_grid = zeros(Y,Z);
d_samp  = size(samp_scheme_caspr,1);
close all;figure;set(gcf,'units','normalized','outerposition',[0 0 1 1],'Color','w')
subplot(131)
for n = 1 : d_samp : Ns_thr * Sl
    Cart_grid(samp_scheme_caspr(max(1,n-d_samp):n)) = n / (Ns_thr * Sl);
    imshow(Cart_grid,[0 1]);colormap(gca,cm);title('CASPR','FontSize',16)
    pause(0.05)
end

%% Create figure 1-B - Dual density CASPR
dd_Sl       = 16;       % Number of point on the interleaf for central density part
dd_Ns       = 10;       % Number of shots required to fill the central density part
samp_scheme_ddcaspr = generate_ddcaspr_samp_scheme(Y,Z,Yh,Zh,Ys,Zs,Sl,dd_Sl,Ns,dd_Ns);

% Visualization
Cart_grid = zeros(Y,Z);
d_samp  = size(samp_scheme_ddcaspr,1);
subplot(132)
for n = 1 : d_samp : Ns_thr * Sl
    Cart_grid(samp_scheme_ddcaspr(max(1,n-d_samp):n)) = n / (Ns_thr * Sl);
    imshow(Cart_grid,[0 1]);colormap(gca,cm);title('dd-CASPR','FontSize',16)
    pause(0.05)
end

%% Create figure 1-C - Accelerated dual density CASPR
% Note that for the accelerated case, first an autocalibration region is acquired
dd_Sl = 16;
dd_Ns = 5;
Ys    = 2;        % Sense in Y
Zs    = 2;        % Sense in Z  
Yh    = 0.8;      % Half scan in Y
Zh    = 0.85;      % Half scan in Z
[samp_scheme_acc_dd_caspr,Ns_calib] = generate_ddcaspr_samp_scheme(Y,Z,Yh,Zh,Ys,Zs,Sl,dd_Sl,Ns,dd_Ns);

% Visualization
Cart_grid = zeros(Y,Z);
d_samp  = size(samp_scheme_acc_dd_caspr,1);
subplot(133)
for n = 1 + Ns_calib * Sl : d_samp : Ns_thr * Sl
     Cart_grid(samp_scheme_acc_dd_caspr(max(1+ Ns_calib * Sl,n-d_samp):n)) = n / (Ns_thr * Sl);
    imshow(Cart_grid,[0 1]);colormap(gca,cm);title('Accelerated dd-CASPR','FontSize',16)
    pause(0.05)
end

cb=colorbar('Location','EastOutside');
cb.TickLabels = {};
set(gca,'Position',[0.6916 0.1100 0.2134 0.8150]);
cb.Position = cb.Position; %- [0.025 0 0 0];
t1 = text(77,47,'Newer data -->','FontSize',14,'Color','k','Rotation',90)
%% Add some final image labels
ah=annotation('arrow',[.1 .2],[.24,.24],'Color','k');
ah=annotation('arrow',[.1 .1],[.24,.425],'Color','k');
text(-165,77,'K_{y}','FontSize',14)
text(-187,60,'K_{z}','FontSize',14)

export_fig /nfs/arch11/researchData/USER/tbruijne/Manuscripts/RS-CASPR/Samp_schemes/samp_schemes.png