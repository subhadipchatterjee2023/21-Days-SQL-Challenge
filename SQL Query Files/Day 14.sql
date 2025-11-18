-- 1. Show all staff members and their schedule information (including those with no schedule entries).
select	s.*, ss.week, ss.present
from staff s
left join staff_schedule ss
on s.staff_id = ss.staff_id;

-- 2. List all services from services_weekly and their corresponding staff (show services even if no staff assigned).
select sw.service, st.staff_id, st.staff_name, st.role
from services_weekly sw
left join staff st
on sw.service = st.service;

-- 3. Display all patients and their service's weekly statistics (if available).
select p.patient_id, p.name, s.week, s.patient_satisfaction, s.staff_morale
from patients p
left join services_weekly s
on p.service = s.service;

/* Create a staff utilisation report showing all staff members (staff_id, staff_name, role, service) and the count of weeks they were present (from staff_schedule). 
Include staff members even if they have no schedule records. Order by weeks present descending. */
select st.staff_id, st.staff_name, st.role, st.service, sum(coalesce(ss.present, 0)) as count_of_weeks
from staff st
left join staff_schedule ss
on st.staff_id = ss.staff_id
group by st.staff_id, st.staff_name, st.role, st.service
order by count_of_weeks desc;
