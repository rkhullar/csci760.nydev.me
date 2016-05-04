/*
 * @author  : Rajan Khullar
 * @created : 04/16/16
 * @updated : 05/04/16
 */


/* setup reader accounts */
truncate dbo.actor cascade;
select new.reader( 0, 'Rajan', 'Khullar', 'rajan@nydev.me', 0, 'Earth');
select new.reader( 1, 'bot01', 'nydev', 'bot01@nydev.me', 0, 'NYIT');
select new.reader( 2, 'bot02', 'nydev', 'bot02@nydev.me', 0, 'NYIT');
select new.reader( 3, 'bot03', 'nydev', 'bot03@nydev.me', 0, 'NYIT');
select new.reader( 4, 'bot04', 'nydev', 'bot04@nydev.me', 0, 'NYIT');
select new.reader( 5, 'bot05', 'nydev', 'bot05@nydev.me', 0, 'NYIT');
select new.reader( 6, 'bot06', 'nydev', 'bot06@nydev.me', 0, 'NYIT');
select new.reader( 7, 'bot07', 'nydev', 'bot07@nydev.me', 0, 'NYIT');
select new.reader( 8, 'bot08', 'nydev', 'bot08@nydev.me', 0, 'NYIT');
select new.reader( 9, 'bot09', 'nydev', 'bot09@nydev.me', 0, 'NYIT');
select new.reader(10, 'bot10', 'nydev', 'bot10@nydev.me', 0, 'NYIT');
select new.reader(11, 'bot11', 'nydev', 'bot11@nydev.me', 0, 'NYIT');
select new.reader(12, 'bot12', 'nydev', 'bot12@nydev.me', 0, 'NYIT');
select new.reader(13, 'bot13', 'nydev', 'bot13@nydev.me', 0, 'NYIT');
select new.reader(14, 'bot14', 'nydev', 'bot14@nydev.me', 0, 'NYIT');
select new.reader(15, 'bot15', 'nydev', 'bot15@nydev.me', 0, 'NYIT');
select new.reader(16, 'bot16', 'nydev', 'bot16@nydev.me', 0, 'NYIT');
select new.reader(17, 'bot17', 'nydev', 'bot17@nydev.me', 0, 'NYIT');
select new.reader(18, 'bot18', 'nydev', 'bot18@nydev.me', 0, 'NYIT');
select new.reader(19, 'bot19', 'nydev', 'bot19@nydev.me', 0, 'NYIT');
select new.reader(20, 'bot20', 'nydev', 'bot20@nydev.me', 0, 'NYIT');


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
select new.book(00, '05/03/2016', 'El Monster'         , 'Donald' , 'Trump'  , 'Pub1', '', 'Princeton');
select new.book(01, '05/03/2016', 'Things Happen'      , 'Matthew', 'Warshaw', 'Pub2', '', 'Princeton');
select new.book(02, '05/03/2016', 'Encyclopedia Alpha' , 'John'   , 'Adams'  , 'Pub1', '', 'Harvard'  );
select new.book(03, '05/03/2016', 'Encyclopedia Beta'  , 'John'   , 'Adams'  , 'Pub2', '', 'Harvard'  );
select new.book(04, '05/03/2016', 'Encyclopedia Gamma' , 'John'   , 'Adams'  , 'Pub1', '', 'Harvard'  );
select new.book(05, '05/03/2016', 'Encyclopedia Theta' , 'John'   , 'Adams'  , 'Pub2', '', 'Harvard'  );
select new.book(06, '05/03/2016', 'Encyclopedia Iota'  , 'John'   , 'Adams'  , 'Pub1', '', 'Harvard'  );
select new.book(07, '05/03/2016', 'Encyclopedia Omega' , 'John'   , 'Adams'  , 'Pub2', '', 'Harvard'  );
select new.book(08, '05/03/2016', 'Life of Pi'         , 'Mary'   , 'Jane'   , 'Pub1', '', 'Soul'     );
select new.book(09, '05/03/2016', 'The School Bus'     , 'Mary'   , 'Jane'   , 'Pub2', '', 'Soul'     );
select new.book(10, '05/03/2016', 'Martian War'        , 'Mary'   , 'Jane'   , 'Pub1', '', 'Soul'     );
select new.book(11, '05/03/2016', 'Data Structures'    , 'Alan'   , 'Turing' , 'Pub2', '', 'Internet' );
select new.book(12, '05/03/2016', 'Subway Six'         , 'Mary'   , 'Jane'   , 'Pub1', '', 'Soul'     );
select new.book(13, '05/03/2016', 'Alphabet Soup'      , 'Joseph' , 'Stalin' , 'Pub2', '', 'Princeton');
select new.book(15, '05/03/2016', 'The Cheaters'       , 'Hillary', 'Clinton', 'Pub1', '', 'Internet' );
select new.book(16, '05/03/2016', 'Universal History'  , 'John'   , 'Adams'  , 'Pub2', '', 'Princeton');
select new.book(17, '05/03/2016', 'Python Machines'    , 'Matthew', 'Warshaw', 'Pub1', '', 'City'     );
select new.book(18, '05/03/2016', 'Computer Arch'      , 'Matthew', 'Warshaw', 'Pub2', '', 'City'     );
select new.book(19, '05/03/2016', 'How to Linux'       , 'Matthew', 'Warshaw', 'Pub1', '', 'City'     );
select new.book(20, '05/03/2016', 'I am the Wizard Now', 'Harry'  , 'Potter' , 'Pub2', '', 'Hogwarts' );

/* create library branches */
truncate dbo.branch cascade;
insert into dbo.branch("name", address) values
('New York Library', 'New York'),
('Boston Library', 'Massachusetts'),
('Nanjing World Library', 'Nanjing');
