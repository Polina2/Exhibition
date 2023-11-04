create function replace_null()
RETURNS void as $$
DECLARE
i work_interval;
BEGIN
for i in 
select * from work_interval
loop
if i.type = 'NULL' then
insert into work_interval
VALUES
(i.id, i.date_from, i.date_to, 'LIGHT'),
(i.id, i.date_from, i.date_to, 'DARK'),
(i.id, i.date_from, i.date_to, 'OPEN_SPACE');
end if;
end loop;
DELETE FROM work_interval
where type = 'NULL';
end
$$ LANGUAGE plpgsql;