/*
 * @author  : Rajan Khullar
 * @created : 04/16/16
 * @updated : 05/04/16
 */


/* setup reader accounts */
truncate dbo.actor cascade;
select new.reader(10000000, 'Rajan', 'Khullar', 'rajan@nydev.me');
select new.reader(10000001, 'bot01', 'nydev', 'bot01@nydev.me');
select new.reader(10000002, 'bot02', 'nydev', 'bot02@nydev.me');
select new.reader(10000003, 'bot03', 'nydev', 'bot03@nydev.me');
select new.reader(10000004, 'bot04', 'nydev', 'bot04@nydev.me');
select new.reader(10000005, 'bot05', 'nydev', 'bot05@nydev.me');
select new.reader(10000006, 'bot06', 'nydev', 'bot06@nydev.me');
select new.reader(10000007, 'bot07', 'nydev', 'bot07@nydev.me');
select new.reader(10000008, 'bot08', 'nydev', 'bot08@nydev.me');
select new.reader(10000009, 'bot09', 'nydev', 'bot09@nydev.me');
select new.reader(10000010, 'bot10', 'nydev', 'bot10@nydev.me');
select new.reader(10000011, 'bot11', 'nydev', 'bot11@nydev.me');
select new.reader(10000012, 'bot12', 'nydev', 'bot12@nydev.me');
select new.reader(10000013, 'bot13', 'nydev', 'bot13@nydev.me');
select new.reader(10000014, 'bot14', 'nydev', 'bot14@nydev.me');
select new.reader(10000015, 'bot15', 'nydev', 'bot15@nydev.me');
select new.reader(10000016, 'bot16', 'nydev', 'bot16@nydev.me');
select new.reader(10000017, 'bot17', 'nydev', 'bot17@nydev.me');
select new.reader(10000018, 'bot18', 'nydev', 'bot18@nydev.me');
select new.reader(10000019, 'bot19', 'nydev', 'bot19@nydev.me');
select new.reader(10000020, 'bot20', 'nydev', 'bot20@nydev.me');


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
select new.book(1000000000001, '05/03/2016', 'Things Happen'      , 'Matthew', 'Warshaw', 'Pub2', '', 'Princeton');
select new.book(1000000000002, '05/03/2016', 'Encyclopedia Alpha' , 'John'   , 'Adams'  , 'Pub1', '', 'Harvard'  );
select new.book(1000000000003, '05/03/2016', 'Encyclopedia Beta'  , 'John'   , 'Adams'  , 'Pub2', '', 'Harvard'  );
select new.book(1000000000004, '05/03/2016', 'Encyclopedia Gamma' , 'John'   , 'Adams'  , 'Pub1', '', 'Harvard'  );
select new.book(1000000000005, '05/03/2016', 'Encyclopedia Theta' , 'John'   , 'Adams'  , 'Pub2', '', 'Harvard'  );
select new.book(1000000000006, '05/03/2016', 'Encyclopedia Iota'  , 'John'   , 'Adams'  , 'Pub1', '', 'Harvard'  );
select new.book(1000000000007, '05/03/2016', 'Encyclopedia Omega' , 'John'   , 'Adams'  , 'Pub2', '', 'Harvard'  );
select new.book(1000000000008, '05/03/2016', 'Life of Pi'         , 'Mary'   , 'Jane'   , 'Pub1', '', 'Soul'     );
select new.book(1000000000009, '05/03/2016', 'The School Bus'     , 'Mary'   , 'Jane'   , 'Pub2', '', 'Soul'     );
select new.book(1000000000010, '05/03/2016', 'Martian War'        , 'Mary'   , 'Jane'   , 'Pub1', '', 'Soul'     );
select new.book(1000000000011, '05/03/2016', 'Data Structures'    , 'Alan'   , 'Turing' , 'Pub2', '', 'Internet' );
select new.book(1000000000012, '05/03/2016', 'Subway Six'         , 'Mary'   , 'Jane'   , 'Pub1', '', 'Soul'     );
select new.book(1000000000013, '05/03/2016', 'Alphabet Soup'      , 'Joseph' , 'Stalin' , 'Pub2', '', 'Princeton');
select new.book(1000000000015, '05/03/2016', 'The Cheaters'       , 'Hillary', 'Clinton', 'Pub1', '', 'Internet' );
select new.book(1000000000016, '05/03/2016', 'Universal History'  , 'John'   , 'Adams'  , 'Pub2', '', 'Princeton');
select new.book(1000000000017, '05/03/2016', 'Python Machines'    , 'Matthew', 'Warshaw', 'Pub1', '', 'City'     );
select new.book(1000000000018, '05/03/2016', 'Computer Arch'      , 'Matthew', 'Warshaw', 'Pub2', '', 'City'     );
select new.book(1000000000019, '05/03/2016', 'How to Linux'       , 'Matthew', 'Warshaw', 'Pub1', '', 'City'     );
select new.book(1000000000020, '05/03/2016', 'I am the Wizard Now', 'Harry'  , 'Potter' , 'Pub2', '', 'Hogwarts' );

/* create library branches */
truncate dbo.branch cascade;
insert into dbo.branch("name", address) values
('New York Library', 'New York'),
('Boston Library', 'Massachusetts'),
('Nanjing World Library', 'Nanjing');
