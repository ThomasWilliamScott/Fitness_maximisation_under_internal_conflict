% This specifies parameter values for a single trial and then runs the 
% 'Generate_data.m' script. It outputs the mean trait value and plots a
% graph of how the trait value changes over time.

clearvars
clc
close all

% Fixed parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
o0 = 0; % Optimum trait value for party 0.
o1 = 1; % Optimum trait value for party 1.
theta = 0.8; % Coreplicon 1 proportional size (i.e., fraction of genome 
% constituted by coreplicon 1 rather than coreplicon 0).
z(1) = 0.5; % Initial trait value.
T=100000; % Number of time steps.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Variable parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigma = 0.2; % Std dev for the normal distribution from which trait 
% influencing mutations are drawn.
s = 0; % = mu_sup / mu_trait. It is the rate of generating suppressors of 
% first-in-line trait influencers by mutation, divided by the rate of 
% generating trait influencers by mutation. Biological realism would 
% suggest that this should be small (<<1).
lambda=0; % Rate with which probability of being suppressed drops off with 
% larger positions in the 'trait-influencer queue'. lambda=0 implies no 
% drop off; lambda approaching infinity means only the first trait 
% influencer in the queue may be suppressed. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Generate_data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(1:T+1,z)
hold on
zbar=mean(z);
yline(zbar,'LineWidth',2,'Color','r')
box off
xlim([1 T+1])
ylim([-0.5 1.5])
str = ['Average trait value = ' num2str(zbar)];
title(str);
fontsize(16,"points")
xlabel('Time steps (t)')
ylabel('Trait value (z)')
set(gcf,'color','w');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%