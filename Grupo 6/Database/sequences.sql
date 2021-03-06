CREATE SEQUENCE data_history_inc START WITH 1;
CREATE SEQUENCE memory_history_inc START WITH 1;
CREATE SEQUENCE memory_inc START WITH 1;
CREATE SEQUENCE sessions_inc START WITH 1;
CREATE SEQUENCE sessions_history_inc START WITH 1;
CREATE SEQUENCE tablespace_history_inc START WITH 1;
CREATE SEQUENCE user_history_inc START WITH 1;

CREATE OR REPLACE TRIGGER data_history_trig 
BEFORE INSERT ON DATAFILE_HISTORY 
FOR EACH ROW
BEGIN
  SELECT data_history_inc.NEXTVAL
  INTO   :new.DATAFILE_HISTORY_ID
  FROM   dual;
END data_history_trig;

CREATE OR REPLACE TRIGGER memory_history_trig 
BEFORE INSERT ON MEMORY_HISTORY 
FOR EACH ROW
BEGIN
  SELECT MEMORY_HISTORY_INC.NEXTVAL
  INTO   :new.MEMORY_HISTORY_ID
  FROM   dual;
END memory_history_trig;

CREATE OR REPLACE TRIGGER memory_trig 
BEFORE INSERT ON MEMORY_T
FOR EACH ROW
BEGIN
  SELECT memory_inc.NEXTVAL
  INTO   :new.MEMORY_ID
  FROM   dual;
END memory_trig;

CREATE OR REPLACE TRIGGER sessions_trig 
BEFORE INSERT ON SESSIONS
FOR EACH ROW
BEGIN
  SELECT sessions_inc.NEXTVAL
  INTO   :new.SESSIONS_ID
  FROM   dual;
END sessions_trig;

CREATE OR REPLACE TRIGGER sessions_history_trig 
BEFORE INSERT ON SESSIONS_HISTORY 
FOR EACH ROW
BEGIN
  SELECT sessions_history_inc.NEXTVAL
  INTO   :new.SESSIONS_HISTORY_ID
  FROM   dual;
END sessions_history_trig;

CREATE OR REPLACE TRIGGER tablespace_history_trig 
BEFORE INSERT ON TABLESPACE_HISTORY 
FOR EACH ROW
BEGIN
  SELECT tablespace_history_inc.NEXTVAL
  INTO   :new.TABLESPACE_HISTORY_ID
  FROM   dual;
END tablespace_history_trig;

CREATE OR REPLACE TRIGGER user_history_trig 
BEFORE INSERT ON USER_HISTORY 
FOR EACH ROW
BEGIN
  SELECT user_history_inc.NEXTVAL
  INTO   :new.USER_HISTORY_ID
  FROM   dual;
END user_history_trig;