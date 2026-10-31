# Atlas export for comparison

`atlas_avibase.csv` contains every row from the corrected digitized atlas workbook, with snake_case headers, the three atlas period columns, and `avibase_id`, `avibase_name` and `avibase_notes` joined by SEQ. Read `seq` as text: `0a` and `0b` distinguish two unnumbered book entries. The CSV retains all source rows and the three atlas periods; apply the desired period and record filters in the comparison. Avibase matches include qualifications in `avibase_notes` and are not all independently validated.

Generate it from the project root with `eval(fileread('scripts/07_export_comparison.m'))`. This uses `data/raw/A Bird Atlas of Kenya_v5.xlsx` and `data/curated/sp_list_avibase.csv`. The corrected workbook and curated mapping are still being reviewed and have not yet been committed; this export captures their state at generation time.
