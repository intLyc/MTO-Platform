% ------------------------------------------------------------------------
% This source file is part of the 'ESA Advanced Concepts Team's			
% Space Mechanics Toolbox' software.                                       
%                                                                          
% The source files are for research use only,                              
% and are distributed WITHOUT ANY WARRANTY. Use them on your own risk.     
%                                                                                                                                                  
% Copyright (c) 2004-2007 European Space Agency
% ------------------------------------------------------------------------
% 
function [J,rp,DVvec,penalty,Itime,FBalt,alph,Vrelin,Vrelout] = mga(t, problem)

%Programmed by: Claudio Bombardelli (ESA/ACT)
%               Dario Izzo          (ESA/ACT)
%Date:                  16/04/2007
%Revision:              3
%Tested by:             CBo, DI
%
%
%Computes the DeltaV cost function of a Multiple Gravity Assist (MGA) trajectory
%with no Deep Space Maneuvers given a sequence of planets and a decision
%vector t representing the different epochs. The DeltaV cost is that
%associated to an orbit insertion in the last planet.
%
%N.B.: We assume here that the DV maneuvers during the swing-bys are given
%instantaneously at the various planet pericentres  (so we use the routine PowSwingByInv.m)
%
%Usage:     [J,rp,DVvec,Itime,FBalt,alph,Vrelin,Vrelout] = mga(t,MGAproblem,yplot)
%
%Outputs:
%           J:     Cost function = depends on the problem: 

%                  *orbit insertion: total DV (V_launcher not counted)+ penalties (km/sec)
%                  (penalties are activated when the constraints on the
%                  swing by altitudes are not violated)
%                  **gtoc1= 1/d where d=(s/c final mass)*v_asteroid'*vrel_ast_sc
%                  ***asteroid deflection-> 1/d where d=deflecion on the
%                  earth-asteroid lineofsight

%           rp:    vector of the swing-by radii (km)
%           DVvec: vector of all DV maneuvers (km/sec)
%           Itime: vector of epochs corresponding to each DV maneuver
%                  (mjd2000)
%           FBalt: vector containing the swing-by altitudes (km)
%           alph:  vector containing the turning angle of the relative
%                  velocity vector (wrt each planet)
%           Vrelin,Vrelout: Incoming and outgoing velocity vectors for each
%                           planet (km/sec)
%
%
%Inputs:
%           t(1)=  epoch of departure (MJD2000) from the first planet (usually earth)
%           t(2..n)= planet-to-planet travel times (days)[Time of Flight]
%
%           MGAproblem = struct array defining the problem, e.g
%               MGAproblem.sequence:  planet sequence. Example [3 2 2 3 5]= [E V V E J]. A
%                      negative sign represents a retrograde orbit after the fly by
%               MGAproblem.DVlaunch:  launch vehicle DV (km/sec)
%               MGAproblem.objective.type: type of objective function (e.g.
%                       'orbit insertion','rndv','gtoc1')
%               MGAproblem.objective.rp: pericentre radius of the
%                       target orbit if type = 'orbit insertion'
%               MGAproblem.objective.e:  eccentricity of the target
%                       orbit if type = 'orbit insertion'
%               MGAproblem.yplot:     1-> plot trajectory, 0-> don't
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sequence= problem.sequence;  % THE PLANETs SEQUENCE
DVlaunch = problem.DVlaunch; % launch DV (km/s)
yplot = problem.yplot;
DVtot=0;

switch problem.objective.type
    case 'orbit insertion'
        rp_target= problem.objective.rp; % radius of pericentre at capture
        e_target=problem.objective.e;   % Eccentricity of the target orbit at capture
    case 'gtoc1'
        Isp=problem.objective.Isp;
        mass = problem.objective.mass;
    case 'deflection demo'
        Isp=problem.objective.Isp;
        mass = problem.objective.mass;
        astmass = problem.customobject.mass;
        obstime = problem.objective.obstime;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading the values for the minimum allowed pericentre radius of each planet
%
rpmin=zeros(6,1);
rpmin(2)=problem.rpmin.venus;   %(Venus)
rpmin(3)=problem.rpmin.earth;   %(Earth)
rpmin(4)=problem.rpmin.mars;     %(Mars)
rpmin(5)=problem.rpmin.jupiter; %(Jupiter)
rpmin(6)=problem.rpmin.saturn;  %(Saturn)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Reading the penalty factors for low pericenter fly-bys. These can be
%interpreted as km/sec penalties for each km of violation
%
rpfact=zeros(6,1);
rpfact(2)=problem.rpfact.venus;
rpfact(3)=problem.rpfact.earth;
rpfact(4)=problem.rpfact.mars;
rpfact(5)=problem.rpfact.jupiter;
rpfact(6)=problem.rpfact.saturn;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Penalty factor for the DV in excess at launch
%
%dv_excess_fact=1;

%**************************************************************************
%Definition of the gravitational constants of the various planets
%(used in the powered swing-by routine) and of the sun (used in the lambert
%solver routine)
%**************************************************************************


mu(2)=324860;         %Gravitational constant of Venus
mu(3)=398601.19;      %                          Earth
mu(4)=42828.3;        %                          Mars
mu(5)=126.7e6;        %                          Jupiter
mu(6)=37.9e6;         %                          Saturn

muSUN=1.32712428e+11; %Gravitational constant of Sun


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Definition of planetari radii
%
RPL(2)=6052;
RPL(3)=6378;
RPL(4)=3397;
RPL(5)=71492;
RPL(6)=60268;

%**************************************************************************
%Evaluation of position and velocities of the planets
%**************************************************************************

N=length(sequence);

r= zeros(3,N+1);
v= zeros(3,N+1);

T=0;
muvec=zeros(N,1);
rpminvec=zeros(N-1,1);
rpfactvec=zeros(N-1,1);
Itime = zeros(N);
RPLvec = zeros(N);

seq = abs (sequence);
for i=1:N
    T=T+t(i);
    Itime(i)=T;
    if seq(i)<10
        [r(:,i),v(:,i)]=pleph_an( T , seq(i)); %positions and velocities of solar system planets
        muvec(i)=mu(seq(i)); %gravitational constants
        RPLvec(i)=RPL(seq(i)); %planetary radii
    else
        [r(:,i),v(:,i)]=CUSTOMeph( mjd20002jed(T) , ...
            problem.customobject(seq(i)).epoch, ...
            problem.customobject(seq(i)).keplerian , 1); %positions and velocities of custom object
        muvec(i)=problem.customobject(seq(i)).mu; %gravitational constant of custom object
        RPLvec(i)=problem.customobject(seq(i)).RPL; %planetary radii of custom object
    end

end

for i=1:N-2 %i=1 refers to the second planet
    rpminvec(i)=rpmin(seq(i+1)); %minimum fly-by distances
    rpfactvec(i)=rpfact(seq(i+1)); % penalty factors for low fly-by
end


%**************************************************************************
%Evaluation of the first Lambert arc and of the departure velocity
%**************************************************************************

lw=vett(r(:,1),r(:,2));
lw=sign(lw(3));
lw = (lw ~= 1);
%if lw==1
%    lw=0;
%else
%    lw=1;
%end
[V1,V(:,2,1)]=lambertI(r(:,1),r(:,2),t(2)*24*60*60,muSUN,lw);
DVdep=norm(V1-v(:,1));

%**************************************************************************
%Evaluation of the remaining Lambert arcs and swingby DVs
%**************************************************************************
alph = zeros(N-2,1);
DV = zeros(N-2,1);
rp = zeros(N-2,1);
Vrelin = zeros(3,N-2);
Vrelout = zeros(3,N-2);
FBalt = zeros(N-2,1);

for i=2:N-1;

    lw=vett(r(:,i),r(:,i+1));
    lw=sign(lw(3));
    if sign(sequence(i)) == 1
        lw = (lw ~= 1);     %prograde
    else
        lw = (lw == 1);     %retrograde
    end
    %if lw==1
    %    lw=0;
    %else
    %    lw=1;
    %end
    [V(:,i,2),V(:,i+1,1)]=lambertI(r(:,i),r(:,i+1),t(i+1)*24*60*60,muSUN,lw);

    VinH=V(:,i,1); %S/C heliocentric incoming velocity
    VoutH=V(:,i,2);%S/C  "            outgoing   "
    %Vpla=v(:,i);   %    heliocentric velocity of planet
    VinP=VinH-v(:,i); % S/C relative incoming velocity
    VoutP=VoutH-v(:,i);% S/C relative outgoing velocity
    Vin=norm(VinP);
    Vout=norm(VoutP);
    alpha=acos(VinP'*VoutP/Vin/Vout); %swing-by turning angle
    alph(i-1)=alpha*180/pi;
    [DV(i-1) , rp(i-1)]=PowSwingByInv(Vin,Vout,alpha);
    Vrelin(:,i-1)=VinP;
    Vrelout(:,i-1)=VoutP;
    rp(i-1)=rp(i-1)*muvec(i);
    FBalt(i)=rp(i-1)-RPLvec(i);
end;

%**************************************************************************
%Evaluation of the arrival DV
%**************************************************************************
%

DVrel=norm(V(:,N,1)-v(:,N)); %Relative velocity at target planet
switch problem.objective.type
    case 'orbit insertion'
        DVper=sqrt(DVrel^2+2*muvec(N)/rp_target);  %Hyperbola
        DVper2=sqrt(2*muvec(N)/rp_target-muvec(N)/rp_target*(1-e_target)); %Ellipse
        DVarr=abs(DVper-DVper2);
    otherwise
        DVarr = DVrel;
end

DV(N-1,1)=DVarr;

%**************************************************************************
%Evaluation of total DV
%**************************************************************************
switch problem.objective.type
    case 'gtoc1'
        DVtot=sum(DV(1:N-2));
    case 'deflection demo'
        DVtot=sum(DV(1:N-2));
    otherwise
        DVtot=sum(DV);
end


DVvec=[DVdep ; DV];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% penalties for low pericenter radii
penalty(1:N-1,1)=0;
for i=1:N-2
    rpref=rpminvec(i);
    if (rp(i) < rpref)
        penalty(i+1)=rpfactvec(i)*(rpref - rp(i));
        %DVtot = DVtot + rpfactvec(i)*(rpref - rp(i));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%penalty for exceeding launch DV

if (DVdep > DVlaunch)
    penalty(1)=(DVdep - DVlaunch);
    %DVtot = DVtot + (DVdep - DVlaunch);
end
DVtot = DVtot + sum(penalty);

%Finally our objective function is:
switch problem.objective.type
    case 'orbit insertion'
        J= DVtot;
    case 'rndv'
        J= DVtot;
    case 'gtoc1'
        mass_fin = mass * exp (- DVtot/ (Isp/1000 * 9.80665));
        J = (mass_fin * abs((V(:,N,1)-v(:,N))'* v(:,N,1)));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NOTE: the following routines are needed when running this file outside of
% the ACT library


%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************
%                       ASTRODYNAMICAL ROUTINES
%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************


function  [r,v,E]=pleph_an ( mjd2000, planet)
%The original version of this file was written in Fortran 77
%and is part of ESOC library. The file has later been translated under the
%name uplanet.m in Matlab, but that version was affected by several
%mistakes. In particular Pluto orbit was affected by great uncertainties.
%As a consequence its analytical eph have been substituted by a fifth order
%polynomial least square fit generated by Dario Izzo (ESA ACT). JPL405
%ephemerides (Charon-Pluto barycenter) have been used to produce the
%coefficients. WARNING: Pluto ephemerides should not be used outside the
%range 2000-2100;
%
%The analytical ephemerides of the nine planets of our solar system are
%returned in rectangular coordinates referred to the ecliptic J2000
%reference frame. Using analytical ephemerides instead of real ones (for
%examples JPL ephemerides) is faster but not as accurate, especially for
%the outer planets
%
%Date:                  28/05/2004
%Revision:              1
%Tested by:             ----------
%
%
%Usage: [r,v,E]=pleph_an ( mjd2000 , IBODY );
%
%Inputs:
%           mjd2000:    Days elapsed from 1st of January 2000 counted from
%           midnight.
%           planet:     Integer form 1 to 10 containing the number
%           of the planet (Mercury, Venus, Earth, Mars, Jupiter, Saturn,
%           Uranus, Neptune, Pluto, Custom)
%
%Outputs:
%           r:         Column vector containing (in km) the position of the
%                      planet in the ecliptic J2000
%           v:         Column vector containing (in km/sec.) the velocity of
%                      the planet in the ecliptic J2000
%           E:         Column Vectors containing the six keplerian parameters,
%                      (a,e,i,OM,om,Eccentric Anomaly)
%
%Xref:      the routine needs a variable mu on the workspace whose 10th
%           element should be the sun gravitational parameter in KM^3/SEC^2

RAD=pi/180;
AU  = 149597870.66;        %Astronomical Unit in Km
KM=AU;

%
%  T = JULIAN CENTURIES SINCE 1900
%
T   = (mjd2000 + 36525.00)/36525.00;
TT  = T*T;
TTT = T*TT;
%
%  CLASSICAL PLANETARY ELEMENTS ESTIMATION IN MEAN ECLIPTIC OF DATE
%
switch planet
    %
    %  MERCURY
    %
    case 1
        E(1) = 0.38709860;
        E(2) = 0.205614210 + 0.000020460*T - 0.000000030*TT;
        E(3) = 7.002880555555555560 + 1.86083333333333333e-3*T - 1.83333333333333333e-5*TT;
        E(4) = 4.71459444444444444e+1 + 1.185208333333333330*T + 1.73888888888888889e-4*TT;
        E(5) = 2.87537527777777778e+1 + 3.70280555555555556e-1*T +1.20833333333333333e-4*TT;
        XM   = 1.49472515288888889e+5 + 6.38888888888888889e-6*T;
        E(6) = 1.02279380555555556e2 + XM*T;
        %
        %  VENUS
        %
    case 2
        E(1) = 0.72333160;
        E(2) = 0.006820690 - 0.000047740*T + 0.0000000910*TT;
        E(3) = 3.393630555555555560 + 1.00583333333333333e-3*T - 9.72222222222222222e-7*TT;
        E(4) = 7.57796472222222222e+1 + 8.9985e-1*T + 4.1e-4*TT;
        E(5) = 5.43841861111111111e+1 + 5.08186111111111111e-1*T -1.38638888888888889e-3*TT;
        XM   = 5.8517803875e+4 + 1.28605555555555556e-3*T;
        E(6) = 2.12603219444444444e2 + XM*T;
        %
        %  EARTH
        %
    case 3
        E(1) = 1.000000230;
        E(2) = 0.016751040 - 0.000041800*T - 0.0000001260*TT;
        E(3) = 0.00;
        E(4) = 0.00;
        E(5) = 1.01220833333333333e+2 + 1.7191750*T + 4.52777777777777778e-4*TT + 3.33333333333333333e-6*TTT;
        XM   = 3.599904975e+4 - 1.50277777777777778e-4*T - 3.33333333333333333e-6*TT;
        E(6) = 3.58475844444444444e2 + XM*T;
        %
        %  MARS
        %
    case 4
        E(1) = 1.5236883990;
        E(2) = 0.093312900 + 0.0000920640*T - 0.0000000770*TT;
        E(3) = 1.850333333333333330 - 6.75e-4*T + 1.26111111111111111e-5*TT;
        E(4) = 4.87864416666666667e+1 + 7.70991666666666667e-1*T - 1.38888888888888889e-6*TT - 5.33333333333333333e-6*TTT;
        E(5) = 2.85431761111111111e+2 + 1.069766666666666670*T +  1.3125e-4*TT + 4.13888888888888889e-6*TTT;
        XM   = 1.91398585e+4 + 1.80805555555555556e-4*T + 1.19444444444444444e-6*TT;
        E(6) = 3.19529425e2 + XM*T;

        %
        %  JUPITER
        %
    case 5
        E(1) = 5.2025610;
        E(2) = 0.048334750 + 0.000164180*T  - 0.00000046760*TT -0.00000000170*TTT;
        E(3) = 1.308736111111111110 - 5.69611111111111111e-3*T +  3.88888888888888889e-6*TT;
        E(4) = 9.94433861111111111e+1 + 1.010530*T + 3.52222222222222222e-4*TT - 8.51111111111111111e-6*TTT;
        E(5) = 2.73277541666666667e+2 + 5.99431666666666667e-1*T + 7.0405e-4*TT + 5.07777777777777778e-6*TTT;
        XM   = 3.03469202388888889e+3 - 7.21588888888888889e-4*T + 1.78444444444444444e-6*TT;
        E(6) = 2.25328327777777778e2 + XM*T;
        %
        %  SATURN
        %
    case 6
        E(1) = 9.5547470;
        E(2) = 0.055892320 - 0.00034550*T - 0.0000007280*TT + 0.000000000740*TTT;
        E(3) = 2.492519444444444440 - 3.91888888888888889e-3*T - 1.54888888888888889e-5*TT + 4.44444444444444444e-8*TTT;
        E(4) = 1.12790388888888889e+2 + 8.73195138888888889e-1*T -1.52180555555555556e-4*TT - 5.30555555555555556e-6*TTT;
        E(5) = 3.38307772222222222e+2 + 1.085220694444444440*T + 9.78541666666666667e-4*TT + 9.91666666666666667e-6*TTT;
        XM   = 1.22155146777777778e+3 - 5.01819444444444444e-4*T - 5.19444444444444444e-6*TT;
        E(6) = 1.75466216666666667e2 + XM*T;
        %
        %  URANUS
        %
    case 7
        E(1) = 19.218140;
        E(2) = 0.04634440 - 0.000026580*T + 0.0000000770*TT;
        E(3) = 7.72463888888888889e-1 + 6.25277777777777778e-4*T + 3.95e-5*TT;
        E(4) = 7.34770972222222222e+1 + 4.98667777777777778e-1*T + 1.31166666666666667e-3*TT;
        E(5) = 9.80715527777777778e+1 + 9.85765e-1*T - 1.07447222222222222e-3*TT - 6.05555555555555556e-7*TTT;
        XM   = 4.28379113055555556e+2 + 7.88444444444444444e-5*T + 1.11111111111111111e-9*TT;
        E(6) = 7.26488194444444444e1 + XM*T;
        %
        %  NEPTUNE
        %
    case 8
        E(1) = 30.109570;
        E(2) = 0.008997040 + 0.0000063300*T - 0.0000000020*TT;
        E(3) = 1.779241666666666670 - 9.54361111111111111e-3*T - 9.11111111111111111e-6*TT;
        E(4) = 1.30681358333333333e+2 + 1.0989350*T + 2.49866666666666667e-4*TT - 4.71777777777777778e-6*TTT;
        E(5) = 2.76045966666666667e+2 + 3.25639444444444444e-1*T + 1.4095e-4*TT + 4.11333333333333333e-6*TTT;
        XM   = 2.18461339722222222e+2 - 7.03333333333333333e-5*T;
        E(6) = 3.77306694444444444e1 + XM*T;
        %
        %  PLUTO
        %
    case 9
        %Fifth order polynomial least square fit generated by Dario Izzo
        %(ESA ACT). JPL405 ephemerides (Charon-Pluto barycenter) have been used to produce the coefficients.
        %This approximation should not be used outside the range 2000-2100;
        T=mjd2000/36525;
        TT=T*T;
        TTT=TT*T;
        TTTT=TTT*T;
        TTTTT=TTTT*T;
        E(1)=39.34041961252520 + 4.33305138120726*T - 22.93749932403733*TT + 48.76336720791873*TTT - 45.52494862462379*TTTT + 15.55134951783384*TTTTT;
        E(2)=0.24617365396517 + 0.09198001742190*T - 0.57262288991447*TT + 1.39163022881098*TTT - 1.46948451587683*TTTT + 0.56164158721620*TTTTT;
        E(3)=17.16690003784702 - 0.49770248790479*T + 2.73751901890829*TT - 6.26973695197547*TTT + 6.36276927397430*TTTT - 2.37006911673031*TTTTT;
        E(4)=110.222019291707 + 1.551579150048*T - 9.701771291171*TT + 25.730756810615*TTT - 30.140401383522*TTTT + 12.796598193159 * TTTTT;
        E(5)=113.368933916592 + 9.436835192183*T - 35.762300003726*TT + 48.966118351549*TTT - 19.384576636609*TTTT - 3.362714022614 * TTTTT;
        E(6)=15.17008631634665 + 137.023166578486*T + 28.362805871736*TT - 29.677368415909*TTT - 3.585159909117*TTTT + 13.406844652829 * TTTTT;

end
%
%  CONVERSION OF AU INTO KM, DEG INTO RAD
%
E(1)     =     E(1)*KM;
for  I = 3: 6
    E(I)     = E(I)*RAD;
end
E(6)     = mod(E(6), 2*pi);

%Conversion from mean anomaly to eccentric anomaly via Kepler's equation
EccAnom=M2E(E(6),E(2));
E(6)=EccAnom;

%Calcolo velocit?e posizione nel sistema J2000
[r,v]=conversion(E);

%--------------------------------------------------------------------------
function [r,v] = conversion (E)
% Parametri orbitali

muSUN=  1.327124280000000e+011;       %gravitational parameter for the sun

a=E(1);
e=E(2);
i=E(3);
omg=E(4);
omp=E(5);
EA=E(6);


% Grandezze definite nel piano dell'orbita

b=a*sqrt(1-e^2);
n=sqrt(muSUN/a^3);

xper=a*(cos(EA)-e);
yper=b*sin(EA);

xdotper=-(a*n*sin(EA))/(1-e*cos(EA));
ydotper=(b*n*cos(EA))/(1-e*cos(EA));

% Matrice di trasformazione da perifocale a ECI

R(1,1)=cos(omg)*cos(omp)-sin(omg)*sin(omp)*cos(i);
R(1,2)=-cos(omg)*sin(omp)-sin(omg)*cos(omp)*cos(i);
R(1,3)=sin(omg)*sin(i);
R(2,1)=sin(omg)*cos(omp)+cos(omg)*sin(omp)*cos(i);
R(2,2)=-sin(omg)*sin(omp)+cos(omg)*cos(omp)*cos(i);
R(2,3)=-cos(omg)*sin(i);
R(3,1)=sin(omp)*sin(i);
R(3,2)=cos(omp)*sin(i);
R(3,3)=cos(i);

% Posizione nel sistema inerziale

r=R*[xper;yper;0];
v=R*[xdotper;ydotper;0];

%--------------------------------------------------------------------------
function E=M2E(M,e)
%
tol=1e-13;
err=1;
E=M+e*cos(M);   %initial guess
while err>tol
    Enew=E-(E-e*sin(E)-M)/(1-e*cos(E));
    err=abs(E-Enew);
    E=Enew;
end


%--------------------------------------------------------------------------
function [v1,v2,a,p,theta,iter]=lambertI(r1,r2,t,mu,lw,N,branch)
%
%This routine implements a new algorithm that solves Lambert's problem. The
%algorithm has two major characteristics that makes it favorable to other
%existing ones.
%
%   1) It describes the generic orbit solution of the boundary condition
%   problem through the variable X=log(1+cos(alpha/2)). By doing so the
%   graphs of the time of flight become defined in the entire real axis and
%   resembles a straight line. Convergence is granted within few iterations
%   for all the possible geometries (except, of course, when the transfer
%   angle is zero). When multiple revolutions are considered the variable is
%   X=tan(cos(alpha/2)*pi/2).
%
%   2) Once the orbit has been determined in the plane, this routine
%   evaluates the velocity vectors at the two points in a way that is not
%   singular for the transfer angle approaching to pi (Lagrange coefficient
%   based methods are numerically not well suited for this purpose).
%
%   As a result Lambert's problem is solved (with multiple revolutions
%   being accounted for) with the same computational effort for all
%   possible geometries. The case of near 180 transfers is also solved
%   efficiently.
%
%   We note here that even when the transfer angle is exactly equal to pi
%   the algorithm does solve the problem in the plane (it finds X), but it
%   is not able to evaluate the plane in which the orbit lies. A solution
%   to this would be to provide the direction of the plane containing the
%   transfer orbit from outside. This has not been implemented in this
%   routine since such a direction would depend on which application the
%   transfer is going to be used in.
%
%Usage: [v1,v2,a,p,theta,iter]=lambertI(r1,r2,t,mu,lw,N,branch)
%
%Inputs:
%           r1=Position vector at departure (column)
%           r2=Position vector at arrival (column, same units as r1)
%           t=Transfer time (scalar)
%           mu=gravitational parameter (scalar, units have to be
%           consistent with r1,t units)
%           lw=1 if long way is chosen
%           branch='l' if the left branch is selected in a problem where N
%           is not 0 (multirevolution)
%           N=number of revolutions
%
%Outputs:
%           v1=Velocity at departure        (consistent units)
%           v2=Velocity at arrival
%           a=semi major axis of the solution
%           p=semi latus rectum of the solution
%           theta=transfer angle in rad
%           iter=number of iteration made by the newton solver (usually 6)
%
%please report bugs to dario.izzo@esa.int





%Preliminary control on the function call
if nargin==5
    N=0;
end
if t<=0
    warning('Negative time as input')
    v1=NaN;
    v2=NaN;
    return
end


tol=1e-11;  %Increasing the tolerance does not bring any advantage as the
%precision is usually greater anyway (due to the rectification of the tof
%graph) except near particular cases such as parabolas in which cases a
%lower precision allow for usual convergence.


%Non dimensional units
R=sqrt(r1'*r1);
V=sqrt(mu/R);
T=R/V;

%working with non-dimensional radii and time-of-flight
r1=r1/R;
r2=r2/R;
t=t/T;

%Evaluation of the relevant geometry parameters in non dimensional units
r2mod=sqrt(r2'*r2);
theta=real(acos((r1'*r2)/r2mod)); %the real command is useful when theta is very
%close to pi and the acos function could return complex numbers
if lw
    theta=2*pi-theta;
end
c=sqrt(1+r2mod^2-2*r2mod*cos(theta)); %non dimensional chord
s=(1+r2mod+c)/2;                      %non dimensional semi-perimeter
am=s/2;                               %minimum energy ellipse semi major axis
lambda=sqrt(r2mod)*cos(theta/2)/s;    %lambda parameter defined in BATTIN's book



%We start finding the log(x+1) value of the solution conic:
%%NO MULTI REV --> (1 SOL)
if N==0
    inn1=-.5233;    %first guess point
    inn2=.5233;     %second guess point
    x1=log(1+inn1);
    x2=log(1+inn2);
    y1=log(x2tof(inn1,s,c,lw,N))-log(t);
    y2=log(x2tof(inn2,s,c,lw,N))-log(t);

    %Newton iterations
    err=1;
    i=0;
    while ((err>tol) && (y1~=y2))
        i=i+1;
        xnew=(x1*y2-y1*x2)/(y2-y1);
        ynew=log(x2tof(exp(xnew)-1,s,c,lw,N))-log(t);
        x1=x2;
        y1=y2;
        x2=xnew;
        y2=ynew;
        err=abs(x1-xnew);
    end
    iter=i;
    x=exp(xnew)-1;


    %%MULTI REV --> (2 SOL) SEPARATING RIGHT AND LEFT BRANCH
else
    if branch=='l'
        inn1=-.5234;
        inn2=-.2234;
    else
        inn1=.7234;
        inn2=.5234;
    end
    x1=tan(inn1*pi/2);
    x2=tan(inn2*pi/2);
    y1=x2tof(inn1,s,c,lw,N)-t;

    y2=x2tof(inn2,s,c,lw,N)-t;
    err=1;
    i=0;

    %Newton Iteration
    while ((err>tol) && (i<60) && (y1~=y2))
        i=i+1;
        xnew=(x1*y2-y1*x2)/(y2-y1);
        ynew=x2tof(atan(xnew)*2/pi,s,c,lw,N)-t;
        x1=x2;
        y1=y2;
        x2=xnew;
        y2=ynew;
        err=abs(x1-xnew);
    end
    x=atan(xnew)*2/pi;
    iter=i;
end

%The solution has been evaluated in terms of log(x+1) or tan(x*pi/2), we
%now need the conic. As for transfer angles near to pi the lagrange
%coefficient technique goes singular (dg approaches a zero/zero that is
%numerically bad) we here use a different technique for those cases. When
%the transfer angle is exactly equal to pi, then the ih unit vector is not
%determined. The remaining equations, though, are still valid.


a=am/(1-x^2);                       %solution semimajor axis
%calcolo psi
if x<1 %ellisse
    beta=2*asin(sqrt((s-c)/2/a));
    if lw
        beta=-beta;
    end
    alfa=2*acos(x);
    psi=(alfa-beta)/2;
    eta2=2*a*sin(psi)^2/s;
    eta=sqrt(eta2);
else %iperbole
    beta=2*asinh(sqrt((c-s)/2/a));
    if lw
        beta=-beta;
    end
    alfa=2*acosh(x);
    psi=(alfa-beta)/2;
    eta2=-2*a*sinh(psi)^2/s;
    eta=sqrt(eta2);
end
p=r2mod/am/eta2*sin(theta/2)^2;     %parameter of the solution
sigma1=1/eta/sqrt(am)*(2*lambda*am-(lambda+x*eta));
ih=vers(vett(r1,r2)');
if lw
    ih=-ih;
end

vr1 = sigma1;
vt1 = sqrt(p);
v1  = vr1 * r1   +   vt1 * vett(ih,r1)';

vt2=vt1/r2mod;
vr2=-vr1+(vt1-vt2)/tan(theta/2);
v2=vr2*r2/r2mod+vt2*vett(ih,r2/r2mod)';
v1=v1*V;
v2=v2*V;
a=a*R;
p=p*R;

%--------------------------------------------------------------------------
function t=x2tof(x,s,c,lw,N)
%Subfunction that evaluates the time of flight as a function of x
am=s/2;
a=am/(1-x^2);
if x<1 %ELLISSE
    beta=2*asin(sqrt((s-c)/2/a));
    if lw
        beta=-beta;
    end
    alfa=2*acos(x);
else   %IPERBOLE
    alfa=2*acosh(x);
    beta=2*asinh(sqrt((s-c)/(-2*a)));
    if lw
        beta=-beta;
    end
end
t=tofabn(a,alfa,beta,N);

%--------------------------------------------------------------------------
function t=tofabn(sigma,alfa,beta,N)
%subfunction that evaluates the time of flight via Lagrange expression
if sigma>0
    t=sigma*sqrt(sigma)*((alfa-sin(alfa))-(beta-sin(beta))+N*2*pi);
else
    t=-sigma*sqrt(-sigma)*((sinh(alfa)-alfa)-(sinh(beta)-beta));
end

%--------------------------------------------------------------------------
function v=vers(V)
%subfunction that evaluates unit vectors
v=V/sqrt(V'*V);

%--------------------------------------------------------------------------
function ansd = vett(r1,r2)
%subfunction that evaluates vector product
ansd(1)=(r1(2)*r2(3)-r1(3)*r2(2));
ansd(2)=(r1(3)*r2(1)-r1(1)*r2(3));
ansd(3)=(r1(1)*r2(2)-r1(2)*r2(1));

%--------------------------------------------------------------------------
function [DV,rp,iter]=PowSwingByInv(Vin,Vout,alpha)
%
%Usage: [DV,rp,iter] = PowSwingByInv(Vin,Vout,alpha)
%
%Outputs:
%           DV:    Velcity Increment of the Powered SwingBy (non dimensional)
%           rp:    Pericenter radius found.
%           iter:  Number of iteration to converge (-1 if convergence is failed)
%
%Inputs:
%           Vin:   Incoming hyperbolic velocity modulus  (non dimensional)
%           Vout:  Outgoing hyperbolic velocity modulus  (non dimensional)
%           alpha: Angle between Vin and Vout (in rad.)
%
%Comments:  The non dimensional units are R for the length and sqrt(mu/R)
%for the velocity --> gravitational constant is one. R may be choosen
%freely as any relevant length. Magic of the non dimensional forms: if we
%forget about dimension and we call the routine, then DV is returned in the
%same units as the input parameters, and rp has to be multiplied by the
%planet gravitational constant (unit consistent with the velocity input)
%to be transformed in the length.

aIN=1/Vin^2;    %semimajor axis of the incoming hyperbola
aOUT=1/Vout^2;  %semimajor axis of the outcoming hyperbola

%We find the perigee radius with an iteration method based on the gradient
%of the function. Attention has to be payed to the initial point as the
%function is not defined for rp<0. The option here implemented considers
%halfing the perigee radius whenever the gradient pushes the next iteration
%in a non defined zone.
i=0;
maxiter=30;     %maximum number of iteration allowed for the gradient method
rp=1;           %Initial point
err=1;
while((err>1e-8)&&(i<maxiter))
    i=i+1;
    f=asin(aIN/(aIN+rp))+asin(aOUT/(aOUT+rp))-alpha;
    df=-aIN/sqrt(rp^2+2*aIN*rp)/(aIN+rp)-aOUT/sqrt(rp^2+2*aOUT*rp)/(aOUT+rp);
    rpNew=rp-f/df;
    if (rpNew>0)
        err=abs(rpNew-rp);
        rp=rpNew;
    else
        rp=rp/2;
    end
end

%Evaluation of the DV
DV=abs(sqrt(Vout^2+2/rp)-sqrt(Vin^2+2/rp));

%If the maximum number of iteration is achieved the returned number of
%iteration is -1.
iter=i;
if iter==maxiter
    iter=-1;
end

%--------------------------------------------------------------------------
function [r,v]=CUSTOMeph(jd,epoch,keplerian,flag)
%
%Returns the position and the velocity of an object having keplerian
%parameters epoch,a,e,i,W,w,M
%
%Usage:     [r,v]=CUSTOMeph(jd,name,list,data,flag)
%
%Inputs:    jd: julian date
%           epoch: mjd when the object was observed (referred to M)
%           keplerian: vector containing the keplerian orbital parameters
%
%Output:    r = object position with respect to the Sun (km if flag=1, AU otherwise)
%           v = object velocity ( km/s if flag=1, AU/days otherways )
%
%Revisions :    Function added 04/07

muSUN=1.32712428e+11;    %Gravitational constant of Sun
AU  = 149597870.66;      %Astronomical Unit in Km



     a=keplerian(1)*AU; %in km
     e=keplerian(2);
     i=keplerian(3); 
     W=keplerian(4);
     w=keplerian(5);
     M=keplerian(6);
     jdepoch=mjd2jed(epoch);
     DT=(jd-jdepoch)*60*60*24;
     n=sqrt(muSUN/a^3);
     M=M/180*pi;
     M=M+n*DT;
     M=mod(M,2*pi);
     E=M2E(M,e);
     [r,v]=par2IC([a,e,i/180*pi,W/180*pi,w/180*pi,E],muSUN);
     if flag~=1
         r=r/AU;
         v=v*86400/AU;
     end
 
%--------------------------------------------------------------------------
function jd = mjd20002jed(mjd2000)
%This function converts mean julian date 2000 to julian date
jd=mjd2000+2451544.5;

%--------------------------------------------------------------------------
function jd = mjd2jed(mjd)
% This function converts mean Julian date into Julian date
jd = mjd +2400000.5;

%--------------------------------------------------------------------------
function [r0,v0]=par2IC(E,mu)
%
%Usage: [r0,v0] = IC2par(E,mu)
%
%Outputs:
%           r0:    column vector for the position
%           v0:    column vector for the velocity
%
%Inputs:
%           E:     Column Vectors containing the six keplerian parameters,
%                  (a (negative fr hyperbolas),e,i,OM,om,Eccentric Anomaly 
%                    or Gudermannian if e>1)
%           mu:    gravitational constant
%
%Comments:  The parameters returned are, of course, referred to the same
%ref. frame in which r0,v0 are given. a can be given either in kms or AUs,
%but has to be consistent with mu.All the angles must be given in radians. 

a=E(1);
e=E(2);
i=E(3);
omg=E(4);
omp=E(5);
EA=E(6);


% Grandezze definite nel piano dell'orbita
if e<1
    b=a*sqrt(1-e^2);
    n=sqrt(mu/a^3);

    xper=a*(cos(EA)-e);
    yper=b*sin(EA);

    xdotper=-(a*n*sin(EA))/(1-e*cos(EA));
    ydotper=(b*n*cos(EA))/(1-e*cos(EA));
else
    b=-a*sqrt(e^2-1);
    n=sqrt(-mu/a^3);   
    dNdzeta=e*(1+tan(EA)^2)-(1/2+1/2*tan(1/2*EA+1/4*pi)^2)/tan(1/2*EA+1/4*pi);
    
    xper = a/cos(EA)-a*e;
    yper = b*tan(EA);
    
    xdotper = a*tan(EA)/cos(EA)*n/dNdzeta;
    ydotper = b/cos(EA)^2*n/dNdzeta;
end

% Matrice di trasformazione da perifocale a ECI

R(1,1)=cos(omg)*cos(omp)-sin(omg)*sin(omp)*cos(i);
R(1,2)=-cos(omg)*sin(omp)-sin(omg)*cos(omp)*cos(i);
R(1,3)=sin(omg)*sin(i);
R(2,1)=sin(omg)*cos(omp)+cos(omg)*sin(omp)*cos(i);
R(2,2)=-sin(omg)*sin(omp)+cos(omg)*cos(omp)*cos(i);
R(2,3)=-cos(omg)*sin(i);
R(3,1)=sin(omp)*sin(i);
R(3,2)=cos(omp)*sin(i);
R(3,3)=cos(i);

% Posizione nel sistema inerziale 

r0=R*[xper;yper;0];
v0=R*[xdotper;ydotper;0];
