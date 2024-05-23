-- migrate:up

create extension if not exists "uuid-ossp";
create schema if not exists car_api_data;

create table car_api_data.car(
    id uuid primary key default uuid_generate_v4(),
    brand text,
    model text,
    equipment text,
    engine_capacity numeric check ( engine_capacity >= 0 ),
    drive text,
    color text,
    mileage numeric check ( mileage >= 0 )
);

create table car_api_data.firm(
    id uuid primary key default uuid_generate_v4(),
    name text,
    phone text,
    address text,
    foundation_year int
);

create table car_api_data.car_firm(
    car_id uuid references car_api_data.car on delete cascade,
    firm_id uuid references car_api_data.firm on delete cascade,
    primary key (car_id, firm_id)
);

create table car_api_data.feedback(
    id uuid primary key default uuid_generate_v4(),
    score int check ( 0 <= score and score <= 10),
    report text,
    firm_id uuid references car_api_data.firm on delete cascade 
);

insert into car_api_data.car (brand, model, equipment, engine_capacity, drive, color, mileage)
values
    ('BMV', 'BMW M2 F87-рестайлинг купе', '3.0 MT', 3.0, 'задний', 'белый', 100000),
    ('BMV', 'BMW M2 F87-рестайлинг купе', '3.0 AMT', 3.0, 'задний', 'чёрный', 20000),
    ('Toyota', 'Toyota Camry', ' 2.4 AT', 2.4, 'передний', 'чёрный', 1679239),
    ('Mazda', 'Mazda CX-7', '2.3 AT', 2.3, 'полный', 'красный', 345140),
    ('Geely', 'Geely Okavango', '2.0 AMT', 2.0, 'передний', 'белый', 400890),
    ('Lada', 'Lada (ВАЗ) Granta', ' 1.6 AMT', 1.6, 'передний', 'белый', 823000),
    ('Jetour', 'Jetour T2', '2.0 AMT', 2.0, 'полный', 'серый', 278290),
    ('SsangYong', 'SsangYong Kyron', '2.3 MT', 2.3, 'полный', 'чёрный',300290),
    ('Volkswagen', 'Volkswagen Polo', '1.6 MT', 1.6, 'передний', 'кремовый', 400400),
    ('Lada', 'Lada (ВАЗ) 2101', '1.2 MT', 1.2, 'задний', 'белый', 100400400);
    
insert into car_api_data.firm(name, phone, address, foundation_year)
values
    ('Лучший прокат', '+79649711288', 'ул. Космонавтов д.7', 2000),
    ('Ru Прокат', '+79649800288', 'ул. Тополиная д.1', 1930),
    ('Хоть что-то', '+79649001288', 'ул. Ленина д.60', 1909),
    ('Понт', '+79649001288', 'ул. Московская д.3',2012);

insert into car_api_data.car_firm
values
    ((select id from car_api_data.car where model = 'Mazda CX-7'), (select id from car_api_data.firm where name = 'Лучший прокат')),
    ((select id from car_api_data.car where model = 'Toyota Camry'), (select id from car_api_data.firm where name = 'Лучший прокат')),
    ((select id from car_api_data.car where model = 'BMW M2 F87-рестайлинг купе' and equipment='3.0 AMT'), (select id from car_api_data.firm where name = 'Лучший прокат')),
    ((select id from car_api_data.car where model = 'Lada (ВАЗ) Granta'), (select id from car_api_data.firm where name = 'Ru Прокат')),
    ((select id from car_api_data.car where model = 'Lada (ВАЗ) 2101'), (select id from car_api_data.firm where name = 'Ru Прокат')),
    ((select id from car_api_data.car where model = 'Lada (ВАЗ) 2101'), (select id from car_api_data.firm where name = 'Хоть что-то')),
    ((select id from car_api_data.car where model = 'Lada (ВАЗ) Granta'), (select id from car_api_data.firm where name = 'Хоть что-то')),
    ((select id from car_api_data.car where model = 'Volkswagen Polo'), (select id from car_api_data.firm where name = 'Хоть что-то')),
    ((select id from car_api_data.car where model = 'Mazda CX-7'), (select id from car_api_data.firm where name = 'Хоть что-то')),
    ((select id from car_api_data.car where model = 'BMW M2 F87-рестайлинг купе' and equipment='3.0 MT'), (select id from car_api_data.firm where name = 'Понт')),
    ((select id from car_api_data.car where model = 'BMW M2 F87-рестайлинг купе' and equipment='3.0 AMT'), (select id from car_api_data.firm where name = 'Понт')),
    ((select id from car_api_data.car where model = 'Geely Okavango'), (select id from car_api_data.firm where name = 'Понт'));

insert into car_api_data.feedback(score, report, firm_id)
values
    (10, 'Доволен!!', (select id from car_api_data.firm where name = 'Лучший прокат')),
    (5, 'В машине много пыли', (select id from car_api_data.firm where name = 'Лучший прокат')),
    (9, 'Машины в хорошем состоянии', (select id from car_api_data.firm where name = 'Лучший прокат')),
    (3, 'Масло подтекает', (select id from car_api_data.firm where name = 'Ru Прокат')),
    (9, 'В машине очень чисто!!', (select id from car_api_data.firm where name = 'Ru Прокат')),
    (10, 'Хорошое обслуживание', (select id from car_api_data.firm where name = 'Ru Прокат')),
    (9, 'Удобный сайт', (select id from car_api_data.firm where name = 'Ru Прокат')),
    (2, 'Машина без бензина и с доисторическим маслом', (select id from car_api_data.firm where name = 'Хоть что-то')),
    (0, 'Нашёл старые, грязные, вонючие носки', (select id from car_api_data.firm where name = 'Хоть что-то')),
    (3, 'Лопнуло колесо', (select id from car_api_data.firm where name = 'Хоть что-то')),
    (10, 'После проката болшье людей купили мои курсы', (select id from car_api_data.firm where name = 'Понт')),
    (9, 'Всё круто', (select id from car_api_data.firm where name = 'Понт')),
    (8, 'Ничего страшно что я машину под речкой оставил?', (select id from car_api_data.firm where name = 'Понт'));

-- migrate:down

drop table if exists car_api_data.car, car_api_data.firm, car_api_data.feedback, car_api_data.car_firm cascade;