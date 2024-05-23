GET_FIRMS = """
with firm_feetback as
(
    select
    f.id,
    coalesce(jsonb_agg(jsonb_build_object(
        'id', fe.id, 'score', fe.score, 'report', fe.report))
         filter (where fe.id is not null), '[]') as feedback
    from car_api_data.firm f
    left join car_api_data.feedback fe on fe.firm_id = f.id
    group by f.id
),
firm_cars as
(
    select
    f.id,
    coalesce(jsonb_agg(jsonb_build_object(
        'id', c.id, 'brand', c.brand, 'model', c.model,
        'equipment', c.equipment, 'engine capacity', c.engine_capacity,
        'drive', c.drive, 'color', c.color, 'mileage', c.mileage))
         filter (where c.id is not null), '[]') as car
    from car_api_data.firm f
    left join car_api_data.car_firm cf on cf.firm_id = f.id
    left join car_api_data.car c on c.id = cf.car_id
    group by f.id
)
select
    f.id,
    f.name,
    f.phone,
    f.address,
    f.foundation_year,
    ff.feedback,
    fc.car
from car_api_data.firm f
left join firm_feetback ff on ff.id = f.id
left join firm_cars fc on fc.id = f.id
{where}
group by f.id, ff.feedback, fc.car;
"""

INSERT_FIRM = """
    insert into car_api_data.firm(name, phone, address, foundation_year)
    values ({name}, {phone}, {address}, {foundation_year})
    returning id;
"""

UPDATE_FIRM = """
    update car_api_data.firm set
    name = {name}, 
    phone = {phone},
    address = {address},
    foundation_year = {foundation_year}
    where id = {id} 
    returning id;
"""

DELETE_FIRM_LINK = "delete from car_api_data.car_firm where firm_id = {id};"

DELETE_FIRM = "delete from car_api_data.firm where id = {id} returning id;"