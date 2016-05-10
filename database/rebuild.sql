/*
 * @author  : Rajan Khullar
 * @created : 04/16/16
 * @updated : 05/09/16
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
  payment money not null default 0,
  primary key (id)
);

create view dbv.reader as
  select a.id, r.card, a.firstname, a.lastname, a.email, a.phone, a.address, a.password, r.payment
  from dbo.actor a, dbo.reader r
  where a.id = r.id;

create function new.actor(fname varchar(20), lname varchar(20), email varchar(50), phone numeric(9,0) default 0, address varchar(100) default 'NYIT', pswd bytea default digest('aaaaaa', 'sha256'))
  returns integer as $$
  insert into dbo.actor(firstname, lastname, email, phone, address, "password")
    values ($1, $2, $3, $4, $5, $6)
    returning id;
$$ language sql;


create function new.reader(card numeric(8, 0), fname varchar(20), lname varchar(20), email varchar(50), phone numeric(9,0) default 0, address varchar(100) default 'NYIT', pswd bytea default digest('aaaaaa', 'sha256'))
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

create view dbv.book as
  select b.isbn, b.pubdate, b.title,
    concat(a.firstname, ' ', a.lastname) as author,
    concat(p.firstname, ' ', p.lastname) as publisher, p.address
  from dbo.book b, dbo.author a, dbo.publisher p
  where b.auhtorID = a.id and b.publisherID = p.id;

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

create function new.uniq_publish(fname varchar(20), lname varchar(20), addresss varchar(100))
  returns integer as $$
  insert into dbo.publisher(firstname, lastname, address)
    select fname, lname, addresss
    where not exists
    (
      select *
      from dbo.publisher
      where firstname=fname and lastname=lname and address=addresss
    )
  returning id;
  $$ language sql;

create function new.book(isbn numeric(13,0), pubdate text, title varchar(100), author_fname varchar(20), author_lname varchar(20), publish_fname varchar(20), publish_lname varchar(20), publish_address varchar(100))
  returns void as $$
  select new.uniq_author(author_fname, author_lname);
  select new.uniq_publish(publish_fname, publish_lname, publish_address);
  insert into dbo.book(isbn, pubdate, title, auhtorID, publisherID)
      select isbn, to_date(pubdate, 'MM/DD/YYYY'), title,
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

create view dbv.inventory as
  select c.isbn, o.title, b.id as branchID, count(*)
  from dbo.copy c, dbo.branch b, dbo.book o
  where c.branchID = b.id and c.isbn = o.isbn
  group by c.isbn, o.title, b.id
  order by c.isbn, b.id;

create function new.copy(isbn numeric(13,0), branchID integer, amt integer)
  returns void as $$
  declare
    count integer := 1;
  begin
    while count <= amt loop
      insert into dbo.copy(isbn, branchID, n)
        select isbn, branchID, count;
      count := count + 1;
    end loop;
  end;
  $$ language plpgsql;

create function new.easy_copy(book_title varchar(100), n1 int default 10, n2 int default 10, n3 int default 10)
  returns void as $$
  declare
    book numeric(13,0);
  begin
    select isbn into book from dbo.book where title=book_title;
    perform new.copy(book, 1, n1);
    perform new.copy(book, 2, n2);
    perform new.copy(book, 3, n3);
  end;
  $$ language plpgsql;

create table map.borrow
(
  copyID serial references dbo.copy(id),
  readerID serial references dbo.reader(id),
  pickup date not null default current_date,
  return date,
  primary key (copyID, readerID, pickup)
);

create table map.reserve
(
  copyID serial references dbo.copy(id),
  readerID serial references dbo.reader(id),
  primary key (copyID, readerID)
);

create view dbv.borrow as
  select m.readerID, m.copyID, c.branchID, b.isbn, b.title, b.author, m.pickup, m.pickup+20 as duedate
  from map.borrow m, dbo.copy c, dbv.book b
  where m.copyID = c.id and c.isbn = b.isbn and m.return is null;

create view dbv.reserve as
  select m.readerID, m.copyID, c.branchID, b.isbn, b.title, b.author
  from map.reserve m, dbv.book b, dbo.copy c
  where m.copyID = c.id and c.isbn = b.isbn;

create view dbv.fines as
  select sum(current_date - b.duedate)
  from dbv.borrow b, dbo.reader r
  where b.readerID = r.id
