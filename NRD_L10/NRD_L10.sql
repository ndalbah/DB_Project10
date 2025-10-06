-- connect to SQL PLUS
connect sys/sys as sysdba

-- Create spool file
SPOOL C:\NRD_L10\NRD_L10.txt

-- Run script northwoods
@ C:\NRD_L10\7Northwoods.sql

-- Question #1
SELECT bldg_code, room
FROM LOCATION
WHERE  capacity = 
(
    SELECT capacity
    FROM LOCATION
    WHERE bldg_code = 'CR' AND room = '103'
);

-- Question #2
SELECT s_last, s_first, course.course_name, term.term_desc, enrollment.grade
FROM student, course_section, term, enrollment, course 
WHERE course.course_id = course_section.course_id AND student.s_id = enrollment.s_id AND course_section.c_sec_id = enrollment.c_sec_id AND term.term_id = course_section.term_id AND student.f_id = (
    SELECT f_id
    FROM faculty
    WHERE f_first = 'Kim' AND f_last = 'Cox');

-- Run script software expert
@ C:\NRD_L10\7Software.sql

-- Question #3
SELECT c_first, c_last
FROM consultant
WHERE c_id IN 
(
    SELECT distinct c_id
    FROM project_consultant
    WHERE p_id IN 
    (
        SELECT distinct p_id
        FROM project_consultant
        WHERE c_id = 
        (
            SELECT distinct c_id
            FROM consultant
            WHERE c_first = 'Mark' AND c_last = 'Myers'
        )
    )
);

-- Question #4
SELECT project_name, c_first, c_last
FROM project, consultant
WHERE project.mgr_id = consultant.c_id 
AND project.p_id IN 
(
    SELECT p_id
    FROM project_consultant
    WHERE c_id = 
    (   
        SELECT c_id
        FROM consultant
        WHERE c_first = 'Mark' AND c_last = 'Myers'
    )
);

-- Question #5
SELECT c_first, c_last
FROM consultant
WHERE c_id IN 
(
    SELECT c_id 
    FROM project_consultant
    WHERE p_id = 
    (
        SELECT p_id
        FROM project
        WHERE client_id = 
        (
            SELECT client_id
            FROM client
            WHERE client_name = 'Morningstar Bank'
        )
    )
);

-- Run script clearwater
@ C:\NRD_L10\7clearwater.sql

-- Question #6
SELECT inventory.inv_id, inventory.inv_size, item.item_desc, inventory.color, shipment_line.sl_quantity
FROM inventory, shipment_line, item
WHERE item.item_id = inventory.item_id AND inventory.inv_id = shipment_line.inv_id AND inventory.inv_id != 12 AND shipment_line.sl_date_received = 
(
    SELECT sl_date_received
    FROM shipment_line
    WHERE inv_id = 
    (
        SELECT inv_id 
        FROM inventory
        WHERE inv_id = 12
    )
    AND ship_id = 4
);

-- Save spool
SPOOL OFF;