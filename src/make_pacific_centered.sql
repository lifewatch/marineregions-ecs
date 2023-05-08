--create duplicate table for working on 0-360 product
CREATE TABLE ecs_0_360 AS
TABLE ecs;
 
--clip to -180 - 180 to compensate for incorrect geometries
UPDATE public.ecs_0_360
SET the_geom = ST_Multi(ST_Intersection(the_geom,ST_GeomFromText('MultiPolygon (((-180 90, 180 90, 180 -90, -180 -90, -180 90)))',4326)))
 
--function to split features on longitude = 0 before translating
--if you want to use this function on other tables, take into account to change the table names
CREATE FUNCTION split_geometry_greenwich() RETURNS void AS $$
DECLARE
temprow RECORD;
BEGIN
--this FOR loop only takes into account polygons that cross longitude = 0, which will speed up the algorithm
FOR temprow IN
    SELECT mrgid, the_geom FROM public.ecs_0_360 GROUP BY mrgid, the_geom HAVING ST_Intersects(the_geom,ST_MakeLine(ST_SetSRID(ST_MakePoint(0,90), 4326),ST_SetSRID(ST_MakePoint(0,-90), 4326))) = TRUE
LOOP
    RAISE NOTICE 'Splitting geometry for MRGID %', quote_literal(temprow.mrgid);
    UPDATE public.ecs_0_360
    SET the_geom = ST_CollectionExtract(ST_Split(the_geom, ST_MakeLine(ST_SetSRID(ST_MakePoint(0,90), 4326),ST_SetSRID(ST_MakePoint(0,-90), 4326))), 3)
    WHERE mrgid = temprow.mrgid;
END LOOP;
END;
$$ LANGUAGE plpgsql;
 
--run new function
SELECT split_geometry_greenwich()
 
--move all components of the given geometries whose bounding box falls completely on the left of x=0 to +360
--https://postgis.net/docs/ST_WrapX.html
UPDATE public.ecs_0_360
SET the_geom = ST_WrapX(the_geom, 0, 360)
 
--fix invalid geometry where necessary
--https://postgis.net/docs/ST_MakeValid.html
UPDATE public.ecs_0_360
SET the_geom=ST_CollectionExtract(ST_MakeValid(the_geom),3)
WHERE ST_IsValid(the_geom) = false;
