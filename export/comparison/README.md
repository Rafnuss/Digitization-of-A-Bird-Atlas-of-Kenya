# Atlas export for comparison

`atlas_avibase.csv` contains every row and column from the corrected digitized atlas workbook, with `avibase_id`, `avibase_name`, `avibase_review_status` and `avibase_notes` joined by SEQ. Read SEQ as text: `0a` and `0b` distinguish two unnumbered book entries. The CSV retains all periods and source rows; apply the desired period and record filters in the comparison. Avibase matches marked `name_matched`, `kenyan_match` or `parent_fallback` include qualifications in the notes and are not all independently validated.

Generate it from the project root with `addpath('scripts'); step_07_export_comparison`. This uses `data/raw/A Bird Atlas of Kenya_v5.xlsx` and `data/curated/sp_list_avibase.csv`. The corrected workbook and curated mapping are still being reviewed and have not yet been committed; this export captures their state at generation time.
