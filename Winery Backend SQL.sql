select wy.name, w.name
from wineries wy, wines w, grapes g, regions r
where r.id = wy.region_id
and wy.id = w.winery_id 
and g.id = w.grape_id
and r.name = 'Napa Valley'
order by wy.name, w.name

select r.name, count(wy.id)
from regions r, wineries wy
where r.id = wy.region_id
group by r.name
order by count(wy.id) DESC

select r.name "region", wy.name, wy.country, wy.province, wy.area
from regions r, wineries wy
where r.id = wy.region_id
order by r.name, wy.country, wy.province, wy.area, wy.name

select * from wineries where name = 'Crooked Vine Winery' or name = 'E & J Gallo Winery'

select wy.* 
from regions r, wineries wy
where r.id = wy.region_id
and name = 'Crooked Vine Winery' or name = 'E & J Gallo Winery'

select wy.* from regions r, wineries wy where r.id = wy.region_id and name = 'Crooked Vine Winery' or name = 'E & J Gallo Winery'

select y.* from wineries y, wines w, grapes g where  y.id = w.winery_id and g.id = w.grape_id and g.name='Chardonnay'

select y.* from wineries y, wines w, grapes g, regions r where  y.id = w.winery_id and g.id = w.grape_id and r.id = y.region_id and g.name='Chardonnay' and r.name='Napa Valley'

select * from trips;