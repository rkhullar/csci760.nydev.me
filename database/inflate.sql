/*
 * @author  : Rajan Khullar
 * @created : 04/16/16
 * @updated : 04/27/16
 */

truncate dbo.actor cascade;
select new.actor('Admin', 'Admin', 'admin@nydev.me', digest('mypass', 'sha256'));
select new.reader('Rajan', 'Khullar', 'rajan@nydev.me', 12345678);

truncate dbo.admin;
insert into dbo.admin
select id
from dbo.actor
where email = 'admin@nydev.me';