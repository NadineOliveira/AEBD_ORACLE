CREATE SEQUENCE USERS_HISTORY_INC START WITH 1;
CREATE SEQUENCE Sessions_History_INC START WITH 1;
CREATE SEQUENCE Tablespace_History_INC START WITH 1;
CREATE SEQUENCE Datafile_History_INC START WITH 1;
CREATE SEQUENCE Memory_History_INC START WITH 1;

-- Users_History

CREATE OR REPLACE TRIGGER Users_History_trig
AFTER UPDATE ON USER_T
FOR EACH ROW
BEGIN
    INSERT INTO USER_HISTORY (TIME_STAMP, USER_ID, USERNAME, EXPIRATION_DATE, STATUS, CREATED_DATE)
    VALUES (CURRENT_TIMESTAMP,:old.USER_ID, :old.USERNAME , :old.EXPIRATION_DATE ,:old.STATUS ,:old.CREATED_DATE);
END Users_History_trig;

-- Sessions_History

CREATE OR REPLACE TRIGGER Sessions_HistoryUP_trig
AFTER UPDATE ON Sessions
FOR EACH ROW
BEGIN
	INSERT INTO Sessions_History (USERNAME, SERIAL ,TIME_STAMP, SESSIONS_ID,CPU, WAIT_SESSIONS, USER_ID)
	VALUES (:old.USERNAME,:old.SERIAL,CURRENT_TIMESTAMP,:old.SESSIONS_ID,:old.CPU,:old.WAIT_SESSIONS,:old.USER_ID);
END Sessions_HistoryUP_trig;

-- Tablespace_History

CREATE OR REPLACE TRIGGER Tablespace_HistoryUP_trig
AFTER UPDATE ON Tablespace_T
FOR EACH ROW
BEGIN
	INSERT INTO Tablespace_History (TIME_STAMP,NAME_TABLESPACE,SIZE_TABLESPACE,FREE_SPACE,USED,TYPE_TABLESPACE,MAX_SIZE,STATUS)
	Values (CURRENT_TIMESTAMP,:old.NAME_TABLESPACE,:old.SIZE_TABLESPACE,:old.FREE_SPACE,:old.USED,:old.TYPE_TABLESPACE,:old.MAX_SIZE,:old.STATUS);
END Tablespace_HistoryUP_trig;


-- Datafile_History

CREATE OR REPLACE TRIGGER Datafile_History_trig
AFTER UPDATE ON Datafile_T
FOR EACH ROW
BEGIN
	INSERT INTO Datafile_History (TIME_STAMP,DATAFILE_ID,NAME_DATAFILE,USER_BYTES,AUTOEXTENSIBLE,STATUS,BYTES,NAME_TABLESPACE)
	VALUES (CURRENT_TIMESTAMP,:old.DATAFILE_ID, :old.NAME_DATAFILE, :old.USER_BYTES, :old.AUTOEXTENSIBLE, :old.STATUS, :old.BYTES, :old.NAME_TABLESPACE);
END Datafile_History_trig;

-- Memory_History

CREATE OR REPLACE TRIGGER Memory_HistoryUP_trig
AFTER UPDATE ON Memory_T
FOR EACH ROW
BEGIN
	INSERT INTO Memory_History (TIME_STAMP,MEMORY_ID,PGA,DATA_STORAGE,SGA,SHARED_IO_POOL,SHARED_POOL_MEMORY,BUFFER_CACHE_MEMORY,LARGE_POOL,JAVA_POOL,STREAM_POOL,NAME_TABLESPACE)
	VALUES (CURRENT_TIMESTAMP,:old.MEMORY_ID,:old.PGA, :old.DATA_STORAGE, :old.SGA, :old.SHARED_IO_POOL, :old.SHARED_POOL_MEMORY, :old.BUFFER_CACHE_MEMORY, :old.LARGE_POOL, :old.JAVA_POOL, :old.STREAM_POOL, :old.NAME_TABLESPACE);
END Memory_HistoryUP_trig;
