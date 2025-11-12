-- 1. Count the total number of patients in the hospital.
select count(patient_id) from patients;

-- 2. Calculate the average satisfaction score of all patients.
select round(avg(satisfaction),2) from patients;

-- 3. Find the minimum and maximum age of patients.
select min(age), max(age) from patients;

	/* 4. Calculate the total number of patients admitted, total patients refused, and the average patient satisfaction across all services and weeks. 
	Round the average satisfaction to 2 decimal places. */
select sum(patients_admitted), sum(patients_refused), round(avg(patient_satisfaction),2)
from services_weekly;