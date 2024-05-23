-- migrate:up
insert into car_api_data.firm (name, phone, address, foundation_year)
select
       concat(firm_names[1 + floor((random() * array_length(firm_names, 1)))::int], md5(random()::text)),
       md5(random()::text),
       concat(firm_addresses[1 + floor((random() * array_length(firm_addresses, 1)))::int], (random() * 10)::text),
       1920 + random() * 80
from generate_series(1, 100000)
        cross join
     (select '{МистерКрутой,У_Максима,папа_водит,Япошка,BMW_love,Mersendes_love,Никита,Михаил,Такчки,Безназвания}'
        ::text[] as firm_names,
        '{Воскресенская,Цветочная,Московская,Ворошилова,Ленина,Пушкина}'
        ::text[] as firm_addresses) as nms;
-- migrate:down
