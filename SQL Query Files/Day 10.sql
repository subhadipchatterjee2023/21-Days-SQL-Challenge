-- 1. Categorise patients as 'High', 'Medium', or 'Low' satisfaction based on their scores.
select patient_id,
satisfaction,
case
	when satisfaction > 80 then 'High'
    when satisfaction >= 50 and satisfaction < 80 then 'Medium'
    else 'Low'
end as patient_satisfaction
from patients;

-- 2. Label staff roles as 'Medical' or 'Support' based on role type.
-- 3. Create age groups for patients (0-18, 19-40, 41-65, 65+).
-- Create a service performance report showing service name, total patients admitted, and a performance category based on the following: 
-- 'Excellent' if avg satisfaction >= 85, 'Good' if >= 75, 'Fair' if >= 65, otherwise 'Needs Improvement'. Order by average satisfaction descending.