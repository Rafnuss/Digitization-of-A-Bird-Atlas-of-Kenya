% Atlas workbook and Avibase crosswalk -> comparison atlas CSV.
% Read the source atlas and the curated historical taxonomy ----------------
atlas_options = detectImportOptions('data/raw/A Bird Atlas of Kenya_v5.xlsx',VariableNamingRule='preserve');
atlas_options = setvartype(atlas_options,atlas_options.VariableNames,'string');
atlas = readtable('data/raw/A Bird Atlas of Kenya_v5.xlsx',atlas_options);
taxonomy_options = detectImportOptions('data/curated/atlas_taxonomy.csv');
taxonomy_options = setvartype(taxonomy_options,taxonomy_options.VariableNames,'string');
taxonomy_options.DataLines = [2 Inf];
taxonomy = readtable('data/curated/atlas_taxonomy.csv',taxonomy_options);

% Select the atlas fields used for comparison ------------------------------
atlas = atlas(:,{'SEQ','Scientific name','Common name','SqN','SqL','pre-1970','1970-1984','post-1984'});
atlas.Properties.VariableNames = {'seq','scientific_name','common_name','sq_n','sq_l','pre_1970','period_1970_1984','post_1984'};

% Attach the Avibase concept to each source row ----------------------------
assert(numel(unique(taxonomy.SEQ)) == height(taxonomy));
[found,idx] = ismember(atlas.seq,taxonomy.SEQ);
assert(all(found));
assert(all(atlas.scientific_name == taxonomy.scientific_name(idx)));
assert(all(atlas.common_name == taxonomy.common_name(idx)));
atlas.avibase_id = taxonomy.avibase_id(idx);
atlas.avibase_name = taxonomy.avibase_name(idx);
atlas.avibase_notes = taxonomy.notes(idx);
writetable(atlas,'export/comparison/atlas_records.csv');
fprintf('Wrote %d atlas rows for %d taxa.\n',height(atlas),height(taxonomy));
