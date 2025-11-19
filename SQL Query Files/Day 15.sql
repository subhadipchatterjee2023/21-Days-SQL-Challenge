-- 1. Join patients, staff, and staff_schedule to show patient service and staff availability.
select p.patient_id, p.service, st.*, ss.week, ss.present
from patients p
join staff st
on p.service = st.service
join staff_schedule ss
on st.staff_id = ss.staff_id;

-- 2. Combine services_weekly with staff and staff_schedule for comprehensive service analysis.


-- 3. Create a multi-table report showing patient admissions with staff information.
/* 4. Create a comprehensive service analysis report for week 20 showing: service name, total patients admitted that week, total patients refused, 
average patient satisfaction, count of staff assigned to service, and count of staff present that week. Order by patients admitted descending. */
select sw.service,
sw.week,
sum(sw.patients_admitted) as total_admitted,
sum(sw.patients_refused) as total_refused,
avg(sw.patient_satisfaction) as avg_satisfaction,
count(distinct s.staff_id) as staff_assigned,
count(case when ss.present = 'yes' then 1 end) as staff_present_week
from services_weekly sw
join staff s
	on sw.service = s.service
join staff_schedule ss
	on s.staff_id = ss.staff_id
    and sw.week = ss.week
where sw.week = 20
group by sw.service
order by total_admitted desc;


