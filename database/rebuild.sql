/*
 * @author  : Rajan Khullar
 * @created : 04/16/16
 * @updated : 04/28/16
 */

create extension if not exists pgcrypto;

drop schema if exists dbo cascade;
drop schema if exists dbv cascade;
drop schema if exists new cascade;
drop schema if exists map cascade;

create schema dbo;
create schema dbv;
create schema new;
create schema map;

/* Login System */

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
  id serial references dbo.actor(id),
  primary key (id)
);

create table dbo.reader
(
  id serial references dbo.actor(id),
  card numeric(8, 0) unique not null,
  primary key (id)
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

/* Book Base */
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

create function new.uniq_author(fname varchar(20), lname varchar(20))
  returns integer as $$
  insert into dbo.author(firstname, lastname)
    select fname, lname
    where not exists
    (
      select *
      from dbo.author
      where firstname=fname and lastname=lname
    )
  returning id;
  $$ language sql;

create function new.uniq_publish(fname varchar(20), lname varchar(20), address varchar(100))
  returns integer as $$
  insert into dbo.publisher(firstname, lastname, address)
    select fname, lname, address
    where not exists
    (
      select *
      from dbo.publisher
      where firstname=fname and lastname=lname and address=address
    )
  returning id;
  $$ language sql;

create function new.book(isbn numeric(13,0), pubdate date, title varchar(100), author_fname varchar(20), author_lname varchar(20), publish_fname varchar(20), publish_lname varchar(20), publish_address varchar(100))
  returns void as $$
  select new.uniq_author(author_fname, author_lname);
  select new.uniq_publish(publish_fname, publish_lname, publish_address);
  insert into dbo.book(isbn, pubdate, title, auhtorID, publisherID)
      select isbn, pubdate, title,
        (select id from dbo.author
          where firstname=author_fname and lastname=author_lname),
        (select id from dbo.publisher
          where firstname=publish_fname and lastname=publish_lname and address=publish_address);
  $$ language sql;


/* Library Base */
create table dbo.branch
(
  id serial primary key,
  name varchar(100) not null,
  address varchar(100) not null
);

create table dbo.copy
(
  id serial primary key,
  isbn numeric(13, 0) references dbo.book(isbn) not null,
  branchID serial references dbo.branch(id) not null,
  n integer not null,
  unique (isbn, branchID, n),
  lock boolean not null default false
);

create table map.borrow
(
  copyID serial references dbo.copy(id),
  readerID serial references dbo.reader(id),
  pickup timestamp not null default now(),
  return timestamp,
  payment money not null default 0,
  primary key (copyID, readerID, pickup)
);

create table map.reserve
(
  copyID serial references dbo.copy(id),
  readerID serial references dbo.reader(id),
  record time not null default now()
);