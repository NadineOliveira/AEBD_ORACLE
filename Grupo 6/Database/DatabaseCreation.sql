CREATE TABLE USER_T(
USER_ID NUMBER NOT NULL,
USERNAME VARCHAR2(128 BYTE) NOT NULL,
EXPIRATION_DATE DATE,
STATUS VARCHAR2(32 BYTE),
CREATED_DATE DATE NOT NULL,
CONSTRAINT USER_PK PRIMARY KEY (USER_ID)
);

CREATE TABLE TABLESPACE_T(
NAME_TABLESPACE VARCHAR2(30 BYTE) NOT NULL,
SIZE_TABLESPACE NUMBER NOT NULL,
FREE_SPACE NUMBER NOT NULL,
USED NUMBER NOT NULL,
TYPE_TABLESPACE VARCHAR2(21 BYTE),
MAX_SIZE NUMBER NOT NULL,
STATUS VARCHAR2(9 BYTE),
CONSTRAINT TABLESPACE_PK PRIMARY KEY (NAME_TABLESPACE)
);


CREATE TABLE TABLESPACE_USER(
NAME_TABLESPACE VARCHAR2(30 BYTE) NOT NULL,
USER_ID NUMBER NOT NULL,
CONSTRAINT TABLESPACE_USER_PK PRIMARY KEY (NAME_TABLESPACE,USER_ID),
CONSTRAINT TABLESPACE_USER_FOREIGN_KEY FOREIGN KEY (USER_ID) REFERENCES USER_T(USER_ID) ON DELETE CASCADE,
CONSTRAINT TABLESPACE_TABLESPACE_FOREIGN_KEY FOREIGN KEY (NAME_TABLESPACE) REFERENCES TABLESPACE_T(NAME_TABLESPACE) ON DELETE CASCADE
);


CREATE TABLE TABLESPACE_HISTORY(
TABLESPACE_HISTORY_ID NUMBER  NOT NULL,
TIME_STAMP TIMESTAMP NOT NULL,
NAME_TABLESPACE VARCHAR2(30 BYTE) NOT NULL,
SIZE_TABLESPACE NUMBER NOT NULL,
FREE_SPACE NUMBER NOT NULL,
USED NUMBER NOT NULL,
TYPE_TABLESPACE VARCHAR2(21 BYTE),
MAX_SIZE NUMBER NOT NULL,
STATUS VARCHAR2(9 BYTE),
CONSTRAINT TABLESPACE_HISTORY_PK PRIMARY KEY (TABLESPACE_HISTORY_ID),
CONSTRAINT TABLESPACE_HISTORY_TABLESPACE_FOREIGN_KEY FOREIGN KEY (NAME_TABLESPACE) REFERENCES TABLESPACE_T(NAME_TABLESPACE) ON DELETE SET null
);


CREATE TABLE DATAFILE_T(
DATAFILE_ID NUMBER  NOT NULL,
NAME_DATAFILE VARCHAR2(512 BYTE) NOT NULL,
USER_BYTES NUMBER,
AUTOEXTENSIBLE VARCHAR2(3 BYTE),
STATUS VARCHAR2(9 BYTE),
BYTES NUMBER,
NAME_TABLESPACE VARCHAR2(30 BYTE) NOT NULL,
CONSTRAINT DATAFILE_PK PRIMARY KEY (DATAFILE_ID),
CONSTRAINT DATAFILE_TABLESPACE_FOREIGN_KEY FOREIGN KEY (NAME_TABLESPACE) REFERENCES TABLESPACE_T(NAME_TABLESPACE) ON DELETE CASCADE
);


CREATE TABLE DATAFILE_HISTORY(
DATAFILE_HISTORY_ID NUMBER  NOT NULL,
TIME_STAMP TIMESTAMP NOT NULL,
DATAFILE_ID NUMBER,
NAME_DATAFILE VARCHAR2(512 BYTE) NOT NULL,
USER_BYTES NUMBER,
AUTOEXTENSIBLE VARCHAR2(3 BYTE),
STATUS VARCHAR2(9 BYTE),
BYTES NUMBER,
NAME_TABLESPACE VARCHAR2(30 BYTE) NOT NULL,
CONSTRAINT DATAFILE_HISTORY_PK PRIMARY KEY (DATAFILE_HISTORY_ID),
CONSTRAINT DATAFILE_HISTORY_DATAFILE_FOREIGN_KEY FOREIGN KEY (DATAFILE_ID) REFERENCES DATAFILE_T(DATAFILE_ID) ON DELETE SET null
);

CREATE TABLE USER_HISTORY(
USER_HISTORY_ID NUMBER  NOT NULL,
TIME_STAMP TIMESTAMP NOT NULL,
USER_ID NUMBER,
USERNAME VARCHAR2(128 BYTE) NOT NULL,
EXPIRATION_DATE DATE,
STATUS VARCHAR2(32 BYTE),
CREATED_DATE DATE NOT NULL,
CONSTRAINT USER_HISTORY_PK PRIMARY KEY (USER_HISTORY_ID),
CONSTRAINT USER_HISTORY_USER_FOREIGN_KEY FOREIGN KEY (USER_ID) REFERENCES USER_T(USER_ID) ON DELETE SET null
);

CREATE TABLE SESSIONS(
SESSIONS_ID NUMBER  NOT NULL,
USERNAME VARCHAR2(128 BYTE) NOT NULL,
SERIAL NUMBER,
CPU NUMBER NOT NULL,
WAIT_SESSIONS NUMBER NOT NULL,
USER_ID NUMBER NOT NULL,
CONSTRAINT SESSIONS_PK PRIMARY KEY (SESSIONS_ID),
CONSTRAINT SESSIONS_USER_FOREIGN_KEY FOREIGN KEY (USER_ID) REFERENCES USER_t(USER_ID) ON DELETE CASCADE
);


CREATE TABLE SESSIONS_HISTORY(
SESSIONS_HISTORY_ID NUMBER  NOT NULL,
USERNAME VARCHAR2(128 BYTE) NOT NULL,
SERIAL NUMBER,
TIME_STAMP TIMESTAMP NOT NULL,
SESSIONS_ID NUMBER,
CPU NUMBER NOT NULL,
WAIT_SESSIONS NUMBER NOT NULL,
USER_ID NUMBER NOT NULL,
CONSTRAINT SESSIONS_HISTORY_PK PRIMARY KEY (SESSIONS_HISTORY_ID),
CONSTRAINT SESSIONS_HISTORY_SESSIONS_FOREIGN_KEY FOREIGN KEY (SESSIONS_ID) REFERENCES SESSIONS(SESSIONS_ID) ON DELETE SET null
);

CREATE TABLE ROLE_T(
ROLE_ID NUMBER  NOT NULL,
NAME_ROLE VARCHAR2(128 BYTE) NOT NULL,
COMMON VARCHAR(3),
AUTHENTICATION_ROLE VARCHAR2(11),
CONSTRAINT ROLE_PK PRIMARY KEY (ROLE_ID)
);

CREATE TABLE USER_HAS_ROLE(
USER_ID NUMBER  NOT NULL,
ROLE_ID NUMBER NOT NULL,
CONSTRAINT USER_ROLE_PK PRIMARY KEY (USER_ID,ROLE_ID),
CONSTRAINT USER_HAS_ROLE_USER_FOREIGN_KEY FOREIGN KEY (USER_ID) REFERENCES USER_T(USER_ID) ON DELETE CASCADE,
CONSTRAINT USER_HAS_ROLE_ROLE_FOREIGN_KEY FOREIGN KEY (ROLE_ID) REFERENCES ROLE_T(ROLE_ID) ON DELETE CASCADE
);


CREATE TABLE MEMORY_T(
MEMORY_ID NUMBER  NOT NULL,
PGA NUMBER,
DATA_STORAGE NUMBER,
SGA NUMBER,
SHARED_IO_POOL NUMBER,
SHARED_POOL_MEMORY NUMBER,
BUFFER_CACHE_MEMORY NUMBER,
LARGE_POOL NUMBER,
JAVA_POOL NUMBER,
STREAM_POOL NUMBER,
NAME_TABLESPACE VARCHAR2(30 BYTE) NOT NULL,
CONSTRAINT MEMORY_PK PRIMARY KEY (MEMORY_ID),
CONSTRAINT MEMORY_TABLESPACE_FOREIGN_KEY FOREIGN KEY (NAME_TABLESPACE) REFERENCES TABLESPACE_T(NAME_TABLESPACE) ON DELETE CASCADE
);

CREATE TABLE MEMORY_HISTORY(
MEMORY_HISTORY_ID NUMBER  NOT NULL,
TIME_STAMP TIMESTAMP NOT NULL,
MEMORY_ID NUMBER,
PGA NUMBER,
DATA_STORAGE NUMBER,
SGA NUMBER,
SHARED_IO_POOL NUMBER,
SHARED_POOL_MEMORY NUMBER,
BUFFER_CACHE_MEMORY NUMBER,
LARGE_POOL NUMBER,
JAVA_POOL NUMBER,
STREAM_POOL NUMBER,
NAME_TABLESPACE VARCHAR2(30 BYTE) NOT NULL,
CONSTRAINT MEMORY_HISTORY_PK PRIMARY KEY (MEMORY_HISTORY_ID),
CONSTRAINT MEMORY_HISTORY_MEMORY_FOREIGN_KEY FOREIGN KEY (MEMORY_ID) REFERENCES MEMORY_T(MEMORY_ID)ON DELETE SET null
);
