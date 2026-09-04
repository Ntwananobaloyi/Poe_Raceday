CREATE DATABASE RACEDAY;
USE RACEDAY;

CREATE TABLE ROLES (ROLE_ID INT IDENTITY(1001,1) PRIMARY KEY,
                    ROLE_NAME VARCHAR(255) NOT NULL,
                    NAME VARCHAR(255) NOT NULL); 


   INSERT INTO ROLES(ROLE_NAME,NAME)
   VALUES('ORGANISER','THABO'),
         ('PARTICIPANT','EMILY'),
         ('ORGANISER','AISHA'),
         ('PARTICIPANT','LIAM'),
         ('ORGANISER','NALEDI');

          SELECT*FROM ROLES


          CREATE TABLE USERS(USER_ID INT IDENTITY(100,1) PRIMARY KEY,
                   USER_NAME VARCHAR(255) NOT NULL, 
                   USER_SURNAME VARCHAR(255) NOT NULL,
                   USER_DOB VARCHAR(255) NOT NULL,
                   ROLEID INT,
                   FOREIGN KEY(ROLEID) REFERENCES ROLES(ROLE_ID));

             INSERT INTO USERS(USER_NAME, USER_SURNAME,USER_DOB,ROLEID)
             VALUES ('THABO','MOKOENA','25-May-2006',1001),
                    ('EMILY','CARTER','26-September-2012',1002),
                    ('AISHA','PATEL','26-April-2003',1003),
                    ('LIAM','VAN WYK','04-October-2000',1004),
                    ('NALEDI','KHUMALO','11-June-2008',1005); 

                    SELECT*FROM USERS 

                     CREATE TABLE EVENT(EVENT_ID INT IDENTITY(100,1)PRIMARY KEY,
                           EVENT_DATE VARCHAR(255) NOT NULL,
                           EVENT_LOCATION VARCHAR(255) NOT NULL,
                           USERID INT,
                           FOREIGN KEY(USERID) REFERENCES USERS(USER_ID));

                 INSERT INTO EVENT(EVENT_DATE, EVENT_LOCATION,USERID)
                 VALUES('02-JANUARY-2026','Johanesburg','1'),
                       ('28-August-2026','Cape Town','2'),
                        ('26-April-2026','Durban','3'),
                       ('05-May-2026','Petermaritzburg','4'),
                       ('24-November-2026','Western Cape','5');

                        Select*from Event
   
     CREATE TABLE CATEGORIES(CATEGORY_ID INT IDENTITY(400,1) PRIMARY KEY, 
                                             CATEGORY_TYPE VARCHAR(255) NOT NULL,
                                             CATEGORY_DISTANCE VARCHAR(255) NOT NULL,
                                             EVENTID INT, 
                                             FOREIGN KEY(EVENTID) REFERENCES EVENT(EVENT_ID));

                           INSERT INTO CATEGORIES(CATEGORY_TYPE, CATEGORY_DISTANCE, EVENTID)
                            VALUES('5KM FUN RUN','5KM',100),
                                  ('10KM OPEN','10KM',101),
                                  ('21,1 KM HALF MARATHON','21,1KM',102),
                                  ('42,2KM FULL MARATHON','42,2KM',103),
                                  ('109KM CYCLE ROAD','109KM',104);

                                  SELECT*FROM CATEGORIES

CREATE TABLE ENROLLMENTS(ENROLLMENT_ID INT IDENTITY(500,1) PRIMARY KEY,
                        PAYMENT_STATUS VARCHAR(255) NOT NULL,
                        USERID INT,
                        CATEGORYID INT,
                        FOREIGN KEY(USERID)REFERENCES USERS(USER_ID),
                        FOREIGN KEY(CATEGORYID) REFERENCES CATEGORIES(CATEGORY_ID));

                    INSERT INTO ENROLLMENTS(PAYMENT_STATUS, USERID,CATEGORYID)
                    VALUES('PAYMENT OUTSTANDING',1,400),
                          ('PAYMENT RECEIVED',2,401),
                          ('PENDING',3,402),
                          ('PAYMENT FAILED',4,403),
                          ('REFUNDED',5,404);

                          SELECT*FROM ENROLLMENTS

                                             
CREATE TABLE RESULTS(RESULT_ID INT IDENTITY(600,1)PRIMARY KEY, 
                    STATUS VARCHAR(255)NOT NULL,
                    OVERALL_POSITION VARCHAR(255) NOT NULL,
                    ENROLLMENTID INT, 
                    FOREIGN KEY(ENROLLMENTID) REFERENCES ENROLLMENTS(ENROLLMENT_ID));

           INSERT INTO RESULTS(STATUS, OVERALL_POSITION,ENROLLMENTID)  
           VALUES('finished','1st position',500),
              ('finished','2ND POSITION',501),
              ('did not start','3RD POSITION',502),
              ('disqualified','4TH POSITION',503),
              ('did not start','5TH POSITION',504);
              select*from results
