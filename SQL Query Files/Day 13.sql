-- 1. Join patients and staff based on their common service field (show patient and staff who work in same service).
select p.patient_id, p.name, p.service, s.staff_name
from patients p
join staff s
on p.service = s.service
order by p.service;

-- 2. Join services_weekly with staff to show weekly service data with staff information.
select sw.week, sw.month, sw.service, s.staff_id, s.staff_name, s.role
from services_weekly sw
join staff s
on sw.service = s.service
order by s.role;

-- 3. Create a report showing patient information along with staff assigned to their service.
select p.patient_id, p.name, p.age, p.arrival_date, p.service, p.satisfaction, s.staff_name, s.role
from patients p
join staff s
on p.service = s.service;

/* Create a comprehensive report showing patient_id, patient name, age, service, and the total number of staff members available in their service. 
Only include patients from services that have more than 5 staff members. 
Order by number of staff descending, then by patient name. */
select p.patient_id, p.name, p.age, p.service,
count(s.staff_id) as total_staff
from patients p
join staff s
on p.service = s.service
group by p.patient_id, p.name, p.age, p.service
having count(s.staff_id) > 5
order by total_staff desc, p.name;
