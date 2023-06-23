use Elmer
go

-- summarize the households (hhs_all) by county and target:
select  pd.county_name_luvit_2023, pd.target_name_luvit_2023, sum(pf.value) as val  
from small_areas.parcel_facts pf
    join small_areas.variable_dim vd on pf.variable_dim_id = vd.variable_dim_id
    join small_areas.parcel_dim pd on pf.parcel_dim_id = pd.parcel_dim_id
where pf.model_year = 2040
    and vd.[name] like 'hhs_all'
group by pd.county_name_luvit_2023,  pd.target_name_luvit_2023
order by pd.county_name_luvit_2023,  pd.target_name_luvit_2023

-- now summarize the hhs_all variable by congressional district, 
--  using a spatial join to ElmerGeo.dbo.CONGDIST12:
select  c.district_n, sum(pf.value) as val  -- ran in 0:08
from small_areas.parcel_facts pf
    join small_areas.variable_dim vd on pf.variable_dim_id = vd.variable_dim_id
    join small_areas.parcel_dim pd on pf.parcel_dim_id = pd.parcel_dim_id
    join ElmerGeo.dbo.CONGDIST12 c on c.Shape.STContains(pd.geom) = 1
where pf.model_year = 2040
    and vd.[name] like 'hhs_all'
group by c.district_n
order by c.district_n


-- take a peek at the congdist12 fields in ElmerGeo:
select top 10 *
from elmergeo.dbo.CONGDIST12