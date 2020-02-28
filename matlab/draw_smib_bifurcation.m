
% -----------------------------------------------------------------------
% Copyright (c) 2011-2020 by Keyou Wang (wangkeyou@sjtu.edu.cn)
% 
% Description:
%  This program is written to draw the bifurcation of the single
%  machine infinite bus (SMIB) system.
%
%  The parameter space will be illustrated as shown in ref[1] after run this script. 
%  
%  If you are interested in the theory of the program. You are recommanded
%  to read my paper [2] or other books or papers on dynamical systems as
%  follows.
%   
% See reference:
% [1]. 齐琛，汪可友，吴盼，李国杰，虚拟同步机功角稳定的参数空间分析,中国电机工程学报，2019
% [2]. K.Wang, M.L.Crow,The Fokker-Planck Equation for Power System Stability
%       Probability Density Function Evolution,IEEE Transactions on Power Systems, 2013
% [3]. A. A. Andronov, A. A. Vitt, and S. E. Khaikin, Theory of Oscillators.
%       New York: Dover, 1966.


clear all;close all;clc;
global F D deltau1
F=0.5;
D=0.2;

Fpool=[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 0.95 0.98];

% Fpool=[0.5];
DDcr=[];

for kk=1:length(Fpool)
    F=Fpool(kk);
    
    deltas=asin(F);
    deltau1=pi-asin(F);
    deltau2=pi-asin(F)-2*pi;
    
    Area1=F*(deltau1-deltau2);
    
    % Define initial conditions.
    t0 = 0;
    tfinal = 100;
    
    x0 = [deltau2+1e-5 0+1e-5]';
    
    options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);
    
    options = odeset(options,'Events',@myevents_twoevents);
    
    % Simulate the differential equation.
    figure
    title(['F=' num2str(F)])
    hold on
    plot([deltau2-1 25],[0 0],'r')
    plot([deltau1 deltau1],[-4 6],'k')
    plot([deltau2 deltau2],[-4 6],'k')
    xlim([-4 6]);
    xlabel('\delta')
    ylabel('\omega')
        
    xstop=[];
        
    if F<2/pi
        Dapp=F/(4/pi);
        Dpool=linspace(0.98,1.1,100)*Dapp;

    elseif 2/pi<F<0.8
        Dapp=F/(4/pi);
        Dpool=linspace(1,1.5,100)*Dapp;
    elseif 0.8<F<1
        Dapp=F;
        Dpool=linspace(0.8,2,100)*Dapp;        
    end

    for k=1:length(Dpool)
        D=Dpool(k);
        [t,x,te,xe,ie] = ode45(@smib,[t0 tfinal],x0,options);
        % Accumulate output.
        
        xstop=[xstop; xe];
        plot(x(:,1),x(:,2),'k')
        if ~isempty(ie)
            switch ie
                case 1
                case 2
                    break;
                otherwise
            end
        end
    end
    
        
    idx=length(xstop(:,1));
    Dpool(idx:idx+1)
    xstop(end,:)
    
    Dcr=mean(Dpool(idx:idx+1));
    
    DDcr=[DDcr Dcr];
    
end

figure

plot(DDcr, Fpool,'o');hold on;
dd=linspace(0, 1.1, 100);
ff=interp1(DDcr,Fpool,dd,'spline');
plot(dd,ff)
plot([0 1.2],[1 1],'k')
ddd=linspace(0, 2/pi, 100);

xlim([0 1.1]);
ylim([0 1.1]);
xlabel('D');

ylabel('P_m/P_{max}');
legend('numerical points','interplated points', 'limit','appro line')

csvwrite('D_F_plot.csv',[DDcr;Fpool]')
 
figure

plot([0 1.2],[1 1],'k','LineWidth',2);hold on;
plot(dd,ff,'k','LineWidth',2)
plot(ddd,ddd*4/pi,'k:','LineWidth',2);
xlim([0 1.1]);
ylim([0 1.2]);
% xlabel('D^\prime');
xlabel('D');
ylabel('F');
text(0.7, 0.4, '\fontsize{16} Region I')
text(0.3, 0.8, '\fontsize{16} Region II')
text(0.5, 1.1, '\fontsize{16} Region III')
% text(0.65, 0.7, '\fontsize{16} F_1(D^\prime)')
text(0.65, 0.7, '\fontsize{16} F_1(D)')



