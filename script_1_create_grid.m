% Load template map to match
template = double(rgb2gray(imread("template.png")));
g.szt = size(template);
% figure; imagesc(template); colormap(gray); axis equal tight;


% Load the code template and assign name
flrc = dir('templateCode/');
flrc = flrc(contains({flrc.name},"templateCode"));
templateCode=nan(24,24,numel(flrc));
code=strings(1,numel(flrc));
codeName=strings(2,numel(flrc));
for i_f=1:numel(flrc)
    tmp = imread(['templateCode/' flrc(i_f).name]);
    if size(tmp,3)==3
        tmp = rgb2gray(tmp);
    end
    templateCode(:,:,i_f) = tmp;
    for i=1:2
        code(i_f) = flrc(i_f).name(14:15);
        switch flrc(i_f).name(13+i)
            case "0"
                codeName(i,i_f)="none";
            case "1"
                codeName(i,i_f)="presence";
            case "2"
                codeName(i,i_f)="probable";
            case "3"
                codeName(i,i_f)="confirmed";
            case "x"
                codeName(i,i_f)="unknown";
        end
    end
end

%% 
% define the grid on which to extract the information. Unit is pixel of
% template/page.
g.dx=56/2;
g.dy=56/2;
g.x0=18; % first pixel position
g.y0=24;
g.x=g.x0:g.dx:g.szt(2);
g.y=g.y0:g.dy:g.szt(1);
[g.X,g.Y] = meshgrid(g.x,g.y);

% Convert to lat lon
dll=.5;
g.lon = 33.25 + dll*(g.x-g.x0)/g.dx;
g.lat = 5.25 - dll*(g.y-g.y0)/g.dy;
[g.LON,g.LAT] = meshgrid(g.lon,g.lat);

% Build the mask of value within kenya.
tmp = double(rgb2gray(imread("template_mask.png")))>0;
g.mask = ~(tmp(g.y,g.x)==0);

% extend the mask to the same grid as template.
F=griddedInterpolant({g.y,g.x},double(g.mask),'nearest');
g.mask_extend = F({1:g.szt(1),1:g.szt(2)});

figure; hold on; set(gca,"YDir","reverse")
imagesc(template, "alphadata", g.mask_extend);
colormap(gray); axis equal tight;
scatter(g.X(g.mask),g.Y(g.mask),'k')
xline(g.x); yline(g.y)

% Create the table of the grid 
tmp=struct();
tmp1 = jsondecode(fileread('../Rcode/grid.geojson'));
for i_f=1:numel(tmp1.features)
    tmp2 = tmp1.features(i_f).geometry.coordinates(:,:,1);
    tmp3 = tmp1.features(i_f).geometry.coordinates(:,:,2);
    tmp(i_f).SqL = string(tmp1.features(i_f).properties.SqL);
    tmp(i_f).SqN = tmp1.features(i_f).properties.SqN;
    tmp(i_f).lon = mean(tmp2(1:4));
    tmp(i_f).lat = mean(tmp3(1:4));
end
tg = struct2table(tmp);

figure; hold on;
imagesc([g.lon(1)-dll g.lon(end)+dll],[g.lat(1)+dll g.lat(end)-dll],template, "alphadata", g.mask_extend);
colormap(gray); axis equal tight;
scatter(g.LON(g.mask),g.LAT(g.mask),'k')
xline(g.lon); yline(g.lat)
plot(tg.lon,tg.lat,'.r')

% Assign SQL SQN code to grid
tmp = g.LAT(:)==tg.lat' & g.LON(:)==tg.lon';
[r,c]=ind2sub(size(tmp),find(tmp));
g.sqL = strings(size(g.LAT));
g.sqN = strings(size(g.LAT));
g.sqL(r) = tg.SqL(c);
g.sqN(r) = tg.SqN(c);


%% Save grid
save('data/grid','g')

%% Export data for app
gX=g.X(g.mask); 
gY=g.Y(g.mask);
save('data/data_fix','templateCode','template','gX','gY','codeName')
