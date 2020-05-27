-- ========
-- READ ME
-- ========
-- Name: Arshdeep Singh
-- ========
-- 1. The following is the flow of the execution in the project:
--     - Creation of database
--     - Creation of tables
--     - Creation of after insert triggers
--     - Creation of before insert triggers
--     - Creation of after update triggers
--     - Creation of after delete triggers
--     - Insertion of dummy data into tables
--     - Queries, Views and Procedures
-- 2. The entire file has been commented with the information that will help understand the inserted data.
-- 3. Certain command and queries are commented. (They were used during the implementation phase).
-- 4. The project report quotes the line number to facilitate the navigation to the required code.

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DROP DATABASE IF EXISTS project_19203890;

CREATE DATABASE project_19203890;

USE project_19203890;

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Creating Tables

CREATE TABLE stream(
    stream_ID CHAR(2) NOT NULL,
    stream_name VARCHAR(20) NOT NULL,
    PRIMARY KEY (stream_ID)
);

CREATE TABLE student(
    student_ID CHAR(6) NOT NULL,
    student_name VARCHAR(20) NOT NULL,
    student_GPA FLOAT NOT NULL,
    student_stream_ID CHAR(2) NOT NULL,
    PRIMARY KEY(student_ID),
    FOREIGN KEY (student_stream_ID) REFERENCES stream(stream_ID) ON UPDATE CASCADE
);

CREATE TABLE supervisor(
    supervisor_ID CHAR(6) NOT NULL,
    supervisor_name VARCHAR(20) NOT NULL,
    supervisor_stream_ID CHAR(2) NOT NULL,
    PRIMARY KEY (supervisor_ID),
    FOREIGN KEY (supervisor_stream_ID) REFERENCES stream(stream_ID) ON UPDATE CASCADE
);

CREATE TABLE project(
    project_ID CHAR(6) NOT NULL,
    project_name VARCHAR(20) NOT NULL,
    project_stream_ID CHAR(2) NOT NULL,
    project_supervisor_ID CHAR(6) NOT NULL,
    project_availability BOOLEAN NOT NULL,
    PRIMARY KEY (project_ID),
    FOREIGN KEY (project_supervisor_ID) REFERENCES supervisor(supervisor_ID) ON UPDATE CASCADE,
    FOREIGN KEY (project_stream_ID) REFERENCES stream(stream_ID) ON UPDATE CASCADE,
    CONSTRAINT project_name_unique UNIQUE (project_name)
);

CREATE TABLE allocated(
    allocated_project_ID CHAR(6) NOT NULL,
    allocated_student_ID CHAR(6) NOT NULL,
    allocated_student_proposed BOOLEAN NOT NULL,
    PRIMARY KEY (allocated_project_ID, allocated_student_ID),
    FOREIGN KEY (allocated_project_ID) REFERENCES project(project_ID) ON UPDATE CASCADE,
    FOREIGN KEY (allocated_student_ID) REFERENCES student(student_ID) ON UPDATE CASCADE
);

CREATE TABLE preference(
    preference_student_ID CHAR(6) NOT NULL,
    preference_project_ID_1 CHAR(6) NOT NULL,
    preference_project_ID_2 CHAR(6),
    preference_project_ID_3 CHAR(6),
    preference_project_ID_4 CHAR(6),
    preference_project_ID_5 CHAR(6),
    preference_project_ID_6 CHAR(6),
    preference_project_ID_7 CHAR(6),
    preference_project_ID_8 CHAR(6),
    preference_project_ID_9 CHAR(6),
    preference_project_ID_10 CHAR(6),
    preference_project_ID_11 CHAR(6),
    preference_project_ID_12 CHAR(6),
    preference_project_ID_13 CHAR(6),
    preference_project_ID_14 CHAR(6),
    preference_project_ID_15 CHAR(6),
    preference_project_ID_16 CHAR(6),
    preference_project_ID_17 CHAR(6),
    preference_project_ID_18 CHAR(6),
    preference_project_ID_19 CHAR(6),
    preference_project_ID_20 CHAR(6),
    PRIMARY KEY (preference_student_ID),
    FOREIGN KEY (preference_student_ID) REFERENCES student(student_ID) ON UPDATE CASCADE
);

-- This is an audit table (to keep record of any update or delete)
CREATE TABLE project_audit(
    project_audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    project_audit_user VARCHAR(20) NOT NULL,
    project_audit_time TIME NOT NULL,
    project_audit_table_name VARCHAR (20) NOT NULL,
    project_audit_table_operation VARCHAR (20) NOT NULL,
    project_audit_description VARCHAR(50000)
);

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Creating Triggers for the Tables

-- Trigger 1. 
    -- For after insert into tables
    -- Trigger 1.1.
        -- on STREAM (After Insert: logs the changes)
DROP TRIGGER IF EXISTS trigger_after_insert_stream;
DELIMITER //
CREATE TRIGGER trigger_after_insert_stream
AFTER INSERT ON stream
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'stream', 'INSERT', CONCAT(
        ' Stream ID : ', NEW.stream_ID, 
        ', Stream Name : ', NEW.Stream_name 
        )
    );
END
//
DELIMITER ; 

    -- Trigger 1.2.
        -- on STUDENT (After Insert: log the changes)
DROP TRIGGER IF EXISTS trigger_after_insert_student;
DELIMITER //
CREATE TRIGGER trigger_after_insert_student
AFTER INSERT ON student
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'student', 'INSERT', CONCAT(
        ' Student ID : ', NEW.student_ID, 
        ', Student Name : ', NEW.student_name,
        ', Student GPA : ', NEW.student_GPA,
        ', Student Stream : ', NEW.student_stream_ID
        )
    );
END
//
DELIMITER ;

    -- Trigger 1.3.
        -- on SUPERVISOR (After Insert: log the changes)
DROP TRIGGER IF EXISTS trigger_after_insert_supervisor;
DELIMITER //
CREATE TRIGGER trigger_after_insert_supervisor
AFTER INSERT ON supervisor
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'supervisor', 'INSERT', CONCAT(
        ' Supervisor ID : ', NEW.supervisor_ID, 
        ', Supervisor Name : ', NEW.supervisor_name,
        ', Supervisor Stream : ', NEW.supervisor_stream_ID
        )
    );
END
//
DELIMITER ;

    -- Trigger 1.4.
        -- on PROJECT (After Insert: log the changes)
DROP TRIGGER IF EXISTS trigger_after_insert_project;
DELIMITER //
CREATE TRIGGER trigger_after_insert_project
AFTER INSERT ON project
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'project', 'INSERT', CONCAT(
        ' Project ID : ', NEW.project_ID, 
        ', Project Name : ', NEW.project_name,
        ', Project Stream : ', NEW.project_stream_ID,
        ', Project Supervisor : ', NEW.project_supervisor_ID,
        ', Project Both: ', NEW.project_availability
        )
    );
END
//
DELIMITER ;

    -- Trigger 1.5 
        -- on ALLOCATED (After Insert: log the changes)
DROP TRIGGER IF EXISTS trigger_after_insert_allocated;
DELIMITER //
CREATE TRIGGER trigger_after_insert_allocated
AFTER INSERT ON allocated
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'allocated', 'INSERT', CONCAT( 
        ' Allocated Project ID : ', NEW.allocated_project_ID, 
        ', Allocated Student ID : ', NEW.allocated_student_ID,
        ', Allocated Student Proposed : ', NEW.allocated_student_proposed
        )
    );
END
//
DELIMITER ;

    -- Trigger 1.6 
        -- on PREFERENCE (After Insert: log the changes)
DROP TRIGGER IF EXISTS trigger_after_insert_preference;
DELIMITER //
CREATE TRIGGER trigger_after_insert_preference
AFTER INSERT ON preference
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'preference', 'INSERT', CONCAT( 
        ' Preference Student ID : ', NEW.preference_student_ID, 
        ', Preference Project ID 1 : ', NEW.preference_project_ID_1,
        ', Preference Project ID 2 : ', NEW.preference_project_ID_2, 
        ', Preference Project ID 3 : ', NEW.preference_project_ID_3, 
        ', Preference Project ID 4 : ', NEW.preference_project_ID_4, 
        ', Preference Project ID 5 : ', NEW.preference_project_ID_5, 
        ', Preference Project ID 6 : ', NEW.preference_project_ID_6, 
        ', Preference Project ID 7 : ', NEW.preference_project_ID_7, 
        ', Preference Project ID 8 : ', NEW.preference_project_ID_8, 
        ', Preference Project ID 9 : ', NEW.preference_project_ID_9, 
        ', Preference Project ID 10 : ', NEW.preference_project_ID_10, 
        ', Preference Project ID 11 : ', NEW.preference_project_ID_11, 
        ', Preference Project ID 12 : ', NEW.preference_project_ID_12, 
        ', Preference Project ID 13 : ', NEW.preference_project_ID_13, 
        ', Preference Project ID 14 : ', NEW.preference_project_ID_14, 
        ', Preference Project ID 15 : ', NEW.preference_project_ID_15, 
        ', Preference Project ID 16 : ', NEW.preference_project_ID_16, 
        ', Preference Project ID 17 : ', NEW.preference_project_ID_17, 
        ', Preference Project ID 18 : ', NEW.preference_project_ID_18, 
        ', Preference Project ID 19 : ', NEW.preference_project_ID_19, 
        ', Preference Project ID 20 : ', NEW.preference_project_ID_20
        )
    );
END
//
DELIMITER ;

    -- EXAMPLE
        -- 1.1.
        -- 1.2.
        -- 1.3.
        -- 1.4.
        -- 1.5.
        -- 1.6.
            -- In the subsequent trigger, the examples will trigger the after insert triggers.


-- TRIGGER 2.
    -- For before insert into Tables.
    -- Trigger 2.1.
        -- For the STREAM table, after inserting, updated the full form of CS as Cthulhu Studies and DS as Dagon Studies
        -- Trim the stream_name and converted stream_ID to upper case
DROP TRIGGER IF EXISTS trigger_before_insert_stream;
DELIMITER //
CREATE TRIGGER trigger_before_insert_stream
BEFORE INSERT ON stream
FOR EACH ROW
BEGIN
	IF (NEW.stream_ID NOT IN ('CS', 'DS')) THEN
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Warning: Stream ID can ONLY be \'CS\' or \'DS\' (Currently available)';
	END IF;
    IF (NEW.stream_ID = 'CS' AND NEW.stream_name != 'Cthulhu Studies') THEN 
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Warning: Stream Name can ONLY be \'Cthulhu Studies\'';
    END IF;
    IF (NEW.stream_ID = 'DS' AND NEW.stream_name != 'Dagon Studies') THEN 
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Warning: Stream Name can ONLY be \'Dagon Studies\'';
    END IF;
    SET NEW.stream_ID = TRIM(NEW.stream_ID);
    SET NEW.stream_ID = UPPER(NEW.stream_ID);
    SET NEW.stream_name = TRIM(NEW.stream_name);
END
//
DELIMITER ;  

    -- Trigger 2.2. 
        -- The Student should not have a GPA <0 and >4.2
        -- The Stream entered should be either CS or DS (no other Stream allowed)
DROP TRIGGER IF EXISTS trigger_before_insert_student;
DELIMITER //
CREATE TRIGGER trigger_before_insert_student
BEFORE INSERT ON student
FOR EACH ROW
BEGIN
    IF (NEW.student_GPA < 0 OR NEW.student_GPA > 4.2) THEN 
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Warning: GPA can be between \'0\' and  \'4.2\'';
    END IF;
    IF (NEW.student_stream_ID NOT IN (SELECT stream_ID FROM stream)) THEN
        SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Warning: Stream can be \'CS\' or \'DS\'';
    END IF;
    SET NEW.student_ID = UPPER(NEW.student_ID);
    SET NEW.student_name = TRIM(NEW.student_name);
    SET NEW.student_stream_ID = UPPER(NEW.student_stream_ID);
END
//
DELIMITER ;

    -- Trigger 2.3.
        -- For the SUPERVISOR table, before inserting, need to check if the stream is either CS or DS
DROP TRIGGER IF EXISTS trigger_before_insert_supervisor;
DELIMITER //
CREATE TRIGGER trigger_before_insert_supervisor
BEFORE INSERT ON supervisor
FOR EACH ROW
BEGIN
	IF (NEW.supervisor_stream_ID NOT IN (SELECT stream_ID FROM stream)) THEN
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Warning: Stream can be \'CS\' or \'DS\'';
	END IF;
    SET NEW.supervisor_ID = UPPER(NEW.supervisor_ID);
    SET NEW.supervisor_name = TRIM(NEW.supervisor_name);
    SET NEW.supervisor_stream_ID = UPPER(NEW.supervisor_stream_ID);
END
//
DELIMITER ; 
    
    -- Trigger 2.4. 
        -- For the PROJECT table, before inserting, need to check if the stream is either CS or DS
DROP TRIGGER IF EXISTS trigger_before_insert_project;
DELIMITER //
CREATE TRIGGER trigger_before_insert_project
BEFORE INSERT ON project
FOR EACH ROW
BEGIN
	IF (NEW.project_stream_ID NOT IN (SELECT stream_ID FROM stream)) THEN
		SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Warning: Stream can be \'CS\' or \'DS\'';
	END IF;
    SET NEW.project_ID = UPPER(NEW.project_ID);
    SET NEW.project_name = TRIM(NEW.project_name);
    SET NEW.project_stream_ID = UPPER(NEW.project_stream_ID);
    SET NEW.project_supervisor_ID = UPPER(NEW.project_supervisor_ID);
END
//

    -- Trigger 2.5
        -- For ALLOCATED table, before inserting, making the ID's uppercase
DROP TRIGGER IF EXISTS trigger_before_insert_allocated;
DELIMITER //
CREATE TRIGGER trigger_before_insert_allocated
BEFORE INSERT ON allocated
FOR EACH ROW
BEGIN
    SET NEW.allocated_project_ID = UPPER(NEW.allocated_project_ID);
    SET NEW.allocated_student_ID = UPPER(NEW.allocated_student_ID);
END
//

    -- Trigger 2.6
        -- For PREFERENCE table, before inserting, making the ID's uppercase
DROP TRIGGER IF EXISTS trigger_before_insert_preference;
DELIMITER //
CREATE TRIGGER trigger_before_insert_preference
BEFORE INSERT ON preference
FOR EACH ROW
BEGIN
    SET NEW.preference_student_ID = UPPER(NEW.preference_student_ID);
    SET NEW.preference_project_ID_1 = UPPER(NEW.preference_project_ID_1);
    SET NEW.preference_project_ID_2 = UPPER(NEW.preference_project_ID_2);
    SET NEW.preference_project_ID_3 = UPPER(NEW.preference_project_ID_3);
    SET NEW.preference_project_ID_4 = UPPER(NEW.preference_project_ID_4);
    SET NEW.preference_project_ID_5 = UPPER(NEW.preference_project_ID_5);
    SET NEW.preference_project_ID_6 = UPPER(NEW.preference_project_ID_6);
    SET NEW.preference_project_ID_7 = UPPER(NEW.preference_project_ID_7);
    SET NEW.preference_project_ID_8 = UPPER(NEW.preference_project_ID_8);
    SET NEW.preference_project_ID_9 = UPPER(NEW.preference_project_ID_9);
    SET NEW.preference_project_ID_10 = UPPER(NEW.preference_project_ID_10);
    SET NEW.preference_project_ID_11 = UPPER(NEW.preference_project_ID_11);
    SET NEW.preference_project_ID_12 = UPPER(NEW.preference_project_ID_12);
    SET NEW.preference_project_ID_13 = UPPER(NEW.preference_project_ID_13);
    SET NEW.preference_project_ID_14 = UPPER(NEW.preference_project_ID_14);
    SET NEW.preference_project_ID_15 = UPPER(NEW.preference_project_ID_15);
    SET NEW.preference_project_ID_16 = UPPER(NEW.preference_project_ID_16);
    SET NEW.preference_project_ID_17 = UPPER(NEW.preference_project_ID_17);
    SET NEW.preference_project_ID_18 = UPPER(NEW.preference_project_ID_18);
    SET NEW.preference_project_ID_19 = UPPER(NEW.preference_project_ID_19);
    SET NEW.preference_project_ID_20 = UPPER(NEW.preference_project_ID_20);
END
//
DELIMITER ; 

    -- EXAMPLES
        -- 2.1.
            -- INSERT INTO stream (stream_ID, stream_name) VALUES
            -- ('DS', 'Cthulhu Studies');
            -- SELECT * FROM stream;
    
        -- 2.2.
            -- INSERT INTO student (student_ID, student_name, student_GPA, student_stream_ID) VALUES
            -- ('STUEXP', 'EXP', 4.5, 'CS');

        -- 2.3.
            -- INSERT INTO supervisor (supervisor_ID, supervisor_name, supervisor_stream_ID) VALUES
            -- ('TEAEXP', 'EXP', 'EX');

        -- 2.4.
            -- INSERT INTO project (project_ID, project_name, project_stream_ID, project_supervisor_ID, project_availability) VALUES
            -- ('PRJEXP', 'EXP', 'EX', 'TEAEXP', FALSE);

        -- 2.5 and 2.6
            -- They only have UPPER and TRIM (nothing major to check before inserting)


-- TRIGGER 3. 
    -- For creating Logs for the update on tables (To know the previous values of the tables).
    -- Trigger 3.1.
        -- on STREAM (After Update: logs the changes)
        -- I don't want the ID's name convention to change. Hence, if anyone tried to do so, It will be logged into the table
DROP TRIGGER IF EXISTS trigger_after_update_stream;
DELIMITER //
CREATE TRIGGER trigger_after_update_stream
AFTER UPDATE ON stream
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'stream', 'UPDATE', CONCAT(
        ' Stream ID : ', OLD.stream_ID, 
        ', Stream Name : ', OLD.stream_name, 
        ' -> ',
        ' Stream ID : ', NEW.stream_ID, 
        ', Stream Name : ', NEW.Stream_name 
        )
    );
END
//
DELIMITER ; 

    -- Trigger 3.2.
        -- on STUDENT (After Update: log the changes)
DROP TRIGGER IF EXISTS trigger_after_update_student;
DELIMITER //
CREATE TRIGGER trigger_after_update_student
AFTER UPDATE ON student
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'student', 'UPDATE', CONCAT(
        ' Student ID : ', OLD.student_ID, 
        ', Student Name : ', OLD.student_name,
        ', Student GPA : ', OLD.student_GPA,
        ', Student Stream : ', OLD.student_stream_ID, 
        ' -> ', 
        ' Student ID : ', NEW.student_ID, 
        ', Student Name : ', NEW.student_name,
        ', Student GPA : ', NEW.student_GPA,
        ', Student Stream : ', NEW.student_stream_ID
        )
    );
END
//
DELIMITER ;

    -- Trigger 3.3.
        -- on SUPERVISOR (After update: log the changes)
DROP TRIGGER IF EXISTS trigger_after_update_supervisor;
DELIMITER //
CREATE TRIGGER trigger_after_update_supervisor
AFTER UPDATE ON supervisor
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'supervisor', 'UPDATE', CONCAT(
        ' Supervisor ID : ', OLD.supervisor_ID, 
        ', Supervisor Name : ', OLD.supervisor_name,
        ', Supervisor Stream : ', OLD.supervisor_stream_ID, 
        ' -> ', 
        ' Supervisor ID : ', NEW.supervisor_ID, 
        ', Supervisor Name : ', NEW.supervisor_name,
        ', Supervisor Stream : ', NEW.supervisor_stream_ID
        )
    );
END
//
DELIMITER ;

    -- Trigger 3.4.
        -- on PROJECT (After update: log the changes)
DROP TRIGGER IF EXISTS trigger_after_update_project;
DELIMITER //
CREATE TRIGGER trigger_after_update_project
AFTER UPDATE ON project
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'project', 'UPDATE', CONCAT(
        ' Project ID : ', OLD.project_ID, 
        ', Project Name : ', OLD.project_name,
        ', Project Stream : ', OLD.project_stream_ID,
        ', Project Supervisor : ', OLD.project_supervisor_ID,
        ', Project Both: ', OLD.project_availability,
        ' -> ', 
        ' Project ID : ', NEW.project_ID, 
        ', Project Name : ', NEW.project_name,
        ', Project Stream : ', NEW.project_stream_ID,
        ', Project Supervisor : ', NEW.project_supervisor_ID,
        ', Project Both: ', NEW.project_availability
        )
    );
END
//
DELIMITER ;

    -- Trigger 3.5 
        -- on ALLOCATED (After update: log the changes)
DROP TRIGGER IF EXISTS trigger_after_update_allocated;
DELIMITER //
CREATE TRIGGER trigger_after_update_allocated
AFTER UPDATE ON allocated
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'allocated', 'UPDATE', CONCAT( 
        ' Allocated Project ID : ', OLD.allocated_project_ID, 
        ', Allocated Student ID : ', OLD.allocated_student_ID,
        ', Allocated Student Proposed : ', OLD.allocated_student_proposed, 
        ' -> ', 
        ' Allocated Project ID : ', NEW.allocated_project_ID, 
        ', Allocated Student ID : ', NEW.allocated_student_ID,
        ', Allocated Student Proposed : ', NEW.allocated_student_proposed
        )
    );
END
//
DELIMITER ;

    -- Trigger 3.6 
        -- on PREFERENCE (After update: log the changes)
DROP TRIGGER IF EXISTS trigger_after_update_preference;
DELIMITER //
CREATE TRIGGER trigger_after_update_preference
AFTER UPDATE ON preference
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'preference', 'UPDATE', CONCAT( 
        ' Preference Student ID : ', OLD.preference_student_ID, 
        ', Preference Project ID 1 : ', OLD.preference_project_ID_1,
        ', Preference Project ID 2 : ', OLD.preference_project_ID_2, 
        ', Preference Project ID 3 : ', OLD.preference_project_ID_3, 
        ', Preference Project ID 4 : ', OLD.preference_project_ID_4, 
        ', Preference Project ID 5 : ', OLD.preference_project_ID_5, 
        ', Preference Project ID 6 : ', OLD.preference_project_ID_6, 
        ', Preference Project ID 7 : ', OLD.preference_project_ID_7, 
        ', Preference Project ID 8 : ', OLD.preference_project_ID_8, 
        ', Preference Project ID 9 : ', OLD.preference_project_ID_9, 
        ', Preference Project ID 10 : ', OLD.preference_project_ID_10, 
        ', Preference Project ID 11 : ', OLD.preference_project_ID_11, 
        ', Preference Project ID 12 : ', OLD.preference_project_ID_12, 
        ', Preference Project ID 13 : ', OLD.preference_project_ID_13, 
        ', Preference Project ID 14 : ', OLD.preference_project_ID_14, 
        ', Preference Project ID 15 : ', OLD.preference_project_ID_15, 
        ', Preference Project ID 16 : ', OLD.preference_project_ID_16, 
        ', Preference Project ID 17 : ', OLD.preference_project_ID_17, 
        ', Preference Project ID 18 : ', OLD.preference_project_ID_18, 
        ', Preference Project ID 19 : ', OLD.preference_project_ID_19, 
        ', Preference Project ID 20 : ', OLD.preference_project_ID_20, 
        ' -> ', 
        ' Preference Student ID : ', NEW.preference_student_ID, 
        ', Preference Project ID 1 : ', NEW.preference_project_ID_1,
        ', Preference Project ID 2 : ', NEW.preference_project_ID_2, 
        ', Preference Project ID 3 : ', NEW.preference_project_ID_3, 
        ', Preference Project ID 4 : ', NEW.preference_project_ID_4, 
        ', Preference Project ID 5 : ', NEW.preference_project_ID_5, 
        ', Preference Project ID 6 : ', NEW.preference_project_ID_6, 
        ', Preference Project ID 7 : ', NEW.preference_project_ID_7, 
        ', Preference Project ID 8 : ', NEW.preference_project_ID_8, 
        ', Preference Project ID 9 : ', NEW.preference_project_ID_9, 
        ', Preference Project ID 10 : ', NEW.preference_project_ID_10, 
        ', Preference Project ID 11 : ', NEW.preference_project_ID_11, 
        ', Preference Project ID 12 : ', NEW.preference_project_ID_12, 
        ', Preference Project ID 13 : ', NEW.preference_project_ID_13, 
        ', Preference Project ID 14 : ', NEW.preference_project_ID_14, 
        ', Preference Project ID 15 : ', NEW.preference_project_ID_15, 
        ', Preference Project ID 16 : ', NEW.preference_project_ID_16, 
        ', Preference Project ID 17 : ', NEW.preference_project_ID_17, 
        ', Preference Project ID 18 : ', NEW.preference_project_ID_18, 
        ', Preference Project ID 19 : ', NEW.preference_project_ID_19, 
        ', Preference Project ID 20 : ', NEW.preference_project_ID_20
        )
    );
END
//
DELIMITER ;   

    -- EXAMPLE
        -- 3.1.
            INSERT INTO stream (stream_ID, stream_name) VALUES
            ('CS', 'Cthulhu Studies');
            SELECT * FROM stream;
            UPDATE stream SET stream_name = 'XYZ_example' WHERE stream_ID = 'CS';
            SELECT * FROM project_audit;

        -- 3.2.
            INSERT INTO student (student_ID, student_name, student_GPA, student_stream_ID) VALUES
            ('STUEXP', 'EXP', 4.0, 'CS');
            SELECT * FROM student;
            UPDATE student SET student_name = 'XYZ_example' WHERE student_ID = 'STUEXP';
            SELECT * FROM project_audit;

        -- 3.3.
            INSERT INTO supervisor (supervisor_ID, supervisor_name, supervisor_stream_ID) VALUES
            ('TEAEXP', 'EXP', 'CS');
            SELECT * FROM supervisor;
            UPDATE supervisor SET supervisor_name = 'XYZ_example' WHERE supervisor_ID = 'TEAEXP';
            SELECT * FROM project_audit;

        -- 3.4.
            INSERT INTO project (project_ID, project_name, project_stream_ID, project_supervisor_ID, project_availability) VALUES
            ('PRJEXP', 'EXP', 'CS', 'TEAEXP', FALSE);
            SELECT * FROM project;
            UPDATE project SET project_name = 'XYZ_example' WHERE project_ID = 'PRJEXP';
            SELECT * FROM project_audit;

        -- 3.5.
            INSERT INTO allocated (allocated_project_ID, allocated_student_ID, allocated_student_proposed) VALUES
            ('PRJEXP', 'STUEXP', FALSE);
            SELECT * FROM allocated;
            UPDATE allocated SET allocated_student_proposed = TRUE WHERE allocated_project_ID = 'PRJEXP';
            SELECT * FROM project_audit;

        -- 3.6.
            INSERT INTO preference (preference_student_ID, preference_project_ID_1, preference_project_ID_2, preference_project_ID_3,preference_project_ID_4, preference_project_ID_5, preference_project_ID_6,
            preference_project_ID_7, preference_project_ID_8, preference_project_ID_9, preference_project_ID_10, preference_project_ID_11, preference_project_ID_12, preference_project_ID_13, preference_project_ID_14, 
            preference_project_ID_15, preference_project_ID_16, preference_project_ID_17, preference_project_ID_18, preference_project_ID_19, preference_project_ID_20) VALUES
            ('STUEXP', 'PRJ000', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP', 'PRJEXP');
            SELECT * FROM preference;
            UPDATE preference SET preference_project_ID_1 = 'PRJEXP' WHERE preference_student_ID = 'STUEXP';
            SELECT * FROM project_audit;


-- TRIGGER 4. 
    -- For creating Logs for the delete operation on tables (To know the values deleted).
    -- Trigger 4.1.
        -- on STREAM (After Delete: logs the changes)
DROP TRIGGER IF EXISTS trigger_after_delete_stream;
DELIMITER //
CREATE TRIGGER trigger_after_delete_stream
AFTER DELETE ON stream
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'stream', 'DELETE', CONCAT(
        ' Stream ID : ', OLD.stream_ID, 
        ', Stream Name : ', OLD.stream_name
        )
    );
END
//
DELIMITER ; 

    -- Trigger 4.2.
        -- on STUDENT (After Delete: log the changes)
DROP TRIGGER IF EXISTS trigger_after_delete_student;
DELIMITER //
CREATE TRIGGER trigger_after_delete_student
AFTER DELETE ON student
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'student', 'DELETE', CONCAT(
        ' Student ID : ', OLD.student_ID, 
        ', Student Name : ', OLD.student_name,
        ', Student GPA : ', OLD.student_GPA,
        ', Student Stream : ', OLD.student_stream_ID
        )
    );
END
//
DELIMITER ;

    -- Trigger 4.3.
        -- on SUPERVISOR (After Delete: log the changes)
DROP TRIGGER IF EXISTS trigger_after_delete_supervisor;
DELIMITER //
CREATE TRIGGER trigger_after_delete_supervisor
AFTER DELETE ON supervisor
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'supervisor', 'DELETE', CONCAT(
        ' Supervisor ID : ', OLD.supervisor_ID, 
        ', Supervisor Name : ', OLD.supervisor_name,
        ', Supervisor Stream : ', OLD.supervisor_stream_ID
        )
    );
END
//
DELIMITER ;

    -- Trigger 4.4.
        -- on PROJECT (After Delete: log the changes)
DROP TRIGGER IF EXISTS trigger_after_delete_project;
DELIMITER //
CREATE TRIGGER trigger_after_delete_project
AFTER DELETE ON project
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'project', 'DELETE', CONCAT(
        ' Project ID : ', OLD.project_ID, 
        ', Project Name : ', OLD.project_name,
        ', Project Stream : ', OLD.project_stream_ID,
        ', Project Supervisor : ', OLD.project_supervisor_ID,
        ', Project Both: ', OLD.project_availability
        )
    );
END
//
DELIMITER ;

    -- Trigger 4.5 
        -- on ALLOCATED (After Delete: log the changes)
DROP TRIGGER IF EXISTS trigger_after_delete_allocated;
DELIMITER //
CREATE TRIGGER trigger_after_delete_allocated
AFTER DELETE ON allocated
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'allocated', 'DELETE', CONCAT(
        ' Allocated Project ID : ', OLD.allocated_project_ID, 
        ', Allocated Student ID : ', OLD.allocated_student_ID,
        ', Allocated Student Proposed : ', OLD.allocated_student_proposed
        )
    );
END
//
DELIMITER ;

    -- Trigger 4.6 
        -- on PREFERENCE (After Delete: log the changes)
DROP TRIGGER IF EXISTS trigger_after_delete_preference;
DELIMITER //
CREATE TRIGGER trigger_after_delete_preference
AFTER DELETE ON preference
FOR EACH ROW
BEGIN
	INSERT INTO project_audit (project_audit_user, project_audit_time, project_audit_table_name, project_audit_table_operation, project_audit_description) VALUES
    (USER(), NOW(), 'preference', 'DELETE', CONCAT(
        ' Preference Student ID : ', OLD.preference_student_ID, 
        ', Preference Project ID 1 : ', OLD.preference_project_ID_1,
        ', Preference Project ID 2 : ', OLD.preference_project_ID_2, 
        ', Preference Project ID 3 : ', OLD.preference_project_ID_3, 
        ', Preference Project ID 4 : ', OLD.preference_project_ID_4, 
        ', Preference Project ID 5 : ', OLD.preference_project_ID_5, 
        ', Preference Project ID 6 : ', OLD.preference_project_ID_6, 
        ', Preference Project ID 7 : ', OLD.preference_project_ID_7, 
        ', Preference Project ID 8 : ', OLD.preference_project_ID_8, 
        ', Preference Project ID 9 : ', OLD.preference_project_ID_9, 
        ', Preference Project ID 10 : ', OLD.preference_project_ID_10, 
        ', Preference Project ID 11 : ', OLD.preference_project_ID_11, 
        ', Preference Project ID 12 : ', OLD.preference_project_ID_12, 
        ', Preference Project ID 13 : ', OLD.preference_project_ID_13, 
        ', Preference Project ID 14 : ', OLD.preference_project_ID_14, 
        ', Preference Project ID 15 : ', OLD.preference_project_ID_15, 
        ', Preference Project ID 16 : ', OLD.preference_project_ID_16, 
        ', Preference Project ID 17 : ', OLD.preference_project_ID_17, 
        ', Preference Project ID 18 : ', OLD.preference_project_ID_18, 
        ', Preference Project ID 19 : ', OLD.preference_project_ID_19, 
        ', Preference Project ID 20 : ', OLD.preference_project_ID_20
        )
    );
END
//
DELIMITER ;   

    -- EXAMPLES
        -- 4.6.
            SELECT * FROM preference;
            DELETE FROM preference WHERE preference_student_ID = 'STUEXP';
            SELECT * FROM project_audit;

        -- 4.5.
            SELECT * FROM allocated;
            DELETE FROM allocated WHERE allocated_project_ID = 'PRJEXP';
            SELECT * FROM project_audit;

        -- 4.4.
            SELECT * FROM project;
            DELETE FROM project WHERE project_ID = 'PRJEXP';
            SELECT * FROM project_audit;

        -- 4.3.
            SELECT * FROM supervisor;
            DELETE FROM supervisor WHERE supervisor_ID = 'TEAEXP';
            SELECT * FROM project_audit;

        -- 4.2.
            SELECT * FROM student;
            DELETE FROM student WHERE student_ID = 'STUEXP';
            SELECT * FROM project_audit;

        -- 4.1.
            SELECT * FROM stream;
            DELETE FROM stream WHERE stream_ID = 'CS';
            SELECT * FROM project_audit;

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Inserting values into the tables

INSERT INTO stream (stream_ID, stream_name) VALUES
('CS', 'Cthulhu Studies'),
('DS', 'Dagon Studies');

SELECT * from stream;


INSERT INTO student (student_ID, student_name, student_GPA, student_stream_ID) VALUES
-- NOTE: Students are allocated the projects according to th stream mentioned
('STU001', 'Serita Desrochers', 3.5, 'CS'),
('STU002', 'Vinnie Fordham', 4.0, 'CS'),
('STU003', 'Mindy Dunaway', 3.8, 'CS'),
('STU004', 'Garfield Wagstaff', 3.2, 'CS'),
('STU005', 'Maryellen Nielson', 3.4, 'CS'),
('STU006', 'Buck Waltz', 4.1, 'DS'),
('STU007', 'Kiera Turberville', 3.2,'DS'),
('STU008', 'Aron Licari', 3.7, 'DS'),
('STU009', 'Stefan Henze', 2.6, 'DS'),
('STU010', 'Sonja Lander', 3.9, 'DS'),
('STU011', 'Tariq Mayo', 4.0, 'CS'),
('STU012', 'Alexis Padilla', 3.7, 'CS'),
('STU013', 'Cloe Richards', 2.9, 'CS'),
('STU014', 'Keagan Rayner', 3.5, 'CS'),
('STU015', 'Sam Powell', 4.1, 'CS'),
('STU016', 'Helen Aldred', 3.2, 'DS'),
('STU017', 'Diasy Mae', 4.0, 'DS'),
('STU018', 'Janae Blaese', 3.1, 'DS'),
('STU019', 'Jimmy Kavanagh', 3.3, 'DS'),
('STU020', 'Jobe Shannon', 3.7, 'DS'),
-- NOTE: Students are allocated the projects from BOTH category of projects
('STU021', 'Jose Vargas', 3.9, 'CS'), 
('STU022', 'Arnav Hansen', 4.1, 'DS'),
-- NOTE: Students are not allocated any projects yet, problems described in preference table
('STU023', 'Raul Horton', 3.3, 'CS'),
('STU024', 'Affan Bryant', 3.7, 'DS'),
('STU025', 'Timur Delgado', 4.0, 'CS'),
('STU026', 'Zander Mayer', 3.0, 'DS');

SELECT * from student;

INSERT INTO supervisor (supervisor_ID, supervisor_name, supervisor_stream_ID) VALUES
('TEA001', 'John Murray', 'CS'),
('TEA002', 'David Gatteo', 'CS'),
('TEA003', 'Isabel Crowford', 'CS'),
('TEA004', 'Tobias Long', 'CS'),
('TEA005', 'Liyana Rosales', 'CS'),
('TEA006', 'Jedd Kirkland', 'DS'),
('TEA007', 'Karim Bright', 'DS'),
('TEA008', 'Miriam Wills', 'DS'),
('TEA009', 'Jace Mcneill', 'DS'),
('TEA010', 'Cieran Kim', 'DS');

SELECT * from supervisor;

INSERT INTO project (project_ID, project_name, project_stream_ID, project_supervisor_ID, project_availability) VALUES
-- NOTE: The projects below are proposed by Supervisors (any Stream) and can taken by only CS students
('PRJ001', 'A', 'CS', 'TEA001', FALSE),
('PRJ002', 'B', 'CS', 'TEA002', FALSE),
('PRJ003', 'C', 'CS', 'TEA003', FALSE),
('PRJ004', 'D', 'CS', 'TEA004', FALSE),
('PRJ005', 'E', 'CS', 'TEA005', FALSE),
('PRJ006', 'F', 'CS', 'TEA001', FALSE),
('PRJ007', 'G', 'CS', 'TEA002', FALSE),
('PRJ008', 'H', 'CS', 'TEA003', FALSE),
('PRJ009', 'I', 'CS', 'TEA004', FALSE),
('PRJ010', 'J', 'CS', 'TEA005', FALSE),
('PRJ011', 'K', 'CS', 'TEA006', FALSE),
('PRJ012', 'L', 'CS', 'TEA007', FALSE),
('PRJ013', 'M', 'CS', 'TEA008', FALSE),
('PRJ014', 'N', 'CS', 'TEA009', FALSE),
('PRJ015', 'O', 'CS', 'TEA010', FALSE),
('PRJ046', 'STU', 'CS', 'TEA001', FALSE),
('PRJ047', 'VWX', 'CS', 'TEA002', FALSE),
('PRJ048', 'YZA', 'CS', 'TEA003', FALSE),
('PRJ049', 'ABCD', 'CS', 'TEA004', FALSE),
('PRJ050', 'EFGH', 'CS', 'TEA005', FALSE),
-- NOTE: The projects below are proposed by Supervisors (any Stream) and can taken by only DS students
('PRJ016', 'P', 'DS', 'TEA006', FALSE),
('PRJ017', 'Q', 'DS', 'TEA007', FALSE),
('PRJ018', 'R', 'DS', 'TEA008', FALSE),
('PRJ019', 'S', 'DS', 'TEA009', FALSE),
('PRJ020', 'T', 'DS', 'TEA010', FALSE),
('PRJ021', 'U', 'DS', 'TEA006', FALSE),
('PRJ022', 'V', 'DS', 'TEA007', FALSE),
('PRJ023', 'W', 'DS', 'TEA008', FALSE),
('PRJ024', 'X', 'DS', 'TEA009', FALSE),
('PRJ025', 'Y', 'DS', 'TEA010', FALSE),
('PRJ026', 'Z', 'DS', 'TEA001', FALSE),
('PRJ027', 'AB', 'DS', 'TEA002', FALSE),
('PRJ028', 'CD', 'DS', 'TEA003', FALSE),
('PRJ029', 'EF', 'DS', 'TEA004', FALSE),
('PRJ030', 'GH', 'DS', 'TEA005', FALSE),
('PRJ051', 'IJKL', 'DS', 'TEA006', FALSE),
('PRJ052', 'MNOP', 'DS', 'TEA007', FALSE),
('PRJ053', 'QRST', 'DS', 'TEA008', FALSE),
('PRJ054', 'UVWX', 'DS', 'TEA009', FALSE),
('PRJ055', 'YZAB', 'DS', 'TEA010', FALSE),
-- NOTE: The projects below can be taken by any student
('PRJ031', 'IJ', 'CS', 'TEA001', TRUE),
('PRJ032', 'KL', 'CS', 'TEA002', TRUE),
('PRJ033', 'MN', 'CS', 'TEA003', TRUE),
('PRJ034', 'OP', 'CS', 'TEA004', TRUE),
('PRJ035', 'QR', 'CS', 'TEA005', TRUE),
('PRJ036', 'ST', 'DS', 'TEA006', TRUE),
('PRJ037', 'UV', 'DS', 'TEA007', TRUE),
('PRJ038', 'WX', 'DS', 'TEA008', TRUE),
('PRJ039', 'YZ', 'DS', 'TEA009', TRUE),
('PRJ040', 'ABC', 'DS', 'TEA010', TRUE),
-- NOTE: The projects below are Self Proposed
('PRJ041', 'DEF', 'CS', 'TEA002', FALSE),
('PRJ042', 'GHI', 'CS', 'TEA004', FALSE),
('PRJ043', 'JKL', 'DS', 'TEA006', FALSE),
('PRJ044', 'MNO', 'DS', 'TEA008', FALSE),
('PRJ045', 'PQR', 'DS', 'TEA010', FALSE);

SELECT * from project;

INSERT INTO allocated (allocated_project_ID, allocated_student_ID, allocated_student_proposed) VALUES
-- NOTE: CS students assigned CS projects
('PRJ001', 'STU001', FALSE),
-- ('PRJ001', 'STU006', FALSE), -- Wrond project allocated
('PRJ002', 'STU002', FALSE),
('PRJ003', 'STU005', FALSE),
('PRJ004', 'STU011', FALSE), 
('PRJ005', 'STU012', FALSE), 
('PRJ006', 'STU013', FALSE),
('PRJ007', 'STU014', FALSE),
('PRJ008', 'STU015', FALSE),
-- NOTE: DS students assigned DS projects
('PRJ016', 'STU006', FALSE),
-- ('PRJ016', 'STU001', FALSE), -- Worong project allocated
('PRJ017', 'STU007', FALSE),
('PRJ018', 'STU008', FALSE),
('PRJ019', 'STU009', FALSE),
('PRJ020', 'STU010', FALSE),
('PRJ021', 'STU019', FALSE),
('PRJ022', 'STU020', FALSE),
-- NOTE: Sef Propsed projects assigned to respective student
('PRJ041', 'STU003', TRUE),
('PRJ042', 'STU004', TRUE),
('PRJ043', 'STU016', TRUE),
('PRJ044', 'STU017', TRUE),
('PRJ045', 'STU018', TRUE),
-- NOTE: Both Category project assigned, STU021 is CS, Project is DS; STU022 is DS, Project is CS
('PRJ036', 'STU021', FALSE), 
('PRJ031', 'STU022', FALSE);

SELECT * from allocated;

 
INSERT INTO preference (preference_student_ID, preference_project_ID_1, preference_project_ID_2, preference_project_ID_3,preference_project_ID_4, preference_project_ID_5, preference_project_ID_6,
preference_project_ID_7, preference_project_ID_8, preference_project_ID_9, preference_project_ID_10, preference_project_ID_11, preference_project_ID_12, preference_project_ID_13, preference_project_ID_14, 
preference_project_ID_15, preference_project_ID_16, preference_project_ID_17, preference_project_ID_18, preference_project_ID_19, preference_project_ID_20) VALUES
-- NOTE: Students in CS having CS projcets and Both category preference also
('STU001', 'PRJ001', 'PRJ009', 'PRJ034', 'PRJ002', 'PRJ003', 'PRJ004', 'PRJ005', 'PRJ006', 'PRJ007', 'PRJ008', 'PRJ010', 'PRJ011', 'PRJ012', 'PRJ013', 'PRJ014', 'PRJ015', 'PRJ031', 'PRJ032', 'PRJ033', 'PRJ035'),
('STU002', 'PRJ002', 'PRJ010', 'PRJ035', 'PRJ001', 'PRJ003', 'PRJ004', 'PRJ005', 'PRJ006', 'PRJ007', 'PRJ008', 'PRJ009', 'PRJ011', 'PRJ012', 'PRJ013', 'PRJ014', 'PRJ015', 'PRJ031', 'PRJ032', 'PRJ033', 'PRJ034'),
('STU005', 'PRJ003', 'PRJ013', 'PRJ001', 'PRJ002', 'PRJ035', 'PRJ004', 'PRJ005', 'PRJ006', 'PRJ007', 'PRJ008', 'PRJ009', 'PRJ010', 'PRJ011', 'PRJ012', 'PRJ014', 'PRJ015', 'PRJ031', 'PRJ032', 'PRJ033', 'PRJ034'),
('STU011', 'PRJ004', 'PRJ014', 'PRJ001', 'PRJ002', 'PRJ003', 'PRJ035', 'PRJ005', 'PRJ006', 'PRJ007', 'PRJ008', 'PRJ009', 'PRJ010', 'PRJ011', 'PRJ012', 'PRJ013', 'PRJ015', 'PRJ031', 'PRJ032', 'PRJ033', 'PRJ034'),
('STU012', 'PRJ005', 'PRJ015', 'PRJ001', 'PRJ002', 'PRJ003', 'PRJ004', 'PRJ035', 'PRJ006', 'PRJ007', 'PRJ008', 'PRJ009', 'PRJ010', 'PRJ011', 'PRJ012', 'PRJ013', 'PRJ014', 'PRJ031', 'PRJ032', 'PRJ033', 'PRJ034'),
('STU013', 'PRJ006', 'PRJ031', 'PRJ001', 'PRJ002', 'PRJ003', 'PRJ004', 'PRJ005', 'PRJ035', 'PRJ007', 'PRJ008', 'PRJ009', 'PRJ010', 'PRJ011', 'PRJ012', 'PRJ013', 'PRJ014', 'PRJ015', 'PRJ032', 'PRJ033', 'PRJ034'),
('STU014', 'PRJ007', 'PRJ032', 'PRJ001', 'PRJ002', 'PRJ003', 'PRJ004', 'PRJ005', 'PRJ006', 'PRJ035', 'PRJ008', 'PRJ009', 'PRJ010', 'PRJ011', 'PRJ012', 'PRJ013', 'PRJ014', 'PRJ031', 'PRJ015', 'PRJ033', 'PRJ034'),
('STU015', 'PRJ008', 'PRJ033', 'PRJ001', 'PRJ002', 'PRJ003', 'PRJ004', 'PRJ005', 'PRJ006', 'PRJ007', 'PRJ035', 'PRJ009', 'PRJ010', 'PRJ011', 'PRJ012', 'PRJ013', 'PRJ014', 'PRJ031', 'PRJ032', 'PRJ015', 'PRJ034'),
('STU021', 'PRJ036', 'PRJ001', 'PRJ002', 'PRJ003', 'PRJ004', 'PRJ005', 'PRJ006', 'PRJ007', 'PRJ008', 'PRJ009', 'PRJ010', 'PRJ011', 'PRJ012', 'PRJ013', 'PRJ014', 'PRJ015', 'PRJ046', 'PRJ047', 'PRJ048', 'PRJ049'),
-- NOTE: Students in DS having DS projects and Both category preference also
-- ('STU006', 'PRJ016', 'PRJ023', 'PRJ038', 'PRJ017', 'PRJ018', 'PRJ019', 'PRJ020', 'PRJ021', 'PRJ022', 'PRJ024', 'PRJ025', 'PRJ026', 'PRJ027', 'PRJ028', 'PRJ029', 'PRJ030', 'PRJ036', 'PRJ037', 'PRJ039', 'PRJ040'),
-- STU006 has given the correct preference (It's a corner case where, more than 1 but less than 20 prefernece is given)
('STU006', 'PRJ016', 'PRJ023', 'PRJ038', 'PRJ017', 'PRJ018', 'PRJ019', 'PRJ020', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('STU007', 'PRJ017', 'PRJ024', 'PRJ039', 'PRJ016', 'PRJ018', 'PRJ019', 'PRJ020', 'PRJ021', 'PRJ022', 'PRJ023', 'PRJ025', 'PRJ026', 'PRJ027', 'PRJ028', 'PRJ029', 'PRJ030', 'PRJ036', 'PRJ037', 'PRJ038', 'PRJ040'),
('STU008', 'PRJ018', 'PRJ038', 'PRJ023', 'PRJ017', 'PRJ016', 'PRJ019', 'PRJ020', 'PRJ021', 'PRJ022', 'PRJ024', 'PRJ025', 'PRJ026', 'PRJ027', 'PRJ028', 'PRJ029', 'PRJ030', 'PRJ036', 'PRJ037', 'PRJ039', 'PRJ040'),
('STU009', 'PRJ019', 'PRJ026', 'PRJ016', 'PRJ017', 'PRJ018', 'PRJ020', 'PRJ021', 'PRJ022', 'PRJ023', 'PRJ024', 'PRJ025', 'PRJ027', 'PRJ028', 'PRJ029', 'PRJ030', 'PRJ036', 'PRJ037', 'PRJ038', 'PRJ039', 'PRJ040'),
('STU010', 'PRJ020', 'PRJ027' ,'PRJ016', 'PRJ017', 'PRJ018', 'PRJ019', 'PRJ021', 'PRJ022', 'PRJ023', 'PRJ024', 'PRJ025', 'PRJ026', 'PRJ028', 'PRJ029', 'PRJ030', 'PRJ036', 'PRJ037', 'PRJ038', 'PRJ039', 'PRJ040'),
('STU019', 'PRJ021', 'PRJ036', 'PRJ016', 'PRJ017', 'PRJ018', 'PRJ019', 'PRJ020', 'PRJ022', 'PRJ023', 'PRJ024', 'PRJ025', 'PRJ026', 'PRJ027', 'PRJ028', 'PRJ029', 'PRJ030', 'PRJ037', 'PRJ038', 'PRJ039', 'PRJ040'),
('STU020', 'PRJ022', 'PRJ037', 'PRJ016', 'PRJ017', 'PRJ018', 'PRJ019', 'PRJ020', 'PRJ021', 'PRJ023', 'PRJ024', 'PRJ025', 'PRJ026', 'PRJ027', 'PRJ028', 'PRJ029', 'PRJ030', 'PRJ036', 'PRJ038', 'PRJ039', 'PRJ040'),
('STU022', 'PRJ031', 'PRJ016', 'PRJ017', 'PRJ018', 'PRJ019', 'PRJ020', 'PRJ021', 'PRJ022', 'PRJ023', 'PRJ024', 'PRJ025', 'PRJ026', 'PRJ027', 'PRJ028', 'PRJ029', 'PRJ030', 'PRJ051', 'PRJ052', 'PRJ053', 'PRJ054'),
-- NOTE: Students Self Proposing Projects can't give a preference
-- STU003 is CS, STU004 is CS, STU016 is DS, STU017 is DS, STU018 is DS
('STU003', 'PRJ041', 'PRJ011', 'PRJ001', 'PRJ002', 'PRJ003', 'PRJ004', 'PRJ005', 'PRJ006', 'PRJ007', 'PRJ008', 'PRJ009', 'PRJ010', 'PRJ012', 'PRJ013', 'PRJ014', 'PRJ015', 'PRJ031', 'PRJ032', 'PRJ033', 'PRJ034'),
('STU004', 'PRJ042', 'PRJ011', 'PRJ001', 'PRJ002', 'PRJ003', 'PRJ004', 'PRJ005', 'PRJ006', 'PRJ007', 'PRJ008', 'PRJ009', 'PRJ010', 'PRJ012', 'PRJ013', 'PRJ014', 'PRJ015', 'PRJ031', 'PRJ032', 'PRJ033', 'PRJ034'),
('STU016', 'PRJ043', 'PRJ028', 'PRJ016', 'PRJ017', 'PRJ018', 'PRJ019', 'PRJ020', 'PRJ021', 'PRJ022', 'PRJ023', 'PRJ024', 'PRJ025', 'PRJ026', 'PRJ027', 'PRJ029', 'PRJ030', 'PRJ036', 'PRJ037', 'PRJ038', 'PRJ039'),
('STU017', 'PRJ044', 'PRJ028', 'PRJ016', 'PRJ017', 'PRJ018', 'PRJ019', 'PRJ020', 'PRJ021', 'PRJ022', 'PRJ023', 'PRJ024', 'PRJ025', 'PRJ026', 'PRJ027', 'PRJ029', 'PRJ030', 'PRJ036', 'PRJ037', 'PRJ038', 'PRJ039'),
('STU018', 'PRJ045', 'PRJ028', 'PRJ016', 'PRJ017', 'PRJ018', 'PRJ019', 'PRJ020', 'PRJ021', 'PRJ022', 'PRJ023', 'PRJ024', 'PRJ025', 'PRJ026', 'PRJ027', 'PRJ029', 'PRJ030', 'PRJ036', 'PRJ037', 'PRJ038', 'PRJ039'),
-- NOTE: Students of CS and DS can't take projects from the other stream
-- NOTE: Students can't gain the system
-- STU023 has given just on preference only (5 times as a minimum number of required projcets by the table)
-- STU024 has given one project in all 20 preferences, even if he leaves any filed blank it will caught in the subsequent query
-- STU025 is CS trying to give preferences of DS projects only (NO preference given from the projcets that can be taken by both)
-- STU026 is DS trying to give preferences of CS projects only (NO preference given from the projcets that can be taken by both)
('STU023', 'PRJ010', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
('STU024', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020', 'PRJ020'),
('STU025', 'PRJ017', 'PRJ023', 'PRJ016', 'PRJ018', 'PRJ019', 'PRJ020', 'PRJ021', 'PRJ022', 'PRJ024', 'PRJ025', 'PRJ026', 'PRJ027', 'PRJ028', 'PRJ029', 'PRJ030', 'PRJ051', 'PRJ052', 'PRJ053', 'PRJ054', 'PRJ055'),
('STU026', 'PRJ002', 'PRJ009', 'PRJ001', 'PRJ003', 'PRJ004', 'PRJ005', 'PRJ006', 'PRJ007', 'PRJ008', 'PRJ010', 'PRJ011', 'PRJ012', 'PRJ013', 'PRJ014', 'PRJ015', 'PRJ046', 'PRJ047', 'PRJ048', 'PRJ049', 'PRJ050');

SELECT * FROM preference;
-- DUMMY DATA COMPLETE

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- QUERY 1. Check if each project has been assigned to a unique student.
-- This is also handled using the combination of Primary Key (Both Student ID and Project ID)
SELECT COUNT(allocated_project_ID) AS 'Number of Distinct Projects', COUNT(DISTINCT allocated_student_ID) AS 'Number of Distinct Students'
FROM allocated;

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- QUERY 2. To display CS projects and both Both category to CS students, DS projects and Both category to DS students
SELECT DISTINCT p.project_ID AS Project_ID, p.project_name AS Project_Name, p.project_stream_ID AS Project_Stream 
FROM project p INNER JOIN student s 
WHERE (p.project_stream_ID = "CS" AND s.student_stream_ID = "CS") OR (p.project_availability = TRUE AND s.student_stream_ID = "CS");

-- For Better accessibility a procedure can be defined
DELIMITER //
CREATE PROCEDURE Get_Specific_Project(IN stream_type CHAR(2))
BEGIN
    SELECT DISTINCT p.project_ID AS Project_ID, p.project_name AS Project_Name, p.project_stream_ID AS Project_Stream 
    FROM project p INNER JOIN student s 
    WHERE (p.project_stream_ID = stream_type AND s.student_stream_ID = stream_type) OR (p.project_availability = TRUE AND s.student_stream_ID = stream_type);
END
// DELIMITER ;

CALL Get_Specific_Project("CS"); -- For accessing the projects that can taken by the CS students
CALL Get_Specific_Project("DS"); -- For accessing the projects that can taken by the DS students

-- Providing students ONLY a limited view of the Projects Data.
-- A view can be created for students.
CREATE OR REPLACE VIEW CS_Project AS
    SELECT DISTINCT p.project_ID AS Project_ID, p.project_name AS Project_Name, p.project_stream_ID AS Project_Stream
    FROM project p INNER JOIN student s 
    WHERE (p.project_stream_ID = "CS" AND s.student_stream_ID = "CS") OR (p.project_availability = TRUE AND s.student_stream_ID = "CS");

SELECT * FROM CS_Project;

CREATE OR REPLACE VIEW DS_Project AS
    SELECT DISTINCT p.project_ID AS Project_ID, p.project_name AS Project_Name, p.project_stream_ID AS Project_Stream
    FROM project p INNER JOIN student s 
    WHERE (p.project_stream_ID = "DS" AND s.student_stream_ID = "DS") OR (p.project_availability = TRUE AND s.student_stream_ID = "DS");

SELECT * FROM DS_Project;

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- QUERY 3. To check if the preferences are correct, (Gaming the system)
    -- The student who has entered, 1 preference only
    -- The student who has entered, 20 preferences all of same type
-- The First where clause catches the students where the Student Just enters one Project preference 
-- The subsequent OR statements catches the students who have entered the same preference in any other preference field 

CREATE OR REPLACE VIEW defaulter_preference_gaming AS
    SELECT p.preference_student_ID AS Student_ID, s.student_name AS Student_Name, s.student_stream_ID AS Student_Stream, 'Gaming the System' AS 'Message'
    FROM preference p INNER JOIN student s ON p.preference_student_ID = s.student_ID
    WHERE 
    (
        ((p.preference_project_ID_2 IS NULL) AND (p.preference_project_ID_3 IS NULL) AND (p.preference_project_ID_4 IS NULL) AND (p.preference_project_ID_5 IS NULL) AND (p.preference_project_ID_6 IS NULL) AND (p.preference_project_ID_7 IS NULL) AND (p.preference_project_ID_8 IS NULL) AND (p.preference_project_ID_9 IS NULL) AND (p.preference_project_ID_10 IS NULL) AND (p.preference_project_ID_11 IS NULL) AND (p.preference_project_ID_12 IS NULL) AND (p.preference_project_ID_13 IS NULL) AND (p.preference_project_ID_14 IS NULL) AND (p.preference_project_ID_15 IS NULL) AND (p.preference_project_ID_16 IS NULL) AND (p.preference_project_ID_17 IS NULL) AND (p.preference_project_ID_18 IS NULL) AND (p.preference_project_ID_19 IS NULL) AND (p.preference_project_ID_20 IS NULL))
        OR
        (p.preference_project_ID_1 IN (p.preference_project_ID_2, p.preference_project_ID_3, p.preference_project_ID_4, p.preference_project_ID_5, p.preference_project_ID_6, p.preference_project_ID_7, p.preference_project_ID_8, p.preference_project_ID_9, p.preference_project_ID_10, p.preference_project_ID_11, p.preference_project_ID_12, p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_2 IN (p.preference_project_ID_3, p.preference_project_ID_4, p.preference_project_ID_5, p.preference_project_ID_6, p.preference_project_ID_7, p.preference_project_ID_8, p.preference_project_ID_9, p.preference_project_ID_10, p.preference_project_ID_11, p.preference_project_ID_12, p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_3 IN (p.preference_project_ID_4, p.preference_project_ID_5, p.preference_project_ID_6, p.preference_project_ID_7, p.preference_project_ID_8, p.preference_project_ID_9, p.preference_project_ID_10, p.preference_project_ID_11, p.preference_project_ID_12, p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_4 IN (p.preference_project_ID_5, p.preference_project_ID_6, p.preference_project_ID_7, p.preference_project_ID_8, p.preference_project_ID_9, p.preference_project_ID_10, p.preference_project_ID_11, p.preference_project_ID_12, p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_5 IN (p.preference_project_ID_6, p.preference_project_ID_7, p.preference_project_ID_8, p.preference_project_ID_9, p.preference_project_ID_10, p.preference_project_ID_11, p.preference_project_ID_12, p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_6 IN (p.preference_project_ID_7, p.preference_project_ID_8, p.preference_project_ID_9, p.preference_project_ID_10, p.preference_project_ID_11, p.preference_project_ID_12, p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_7 IN (p.preference_project_ID_8, p.preference_project_ID_9, p.preference_project_ID_10, p.preference_project_ID_11, p.preference_project_ID_12, p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_8 IN (p.preference_project_ID_9, p.preference_project_ID_10, p.preference_project_ID_11, p.preference_project_ID_12, p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_9 IN (p.preference_project_ID_10, p.preference_project_ID_11, p.preference_project_ID_12, p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_10 IN (p.preference_project_ID_11, p.preference_project_ID_12, p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_11 IN (p.preference_project_ID_12, p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_12 IN (p.preference_project_ID_13, p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_13 IN (p.preference_project_ID_14, p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_14 IN (p.preference_project_ID_15, p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_15 IN (p.preference_project_ID_16, p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_16 IN (p.preference_project_ID_17, p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_17 IN (p.preference_project_ID_18, p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_18 IN (p.preference_project_ID_19, p.preference_project_ID_20))
        OR
        (p.preference_project_ID_19 IN (p.preference_project_ID_20))
    );

SELECT * 
FROM defaulter_preference_gaming;

    -- List of Students who have Declared Incorrect Preferences
-- Following query is for CS students not giving correct preference (Giving DS project preferences)
-- Following the UNION operator, the query is for DS students not giving correct preference (Giving CS project preferences)
CREATE OR REPLACE VIEW defaulter_preference_incorrect AS
    SELECT p.preference_student_ID AS Student_ID, s.student_name AS Student_Name, s.student_stream_ID AS Student_Stream, 'Incorrect Preference' AS 'Message'
    FROM preference p INNER JOIN student s ON p.preference_student_ID = s.student_ID 
    WHERE s.student_stream_ID = 'CS' AND 
    (
        (p.preference_project_ID_1 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_2 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_3 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_4 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_5 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_6 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_7 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_8 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_9 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_10 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_11 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_12 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_13 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_14 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_15 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_16 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_17 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_18 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_19 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) OR
        (p.preference_project_ID_20 NOT IN (SELECT c.Project_ID FROM CS_Project as c)) 
    ) 
    UNION
    SELECT p.preference_student_ID AS Student_ID, s.student_name AS Student_Name, s.student_stream_ID AS Student_Stream, 'Incorrect Preference' AS 'Message'
    FROM preference p INNER JOIN student s ON p.preference_student_ID = s.student_ID 
    WHERE s.student_stream_ID = 'DS' AND 
    (
        (p.preference_project_ID_1 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_2 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_3 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_4 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_5 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_6 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_7 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_8 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_9 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_10 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_11 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_12 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_13 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_14 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_15 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_16 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_17 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_18 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_19 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) OR
        (p.preference_project_ID_20 NOT IN (SELECT d.Project_ID FROM DS_Project as d)) 
    );

SELECT * FROM defaulter_preference_incorrect;

    -- For checking the students who have self declared projcets should not have given any preference, they alreday have been allocated their proposed projects
    -- STU003 is CS, STU004 is CS, STU016 is DS, STU017 is DS, STU018 is DS (They all gave preference in the table)
CREATE OR REPLACE VIEW defaulter_preference_self_proposed AS
    SELECT p.preference_student_ID AS Student_ID, s.student_name AS Student_Name, s.student_stream_ID AS Student_Stream, 'Self-proposed Projects' AS 'Message'
    FROM preference p INNER JOIN allocated a ON a.allocated_student_ID = p.preference_student_ID INNER JOIN student s ON a.allocated_student_ID = s.student_ID
    WHERE a.allocated_student_proposed = TRUE;

SELECT * FROM defaulter_preference_self_proposed;

    -- Combination of all the above queries will give all the students not following the guidelines for preference table
    -- Created a Procedure for ease of calling
DROP PROCEDURE IF EXISTS Get_Defaulter_Preference;
DELIMITER //
CREATE PROCEDURE Get_Defaulter_Preference()
BEGIN
    SELECT * FROM defaulter_preference_gaming
    UNION ALL
    SELECT * FROM defaulter_preference_incorrect
    UNION ALL
    SELECT * FROM defaulter_preference_self_proposed;
END
// DELIMITER ;

CALL Get_Defaulter_Preference();

    -- Since we get all the defaulters from the preference table, it is important that students with correct preference are also retrieved
    -- Created a Procedure for ease of calling

DROP PROCEDURE IF EXISTS Get_Correct_Preference;
DELIMITER //
CREATE PROCEDURE Get_Correct_Preference()
BEGIN
    SELECT p.preference_student_ID AS Student_ID, s.student_name AS Student_Name, s.student_stream_ID AS Student_Stream_ID 
    FROM preference p INNER JOIN student s ON p.preference_student_ID = s.student_ID 
    WHERE 
    p.preference_student_ID NOT IN (SELECT Student_ID FROM defaulter_preference_gaming) AND 
    p.preference_student_ID NOT IN (SELECT Student_ID FROM defaulter_preference_incorrect) AND
    p.preference_student_ID NOT IN (SELECT Student_ID FROM defaulter_preference_self_proposed);

END
// DELIMITER ; 

CALL Get_Correct_Preference();

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- QUERY 4. To check the project allocations
    -- The CS Projects are allocated to CS students only
    -- DS projects are allocated to DS students only
    -- Both can be allocated to any student
    -- Self Proposed are allocated to specific student
  
SELECT a.allocated_student_ID AS Studen_ID, s.student_name AS Student_Name, p.project_ID AS Project_ID,
CASE 
	WHEN ((s.student_stream_ID = 'CS' AND p.project_stream_ID != 'CS') AND p.project_availability = FALSE) 
		THEN 'WRONG   : Project allocated to CS Student'
    WHEN ((s.student_stream_ID = 'DS' AND p.project_stream_ID != 'DS') AND p.project_availability = FALSE) 
		THEN 'WRONG   : Project allocated to DS Student'
    WHEN ((s.student_stream_ID = 'CS' OR s.student_stream_ID = 'DS') AND p.project_availability = TRUE) 
		THEN 'CORRECT: Projcet available to both'
    WHEN ((s.student_stream_ID = 'CS' OR s.student_stream_ID = 'DS') AND a.allocated_student_proposed = TRUE) 
		THEN 'CORRECT: Self Proposed'
    ELSE 'CORRECT'
END AS 'Message'
FROM allocated a INNER JOIN project p ON a.allocated_project_ID = p.project_ID INNER JOIN student s ON a.allocated_student_ID = s.student_ID;

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- QUERY 5. Find the students working under different supervisors

    -- Query to find the students working under different supervisors
SELECT a.allocated_student_ID AS Student_ID,  a.allocated_project_ID AS Project_ID, p.project_supervisor_ID AS Supervisor_ID, s.supervisor_name AS Supervisor_Name
FROM allocated a INNER JOIN project p ON a.allocated_project_ID = p.project_ID INNER JOIN supervisor s ON p.project_supervisor_ID = s.supervisor_ID
ORDER BY s.supervisor_ID;

    -- Query to find the load (Number of students assigned to each professor) on each professor
SELECT s.supervisor_name AS Supervisor_Name, COUNT(a.allocated_student_ID) AS Allocated_Students
FROM allocated a INNER JOIN project p ON a.allocated_project_ID = p.project_ID INNER JOIN supervisor s ON p.project_supervisor_ID = s.supervisor_ID
GROUP BY s.supervisor_ID ORDER BY COUNT(a.allocated_student_ID) DESC;    

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- QUERY 6. Find the number of CS projects and DS projects allocated to students

	-- Total Projcets available
SELECT COUNT(*) AS Total_Projects FROM project;    

	-- Query to find how many CS and DS stream students have been assigned a project.
SELECT s.student_stream_ID, COUNT(a.allocated_project_ID) AS Count_Allocated_Projects
FROM allocated a INNER JOIN CS_Project cs ON a.allocated_project_ID = cs.Project_ID INNER JOIN student s ON a.allocated_student_ID = s.student_ID
WHERE (s.student_stream_ID = 'CS' AND (cs.Project_Stream = 'CS' OR cs.Project_Stream = 'DS'))
UNION
SELECT s.student_stream_ID , COUNT(a.allocated_project_ID) 
FROM allocated a INNER JOIN DS_Project ds ON a.allocated_project_ID = ds.Project_ID INNER JOIN student s ON a.allocated_student_ID = s.student_ID
WHERE (s.student_stream_ID = 'DS' AND (ds.Project_Stream = 'CS' OR ds.Project_Stream = 'DS'));

	-- Query to find which projects are not yet assigned/ allocated 
SELECT p.project_ID AS Not_Allocated_Projects
FROM project p 
WHERE p.project_ID NOT IN (SELECT a.allocated_project_ID FROM allocated a);
    
	-- Query to find the names and ID's of the students who haven't been assigned a project yet
SELECT s.student_ID, s.student_name 
FROM student s 
WHERE s.student_ID NOT IN (SELECT a.allocated_student_ID FROM allocated a);

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- QUERY 6. 
	-- To find the total number of CS and DS students in the school

SELECT s.student_stream_ID AS Stream_ID, COUNT(s.student_ID) AS Number_Of_Students 
FROM student s GROUP BY s.student_stream_ID;

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 -- QUERY 7.
	-- To find the number of CS and DS Professors in the school
    
SELECT s.supervisor_stream_ID, COUNT(s.supervisor_ID) AS Number_of_Supervisor
FROM supervisor s GROUP BY s.supervisor_stream_ID;

-- <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ============================== >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>