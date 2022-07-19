%% 2D wave equation solution with explicit central differences in space and time

clc;close all;clear all

%% domain
Nx=101;Ny=101; %odd numbers
dx=1; dy=1;
xc=(Nx+1)/2;yc=(Ny+1)/2; %centre of the domain
x=(0:Nx-1)*dx; %coordiantes 1D vectors
y=(0:Ny-1)*dy;
[X Y]=meshgrid(x,y); % coordinates 2D matrices

C=0.5; % Courant number <<1
v=80;  % wave speed
dt=(C/v)*dx; %stable time step

video=0; % record video?

if video==1
    writerObj = VideoWriter('wave_eq_2D.mp4','MPEG-4');
    writerObj.FrameRate=25;
    writerObj.Quality=75;
    open(writerObj);
end
opengl hardware % or software

%% Perturbation (droplet) (e.g. initial condition)

width=15; % size of the droplet
height=10; % amplitude of the droplet

[x,y] = ndgrid(-1:(2/(width-1)):1);
D = height*exp(-5*(x.^2+y.^2)); % gaussian, higher the coefficint "5" the tigher is distribution

w = size(D,1); % width 
dropcentre=0.5;%rand;
i1 = ceil(dropcentre*(Ny-w))+(1:w);
j1 = ceil(dropcentre*(Nx-w))+(1:w);
%%
U=zeros(Ny,Nx,2);  % Initial Conditions
U(i1,j1,1)=U(i1,j1,1)+D; % initial condition + droplet
U(i1,j1,2)=U(i1,j1,2)+D;

%% Plotting

levels=-5:0.025:5;
[col,h]=contourf(X,Y,U(:,:,1),levels);

colorbar
caxis([-1 1]); caxis manual
 h.LineStyle='none'; % do not show isolines
colormap jet
shading interp
 whitebg([0 0 0])
title('2D Wave equation in a box')
xlabel('X');
ylabel('Y');

daspect([1 1 1]);
hold on;

t=0;

j=2:Ny-1; % internal nodes
i=2:Nx-1; % internal nodes

iter=1;

while (iter<3000) && ishandle(h) % stop when iter>=300 or figure is closed
    iter=iter+1;
    t=dt*(iter-1);    
    % 2D wave equation in FD form
    U(j,i,iter+1) =2*U(j,i,iter)-U(j,i,iter-1)+C^2*(((U(i-1,j,iter)-2*U(i,j,iter)+U(i+1,j,iter))/dx^2)+((U(i,j-1,iter)-2*U(i,j,iter)+U(i,j+1,iter))/dy^2));

   % if mod(iter,2)==0 % show every 2 iter
        h.ZData=U(1:Ny,1:Nx,iter);
    %end
    

    title(['Wave equation in 2D, t = ' num2str(iter*dt,'%3.3f') ', iter=' num2str(iter)])
    drawnow

 if video==1
    frame = getframe(gcf);          % capture frame
    writeVideo(writerObj,frame); 
end% write frame to video file
end
if video==1
    close(writerObj); 
end












