%Animating a plane rotating in a surface, pausing at specific points
%Summer 2022
%Author: Isabella Harker
%-----------------------

lim = 4;
z_1 = 0.236792032999024;
x_1 = (z_1)/4 - 3/8;


%Equation for the figure
[x3, y3,z3] = meshgrid(linspace(-lim, lim, 150), ...
                   linspace(-lim, lim, 150), ...
                   linspace(-lim, lim, 150));

f2 = 4.*x3.^3-12.*x3.*y3.^2+3.*x3.^2.*z3+3.*y3.^2.*z3-(17/2).*z3.^3-(9/2).*x3.^2-(9/2).*y3.^2-12.*z3.^2-3.*z3+2;
hel = isosurface(x3, y3, z3, f2, 0);

%Defines loop variables
h = figure;
loops = 121; 
lines = 60;
total = 6*loops;
inside = 0;
start_cam = [-8 -3 5];

%Creating the movie and video objects
M(1) = struct('cdata', [], 'colormap', []);

h.Visible = "on";
vid = VideoWriter("km1_plane_with_pauses.avi");
open(vid)

ax = gca;
for a=1:total
    %Angle of plane
    theta = (1-a)*pi/(total) + pi;
    inside = 0;
    
    end_cam = [sqrt(73)*cos(theta1+a*(theta2-theta1)/total) sqrt(73)*sin(theta1+a*(theta2-theta1)/total) 5];

    %Graphing the surface
    patch(hel, 'FaceColor', [0 1 1], 'EdgeColor', 'none');
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
    p2 = cos(theta).*(x3 - x_1) + sin(theta).*(z3 - z_1);
    p = isosurface(x3, y3, z3, p2, 0);
    pla = patch(p, 'FaceColor', [1 0 1], 'EdgeColor', 'none');

    formatSpec = '%.4f';
    title(ax, ['plane: ', num2str(cos(theta), formatSpec), 'x + ', num2str(sin(theta), formatSpec), 'z = ', num2str(cos(theta)*x_1 + sin(theta)*z_1, formatSpec)])

    box off

    xt = @(t) x_1;
    zt = @(t) z_1;
    yt = @(t) t;
    fplot3(gca, xt, yt, zt, [-lim lim], 'LineWidth', 2, 'Color', 'red')

    %Values for pausing
    if (a==10)
        inside=1;
    end
    if (a == 57)
        inside=1;
    end
    if (a==365)
        inside = 1;
    end
    if (a == 465)
        inside = 1;
    end
    if (a == 589)
        inside = 1;
    end

    if (inside == 1)
        for i=1:lines
            M(1) = getframe(gcf);
            writeVideo(vid, M(1))
        end
    end
    if (inside == 0)
        M(1) = getframe(gcf);
        writeVideo(vid, M(1))
    end
    delete(pla)
    hold off
end

close(vid);


