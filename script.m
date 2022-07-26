
% Define the scaling factor to upscale between image resolution. For some
% reason some page have been scan with a different resolution and the
% template was also at this smaller resolution, so we upscale them all
% before. 
scale=2.35;

% Load template map to match
template = double(rgb2gray(imread("template.png")));
szt = size(template);
% figure; imagesc(template); colormap(gray); axis equal tight;

% define the grid on which to extract the information. Unit is pixel of
% template/page.
g.dx=56/2;
g.dy=56/2;
g.x0=18; % first pixel position
g.y0=24;
g.x=g.x0:g.dx:szt(2);
g.y=g.y0:g.dy:szt(1);
[g.X,g.Y] = meshgrid(g.x,g.y);

% Build the mask of value within kenya.
tmp = double(rgb2gray(imread("template_mask.png")))>0;
g.mask = ~(tmp(g.y,g.x)==0);

% extend the mask to the same grid as template.
F=griddedInterpolant({g.y,g.x},double(g.mask),'nearest');
g.mask_extend = F({1:szt(1),1:szt(2)});

figure; hold on; set(gca,"YDir","reverse")
imagesc(template, "alphadata", g.mask_extend);
colormap(gray); axis equal tight;
scatter(g.X(g.mask),g.Y(g.mask),'k')
xline(g.x); yline(g.y)

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
%templateCode = imresize(templateCode,scale);

% Find all page to read
fldr = '../pages_png/';
flr = dir(fldr);
flr = flr(contains({flr.name},".png"));
% possible_page_nb = cellfun(@(x) str2double(x(28:end-4)),{flr.name});
% file_base = flr(1).name(1:27);


%% Read the pdf page, extract image
% Prepare structure of data
n_species=2000;
mapImSp=nan(szt(1), szt(2),n_species);
codeMaskSp = nan(sum(g.mask(:)),n_species);
codeMaskSpUncer = nan(sum(g.mask(:)),n_species);
pageNbSp = strings(1,n_species);


i_sp=0;
for i_f = 55:numel(flr)  % i_f=74+17;
    fl=flr(i_f);
    disp(fl.name)

    page = imread([fldr fl.name]);
    if size(page,3)==3
        page = rgb2gray(page);
    end
    szp = size(page);

    % figure; imagesc(page); axis equal tight; colormap('gray')

    % Adjust based on resolution if needed
    if szp(2)==600
        page = imresize(page,scale);
        szp = size(page);
    end
    %figure; hold on; imshow(page);imshow(template/255);
    %set(gca,'ydir','reverse'); axis equal tight off; colormap('gray')

    % compute the cross-correlation
    c = normxcorr2(template,page);
    c = c(ceil(szt(1)/2):(end-floor(szt(1)/2)),ceil(szt(2)/2):(end-floor(szt(2)/2)));
    % figure; imagesc(c); axis equal tight;

    % extract the position of the match
    % a threashold of 0.25 is used to find all the maps
    c(c<.25)=nan;
    % Iteratively find all the map on the pages, remove all max value nearby 
    id=[];
    while ~all(isnan(c(:)))
        [~,tmp]=max(c(:));
        id = [id;tmp];
        [id_yc,id_xc] = ind2sub(szp,id(end));
        id_y = id_yc-round(szt(1)/2);
        id_x = id_xc-round(szt(2)/2);
        c(id_y+(1:szt(1)),id_x+(1:szt(2)))=nan;
    end

    % Get the final position of the max
    [id_yc,id_xc] = ind2sub(szp,id);
    id_y = id_yc-round(szt(1)/2);
    id_x = id_xc-round(szt(2)/2);
    % sort map by page along the x axis
    
    [~,id_xysort]=sort(floor(id_y/(szp(1)/3))+floor(id_x/(szp(2)/2.2))*3);
    id_x=id_x(id_xysort);
    id_y=id_y(id_xysort);
    
    % figure; hold on; imagesc(page); scatter(id_xc,id_yc,'r')
    % set(gca,'ydir','reverse'); axis off equal tight; colormap('gray');

    disp([num2str(numel(id)) ' matches'])

    % Loop through the maps
    for i_m=1:numel(id)
        i_sp=i_sp+1;
        
        % Get the map as image
        mapImSp(:,:,i_sp) = page(id_y(i_m)+(1:szt(1)),id_x(i_m)+(1:szt(2)));

        % Find code: NOT WORKING
       % a=1-mapImSp(540:590,55:125,i_sp)/255;
%         CC = bwconncomp(a>.5);
%         [~,idcc]=max(cellfun(@numel,CC.PixelIdxList));
%         a(CC.PixelIdxList{2})=10;
        % imshow(a)
%         txt = ocr(a,'TextLayout','Word', 'CharacterSet', '0123456789');
%         if numel(txt.Words)>0
%             mapId(i_sp)=txt.Words{1};
%         end

        % write the image
        pageNbSp(i_sp) = [fl.name(1:end-4) '_' num2str(i_m)];
        imwrite(uint8(mapImSp(:,:,i_sp)),"extract/"+pageNbSp(i_sp)+".jpg")
        
        
        % Match the template code on each grid

        % tformEstimate = imregcorr(template,mapImSp(:,:,i_sp));
        % movingReg = imwarp(template,tformEstimate,'OutputView',imref2d(size(template)));
        % mapImSpMatch = min(mapImSp(:,:,i_sp)-movingReg+255,255);
        % mapImSpMatch = filter2(ones(3,3)./9,mapImSpMatch);
        
        mapImSpMatch = min(mapImSp(:,:,i_sp)-template+255,255);

        res = nan(size(mapImSp,1),size(mapImSp,2),size(templateCode,3));
        for i_template=1:size(templateCode,3)
            res(:,:,i_template)=-2*conv2(mapImSpMatch,templateCode(:,:,i_template),'same')+...
                                 conv2(mapImSpMatch.^2,templateCode(:,:,i_template).*0+1,'same')+...
                                 conv2(mapImSpMatch.*0+1,templateCode(:,:,i_template).^2,'same');
        end
        % find the pattern with the best match
        [min_val,id_best]=mink(res,2,3);

        tmp = 1-(min_val(:,:,1)./min_val(:,:,2)).^2*.8;
        tmp = tmp(g.y,g.x);
        % figure; axis tight equal; imagesc(tmp)
        codeMaskSpUncer(:,i_sp)=tmp(g.mask);

        id_best=id_best(:,:,1);
        tmp = id_best(g.y,g.x);
        codeMaskSp(:,i_sp)=tmp(g.mask);

        figure(1); clf;tiledlayout('flow','TileSpacing','tight','Padding','tight')
        nexttile; hold on; axis equal tight off; set(gca,'ydir','reverse');
        imagesc(mapImSp(:,:,i_sp)); colormap(gca,gray)
        %scatter(g.X(g.mask),g.Y(g.mask),'k')
        nexttile; hold on; axis equal tight off; set(gca,'ydir','reverse');
        imagesc(id_best,'AlphaData',g.mask_extend); 
        colormap(gca,brewermap(length(codeName),'Paired'));caxis([1 length(codeName)]); 
        colorbar('YTickLabel',code); %join(codeName')
        scatter(g.X(g.mask),g.Y(g.mask),[],codeMaskSp(:,i_sp),'filled','MarkerEdgeColor','k')
        nexttile; hold on; axis equal tight off; set(gca,'ydir','reverse');
        imshow(template./255);
        g_mask = find(g.mask);
        x_template = 1:size(templateCode,1);x_template=x_template-mean(x_template);
        y_template = 1:size(templateCode,2);y_template=y_template-mean(y_template);
        id_block = find(codeMaskSp(:,i_sp)~=1);
        for i_b=1:numel(id_block)
            val = templateCode(:,:,codeMaskSp(id_block(i_b),i_sp));
            val = repmat(val,1,1,3)./255;
            %val(:,:,3)=val(:,:,3)*codeMaskSpUncer(id_block(i_b),i_sp);
            %val(:,:,2)=val(:,:,2)*codeMaskSpUncer(id_block(i_b),i_sp);
            %val(:,:,1)=1-((1-val(:,:,1))*codeMaskSpUncer(id_block(i_b),i_sp));
            imagesc(g.X(g_mask(id_block(i_b)))+x_template,g.Y(g_mask(id_block(i_b)))+y_template,val)
         end
        %scatter(g.X(g_mask),g.Y(g_mask),200,codeMaskSpUncer(:,i_sp),'s','linewidth',2)
   
%         % colormap(gca,gray)
%         keyboard
    end
end

%% Figure

i_sp=1;

figure; tiledlayout('flow','TileSpacing','tight','Padding','tight')
nexttile; hold on; axis equal tight off; set(gca,'ydir','reverse');
imagesc(template);
id_block = find(codeMaskSp(:,i_sp)~=1);
g_mask = find(g.mask);
x_template = 1:size(templateCode,1);x_template=x_template-mean(x_template);
y_template = 1:size(templateCode,2);y_template=y_template-mean(y_template);
for i_b=1:numel(id_block)
    imagesc(g.X(g_mask(id_block(i_b)))+x_template,g.Y(g_mask(id_block(i_b)))+y_template,templateCode(:,:,codeMaskSp(id_block(i_b),i_sp)))
end
colormap(gca,gray)
nexttile; hold on; axis equal tight off; set(gca,'ydir','reverse');
imagesc(mapImSp(:,:,i_sp)); colormap(gca,gray)

%% Save for labelization app

% Fix data 
gX=g.X(g.mask); 
gY=g.Y(g.mask);
save('data/data_fix','pageNbSp','templateCode','template','gX','gY','codeName','codeMaskSpUncer')


lewisCode = strings(1,n_species);
speciesName = strings(1,n_species);
completed = false(1,n_species);
codeMaskSp=uint8(codeMaskSp);
i_sp=1;
save('data/data_label_v0','speciesName','lewisCode','codeMaskSp','completed','i_sp')


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



%% Load exisiting data
old_atlas = readtable("../data_version_2022_RN/A Bird Atlas of Kenya_v4.xlsx", 'TextType', 'string');
load('data/data_fix')
sp_old_atlas = sortrows(unique(old_atlas(:,1:3)));
sp_old_atlas(sp_old_atlas.SEQ==0,:)=[];

lewisCode=strings(max(sp_old_atlas.SEQ),1);
speciesName=strings(size(lewisCode));
completed = false(size(lewisCode));

lewisCode(sp_old_atlas.SEQ) = string(sp_old_atlas.SEQ);
speciesName(sp_old_atlas.SEQ) = sp_old_atlas.CommonName;

i_sp=1;

% Add atlad square ide
tmp = old_atlas.SqN == double(gCode(:,2))' & old_atlas.SqL == gCode(:,1)';
[r,c]=ind2sub(size(tmp),find(tmp));
old_atlas.idg(:)=nan;
old_atlas.idg(r)=c;

% Add breedin code
old_atlas.pre_1970(ismissing(old_atlas.pre_1970))="none";
old_atlas.x1970_1984(ismissing(old_atlas.x1970_1984))="none";
codeName2=codeName;
codeName2(codeName2=="unknown")="none";
old_atlas.code = sum(cumsum(fliplr(old_atlas.pre_1970 == codeName2(1,:) & old_atlas.x1970_1984 == codeName2(2,:)),2),2);

codeMaskSp(:) = 1;
id = old_atlas.idg>0 & old_atlas.SEQ>0 & old_atlas.code>1;
tmp = sub2ind(size(codeMaskSp),old_atlas.idg(id),old_atlas.SEQ(id));
codeMaskSp(tmp) = old_atlas.code(id);

save('data/data_label_v4','speciesName','lewisCode','codeMaskSp','completed','i_sp')
