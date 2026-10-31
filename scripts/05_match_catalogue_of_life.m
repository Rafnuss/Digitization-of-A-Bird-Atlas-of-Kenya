% Avibase crosswalk and reference -> Catalogue of Life name-matching CSV.
% Exact name/rank matches are candidates, not proof of identical concepts.
opts = detectImportOptions('data/curated/atlas_taxonomy.csv');
opts = setvartype(opts,opts.VariableNames,'string');opts.DataLines = [2 Inf];
taxonomy = readtable('data/curated/atlas_taxonomy.csv',opts);
opts = detectImportOptions('data/intermediate/atlas_taxonomy_reference.csv');
opts = setvartype(opts,opts.VariableNames,'string');opts.DataLines = [2 Inf];
reference = readtable('data/intermediate/atlas_taxonomy_reference.csv',opts);
[found,idx] = ismember(taxonomy.SEQ,reference.SEQ);assert(all(found));
assert(all(taxonomy.avibase_id == reference.avibase_id(idx)));
col = taxonomy(:,{'SEQ','avibase_id','avibase_name','review_status'});
col.query_name = strings(height(col),1);
col.query_rank = strings(height(col),1);
col.match_type = repmat("NOT_QUERIED",height(col),1);
col.matched_name = strings(height(col),1);
col.matched_rank = strings(height(col),1);
col.matched_status = strings(height(col),1);
col.candidate_col_id = strings(height(col),1);
col.accepted_col_id = strings(height(col),1);
col.accepted_name = strings(height(col),1);
col.accepted_rank = strings(height(col),1);
col.review_reason = strings(height(col),1);
col.publish_col_id = strings(height(col),1);
col.issues = strings(height(col),1);
options = weboptions('Timeout',30);
for i = 1:height(col)
    name = reference.reference_name(idx(i));rank = reference.taxonRank(idx(i));
    if ismissing(name) || name == "" || ismissing(rank) || rank == "" || col.review_status(i) == "parent_fallback" || contains(col.avibase_name(i),'[') || contains(col.avibase_name(i),'/')
        col.issues(i) = "No unambiguous reference species or subspecies concept";
        continue
    end
    col.query_name(i) = name;col.query_rank(i) = rank;
    try
        parameters = {'scientificName',name,'kingdom','Animalia','class','Aves','rank',upper(rank),'checklistKey','7ddf754f-d193-4cc9-b351-99906754a03b'};
        if ~ismissing(reference.family(idx(i))) && reference.family(idx(i)) ~= ""
            parameters = [parameters, {'family',reference.family(idx(i))}];
        end
        result = webread('https://api.gbif.org/v2/species/match',parameters{:},options);
        col.match_type(i) = string(result.diagnostics.matchType);
        if isfield(result.diagnostics,'issues'),col.issues(i) = strjoin(string(result.diagnostics.issues),' | ');end
        if isfield(result,'usage')
            col.matched_name(i) = string(result.usage.name);
            col.matched_rank(i) = string(result.usage.rank);
            col.matched_status(i) = string(result.usage.status);
            if col.match_type(i) == "EXACT" && lower(col.matched_rank(i)) == lower(rank) && isfield(result.usage,'canonicalName') && strcmpi(string(result.usage.canonicalName),name)
                col.candidate_col_id(i) = "col:" + string(result.usage.key);
            end
            if isfield(result,'acceptedUsage')
                col.accepted_col_id(i) = "col:" + string(result.acceptedUsage.key);
                col.accepted_name(i) = string(result.acceptedUsage.name);
                col.accepted_rank(i) = string(result.acceptedUsage.rank);
            elseif col.matched_status(i) == "ACCEPTED"
                col.accepted_col_id(i) = "col:" + string(result.usage.key);
                col.accepted_name(i) = col.matched_name(i);
                col.accepted_rank(i) = col.matched_rank(i);
            end
        end
        if col.candidate_col_id(i) ~= ""
            if col.matched_status(i) == "SYNONYM" && (col.accepted_rank(i) == "" || lower(col.accepted_rank(i)) ~= lower(rank))
                col.review_reason(i) = "Accepted rank differs or is unavailable; review concept before publishing ID";
            else
                col.publish_col_id(i) = col.candidate_col_id(i);
                if col.matched_status(i) == "SYNONYM",col.review_reason(i) = "Synonym: same-rank concept equivalence remains unverified";end
            end
        end
    catch err
        col.match_type(i) = "REQUEST_ERROR";col.issues(i) = string(err.message);
    end
    if mod(i,100)==0,fprintf('Checked %d of %d taxa\n',i,height(col));end
    pause(.1)
end
writetable(col,'data/intermediate/atlas_col_name_matches.csv');
disp(groupsummary(col,'match_type'))
