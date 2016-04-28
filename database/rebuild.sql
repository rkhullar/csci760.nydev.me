/*
 * @author  : Rajan Khullar
 * @created : 04/16/16
 * @updated : 04/27/16
 */

create extension if not exists pgcrypto;

drop schema if exists dbo cascade;
drop schema if exists dbv cascade;
drop schema if exists new cascade;

create schema dbo;
create schema dbv;
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

create table dbo.reader
(
  id serial references dbo.actor(id),
  card int8 unique not null
);

create view dbv.reader as
  select a.id, a.firstname, a.lastname, r.card
  from dbo.actor a, dbo.reader r
  where a.id = r.id;

create function new.actor(fname varchar(20), lname varchar(20), email varchar(50), pswd bytea default digest('aaaaaa', 'sha256'))
  returns integer as $$
insert into dbo.actor(firstname, lastname, email, "password")
  values ($1, $2, $3, $4)
  returning id;
$$ language sql;


create function new.reader(fname varchar(20), lname varchar(20), email varchar(50), card int8, pswd bytea default digest('aaaaaa', 'sha256'))
  returns integer as $$
  insert into dbo.reader(id, card)
      values (new.actor($1, $2, $3, $5), $4)
      returning id;
  $$ language sql;