/*
 * @author  : Rajan Khullar
 * @created : 04/16/16
 * @updated : 04/28/16
 */

truncate dbo.actor cascade;
select new.actor('Admin', 'Master', 'admin@nydev.me', 000000000, '1 Rainbow Road', digest('mypass', 'sha256'));
select new.reader(11111111, 'Rajan', 'Khullar', 'rajan@nydev.me', 000000000, '1 Rainbow Road');

truncate dbo.admin;
insert into dbo.admin
select id
from dbo.actor
where email = 'admin@nydev.me';

select new.book(0, current_date, 'El Monster', 'Rajan', 'Khullar', 'NYIT', 'Master', 'NY');