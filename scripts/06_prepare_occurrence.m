% Atlas workbook, Avibase crosswalk and taxonomy reference -> GBIF occurrence CSV.
% Read atlas, curated Avibase concepts, and reference information -----------
atlas_options = detectImportOptions('data/raw/A Bird Atlas of Kenya_v5.xlsx',VariableNamingRule='preserve');
atlas_options = setvartype(atlas_options,atlas_options.VariableNames,'string');
atlas = readtable('data/raw/A Bird Atlas of Kenya_v5.xlsx',atlas_options);
taxonomy_options = detectImportOptions('data/curated/atlas_taxonomy.csv');
taxonomy_options = setvartype(taxonomy_options,taxonomy_options.VariableNames,'string');
taxonomy_options.DataLines = [2 Inf];
taxonomy = readtable('data/curated/atlas_taxonomy.csv',taxonomy_options);
ref_options = detectImportOptions('data/intermediate/atlas_taxonomy_reference.csv');
ref_options = setvartype(ref_options,ref_options.VariableNames,'string');
ref_options.DataLines = [2 Inf];
reference = readtable('data/intermediate/atlas_taxonomy_reference.csv',ref_options);
assert(numel(unique(taxonomy.SEQ)) == height(taxonomy));

% Keep the atlas periods and breeding codes --------------------------------
early = atlas(:,{'SEQ','Scientific name','Common name','SqN','SqL','pre-1970'});
early.Properties.VariableNames = {'SEQ','atlasScientificName','atlasCommonName','SqN','SqL','atlasCode'};
early = early(~ismissing(early.atlasCode),:);
early.eventDate(:) = "1900-01-01T00:00:00/1970-01-01T00:00:00";
early.period(:) = "1900/1970";
late = atlas(:,{'SEQ','Scientific name','Common name','SqN','SqL','1970-1984'});
late.Properties.VariableNames = {'SEQ','atlasScientificName','atlasCommonName','SqN','SqL','atlasCode'};
late = late(~ismissing(late.atlasCode),:);
late.eventDate(:) = "1970-01-01T00:00:00/1984-01-01T00:00:00";
late.period(:) = "1970/1984";
data = [early;late];

% Apply documented review decisions to the GBIF occurrence export ----------
review_options = detectImportOptions('data/curated/atlas_record_review.csv');
review_options = setvartype(review_options,review_options.VariableNames,'string');
review = readtable('data/curated/atlas_record_review.csv',review_options);
[has_review,review_idx] = ismember(data.SEQ,review.seq);
rejected = false(height(data),1);
rejected(has_review) = ismember(review.status(review_idx(has_review)),["rejected","uncertain"]);
data = data(~rejected,:);
[has_review,review_idx] = ismember(data.SEQ,review.seq);
[found,idx] = ismember(data.SEQ,taxonomy.SEQ);assert(all(found));
assert(all(data.atlasScientificName == taxonomy.scientific_name(idx)));
[found,ref_idx] = ismember(data.SEQ,reference.SEQ);assert(all(found));
assert(all(taxonomy.avibase_id(idx) == reference.avibase_id(ref_idx)));

% Retain historical identifications alongside selected concept names --------
data.basisOfRecord(:) = "Occurrence";
data.occurrenceRemarks = data.atlasCode;
data.occurrenceStatus(:) = "present";
data.kingdom(:) = "Animalia";
data.phylum(:) = "Chordata";
data.class(:) = "Aves";
concept_name = taxonomy.avibase_name(idx);
fallback = ismissing(concept_name) | contains(concept_name,'[') | contains(concept_name,'/');
data.scientificName = strtrim(regexprep(concept_name,'\s+\(.*$',''));
data.scientificName(fallback) = data.atlasScientificName(fallback);
reference_name = reference.reference_name(ref_idx);
use_avilist = reference.reference_source(ref_idx) == "AviList v2026" & ~fallback & ~ismissing(reference_name) & reference_name ~= "";
data.scientificName(use_avilist) = reference_name(use_avilist);
data.order = reference.order(ref_idx);
data.family = reference.family(ref_idx);
name_agrees = data.scientificName == reference_name & ~ismissing(reference_name);
data.taxonRank = strings(height(data),1);
data.scientificNameAuthorship = strings(height(data),1);
data.taxonRank(name_agrees) = reference.taxonRank(ref_idx(name_agrees));
data.scientificNameAuthorship(name_agrees) = reference.scientificNameAuthorship(ref_idx(name_agrees));
data.verbatimIdentification = data.atlasScientificName;
data.vernacularName = data.atlasCommonName;
data.taxonID = taxonomy.avibase_id(idx);
data.taxonConceptID = taxonomy.col_id(idx);
use_col = taxonomy.col_publish(idx) == "true" & ~ismissing(data.taxonConceptID);
data.taxonConceptID(~use_col) = "";
reidentified = false(height(data),1);
reidentified(has_review) = review.status(review_idx(has_review)) == "reidentified";
data.scientificName(reidentified) = review.new_scientific_name(review_idx(reidentified));
data.taxonID(reidentified) = review.new_avibase_id(review_idx(reidentified));
data.taxonConceptID(reidentified) = "";
data.taxonRank(reidentified) = "species";
data.scientificNameAuthorship(reidentified) = "";
data.identificationRemarks = strings(height(data),1);
data.identificationRemarks(fallback & ~reidentified) = "Atlas name retained because the selected Avibase concept does not have one unambiguous scientific name in the crosswalk; the concept may include multiple taxa.";
noted = (taxonomy.review_status(idx) == "parent_fallback" | taxonomy.review_status(idx) == "reviewed" | taxonomy.review_status(idx) == "kenyan_match") & ~reidentified;
data.identificationRemarks(noted) = strtrim(data.identificationRemarks(noted) + " " + taxonomy.notes(idx(noted)));
data.identificationRemarks(has_review) = strtrim(data.identificationRemarks(has_review) + " " + review.notes(review_idx(has_review)));
data.identificationRemarks = strtrim("Atlas SEQ: " + data.SEQ + ". " + data.identificationRemarks);
has_col = data.taxonConceptID ~= "" & ~reidentified;
data.identificationRemarks(has_col) = data.identificationRemarks(has_col) + " Catalogue of Life: " + taxonomy.col_notes(idx(has_col));

% Attach the original quarter-degree grid ---------------------------------
grid = jsondecode(fileread('data/raw/grid.geojson'));
locality = strings(numel(grid.features),1);
latitude = nan(numel(grid.features),1);longitude = latitude;uncertainty = latitude;footprint = locality;
for i = 1:numel(grid.features)
    f = grid.features(i);
    x = f.geometry.coordinates(:,:,1);y = f.geometry.coordinates(:,:,2);
    longitude(i) = mean(x(1:4));latitude(i) = mean(y(1:4));
    locality(i) = string(f.properties.SqN) + string(f.properties.SqL);
    polygon = [longitude(i)+.25*[-1 1 1 -1 -1];latitude(i)+.25*[-1 -1 1 1 -1]];
    coordinates = char(sprintf('%0.1f %0.1f, ',polygon));
    footprint(i) = "POLYGON ((" + string(coordinates(1:end-2)) + "))";
    uncertainty(i) = round(deg2km(distance(longitude(i),latitude(i),longitude(i)+.25,latitude(i)+.25))*1000);
end
[found,grid_idx] = ismember(data.SqN + data.SqL,locality);assert(all(found));
data.geodeticDatum(:) = "WGS84";
data.footprintSRS(:) = "WGS84";
data.decimalLatitude = latitude(grid_idx);
data.decimalLongitude = longitude(grid_idx);
data.verbatimCoordinateSystem(:) = "Quarter Degree Squares (QDS), see DOI:10.1111/j.1365-2028.2008.00997.x";
data.footprintWKT = footprint(grid_idx);
data.locality = locality(grid_idx);
data.coordinateUncertaintyInMeters = uncertainty(grid_idx);

% Preserve published IDs, including the former SEQ 0 Shoebill occurrence ----
legacy_seq = data.SEQ;
legacy_seq(legacy_seq == "0a") = "0";
data.occurrenceID = data.period + "_" + legacy_seq + "_" + data.locality;
assert(numel(unique(data.occurrenceID)) == height(data));
data = sortrows(data,'occurrenceID');
data = removevars(data,{'SEQ','atlasScientificName','atlasCommonName','SqN','SqL','atlasCode','period'});
writetable(data,'export/gbif/occurrence.csv');
fprintf('Wrote %d occurrences.\n',height(data));
