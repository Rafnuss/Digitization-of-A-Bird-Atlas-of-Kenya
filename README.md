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

The data consists of the breeding code (presence, probable or confirmed) for all species and quarter degree grid cells in Kenya for two periods: pre-atlas (up to 1970) and during the atlas (1970-1984).

**Geographical coverage:** Covering all of the Republic of Kenya, using quarter degree grid cells (QDGC) (or quarter square degree) (Larsen et al. 2009). On this geographic system, Kenya covers 228 squares.

**Taxonomic coverage:** All 1065 bird species (*aves sp.*) recorded in Kenya by 1985. These comprise the 1053 mentioned by Britton (1980), 13 added since then (EABR; Scopus 9:53-54, 110-111) and one deleted (Parker 1984). The book seems to follow the taxonomy adopted by Britton (1980). While the data preserves the original common and scientific names (as `originalNameUsage`), the data original taxonomy is matched to the GBIF Backbone Taxonomy.

**Temporal coverage:** 1900-01-01 / 1984-12-31


## Sampling Methods

See Lewis & Pomeroy (1989) for information on sampling of the original data. See step description below for the digitisation of the data.

### Study Extent

See Lewis & Pomeroy (1989) for information on the study extent of the original data. Here, we describe only the digitisation of the data. We follow as closely as possible the extent of the data provided in the book. (1) We report all species mentioned in the book and followed their taxonomy (even for species which have since been split or lumped). (2) We report the spatial information at the grid square level providing the original QDGC name (locality), the square as polygon (footprintWKT) and centre of the square (decimalLatitude, decimalLongitude). (3) We report the atlas code (presence, probable and confirmed) as given in the book at the square level. Note that we are not able to provide the atlas code for the pre-atlas period if the post-atlas period has a greater or equal atlas code (data not provided in the book).

### Quality Control	

See Lewis & Pomeroy (1989) for information on the quality control of the original data. We describe here only the digitisation of the data. We considered the book as the reference, and thus manually checked that the digitised data matches the maps of the book. To perform this validation, we generated the same maps as the book based on the digitised data and visually compared them to the original map to check for discrepancy. In the absence of map in the book, we checked the square code provided in the book. Additionally, we used the gbif data-validator before the upload (https://www.gbif.org/tools/data-validator).

### Step Description

1. The base spreadsheet was recovered by Colin Jackson and contains most of the data from the book with some modifications, losses and additions. The source of this document remains unknown.
2. We removed all data dating from after the atlas project.
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
Larsen, R., T. Holmern, S. D. Prager, H. Maliti, and E. Røskaft. 2009. “Using the Extended Quarter Degree Grid Cell System to Unify Mapping and Sharing of Biodiversity Data.” African Journal of Ecology 47(3):382–92. https://doi.org/10.1111/j.1365-2028.2008.00997.x


## How to cite?

> Nussbaumer R, Shema S, Kennedy S, Jackson C (2022). A Bird Atlas of Kenya. Version 1.1. A Rocha Kenya. Occurrence dataset https://doi.org/10.15468/2ga3wk accessed via GBIF.org on 2022-08-01.
