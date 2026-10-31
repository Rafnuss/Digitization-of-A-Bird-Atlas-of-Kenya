% Read the source atlas and the curated historical taxonomy ----------------
atlas_options = detectImportOptions('data/raw/A Bird Atlas of Kenya_v5.xlsx',VariableNamingRule='preserve');
atlas_options = setvartype(atlas_options,atlas_options.VariableNames,'string');
atlas = readtable('data/raw/A Bird Atlas of Kenya_v5.xlsx',atlas_options);
taxonomy_options = detectImportOptions('data/curated/sp_list_avibase.csv');
taxonomy_options = setvartype(taxonomy_options,taxonomy_options.VariableNames,'string');
taxonomy_options.DataLines = [2 Inf];
taxonomy = readtable('data/curated/sp_list_avibase.csv',taxonomy_options);

% Attach the Avibase concept to each source row ----------------------------
assert(numel(unique(taxonomy.SEQ)) == height(taxonomy));
[found,idx] = ismember(atlas.SEQ,taxonomy.SEQ);
assert(all(found));
assert(all(atlas.('Scientific name') == taxonomy.scientific_name(idx)));
assert(all(atlas.('Common name') == taxonomy.common_name(idx)));
atlas.avibase_id = taxonomy.avibase_id(idx);
atlas.avibase_name = taxonomy.avibase_name(idx);
atlas.avibase_review_status = taxonomy.review_status(idx);
atlas.avibase_notes = taxonomy.notes(idx);
writetable(atlas,'export/comparison/atlas_avibase.csv');
fprintf('Wrote %d atlas rows for %d taxa.\n',height(atlas),height(taxonomy));
