-- Who entered the **CEO’s Office** close to the time of the murder?
SELECT 
    k.employee_id,
    e.name,
    k.room,
    k.entry_time,
    k.exit_time
FROM keycard_logs k
JOIN employees e 
    ON e.employee_id = k.employee_id
WHERE k.room = 'CEO Office'
  AND k.entry_time <= '2025-10-15 21:05:00'
  AND k.exit_time  >= '2025-10-15 20:50:00';

-- Who **claimed** to be somewhere else but was not?
SELECT 
    a.employee_id,
    emp.name,
    a.claimed_location,
    a.claim_time,
    k.room AS actual_room,
    k.entry_time,
    k.exit_time
FROM alibis a
JOIN keycard_logs k 
    ON a.employee_id = k.employee_id
    AND a.claim_time BETWEEN k.entry_time AND k.exit_time
JOIN employees emp 
    ON emp.employee_id = a.employee_id
WHERE a.claimed_location <> k.room;


-- Who made or received calls around **20:50–21:00**?
SELECT 
    c.call_id,
    c.caller_id,
    caller.name AS caller_name,
    c.receiver_id,
    receiver.name AS receiver_name,
    c.call_time,
    DATE_ADD(c.call_time, INTERVAL c.duration_sec SECOND) AS call_end_time,
    c.duration_sec
FROM calls c
LEFT JOIN employees caller 
    ON caller.employee_id = c.caller_id
LEFT JOIN employees receiver 
    ON receiver.employee_id = c.receiver_id
WHERE c.call_time <= '2025-10-15 21:00:00'
  AND DATE_ADD(c.call_time, INTERVAL c.duration_sec SECOND) >= '2025-10-15 20:50:00'
ORDER BY c.call_time;

-- What evidence was found at the **crime scene**?
SELECT 
    evidence_id,
    room,
    description,
    found_time
FROM evidence
WHERE room = 'CEO Office'
ORDER BY found_time;

-- Which suspect’s movements, alibi, and call activity **don’t add up**?
SELECT emp.employee_id, emp.name
FROM employees emp WHERE 
    emp.employee_id IN (
        SELECT employee_id
        FROM keycard_logs
        WHERE room = 'CEO Office'
          AND entry_time <= '2025-10-15 21:05:00'
          AND exit_time  >= '2025-10-15 20:50:00'
    )
    AND
    emp.employee_id IN (
        SELECT a.employee_id
        FROM alibis a
        JOIN keycard_logs k 
            ON a.employee_id = k.employee_id
           AND a.claim_time BETWEEN k.entry_time AND k.exit_time
        WHERE a.claimed_location <> k.room
    )
    AND
    emp.employee_id IN (
        SELECT caller_id
        FROM calls
        WHERE call_time <= '2025-10-15 21:00:00'
          AND DATE_ADD(call_time, INTERVAL duration_sec SECOND) >= '2025-10-15 20:50:00'
    );