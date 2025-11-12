-- 1. Find all patients who are older than 60 years.
select * from patients
where age > 60;

-- 2. Retrieve all staff members who work in the 'Emergency' service.
select * from patients
where service = 'emergency';

-- 3. List all weeks where more than 100 patients requested admission in any service.
select distinct week from services_weekly
where patients_request > 100;

-- Question: List all unique hospital services available in the hospital.
select distinct service 
from services_weekly;