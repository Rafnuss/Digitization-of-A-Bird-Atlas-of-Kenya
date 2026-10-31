# Digitalization of A Bird Atlas of Kenya

Raphaël Nussbaumer<sup>1,[![](https://figshare.com/ndownloader/files/8439032/preview/8439032/preview.jpg)](http://orcid.org/0000-0002-8185-1020)</sup>, Sidney Shema<sup>2</sup>, Sikenykeny Kennedy<sup>2</sup>, Colin Jackson <sup>1,[![](https://figshare.com/ndownloader/files/8439032/preview/8439032/preview.jpg)](http://orcid.org/0000-0003-2280-1397)</sup>

<sup>1</sup>A Rocha Kenya, Watamu, Kenya
<sup>2</sup>National Museums of Kenya, Nairobi, Kenya

**Corresponding author**: Raphaël Nussbaumer ([raphael.nussbaumer@arocha.org](mailto:raphael.nussbaumer@arocha.org))

---

[![DOI:10.15468/2ga3wk](https://zenodo.org/badge/DOI/10.15468/2ga3wk.svg)](https://doi.org/10.15468/2ga3wk)
<div data-badge-popover="right" data-badge-type="1" data-doi="10.15468/2ga3wk" data-condensed="true" data-hide-no-mentions="true" class="altmetric-embed"></div>


[![licensebuttons by-nc](https://licensebuttons.net/l/by-nc/3.0/88x31.png)](https://creativecommons.org/licenses/by-nc/4.0)

**Keywords:** africa; kenya; bird; atlas; breeding; nest; presence; distribution; long-term; change; map; quarter degree grid cell; Occurrence; Observation

## Description
This dataset contains the digitized bird atlas data from "A Bird Atlas of Kenya" (Lewis & Pomeroy, 1989) (https://doi.org/10.1201/9781315136264).

The data records breeding codes (presence, probable or confirmed) by atlas taxon and quarter-degree grid cell. The occurrence export covers the pre-atlas and 1970–1984 atlas periods. The comparison CSV also retains the source workbook’s post-1984 column.

**Geographical coverage:** Covering all of the Republic of Kenya, using quarter degree grid cells (QDGC) (or quarter square degree) (Larsen et al. 2009). On this geographic system, Kenya covers 228 squares.

**Taxonomic coverage:** The atlas has 1,065 numbered bird taxa, plus two unnumbered entries for Shoebill and Taita Thrush. The book appears to follow Britton (1980). The source names are retained and linked to Avibase concepts in a curated mapping; see [Atlas taxonomy and Avibase](#atlas-taxonomy-and-avibase).

The original workbook and comparison export retain the atlas entries. The GBIF occurrence export excludes rejected and uncertain entries and applies documented reidentifications; see the [taxonomy and record review](docs/taxonomy.md) for the affected taxa, sources and remaining questions.

**Temporal coverage:** 1900-01-01 / 1984-12-31


## Sampling Methods

See Lewis & Pomeroy (1989) for information on sampling of the original data. See step description below for the digitisation of the data.

### Study Extent

See Lewis & Pomeroy (1989) for information on the study extent of the original data. Here, we describe only the digitisation of the data. We follow as closely as possible the extent of the data provided in the book. (1) The source workbook retains the species and taxonomy described in the book, including taxa since split or lumped; the GBIF export applies the documented record review. (2) We report the spatial information at the grid square level providing the original QDGC name (locality), the square as polygon (footprintWKT) and centre of the square (decimalLatitude, decimalLongitude). (3) We report the atlas code (presence, probable and confirmed) as given in the book at the square level. Note that we are not able to provide the atlas code for the pre-atlas period if the post-atlas period has a greater or equal atlas code (data not provided in the book).

### Quality Control	

See Lewis & Pomeroy (1989) for information on the quality control of the original data. We describe here only the digitisation of the data. We considered the book as the reference, and thus manually checked that the digitised data matches the maps of the book. To perform this validation, we generated the same maps as the book based on the digitised data and visually compared them to the original map to check for discrepancy. In the absence of map in the book, we checked the square code provided in the book. Additionally, we used the gbif data-validator before the upload (https://www.gbif.org/tools/data-validator).

### Step Description

1. The base spreadsheet was recovered by Colin Jackson and contains most of the data from the book with some modifications, losses and additions. The source of this document remains unknown.
2. The occurrence export selects records from the pre-1970 and 1970–1984 periods; the source workbook also retains post-1984 records.
3. We converted the data from a text description to a standardised column (date-atlas code).
4. We changed the species name to the name used in the book (both common and scientific names).
5. We added the data from the missing species (e.g., species without a map).
6. We reverted back any species split/lumped/removed since then.
7. Finally, we manually checked the data with the book (see quality control)
8. We exported the data in Darwin core standard with the code: https://github.com/Rafnuss/Digitization-of-A-Bird-Atlas-of-Kenya

![image](https://user-images.githubusercontent.com/7571260/161981966-ce19656c-b712-493c-a053-a767e3fe49ef.png)


## Bibliographic Citations

Lewis, Adrian, and Derek Pomeroy. 1989. A Bird Atlas of Kenya. edited by A. A. Balkema. Rotterdam: CRC Press. https://doi.org/10.1201/9781315136264

Britton, P. L. 1980. Birds of East Africa: Their Habitat, Status and Distribution. Nairobi: East Africa Natural History Society.

Larsen, R., T. Holmern, S. D. Prager, H. Maliti, and E. Røskaft. 2009. Using the Extended Quarter Degree Grid Cell System to Unify Mapping and Sharing of Biodiversity Data. *African Journal of Ecology* 47(3):382–92. https://doi.org/10.1111/j.1365-2028.2008.00997.x

Fisher, David, and Nigel Hunter. 2016. East African Rarities Committee (EARC) Special Report Species included for East African countries in Britton (1980) which have since been considered unacceptable. *Scopus: Journal of East African Ornithology* 36.2: 55-64.[link](https://www.ajol.info/index.php/scopus/article/view/139746)

Fanshawe, J.H., Prince, P. and Irwin, M. 1992. Black-bellied Storm Petrel Fregetta tropica, Antarctic Prion Pachyptila desolata, and Thin-billed Prion P. belcheri: three species new to Kenya and East Africa. *Scopus: Journal of East African Ornithology* 15: 102–108.

Hunter, N. 2019. Checklist of the Birds of Kenya 5th Edition. ISBN: 9966-761-37-3

Taylor, P.B. 1982. Storm-petrels off the Kenya coast. *Scopus: Journal of East African Ornithology* 6: 15-16

Turner, D.A. 1985. On the claimed occurrence of the Spike-heeled Lark Chersomanes albofasciata in Kenya. *Scopus: Journal of East African Ornithology* 9: 142

## Project files and workflow

- [Atlas workbook](data/raw/A%20Bird%20Atlas%20of%20Kenya_v5.xlsx): the digitized source data, including the atlas names, grid squares and period codes. Earlier versions are available in Git history.
- [Atlas taxonomy](data/curated/atlas_taxonomy.csv): the curated mapping from each atlas `SEQ` to an Avibase ID, name and supporting notes.
- [Record review](data/curated/atlas_record_review.csv): decisions on rejected, uncertain and reidentified atlas entries.
- [Comparison CSV](export/comparison/atlas_records.csv): the atlas records joined to the Avibase mapping, ready for comparison work. See its [export notes](export/comparison/README.md).
- [Occurrence CSV](export/gbif/occurrence.csv): the Darwin Core occurrence export for GBIF, derived from the atlas periods and taxonomy mapping.
- `data/raw/taxonomy/` contains the supplied taxonomy reference workbooks; `data/intermediate/` contains generated working files. Book scans and the labeling app remain in their original locations.

### Comparison CSV

Each row in `atlas_records.csv` comes from the atlas workbook. It includes the original `scientific_name` and `common_name`, grid coordinates `sq_n` and `sq_l`, and the source codes in `pre_1970`, `period_1970_1984` and `post_1984`. The last three fields are separate source periods; select the periods and records appropriate for your analysis. The file also includes `avibase_id`, `avibase_name` and `avibase_notes`, joined by `seq`.

Read `seq` as text: `0a` identifies Shoebill and `0b` Taita Thrush, two unnumbered book entries that both used 0 in the earlier workbook. These are project identifiers, not book sequence numbers. The CSV retains all workbook rows; a row is not necessarily an occurrence in every period.

### Atlas taxonomy and Avibase

The [curated taxonomy table](data/curated/atlas_taxonomy.csv) contains one row per atlas entry, preserving its original common and scientific names alongside its selected Avibase ID and name. The mapping started with historical scientific-name matches to AviList and used modern aliases, book scans, Avibase and Kenyan checklist evidence for difficult cases. Some entries use a more specific Kenyan taxon; others use a broader parent where a precise match is uncertain. The `match_basis`, `review_status`, `source` and `notes` fields document the basis and limitations. Name matches do not by themselves establish that historical and modern taxon concepts are identical; consult the notes before interpreting splits or combining records. See the [taxonomy and record review](docs/taxonomy.md).

### Regenerating exports

The numbered MATLAB scripts are independent stages, not a pipeline that must always be run from the beginning. Run these commands from the project root. Because MATLAB `run` cannot execute filenames beginning with a number, use `eval(fileread(...))` or execute sections interactively.

To regenerate the comparison CSV from the atlas workbook and curated taxonomy, run:

```matlab
eval(fileread('scripts/07_export_comparison.m'))
```

To regenerate the occurrence CSV, first build the classification reference from the supplied workbooks and then export the occurrences:

```matlab
eval(fileread('scripts/04_taxonomy_reference.m'))
eval(fileread('scripts/06_prepare_occurrence.m'))
```

Neither export requires rerunning the historical digitization or contacting GBIF. The occurrence export uses the selected Avibase/AviList scientific name where available and retains the atlas names; see [taxonomy documentation](docs/taxonomy.md) for the fields and qualifications. The files in this repository represent the current working export and may differ from the published GBIF dataset.

### Historical digitization and review

`scripts/01_create_grid.m`, `02_read_atlas_maps.m` and `03_review_digitization.m` document the original grid preparation, map extraction and interactive labeling work. They are not required for the exports above. Step 03 combines interactive review with exporting completed grid records and references an earlier workbook and a saved labeling session that are not included; the completed workbook also involved manual curation. These scripts therefore do not currently reproduce the final workbook end to end.

## How to cite?

> Nussbaumer R, Shema S, Kennedy S, Jackson C (2022). A Bird Atlas of Kenya. Version 1.1. A Rocha Kenya. Occurrence dataset https://doi.org/10.15468/2ga3wk accessed via GBIF.org on 2022-08-01.
