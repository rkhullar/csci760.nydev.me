/*
 * @author  : Rajan Khullar
 * @created : 04/16/16
 * @updated : 04/23/16
 */

create extension if not exists pgcrypto;

drop schema if exists dbo cascade;
drop schema if exists new cascade;

create schema dbo;
create schema new;

create table dbo.actor
(
  id serial primary key,
  firstname varchar(20) not null,
  lastname varchar(20) not null,
  email varchar(50) unique not null,
  password bytea not null
);

create table dbo.admin
(
  id serial references dbo.actor(id)
);

create function new.actor(varchar(20), varchar(20), varchar(50), bytea default digest('aaaaaa', 'sha256'))
  returns boolean as $$
insert into dbo.actor(firstname, lastname, email, "password")
values ($1, $2, $3, $4);
select true as result;
$$ language sql;