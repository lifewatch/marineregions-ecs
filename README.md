# Extended Continental Shelves

Custom code to create Pacific-centered version of the Marine Regions data product: Extended Continental Shelves v1 

## Getting started

* Prerequisites: [PostgreSQL](https://www.postgresql.org/) and [PostGIS](https://postgis.net/)
* It is assumed that you created a PostgreSQL database and you imported via `shp2pgsql` the following Marine Regions' product:
> Flanders Marine Institute (2022). Maritime Boundaries Geodatabase: Extended Continental Shelves, version 1. Available online at https://www.marineregions.org/ https://doi.org/10.14284/577.

An overview of the full workflow is available in the methodology page of the Marine Regions website: https://www.marineregions.org/eezmethodology.php

## Directory structure

```
marineregions-ecs/
└── src/
    └── make_pacific_centered.sql
```

## More information

For any questions please send an email to: info@marineregions.org



