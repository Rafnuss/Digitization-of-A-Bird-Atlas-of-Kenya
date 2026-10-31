% Avibase crosswalk and reference workbooks -> taxonomy reference CSV.
% Read curated concepts and the versioned AviList reference ----------------
topts = detectImportOptions('data/curated/atlas_taxonomy.csv');
topts = setvartype(topts,topts.VariableNames,'string');
taxonomy = readtable('data/curated/atlas_taxonomy.csv',topts);
file = 'data/raw/taxonomy/AviList-v2026-20Oct2026-extended-version.xlsx';
opts = detectImportOptions(file,Sheet='AviList v2026',VariableNamingRule='preserve');
opts.SelectedVariableNames = {'AVIBASE ID','SCIENTIFIC NAME','ENGLISH NAME: AVILIST','ORDER','FAMILY','RANK','AUTHORITY'};
opts = setvartype(opts,opts.SelectedVariableNames,'string');
avilist = readtable(file,opts);
reference = taxonomy(:,{'SEQ','avibase_id'});
reference.reference_name = strings(height(reference),1);
reference.reference_common_name = strings(height(reference),1);
reference.order = strings(height(reference),1);
reference.family = strings(height(reference),1);
reference.taxonRank = strings(height(reference),1);
reference.scientificNameAuthorship = strings(height(reference),1);
reference.reference_source = strings(height(reference),1);
[found,idx] = ismember(reference.avibase_id,avilist.('AVIBASE ID'));
reference.reference_name(found) = avilist.('SCIENTIFIC NAME')(idx(found));
reference.reference_common_name(found) = avilist.('ENGLISH NAME: AVILIST')(idx(found));
reference.order(found) = avilist.ORDER(idx(found));
reference.family(found) = avilist.FAMILY(idx(found));
reference.taxonRank(found) = avilist.RANK(idx(found));
reference.scientificNameAuthorship(found) = avilist.AUTHORITY(idx(found));
reference.reference_source(found) = "AviList v2026";

% Fill available bibliographic fields for concepts absent from AviList 2026 -
file = 'data/raw/taxonomy/avibase_data_bibliographic_2025_v1.xlsx';
for sheet = ["AviList 2025","Clements 2025","IOC 15.1","HBW-Birdlife 10"]
    opts = detectImportOptions(file,Sheet=sheet,VariableNamingRule='preserve');
    opts.SelectedVariableNames = {'avibase_id','sci_name','level','family_name','authors','year','authors_brackets'};
    opts = setvartype(opts,opts.SelectedVariableNames,'string');
    bib = readtable(file,opts);
    missing = reference.reference_source == "";
    [found,idx] = ismember(reference.avibase_id(missing),bib.avibase_id);
    positions = find(missing);positions = positions(found);idx = idx(found);
    reference.reference_name(positions) = bib.sci_name(idx);
    reference.family(positions) = bib.family_name(idx);
    reference.taxonRank(positions) = bib.level(idx);
    authority = bib.authors(idx) + ", " + bib.year(idx);
    bracket = bib.authors_brackets(idx) == "1";
    authority(bracket) = "(" + authority(bracket) + ")";
    reference.scientificNameAuthorship(positions) = authority;
    reference.reference_source(positions) = "Avibase bibliographic data: " + sheet;
end

% A group concept does not automatically inherit a modern species rank -----
group = contains(taxonomy.avibase_name,'[') | contains(taxonomy.avibase_name,'/');
reference.taxonRank(group) = "";
reference.scientificNameAuthorship(group) = "";
writetable(reference,'data/intermediate/atlas_taxonomy_reference.csv');
disp(groupsummary(reference,'reference_source'))
