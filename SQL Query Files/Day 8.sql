-- 1. Convert all patient names to uppercase.
select upper(name) from patients;

-- 2. Find the length of each staff member's name.
select length(staff_name) from staff;

-- 3. Concatenate staff_id and staff_name with a hyphen separator.
select concat(staff_id, '-', staff_name) from staff;

/* Create a patient summary that shows patient_id, full name in uppercase, service in lowercase, 
age category (if age >= 65 then 'Senior', if age >= 18 then 'Adult', else 'Minor'), and name length. 
Only show patients whose name length is greater than 10 characters.
*/
select patient_id, upper(name),
lower(service),
age,
case
	when age >= 18 and age < 65 then 'Adult'
    when age >= 65 then 'Senior'
    else 'Minor'
end as age_category,
length(name) as name_len
from patients
where length(name) > 10;


