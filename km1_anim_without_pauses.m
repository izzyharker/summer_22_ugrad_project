%Animating the intersection of a surface and a 
%rotating plane
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
vid = VideoWriter("km1_anim_without_pauses.avi");
open(vid)

ax = gca;
for a=1:total
    %Plane intersection
    theta = (1-a)*pi/(total) + pi;
    p = (hel.vertices(:,1) - x_1)*cos(theta) + (hel.vertices(:,3) - z_1)*sin(theta);

    %Using p to mask the surface
    mask=p>0;
    outcount = sum(mask(hel.faces),2);
    cross = (outcount==1) | (outcount==2);
    crossing_tris = hel.faces(cross,:);
    cla
    ct = patch('Vertices',hel.vertices,'Faces',crossing_tris,'EdgeColor',[1 .5 0],'FaceColor',[.5 1 .5]);
    

    out_vert = mask(crossing_tris);
    flip = sum(out_vert,2) == 1;
    out_vert(flip,:) = 1-out_vert(flip,:);
    
    %Smoothing the line of intersection
    ntri = size(out_vert,1);
    overt = zeros(ntri,3);
    for i=1:ntri
        v1i = find(~out_vert(i,:));
        v2i = 1 + mod(v1i,3);
        v3i = 1 + mod(v1i+1,3);
        overt(i,:) = crossing_tris(i,[v1i v2i v3i]);
    end
    
    u = (0 - p(overt(:,1))) ./ (p(overt(:,2)) - p(overt(:,1)));
    v = (0 - p(overt(:,1))) ./ (p(overt(:,3)) - p(overt(:,1)));
    
    uverts = repmat((1-u),[1 3]).*hel.vertices(overt(:,1),:) + repmat(u,[1 3]).*hel.vertices(overt(:,2),:);
    vverts = repmat((1-v),[1 3]).*hel.vertices(overt(:,1),:) + repmat(v,[1 3]).*hel.vertices(overt(:,3),:);
    
    x = nan(3,ntri);
    x(1,:) = uverts(:,1)';
    x(2,:) = vverts(:,1)';
    y = nan(3,ntri);
    y(1,:) = uverts(:,2)';
    y(2,:) = vverts(:,2)';
    z = nan(3,ntri);
    z(1,:) = uverts(:,3)';
    z(2,:) = vverts(:,3)';
    
    h = line(x(:),y(:),z(:));
    
    %Graphing the line and the portion of the surface below the line
    delete(ct)
    h.Color = ax.ColorOrder(5,:);
    h.LineWidth = 2;
    
    end_cam = [sqrt(73)*cos(theta1+a*(theta2-theta1)/total) sqrt(73)*sin(theta1+a*(theta2-theta1)/total) 5];

    crossing_tris_2 = hel.faces(outcount==0,:);
    p2 = patch('Vertices',hel.vertices,'Faces',crossing_tris_2,'FaceColor',ax.ColorOrder(2,:),'EdgeColor','none');
    view(3)
    set(ax,'XLim',[-lim lim],'YLim',[-lim lim],'ZLim',[-lim lim],'DataAspectRatio',[1 1 1])
    light('Position',[-7 -8 90])
    light('Position',[-1 1 .25])
    set(p2,'SpecularStrength',.6,'DiffuseStrength',.85,'AmbientStrength',.15,'BackFaceLighting','reverselit')
    set(ax,'CameraPosition',end_cam,'CameraUpVector',[0 0 1])
    xlabel('x')
    ylabel('y')
    zlabel('z')
    
    formatSpec = '%.4f';
    %title(ax, ['plane: ', num2str(cos(theta), formatSpec), 'x + ', num2str(sin(theta), formatSpec), 'z = ', num2str(cos(theta)*x_1 + sin(theta)*z_1, formatSpec)])

    box off

    hold on

    xt = @(t) x_1;
    zt = @(t) z_1;
    yt = @(t) t;
    fplot3(gca, xt, yt, zt, [-lim lim], 'LineWidth', 2, 'Color', 'red')

    M(1) = getframe(gcf);
    writeVideo(vid, M(1))
end

close(vid);


