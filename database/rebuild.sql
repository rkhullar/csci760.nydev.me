/*
 * @author  : Rajan Khullar
 * @created : 04/16/16
 * @updated : 04/28/16
 */

create extension if not exists pgcrypto;

drop schema if exists dbo cascade;
drop schema if exists dbv cascade;
drop schema if exists new cascade;

create schema dbo;
create schema dbv;
create schema new;

/* Account Relations */

create table dbo.actor
(
  id serial primary key,
  firstname varchar(20) not null,
  lastname varchar(20) not null,
  email varchar(50) unique not null,
  phone numeric(9,0) not null,
  address varchar(100) not null,
  password bytea not null
);

create table dbo.admin
(
  id serial references dbo.actor(id)
);

create table dbo.reader
(
  id serial references dbo.actor(id),
  card numeric(8, 0) unique not null
);

create view dbv.reader as
  select a.id, r.card, a.firstname, a.lastname, a.email, a.phone, a.address, a.password
  from dbo.actor a, dbo.reader r
  where a.id = r.id;

create function new.actor(fname varchar(20), lname varchar(20), email varchar(50), phone numeric(9,0), address varchar(100), pswd bytea default digest('aaaaaa', 'sha256'))
  returns integer as $$
insert into dbo.actor(firstname, lastname, email, phone, address, "password")
  values ($1, $2, $3, $4, $5, $6)
  returning id;
$$ language sql;


create function new.reader(card numeric(8, 0), fname varchar(20), lname varchar(20), email varchar(50), phone numeric(9,0), address varchar(100), pswd bytea default digest('aaaaaa', 'sha256'))
  returns integer as $$
  insert into dbo.reader(id, card)
      values (new.actor($2, $3, $4, $5, $6, $7), $1)
      returning id;
  $$ language sql;

/* Book Relations */
create table dbo.author
(
  id serial primary key,
  firstname varchar(20) not null,
  lastname varchar(20) not null
);

create table dbo.publisher
(
  id serial primary key,
  firstname varchar(20) not null,
  lastname varchar(20) not null,
  address varchar(100) not null
);

create table dbo.book
(
  isbn numeric(13, 0) not null primary key,
  title varchar(100) not null,
  auhtorID serial references dbo.author(id) not null,
  publisherID serial references dbo.publisher(id) not null,
  pubdate date not null
);
