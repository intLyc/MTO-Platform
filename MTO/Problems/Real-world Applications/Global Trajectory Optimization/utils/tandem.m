%Programmed by:         Dario Izzo (Advanced Concepts Team)
%Date:                  03/2008
%Revision:              1
%Tested by:             ----------
%
%This file implements a black-box objective function that is defining the
%performance of the mission Tandem (to Saturn) in terms of maximum mass delivered
%to the planet after the impulsive burst in the Saturn pericenter. To do
%this the function needs the performance of the Launcher (ESOC provided the data)
%
%Usage:   [J,DVvec,dsm_epoch,flyby_epoch] = tandem(t,sequence)
%Outputs:
%           J:                  Cost function = Mass delivered at Saturn
%           m_final, m_initial: final and starting mass
%           declination:        launch declination
%           DVvec:              vector of all DV maneuvers
%           DVarr:              hyperbolic velocity at Saturn
%
%
%Inputs:
%           t:         decision vector
%           problem:   problem structure
%
%Dependencies: mga_dsm.m, ecl2equ.m


function [J,m_final,m_initial,declination,DVvec,DVarr] = tandem(t,problem)

seqlen = length(problem.sequence);
if length(t) ~= 6 + (seqlen-2)*4
    warning('It seems that the decision vector has not the correct length');
end

%Position of the Earth at departure (needed to define the declination)
[rE,vE]=pleph_an(t(1),3);

%We evaluate the vector vinf in the ecliptic:
VINF = t(2);
udir = t(3);
vdir = t(4);
vtemp = cross(rE,vE);
iP1 = vE/norm(vE);
zP1 = vtemp/norm(vtemp);
jP1 = cross(zP1,iP1);
theta = 2*pi*udir;         %See Picking a Point on a Sphere
phi = acos(2*vdir-1)-pi/2; %In this way: -pi/2<phi<pi/2 so phi can be used as out-of-plane rotation
vinf = VINF*(cos(theta)*cos(phi)*iP1+sin(theta)*cos(phi)*jP1+sin(phi)*zP1);

%We rotate it to the equatorial plane
vinf = ecl2equ(vinf);

%And we find the declination in degrees
sindelta = vinf(3) / norm(vinf);
declination = asin(sindelta) / pi * 180;

%Now we get the initial mass by interpolating the table for Soyuz-Fregat
%m_initial = SoyuzFregat(VINF,declination);

if strcmp(problem.launcher,'Atlas501')
    m_initial = Atlas501(VINF,declination);
else
    if strcmp(problem.launcher,'Soyuz')
        m_initial = SoyuzFregat(VINF,declination);
    end
end


%We calculate the trajectory DVs
[J,DVvec,DVarr] = mga_dsm(t,problem);
%We apply some losses (consistent with ESOC calculations)
totalDV = sum(DVvec(2:end)) + (seqlen - 2)* 0.025 + 0.090;

%We evaluate the final mass
Isp = 312;
g0 = 9.80665;
m_final = m_initial * exp(-totalDV/Isp/g0*1000);
J = m_final;

function m_initial = SoyuzFregat(VINF,declination)
%This function returns the mass that a Soyuz-Fregat launcher can inject
%into a given escape velocity and asymptote declination. The data here
%refer to ESOC WP-521 and consider an elaborated five impulse strategy to
%exploit the launcher performances as much as possible.
SF = [
    0      0      0      0    0;
    100    100    100    100  100;
    1830.5 1815.9 1737.7 1588 1344.3;
    1910.8 1901.9 1819 1636.4 1369.3;
    2001.8 1995.3 1891.3 1673.9 1391.9;
    2108.8 2088.6 1947.9 1708 1409.5;
    2204 2167.3 1995.5 1734.5 1419.6;
    2270.8 2205.8 2013.6 1745.1 1435.2;
    2204.7 2133.6 1965.4 1712.8 1413.6;
    2087.9 2060.6 1917.7 1681.1 1392.5;
    1979.17 1975.4 1866.5 1649 1371.7;
    1886.9 1882.2 1801 1614.6 1350.5;
    1805.9 1796 1722.7 1571.6 1327.6;
    100    100    100    100  100;
    0      0      0      0    0];
X = [1 2 3 4 5];
Y = [-90 -65 -50 -40 -30 -20 -10 0 10 20 30 40 50 65 90];
m_initial = interp2(X,Y,SF,VINF,declination);

function m_initial = Atlas501(VINF,declination)
%This function returns the mass that a Soyuz-Fregat launcher can inject
%into a given escape velocity and asymptote declination. The data here
%refer to ESOC WP-521 and consider an elaborated five impulse strategy to
%exploit the launcher performances as much as possible.

A5= [
    0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0;
    1160,1100,1010,930,830,740,630,590,550;
    2335.0	,2195.0,2035.0,1865.0,1675.0,1480.0,1275.0,1175.0,1075.0;
    2335.0	,2195.0,2035.0,1865.0,1675.0,1480.0,1275.0,1175.0,1075.0;
    2335.0	,2195.0,2035.0,1865.0,1675.0,1480.0,1275.0,1175.0,1075.0;
    2335.0	,2195.0,2035.0,1865.0,1675.0,1480.0,1275.0,1175.0,1075.0;
    2335.0	,2195.0,2035.0,1865.0,1675.0,1480.0,1275.0,1175.0,1075.0;
    2335.0	,2195.0,2035.0,1865.0,1675.0,1480.0,1275.0,1175.0,1075.0;
    2335.0	,2195.0,2035.0,1865.0,1675.0,1480.0,1275.0,1175.0,1075.0;
    1160,1100,1010,930,830,740,630,590,550;
    0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0];


X = [2.5,3,3.5,4,4.5,5,5.5,5.75,6];
Y = [-40, -30,-29,-28.5, -20, -10, 0, 10, 20,28.5,29,30, 40];
if (abs(declination)>40) ||(VINF<2.5)||(VINF>6)
    m_initial = 0;
else
    m_initial = interp2(X,Y,A5,VINF,declination);
end


function requ=ecl2equ(recl)
incl=0.409072975;       %in radians.
RR=[1 0 0; 0 cos(incl) sin(incl); 0 -sin(incl) cos(incl)];
requ=RR'*recl;


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

%Programmed by:         Dario Izzo          (ESA/ACT)
%                       Claudio Bombardelli (ESA/ACT)

%Date:                  15/03/2007
%Revision:              4
%Tested by:             D.Izzo and C.Bombardelli
%
%
%  Computes the DeltaV cost function of a Multiple Gravity Assist trajectory
%  with a Deep Space Maneuver between each planet pair
%  N.B.: All swing-bys are UNPOWERED (thrust is only present at each dsm)
%  It takes as input a sequence of planets P1,Pn and a decision vector t
%
%  The flyby/dsm sequence is:  P1/d1/P2/d2/../dn-1/Pn
%

% DECISION VECTOR DEFINITION:
%
%  t(1)=  epoch of departure MJD2000 from first planet (not necessarily earth)
%  t(2)=  magnitude hyperbolic escape velocity from first planet
%  t(3,4)= u,v variables for the hyperbolic velocity orientation wrt Earth
%  velocity at departure
%  t(5..n+3)= planet-to-planet Time of Flight [ToF] (days)
%  t(n+4..2n-2)= fraction of ToF at which the DSM occurs
%  t(2n+3..3n) = perigee fly-by radius for planets P2..Pn-1, non-dimensional wrt planetary radii
%  t(3n+1..4n-2) = rotation gamma of the bplane-component of the swingby outgoing velocity (v_rel_out)
%  [take n_r=cross(v_rel_in,v_planet_helio) if you rotate n_r by +gamma around v_rel_in
%  you obtain the projection of v_rel_out on the b-plane]
%  Vector (Vout) around the axis of the incoming swingby velocity vector (Vin)
%

%Usage:     [J,DVvec,DVarr] = mga_dsm(t,MGADSMproblem)
%Outputs:
%           J:     Cost function = depends on the problem:
%                  orbit insertion: total DV from propulsion system (V_launcher not counted)
%                  gtoc1= (s/c final mass)*v_asteroid'*vrel_ast_sc
%                  asteroid deflection-> 1/d with d=deflecion on the earth-asteroid lineofsight
%           DVvec: vector of all DV maneuvers, including the escape C3 and
%                  the arrival DV evaluaed according to the objective function
%           DVarr: Relative velocity at the arrival planet
%
%
%Inputs:
%           t:         decision vector
%               MGADSMproblem = struct array defining the problem, i.e.
%               MGADSMproblem.sequence:  planet sequence. Example [3 3 4]= [E E M]. A
%                      negative sign represents a retrograde orbit after the fly-by
%               MGADSMproblem.objective.type: type of objective function (e.g.
%                       'orbit insertion','rndv','gtoc1')
%               MGADSMproblem.objective.rp: pericentre radius of the
%                       target orbit if type = 'orbit insertion'
%               MGADSMproblem.objective.e:  eccentricity of the target
%                       orbit if type = 'orbit insertion'
%               MGADSMproblem.bounds: decision vector upper and lower
%               bounds for the optimiser
%               MGADSMproblem.yplot:     1-> plot trajectory, 0-> don't
%
%
%*********  IMPORTANT NOTE (SINGULARITY)   ************
%
% The routine is singular when the S/C relative incoming  velocity to a planet v_rel_in
% is parallel to the heliocentric velocity of that planet.
%
% One can move the singularity elsewhere by changing the definition of the
% angle gamma.
% For example one possibility is to define gamma as follows:
% [take n_r=cross(v_rel_in,r_planet_helio) and rotate n_r by +gamma around v_rel_in
% in this case is singular for v_rel_in parallel to r_planet_helio
%
%
function [J,DVvec,DVrel] = mga_dsm(t,problem)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sequence= problem.sequence;  % THE PLANETs SEQUENCE


switch problem.objective.type
    case 'orbit insertion'
        rp_target= problem.objective.rp; % radius of pericentre at capture
        e_target=problem.objective.e;   % Eccentricity of the target orbit at capture
    case 'total DV orbit insertion'
        rp_target= problem.objective.rp; % radius of pericentre at capture
        e_target=problem.objective.e;   % Eccentricity of the target orbit at capture
    case 'gtoc1'
        Isp=problem.objective.Isp;
        mass = problem.objective.mass;
    case 'time to AUs'
        AUdist = problem.objective.AU;
        DVtotal = problem.objective.DVtot;
        DVonboard = problem.objective.DVonboard;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%**************************************************************************
%Definition of the gravitational constants of the various planets
%(used in the powered swing-by routine) and of the sun (used in the lambert
%solver routine)
%**************************************************************************

mu(1)=22321;          %                          Mercury
mu(2)=324860;         %Gravitational constant of Venus
mu(3)=398601.19;      %                          Earth
mu(4)=42828.3;        %                          Mars
mu(5)=126.7e6;        %                          Jupiter
mu(6)=37.93951970883e6; %                        Saturn

muSUN=1.32712428e+11; %Gravitational constant of Sun


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Definition of planetari radii
%
RPL(1)=2440; % Mercury
RPL(2)=6052; % Venus
RPL(3)=6378; % Earth
RPL(4)=3397; % Mars
RPL(5)=71492;% Jupiter
RPL(6)=60330;% Saturn


%**************************************************************************
% Decision vector definition

tdep=t(1);         % departure epoch (MJD2000)
VINF=t(2);         %Hyperbolic escape velocity (km/sec)
udir=t(3);            %Hyperbolic escape velocity var1 (non dim)
vdir=t(4);            %Hyperbolic escape velocity var2 (non dim)
N=length(sequence);

%Preallocating memory increase speed
tof = zeros(N-1,1);
alpha = zeros(N-1,1);

for i=1:N-1
    tof(i)=t(i+4); %planet-to-planet Time of Flight [ToF] (days)
    alpha(i)=t(N+i+3); %fraction of ToF at which the DSM occurs
end


%If we are optimising to reach a given distance in the shortest time ('time
%to AUs) then the decision vector needs to include also r_p and bincl at
%the last planet, otherwise not

if strcmp(problem.objective.type,'time to AUs')
    rp_non_dim=zeros(N-1,1);        %initialization gains speed
    gamma=zeros(N-1,1);
    for i=1:N-1
        rp_non_dim(i)=t(i+2*N+2); % non-dim perigee fly-by radius of planets P2..Pn (i=1 refers to the second planet)
        gamma(i)=t(3*N+i);        % rotation of the bplane-component of the swingby outgoing
        % velocity  Vector (Vout) around the axis of the incoming swingby velocity vector (Vin)
    end
else
    rp_non_dim=zeros(N-2,1);        %initialization gains speed
    gamma=zeros(N-2,1);
    for i=1:N-2
        rp_non_dim(i)=t(i+2*N+2); % non-dim perigee fly-by radius of planets P2..Pn-1 (i=1 refers to the second planet)
        gamma(i)=t(3*N+i);        % rotation of the bplane-component of the swingby outgoing
        % velocity  Vector (Vout) around the axis of the incoming swingby velocity vector (Vin)
    end
end

%**************************************************************************
%Evaluation of position and velocities of the planets
%**************************************************************************

N=length(sequence);

r= zeros(3,N);
v= zeros(3,N);

muvec=zeros(N,1);
Itime = zeros(N);
dT=zeros(1,N);

seq = abs (sequence);

T=tdep;
dT(1:N-1)=tof;

for i=1:N
    Itime(i)=T;
    if seq(i)<10
        [r(:,i),v(:,i)]=pleph_an( T , seq(i)); %positions and velocities of solar system planets
        muvec(i)=mu(seq(i)); %gravitational constants
    else
        [r(:,i),v(:,i)]=CUSTOMeph( mjd20002jed(T) , ...
            problem.customobject(seq(i)).epoch, ...
            problem.customobject(seq(i)).keplerian , 1); %positions and velocities of custom object
        muvec(i)=problem.customobject(seq(i)).mu; %gravitational constant of custom object

    end

    T=T+dT(i);

end



if strcmp(problem.objective.type,'time to AUs')
    rp=zeros(N-1,1);        %initialization gains speed
    for i=1:N-1
        rp(i)= rp_non_dim(i)*RPL(seq(i+1)); %dimensional flyby radii (i=1 corresponds to 2nd planet)
    end
else
    rp=zeros(N-2,1);        %initialization gains speed
    for i=1:N-2
        rp(i)= rp_non_dim(i)*RPL(seq(i+1)); %dimensional flyby radii (i=1 corresponds to 2nd planet)
    end
end


%**************************************************************************
%%%% FIRST BLOCK (P1 to P2)

%Spacecraft position and velocity at departure

vtemp= cross(r(:,1),v(:,1));

iP1= v(:,1)/norm(v(:,1));
zP1= vtemp/norm(vtemp);
jP1= cross(zP1,iP1);


theta=2*pi*udir;         %See Picking a Point on a Sphere
phi=acos(2*vdir-1)-pi/2; %In this way: -pi/2<phi<pi/2 so phi can be used as out-of-plane rotation

%vinf=VINF*(-sin(theta)*iP1+cos(theta)*cos(phi)*jP1+sin(phi)*cos(theta)*zP1);
vinf=VINF*(cos(theta)*cos(phi)*iP1+sin(theta)*cos(phi)*jP1+sin(phi)*zP1);

v_sc_pl_in(:,1)=v(:,1); %Spacecraft absolute incoming velocity at P1
v_sc_pl_out(:,1)=v(:,1)+vinf; %Spacecraft absolute outgoing velocity at P1

%Days from P1 to DSM1
tDSM(1)=alpha(1)*tof(1);

%Computing S/C position and absolute incoming velocity at DSM1
[rd(:,1),v_sc_dsm_in(:,1)]=propagateKEP(r(:,1),v_sc_pl_out(:,1),tDSM(1)*24*60*60,muSUN);

%Evaluating the Lambert arc from DSM1 to P2

lw=vett(rd(:,1),r(:,2));
lw=sign(lw(3));
if lw==1
    lw=0;
else
    lw=1;
end
[v_sc_dsm_out(:,1),v_sc_pl_in(:,2)]=lambertI(rd(:,1),r(:,2),tof(1)*(1-alpha(1))*24*60*60,muSUN,lw);

%First Contribution to DV (the 1st deep space maneuver)
DV=zeros(N-1,1);
DV(1)=norm(v_sc_dsm_out(:,1)-v_sc_dsm_in(:,1));


%****************************************
% INTERMEDIATE BLOCK

tDSM=zeros(N-1,1);
for i=1:N-2

    %Evaluation of the state immediately after Pi

    v_rel_in=v_sc_pl_in(:,i+1)-v(:,i+1);

    e=1+rp(i)/muvec(i+1)*v_rel_in'*v_rel_in;

    beta_rot=2*asin(1/e);              %velocity rotation

    ix=v_rel_in/norm(v_rel_in);
    % ix=r_rel_in/norm(v_rel_in);  % activating this line and disactivating the one above
    % shifts the singularity for r_rel_in parallel to v_rel_in

    iy=vett(ix,v(:,i+1)/norm(v(:,i+1)))';
    iy=iy/norm(iy);
    iz=vett(ix,iy)';
    iVout = cos(beta_rot) * ix + cos(gamma(i))*sin(beta_rot) * iy + sin(gamma(i))*sin(beta_rot) * iz;
    v_rel_out=norm(v_rel_in)*iVout;

    v_sc_pl_out(:,i+1)=v(:,i+1)+v_rel_out;


    %Days from Pi to DSMi
    tDSM(i+1)=alpha(i+1)*tof(i+1);


    %Computing S/C position and absolute incoming velocity at DSMi
    [rd(:,i+1),v_sc_dsm_in(:,i+1)]=propagateKEP(r(:,i+1),v_sc_pl_out(:,i+1),tDSM(i+1)*24*60*60,muSUN);


    %Evaluating the Lambert arc from DSMi to Pi+1

    lw=vett(rd(:,i+1),r(:,i+2));
    lw=sign(lw(3));
    if lw==1
        lw=0;
    else
        lw=1;
    end
    [v_sc_dsm_out(:,i+1),v_sc_pl_in(:,i+2)]=lambertI(rd(:,i+1),r(:,i+2),tof(i+1)*(1-alpha(i+1))*24*60*60,muSUN,lw);

    %DV contribution
    DV(i+1)=norm(v_sc_dsm_out(:,i+1)-v_sc_dsm_in(:,i+1));

end

%************************************************************************
% FINAL BLOCK
%
%1)Evaluation of the arrival DV
%
DVrel=norm(v(:,N)-v_sc_pl_in(:,N)); %Relative velocity at target planet


switch problem.objective.type
    case 'orbit insertion'
        DVper=sqrt(DVrel^2+2*muvec(N)/rp_target);  %Hyperbola
        DVper2=sqrt(2*muvec(N)/rp_target-muvec(N)/rp_target*(1-e_target)); %Ellipse
        DVarr=abs(DVper-DVper2);
    case 'total DV orbit insertion'
        DVper=sqrt(DVrel^2+2*muvec(N)/rp_target);  %Hyperbola
        DVper2=sqrt(2*muvec(N)/rp_target-muvec(N)/rp_target*(1-e_target)); %Ellipse
        DVarr=abs(DVper-DVper2);
    case 'rndv'
        DVarr = DVrel;
    case 'total DV rndv'
        DVarr = DVrel;
    case 'gtoc1'
        DVarr = DVrel;
    case 'time to AUs'  %no DVarr is considered
        DVarr = 0;
end

DV(N)=DVarr;


%
%**************************************************************************
%Evaluation of total DV spent by the propulsion system
%**************************************************************************

switch problem.objective.type
    case 'gtoc1'
        DVtot=sum(DV(1:N-1));
    case 'deflection demo'
        DVtot=sum(DV(1:N-1));
    otherwise
        DVtot=sum(DV);
end


DVvec=[VINF ; DV];




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Finally our objective function is:
switch problem.objective.type
    case 'total DV orbit insertion'
        J= DVtot+VINF;
    case 'total DV rndv'
        J= DVtot+VINF;
    case 'orbit insertion'
        J= DVtot;
    case 'rndv'
        J= DVtot;
    case 'gtoc1'
        mass_fin = mass * exp (- DVtot/ (Isp/1000 * 9.80665));
        J = 1/(mass_fin * abs((v_sc_pl_in(:,N)-v(:,N))'* v(:,N)));
    case 'deflection demo'
        mass_fin = mass * exp (- DVtot/ (Isp/1000 * 9.80665));
        %non-dimensional units (mu=1)
        AU=149597870.66;
        VEL=sqrt(muSUN/AU);
        TIME=AU/VEL;
        %calculate the DV due to the impact
        relV = (V(:,N,1)-v(:,N));
        impactDV = (relV * mass_fin/astmass)/VEL;
        %calculate phi (see defl_radial.m)
        ir = r(:,N)/norm(r(:,N));
        iv = v(:,N)/norm(v(:,N));
        ih = vett(ir,iv)';
        ih = ih/norm(ih);
        itheta = vett(ih,ir)';
        impactDV = (impactDV'*ir) * ir + (impactDV'*itheta) * itheta; %projection on the orbital plane
        phi = acos((impactDV/norm(impactDV))'*ir);
        if (impactDV'*itheta) < 0
            phi = phi +pi;
        end
        %calculate ni0
        r0 = r(:,N)/AU;
        v0 = v(:,N)/VEL;
        E0 = IC2par( r0 , v0 , 1 );
        ni0 = E2ni(E0(6),E0(2));
        %calcuate the deflection projected in covenient coordinates
        a0 = E0(1);
        e0 = E0(2);
        M0 = E2M(E0(6),E0(2));
        numberofobs = 50;
        obstime = linspace(0,obstime,numberofobs);
        M = M0 + obstime*60*60*24/TIME*sqrt(1/a0);
        theta=zeros(numberofobs,1);
        for jj = 1:numberofobs
            theta(jj) = M2ni(M(jj),E0(2));
        end
        theta = theta-ni0;
        [dumb,dr] = defl_radial(a0,e0,ni0,phi,norm(impactDV),theta);

        [dumb,dtan] = defl_tangential(a0,e0,ni0,phi,norm(impactDV),theta);

        %calculate the deflecion on the Earth-asteroid lineofsight
        defl=zeros(3,numberofobs);
        temp=zeros(numberofobs,1);
        for i=1:numberofobs
            Tobs = T + obstime(i);
            [rast,vast]=CUSTOMeph( mjd20002jed(Tobs) , ...
                problem.customobject(seq(end)).epoch, ...
                problem.customobject(seq(end)).keplerian , 1);
            [rearth,vearth]=pleph_an( Tobs , 3);
            lineofsight=(rearth-rast)/norm((rearth-rast));
            defl(:,i) = rast / norm(rast) * dr(i) + ...
                vast / norm(vast) * dtan(i);
            temp(i) = norm(lineofsight'*(defl(:,i)));

        end

        J = 1./abs(temp)/AU;
        [J,index]=min(J);
    case 'time to AUs'
        %non dimensional units
        AU  = 149597870.66;
        V = sqrt(muSUN/AU);
        T = AU/V;
        %evaluate the state of the spacecraft after the last fly-by
        v_rel_in=v_sc_pl_in(:,N)-v(:,N);
        e=1+rp(N-1)/muvec(N)*v_rel_in'*v_rel_in;
        beta_rot=2*asin(1/e);              %velocity rotation
        ix=v_rel_in/norm(v_rel_in);
        % ix=r_rel_in/norm(v_rel_in);  % activating this line and disactivating the one above
        % shifts the singularity for r_rel_in parallel to v_rel_in
        iy=vett(ix,v(:,N)/norm(v(:,N)))';
        iy=iy/norm(iy);
        iz=vett(ix,iy)';
        iVout = cos(beta_rot) * ix + cos(gamma(N-1))*sin(beta_rot) * iy + sin(gamma(N-1))*sin(beta_rot) * iz;
        v_rel_out=norm(v_rel_in)*iVout;
        v_sc_pl_out(:,N)=v(:,N)+v_rel_out;
        t = time2distance(r(:,N)/AU,v_sc_pl_out(:,N)/V,AUdist);
        DVpen=0;
        if sum(DVvec)>DVtotal
            DVpen=DVpen+(sum(DVvec)-DVtotal);
        end
        if sum(DVvec(2:end))>DVonboard
            DVpen=DVpen+(sum(DVvec(2:end))-DVonboard);
        end

        J= (t*T/60/60/24 + sum(tof))/365.25 + DVpen*100;
        if isnan(J)
            J=100000;
        end
end




%--------------------------------------------------------------------------
function [r,v] = propagateKEP(r0,v0,t,mu)
%
%Usage: [r,v] = propagateKEP(r0,v0,t)
%
%Inputs:
%           r0:    column vector for the non dimensional position
%           v0:    column vector for the non dimensional velocity
%           t:     non dimensional time
%
%Outputs:
%           r:    column vector for the non dimensional position
%           v:    column vector for the non dimensional velocity
%
%Comments:  The function works in non dimensional units, it takes an
%initial condition and it propagates it as in a kepler motion analytically.
%
%The matrix DD will be almost always the unit matrix, except for orbits
%with little inclination in which cases a rotation is performed so that
%par2IC is always defined
DD=eye(3);
h=vett(r0,v0);
ih=h/norm(h);
if abs(abs(ih(3))-1)<1e-3         %the abs is needed in cases in which the orbit is retrograde,
                                  %that would held ih=[0,0,-1]!!
    DD=[1,0,0;0,0,1;0,-1,0];      %Random rotation matrix that make the Euler angles well defined for the case
    r0=DD*r0;                     %For orbits with little inclination another ref. frame is used.
    v0=DD*v0;
end

E=IC2par(r0,v0,mu);  

M0=E2M(E(6),E(2));
if E(2)<1
    M=M0+sqrt(mu/E(1)^3)*t;
else
    M=M0+sqrt(-mu/E(1)^3)*t;
end
E(6)=M2E(M,E(2));
[r,v]=par2IC(E,mu);

r=DD'*r;                    
v=DD'*v;


%--------------------------------------------------------------------------%
function E=IC2par(r0,v0,mu)
%
%Usage: E = IC2par(r0,v0,mu)
%
%Inputs:
%           r0:    column vector for the position
%           v0:    column vector for the velocity
%
%Outputs:
%           E:     Column Vectors containing the six keplerian parameters,
%                  (a (negative for hyperbolas),e,i,OM,om,Eccentric Anomaly
%                  (or Gudermannian whenever e>1))
%
%Comments:  The parameters returned are, of course, referred to the same
%ref. frame in which r0,v0 are given. Units have to be consistent, and
%output angles are in radians
%The algorithm used is quite common and can be found as an example in Bate,
%Mueller and White. It goes singular for zero inclination and for ni=pi
%Note also that the anomaly in output ranges from -pi to pi
%Note that a is negative for hyperbolae

k=[0,0,1]';
h=vett(r0,v0)';
p=h'*h/mu;
n=vett(k,h)';
n=n/norm(n);
R0=norm(r0);
evett=vett(v0,h)'/mu-r0/R0;
e=evett'*evett;
E(1)=p/(1-e);
E(2)=sqrt(e);
e=E(2);
E(3)=acos(h(3)/norm(h));
E(5)=(acos((n'*evett)/e));
if evett(3)<0
    E(5)=2*pi-E(5);
end
E(4)=acos(n(1));
if n(2)<0
    E(4)=2*pi-E(4);
end
ni=real(acos((evett'*r0)/e/R0)); %real is to avoid problems when ni~=pi
if (r0'*v0)<0
    ni=2*pi-ni;
end
EccAn=ni2E(ni,e);
E(6)=EccAn;


%--------------------------------------------------------------------------
function E=ni2E(ni,e)
if e<1
    E=2*atan(sqrt((1-e)/(1+e))*tan(ni/2)); %algebraic kepler's equation
else
    E=2*atan(sqrt((e-1)/(e+1))*tan(ni/2)); %algebraic equivalent of kepler's equation in terms of the Gudermannian
end



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



%--------------------------------------------------------------------------
function [v1,v2,a,p,theta,iter]=lambertI(r1,r2,t,mu,lw,N,branch)
%
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
%
%Preliminary control on the function call
if nargin==5
    N=0;
end
if t<=0
    warning('Negative time as input')
    v1=[NaN;NaN;NaN];
    v2=[NaN;NaN;NaN];
    return
end


tol=1e-11;  %Increasing the tolerance does not bring any advantage as the 
%precision is usually greater anyway (due to the rectification of the tof
%graph) except near particular cases such as parabolas in which cases a
%lower precision allow for usual convergence.


%Non dimensional units
R=norm(r1);
V=sqrt(mu/R);
T=R/V;

%working with non-dimensional radii and time-of-flight
r1=r1/R;
r2=r2/R;
t=t/T;                     

%Evaluation of the relevant geometry parameters in non dimensional units
r2mod=norm(r2);
theta=acos(r1'*r2/r2mod);

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
%Subfunction that evaluates the time of flight as a function of x
function t=x2tof(x,s,c,lw,N)  

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
%
%subfunction that evaluates the time of flight via Lagrange expression
%
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
%
%subfunction that evaluates vector product
ansd(1)=(r1(2)*r2(3)-r1(3)*r2(2));
ansd(2)=(r1(3)*r2(1)-r1(1)*r2(3));
ansd(3)=(r1(1)*r2(2)-r1(2)*r2(1));




%--------------------------------------------------------------------------
function  [r,v,E]=pleph_an ( mjd2000, planet);
%
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
%           planet:     Integer form 1 to 9 containing the number
%           of the planet (Mercury, Venus, Earth, Mars, Jupiter, Saturn,
%           Uranus, Neptune, Pluto) 
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
KM  = 149597870.66;        %Astronomical Unit 149597870.66;



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

%Calcolo velocità e posizione nel sistema J2000
[r,v]=conversion(E);



%--------------------------------------------------------------------------
function [r,v] = conversion (E)
%
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
i=0;
tol=1e-10;
err=1;
E=M+e*cos(M);   %initial guess
while err>tol && i<100
    i=i+1;
    Enew=E-(E-e*sin(E)-M)/(1-e*cos(E));
    err=abs(E-Enew);
    E=Enew;
end


%--------------------------------------------------------------------------
function M=E2M(E,e)
%
%Transforms the eccentric anomaly to mean anomaly. All i/o in radians  
%
%Usage: M=E2M(E,e)
%
%Inputs :   E : Eccentric anomaly or Gudermannian if e>1
%           e : Eccentricity of considered orbit
%
%Output :   M : Mean anomaly or N if e>1

if e<1 %Ellipse, E is the eccentric anomaly
    M=E-e*sin(E);
else  %Hyperbola, E is the Gudermannian
    M=e*tan(E)-log(tan(E/2+pi/4));
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

global AU mu

muSUN = mu(11);
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
function t = time2distance(r0,v0,rtarget)
%
%Usage: t = time2distance(r0,v0,rtarget)
%
%Inputs:
%           r0:    column vector for the position (mu=1)
%           v0:    column vector for the velocity (mu=1)
%           rtarget: distance to be reached
%
%Outputs:
%           t:     time taken to reach a given distance
%
%Comments:  everything works in non dimensional units

r0norm = norm(r0);
if r0norm < rtarget
    out = sign(r0'*v0);
    E = IC2par(r0,v0,1);
    a = E(1); e = E(2); E0 = E(6); p = a * (1-e^2);
    %If the solution is an ellipse 
    if e<1
        ra = a * (1+e);
        if rtarget>ra
            t = NaN;
        else %we find the anomaly where the target distance is reached
            ni = acos((p/rtarget-1)/e);         %in 0-pi
            Et = ni2E(ni,e);          %in 0-pi
            if out==1
                t = a^(3/2)*(Et-e*sin(Et)-E0 +e*sin(E0));
            else
                E0 = -E0;
                t = a^(3/2)*(Et-e*sin(Et)+E0 - e*sin(E0));
            end
        end
    else %the solution is a hyperbolae
        ni = acos((p/rtarget-1)/e);         %in 0-pi
        Et = ni2E(ni,e);          %in 0-pi
        if out==1
                t = (-a)^(3/2)*(e*tan(Et)-log(tan(Et/2+pi/4))-e*tan(E0)+log(tan(E0/2+pi/4)));
            else
                E0 = -E0;
                t = (-a)^(3/2)*(e*tan(Et)-log(tan(Et/2+pi/4))+e*tan(E0)-log(tan(E0/2+pi/4)));
        end
    end
else
    t=12;
end
    

%--------------------------------------------------------------------------
function jd = mjd20002jed(mjd2000)
%This function converts mean julian date 2000 to julian date
jd=mjd2000+2451544.5;


%--------------------------------------------------------------------------
function jd = mjd2jed(mjd)
% This function converts mean Julian date into Julian date
jd = mjd +2400000.5;


