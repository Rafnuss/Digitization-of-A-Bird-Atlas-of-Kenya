load('data/grid')
load('data/data_fix.mat')

%% Read filename
flname = readtable('data/filename.xlsx', 'TextType', 'string');

%% Load exisiting data
old_atlas = readtable("data/data_version_2022_RN/A Bird Atlas of Kenya_v5.xlsx", 'TextType', 'string');

% Add breeding code
old_atlas.pre_1970(ismissing(old_atlas.pre_1970))="none";
old_atlas.x1970_1984(ismissing(old_atlas.x1970_1984))="none";
codeName2=codeName;
codeName2(codeName2=="unknown")="none";
old_atlas.code = sum(cumsum(fliplr(old_atlas.pre_1970 == codeName2(1,:) & old_atlas.x1970_1984 == codeName2(2,:)),2),2);

% Get species list
sp_old_atlas = sortrows(unique(old_atlas(:,1:3)));
sp_old_atlas(sp_old_atlas.SEQ==0,:)=[];

% Create initial data for app
seq=strings(max(sp_old_atlas.SEQ),1);
seq(sp_old_atlas.SEQ) = string(sp_old_atlas.SEQ);
speciesName=strings(size(seq));
speciesName(sp_old_atlas.SEQ) = sp_old_atlas.CommonName;
completed = false(size(seq));
mapFileName = strings(max(sp_old_atlas.SEQ),1);
mapFileName(flname.SEQ) = flname.name;

% Create atlas data
tmp = old_atlas.SqN == double(g.sqN(g.mask))' & old_atlas.SqL == g.sqL(g.mask)';
[r,c]=ind2sub(size(tmp),find(tmp));
old_atlas.idg(:)=nan;
old_atlas.idg(r)=c;

codeMaskSp = ones(sum(g.mask(:)), numel(seq));
id = old_atlas.idg>0 & old_atlas.SEQ>0 & old_atlas.code>1;
tmp = sub2ind(size(codeMaskSp),old_atlas.idg(id),old_atlas.SEQ(id));
codeMaskSp(tmp) = old_atlas.code(id);

%% Export data
i_sp=1;
save('data/data_label_v0','speciesName','seq','mapFileName','codeMaskSp','completed','i_sp')

%% App
Labelization

%% Manual export
% load('data/data_fix.mat')
load('data/data_label_v0')

figure('position',[0 0 1400 900]); tiledlayout(1,2,'TileSpacing','tight','Padding','tight');
ax1=nexttile; box on; 
mapImSp = imread("extract/"+ mapFileName(i_sp));
i1 = imagesc(imread("template_mask.png"));
colormap("gray"); axis equal tight;
set(gca,'XTick', []); set(gca,'YTick', []);
ax2=nexttile; box on;
x_template = 1:size(templateCode,1); x_template=(x_template-mean(x_template))+.5;
y_template = 1:size(templateCode,2); y_template=(y_template-mean(y_template))+.5;
i2 = imagesc(imread("template_mask.png"));
colormap("gray"); axis equal tight;
set(gca,'XTick', []); set(gca,'YTick', []);

for i_sp=1:numel(seq)
    if mapFileName(i_sp)==""
        mapImSp = imread("template_mask.png");
            i1.CData=mapImSp;
        else
            mapImSp = imread("extract/"+ mapFileName(i_sp));
            i1.CData=repmat(mapImSp,1,1,3);
    end

    id_block = find(codeMaskSp(:,i_sp)~=1);
    map_b = template;
    for i_b=1:numel(id_block)
        map_b(gY(id_block(i_b))+y_template, gX(id_block(i_b))+x_template) = templateCode(:,:,codeMaskSp(id_block(i_b),i_sp));
    end
    i2.CData=repmat(map_b,1,1,3)./255;
    title(ax1,mapFileName(i_sp),'FontSize',20,'Interpreter','none')
    title(ax2,seq(i_sp)+ " | " + speciesName(i_sp),'FontSize',20,'Interpreter','none')

    exportgraphics(gcf, "manual_check/"+seq(i_sp)+".jpg")
end



%% Read export of labelization app

load('data/data_fix')
load('data/data_label_v1_20220705-182715.mat')

% Create the table of the grid 
grid=struct();
tmp = jsondecode(fileread('../Rcode/grid.geojson'));
for i_f=1:numel(tmp.features)
    tmp2 = tmp.features(i_f).geometry.coordinates(:,:,1);
    tmp3 = tmp.features(i_f).geometry.coordinates(:,:,2);
    grid(i_f).SqL = tmp.features(i_f).properties.SqL;
    grid(i_f).SqN = tmp.features(i_f).properties.SqN;
    grid(i_f).lat = mean(tmp2(1:4));
    grid(i_f).lon = mean(tmp3(1:4));
end
tg = struct2table(grid);

% Compute the coordinate in pixel from the lat lon
dll=.5;
tg.y = (-tg.lon - min(-tg.lon))/dll*g.dy + g.y0 + g.dy;
tg.x = (tg.lat - min(tg.lat))/dll*g.dx + g.x0 + g.dx;

% Find the code (sql sqn) for each pixel set
gCode=strings(numel(gX),2);
for i=1:numel(gX)
    id = gX(i) == tg.x & gY(i) == tg.y;
    if sum(id)>0
        gCode(i,1) = tg.SqL(id);
        gCode(i,2) = tg.SqN(id);
    end
end

% create the table of all obs
d=[];
for i_sp = find(completed)
    id = codeMaskSp(:,i_sp)>1;
    d = [d;repmat(lewisCode(i_sp),sum(id),1) gCode(id,2) gCode(id,1) codeName(1,codeMaskSp(id,i_sp))' codeName(2,codeMaskSp(id,i_sp))'];
end

writematrix(d,'data/export_completed.xlsx')
