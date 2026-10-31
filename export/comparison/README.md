# Atlas export for comparison

`atlas_records.csv` contains every row from the corrected digitized atlas workbook, with snake_case headers, the three atlas period columns, and `avibase_id`, `avibase_name` and `avibase_notes` joined by SEQ. Read `seq` as text: `0a` and `0b` distinguish two unnumbered book entries. The CSV retains all source rows and the three atlas periods; apply the desired period and record filters in the comparison. Avibase matches include qualifications in `avibase_notes` and are not all independently validated.

Generate it from the project root with `eval(fileread('scripts/07_export_comparison.m'))`. This uses `data/raw/A Bird Atlas of Kenya_v5.xlsx` and `data/curated/atlas_taxonomy.csv`. The mapping includes provisional decisions described in [taxonomy documentation](../../docs/taxonomy.md); this export captures their state at generation time.

`avilist_taxa.csv` is the shared AviList v2026 reference exported by `scripts/04_taxonomy_reference.m`. It retains the exact source IDs, rank, names, sequence, family/order, assessment and species-page code fields. KenyaAtlasComparison reads it directly and keeps its curated comparison memberships separate from historical concepts. Run step 04 when refreshing this reference and step 07 when refreshing atlas records. Comparison exclusions and merges must not be applied to the historical export.
