-- 1. Find services that have admitted more than 500 patients in total.
select service,
sum(patients_admitted) as total_patients_admitted
from services_weekly
group by service
having total_patients_admitted > 500;

-- 2.  Show services where average patient satisfaction is below 75.
select service,
avg(patient_satisfaction) as avg_patient_satisfaction
from services_weekly
group by service
having avg_patient_satisfaction < 75;

-- 3. List weeks where total staff presence across all services was less than 50.
select week,
sum(present) as total_staff_presence
from staff_schedule
group by week
having sum(present) < 50;

/* Identify services that refused more than 100 patients in total and had an average patient satisfaction below 80. 
Show service name, total refused, and average satisfaction.*/
select service,
sum(patients_refused) as total_patient_refused,
avg(patient_satisfaction) as avg_satisfaction
from services_weekly
group by 1
having total_patient_refused > 100 
and avg_satisfaction < 80;







