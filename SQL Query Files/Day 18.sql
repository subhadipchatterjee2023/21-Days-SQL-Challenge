/* Create a comprehensive personnel and patient list showing: identifier (patient_id or staff_id), full name, type ('Patient' or 'Staff'), 
and associated service. Include only those in 'surgery' or 'emergency' services. Order by type, then service, then name.
*/
SELECT
  p.patient_id AS identifier,
  p.name AS full_name,
  'Patient' AS type,
  p.service AS service
FROM patients p
WHERE LOWER(TRIM(p.service)) IN ('surgery','emergency')

UNION ALL

SELECT
  s.staff_id AS identifier,
  s.staff_name AS full_name,
  'Staff' AS type,
  s.service AS service
FROM staff s
WHERE LOWER(TRIM(s.service)) IN ('surgery','emergency')
ORDER BY type, service, full_name;