/*
 * @author  : Rajan Khullar
 * @created : 04/16/16
 * @updated : 05/04/16
 */


/* setup reader accounts */
truncate dbo.actor cascade;
select new.reader(00000000, 'Rajan', 'Khullar', 'rajan@nydev.me', 000000000, 'Earth');
select new.reader(11111111, 'bot1', 'nydev', 'bot1@nydev.me', 000000000, 'NYIT');
select new.reader(22222222, 'bot2', 'nydev', 'bot2@nydev.me', 000000000, 'NYIT');
select new.reader(33333333, 'bot3', 'nydev', 'bot3@nydev.me', 000000000, 'NYIT');
select new.reader(44444444, 'bot4', 'nydev', 'bot4@nydev.me', 000000000, 'NYIT');
select new.reader(55555555, 'bot5', 'nydev', 'bot5@nydev.me', 000000000, 'NYIT');
select new.reader(66666666, 'bot6', 'nydev', 'bot6@nydev.me', 000000000, 'NYIT');
select new.reader(77777777, 'bot7', 'nydev', 'bot7@nydev.me', 000000000, 'NYIT');
select new.reader(88888888, 'bot8', 'nydev', 'bot8@nydev.me', 000000000, 'NYIT');
select new.reader(99999999, 'bot9', 'nydev', 'bot9@nydev.me', 000000000, 'NYIT');

/* setup admin accounts */
select new.actor('Admin', 'Master', 'admin@nydev.me', 000000000, 'Earth', digest('mypass', 'sha256'));
truncate dbo.admin;
insert into dbo.admin
  select id
  from dbo.actor
  where email = 'admin@nydev.me';

/* reset books */
truncate dbo.author cascade;
truncate dbo.publisher cascade;
truncate dbo.book cascade;

/* add books to the library */
select new.book(00, '05/03/2016', 'El Monster'         , 'Donald' , 'Trump'  , 'Princeton', '', '');
select new.book(01, '05/03/2016', 'Things Happen'      , 'Matthew', 'Warshaw', 'Princeton', '', '');
select new.book(02, '05/03/2016', 'Encyclopedia Alpha' , 'John'   , 'Adams'  , 'Harvard'  , '', '');
select new.book(03, '05/03/2016', 'Encyclopedia Beta'  , 'John'   , 'Adams'  , 'Harvard'  , '', '');
select new.book(04, '05/03/2016', 'Encyclopedia Gamma' , 'John'   , 'Adams'  , 'Harvard'  , '', '');
select new.book(05, '05/03/2016', 'Encyclopedia Theta' , 'John'   , 'Adams'  , 'Harvard'  , '', '');
select new.book(06, '05/03/2016', 'Encyclopedia Iota'  , 'John'   , 'Adams'  , 'Harvard'  , '', '');
select new.book(07, '05/03/2016', 'Encyclopedia Omega' , 'John'   , 'Adams'  , 'Harvard'  , '', '');
select new.book(08, '05/03/2016', 'Life of Pi'         , 'Mary'   , 'Jane'   , 'Soul'     , '', '');
select new.book(09, '05/03/2016', 'The School Bus'     , 'Mary'   , 'Jane'   , 'Soul'     , '', '');
select new.book(10, '05/03/2016', 'Martian War'        , 'Mary'   , 'Jane'   , 'Soul'     , '', '');
select new.book(11, '05/03/2016', 'Data Structures'    , 'Alan'   , 'Turing' , 'Internet' , '', '');
select new.book(12, '05/03/2016', 'Subway Six'         , 'Mary'   , 'Jane'   , 'Soul'     , '', '');
select new.book(13, '05/03/2016', 'Alphabet Soup'      , 'Joseph' , 'Stalin' , 'Princeton', '', '');
select new.book(15, '05/03/2016', 'The Cheaters'       , 'Hillary', 'Clinton', 'Internet' , '', '');
select new.book(16, '05/03/2016', 'Universal History'  , 'John'   , 'Adams'  , 'Princeton', '', '');
select new.book(17, '05/03/2016', 'Python Machines'    , 'Matthew', 'Warshaw', 'City'     , '', '');
select new.book(18, '05/03/2016', 'Computer Arch'      , 'Matthew', 'Warshaw', 'City'     , '', '');
select new.book(19, '05/03/2016', 'How to Linux'       , 'Matthew', 'Warshaw', 'City'     , '', '');
select new.book(20, '05/03/2016', 'I am the Wizard Now', 'Harry'  , 'Potter' , 'Hogwarts' , '', '');

/* create library branches */
truncate dbo.branch cascade;
insert into dbo.branch("name", address) values
('New York Library', 'New York'),
('Boston Library', 'Massachusetts'),
('Nanjing World Library', 'Nanjing');
