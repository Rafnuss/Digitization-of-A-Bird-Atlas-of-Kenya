% Export to GBUF format

old_atlas = readtable("data/data_version_2022_RN/A Bird Atlas of Kenya_v5.xlsx", 'TextType', 'string');


%% Create a  Matching taxonomy
% res = webread("https://api.gbif.org/v1/species/match?name="+sp_old_atlas.ScientificName(i_sp));

if false

    sp_old_atlas = sortrows(unique(old_atlas(:,1:3)));
    % sp_old_atlas(sp_old_atlas.SEQ==0,:)=[];
    
    sp_old_atlas.kingdom(:) = "animalia";
    sp_old_atlas.phylum(:) = "chordata";
    sp_old_atlas.class(:) = "aves";
    sp_old_atlas.order(:) = "";
    sp_old_atlas.family(:)	= "";
    sp_old_atlas.genus(:) = "";
    sp_old_atlas.species(:) = "";
    sp_old_atlas.taxonRank(:) = "species";
    sp_old_atlas.scientificName(:) = "";
    sp_old_atlas.canonicalName(:) = "";
    sp_old_atlas.matchType(:) = "";
    sp_old_atlas.species(:) = "";
    sp_old_atlas.key(:)="";
    
    % first pass with scientific name
    for i_sp=1:height(sp_old_atlas)
        try
            res = webread("https://api.gbif.org/v1/species/match?rank=species&name="+sp_old_atlas.ScientificName(i_sp));
            sp_old_atlas.order(i_sp) = res.order;
            sp_old_atlas.family(i_sp)	= res.family;
            sp_old_atlas.genus(i_sp) = res.genus;
            sp_old_atlas.scientificName(i_sp) = res.scientificName;
            sp_old_atlas.matchType(i_sp) = res.matchType;
            sp_old_atlas.species(i_sp) = res.species;
            sp_old_atlas.canonicalName(i_sp) = res.canonicalName;
        end
    end
    writetable(sp_old_atlas,'data/sp_list_gbif_v0.xlsx')
    
    % Add semi-manually the missing
    key = readtable("sp_list_gbif_old.xlsx");
    i_sp_list = find(ismissing(sp_old_atlas.matchType))%find(sp_old_atlas.matchType=="");
    for i=1:numel(i_sp_list)
        i_sp = find(sp_old_atlas.SEQ==853)
        %i_sp =i_sp_list(i)
        sp_old_atlas.CommonName(i_sp)
        % usageKey=key.usageKey(sp_old_atlas.SEQ(i_sp)==key.SEQ);
        res = webread("https://api.gbif.org/v1/species/search?rank=species&q="+sp_old_atlas.CommonName(i_sp));
        % res = webread("https://api.gbif.org/v1/species/search?rank=species&q=Telophorus nigrifrons");
        tmp=cellfun(@(x) x.key,res.results);
            
        [~,i_r] = min(tmp);
        res.results{i_r}
    
        sp_old_atlas.order(i_sp) = res.results{i_r}.order;
        sp_old_atlas.family(i_sp)	= res.results{i_r}.family;
        sp_old_atlas.genus(i_sp) = res.results{i_r}.genus;
        sp_old_atlas.scientificName2(i_sp) = string(res.results{i_r}.scientificName);
        sp_old_atlas.matchType(i_sp) = "search";
        sp_old_atlas.species(i_sp) = res.results{i_r}.species;
        sp_old_atlas.canonicalName(i_sp) = res.results{i_r}.canonicalName;
        
    end
    writetable(sp_old_atlas,'sp_list_gbif_v3.xlsx')
end


% Read file
sp_old_atlas = readtable('sp_list_gbif.xlsx','TextType', 'string');


%%  Constructure table

% restructure to get date seperately
tmp1 = old_atlas(:,1:5);
tmp1.atlas = old_atlas.pre_1970;
tmp1.eventDate(:) = "1900/1970";
tmp2 = old_atlas(:,1:5);
tmp2.atlas = old_atlas.x1970_1984;
tmp2.eventDate(:) = "1970/1984";
data = [tmp1;tmp2];
clear tmp1 tmp2

% remove empty atlas code
data(ismissing(data.atlas),:)=[];


% Basic static information
data.basisOfRecord(:) = "Occurrence";
% data.reproductiveConditionProperty = data.atlas;
data.occurrenceRemarks(:) = data.atlas;

% Taxonomy
data.kingdom(:) = "animalia";
data.phylum(:) = "chordata";
data.class(:) = "aves";
data.taxonRank(:) = "species";
data.family(:) = "";
data.genus(:) = "";
data.order(:) = "";
data.scientificName(:) = "";
data.originalNameUsage(:) ="";
data.taxonID(:)="";

for i_sp=1:height(sp_old_atlas)
    id=data.SEQ==sp_old_atlas.SEQ(i_sp);
    data.taxonID(id) = sp_old_atlas.SEQ(i_sp);
    data.originalNameUsage(id) = sp_old_atlas.CommonName(i_sp) + " " + sp_old_atlas.ScientificName(i_sp);
    data.order(id) = sp_old_atlas.order(i_sp);
    data.family(id)	= sp_old_atlas.family(i_sp);
    data.genus(id) = sp_old_atlas.genus(i_sp);
    data.scientificName(id) = sp_old_atlas.scientificName2(i_sp);
end

data = removevars(data,["SEQ", "ScientificName", "CommonName", "atlas"]);


% Geo-
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

data.continent(:) = "Africa";
data.countryCode(:) = "KE";
data.country(:) = "Kenya";
data.geodeticDatum(:) = "WGS84";
data.decimalLatitude(:) = nan;
data.decimalLongitude(:) = nan; 
data.verbatimCoordinateSystem(:) = "Quarter Degree Squares (QDS), see DOI:10.1111/j.1365-2028.2008.00997.x";
for i_l=1:height(tg)
    id = data.SqL==tg.SqL(i_l) & data.SqN==tg.SqN(i_l);
    data.decimalLatitude(id) = tg.lat(i_l);
    data.decimalLongitude(id) = tg.lon(i_l);  
    poly = [tg.lon(i_l)+.25*[-1 1 1 -1 -1]; tg.lat(i_l)+.25*[-1 -1 1 1 -1]];
    str = char(sprintf("%0.1f %0.1f, ",poly));
    data.footprintWKT(id) = "POLYGON (("+str(1:end-2)+"))";
    data.locality(id) = tg.SqN(i_l) + tg.SqL(i_l);
    distgc = distance(tg.lon(i_l),tg.lat(i_l),tg.lon(i_l)+.25,tg.lat(i_l)+.25);
    data.coordinateUncertaintyInMeters(id) = deg2km(distgc)*1000;
end
data = removevars(data,["SqN", "SqL"]);

% 
data.occurrenceID = data.eventDate +"_"+data.taxonID+"_"+data.locality;
%data.occurrenceID = data.eventDate +"_"+data.CommonName+"_"+data.SqN+"_"+data.SqL;
data=sortrows(data,'occurrenceID');
data([false; data.occurrenceID(1:end-1)==data.occurrenceID(2:end)],:)
numel(data.occurrenceID)==numel(unique(data.occurrenceID))



writetable(data,"export_gbif/occurrence.csv")


