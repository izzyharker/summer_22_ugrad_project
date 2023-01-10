%Animating a plane rotating in a surface
%Summer 2022
%Author: Isabella Harker
%-----------------------

lim = 4;
z_1 = 0.236792032999024;
x_1 = (z_1)/4 - 3/8;

%Equation for the surface
[x3, y3,z3] = meshgrid(linspace(-lim, lim, 150), ...
                   linspace(-lim, lim, 150), ...
                   linspace(-lim, lim, 150));

f2 = 4.*x3.^3-12.*x3.*y3.^2+3.*x3.^2.*z3+3.*y3.^2.*z3-(17/2).*z3.^3-(9/2).*x3.^2-(9/2).*y3.^2-12.*z3.^2-3.*z3+2;
hel = isosurface(x3, y3, z3, f2, 0);

%Defining loop variables
h = figure;
loops = 121; 
lines = 60;
total = 6*loops;
inside = 0;
start_cam = [-8 -3 5];

%Creating the movie and video objects
M(1) = struct('cdata', [], 'colormap', []);

theta1 = pi + asin(8/sqrt(73));
theta2 = 2*pi - asin(7/sqrt(74));

h.Visible = "on";
vid = VideoWriter("km1_plane_anim_without_pause_rotation.avi");
open(vid)

ax = gca;
for a=1:total
    %Angle of the plane
    theta = (1-a)*pi/(total) + pi;

    end_cam = [sqrt(73)*cos(theta1+a*(theta2-theta1)/total) sqrt(73)*sin(theta1+a*(theta2-theta1)/total) 5];
    
    %Graphing the surface
    patch(hel, 'FaceColor', [0 0.5 0.5], 'EdgeColor', 'none');
    view(3)
    if (a == 1)
        camlight
    end
    set(ax,'XLim',[-lim lim],'YLim',[-lim lim],'ZLim',[-lim lim],'DataAspectRatio',[1 1 1])
    set(ax,'CameraPosition',end_cam,'CameraUpVector',[0 0 1])
    xlabel('x')
    ylabel('y')
    zlabel('z')

    hold on
    
    %Graphing the plane
    p2 = cos(theta).*x3 + sin(theta).*z3 - cos(theta)*x_1 - sin(theta)*z_1;
    p = isosurface(x3, y3, z3, p2, 0);
    pla = patch(p, 'FaceColor', [0.8 0.2 0.8], 'EdgeColor', 'none');

    formatSpec = '%.4f';
    title(ax, ['plane: ', num2str(cos(theta), formatSpec), 'x + ', num2str(sin(theta), formatSpec), 'z = ', num2str(cos(theta)*x_1 + sin(theta)*z_1, formatSpec)])
    
    box off

    xt = @(t) x_1;
    zt = @(t) z_1;
    yt = @(t) t;
    fplot3(gca, xt, yt, zt, [-lim lim], 'LineWidth', 2, 'Color', [1 0.5 0.5])

    M(1) = getframe(gcf);
    writeVideo(vid, M(1))

    delete(pla)
    hold off
end

close(vid);


