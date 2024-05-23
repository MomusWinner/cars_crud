-- migrate:up
create index frim_foundation_year_idx on car_api_data.firm using btree(foundation_year);

create extension pg_trgm;
create index firm_name_trgm_idx on car_api_data.firm using gist(name gist_trgm_ops);
-- migrate:down