/*
 * @author  : Rajan Khullar
 * @created : 05/16/16
 * @updated : 05/23/16
 */

truncate dbo.actor cascade;
select new.actor('Admin', 'Admin', 'admin@nydev.me');
select new.actor('Rajan', 'Khullar', 'rajan@nydev.me');

truncate dbo.admin;
insert into dbo.admin
select id
from dbo.actor
where email = 'admin@nydev.me';