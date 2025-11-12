-- 1. Count the number of patients by each service.
select service, count(patient_id) as no_of_patients
from patients
group by service;

-- 2. Calculate the average age of patients grouped by service.
select service, round(avg(age),2) as avg_age
from patients
group by service;

-- 3. Find the total number of staff members per role.
select role, round(count(staff_id),2) as total_staff
from staff
group by role;

/* For each hospital service, calculate the total number of patients admitted, total patients refused, 
and the admission rate (percentage of requests that were admitted). 
Order by admission rate descending.*/
select 
  service,
  sum(patients_admitted) as total_patients_admitted,
  sum(patients_request) as total_patients_requested,
  round(sum(patients_admitted)*100.0 / sum(patients_request), 2) as admission_rate
from 
  services_weekly
group by 
  service
order by 
  admission_rate desc;









