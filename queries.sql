/*Users*/
SELECT USERNAME, ACCOUNT_STATUS, EXPIRY_DATE, CREATED,
        USER_ID, DEFAULT_TABLESPACE
FROM DBA_USERS;

/*Tablespace*/
SELECT TBS.TABLESPACE_NAME,USG.USED_SPACE,USG.USED_PERCENT,TBS.MAX_SIZE,TBS.STATUS,TBS.CONTENTS,DF.FILE_NAME,DF.AUTOEXTENSIBLE,
(TABLESPACE_SIZE - USED_SPACE) AS FREE_SPACE
FROM DBA_TABLESPACE_USAGE_METRICS  USG, DBA_TABLESPACES  TBS, DBA_DATA_FILES  DF
WHERE TBS.TABLESPACE_NAME = USG.TABLESPACE_NAME AND TBS.TABLESPACE_NAME = DF.TABLESPACE_NAME;

/*DataFiles*/
SELECT FILE_NAME, FILE_ID, TABLESPACE_NAME, BYTES, STATUS, AUTOEXTENSIBLE,
USER_BYTES
FROM DBA_DATA_FILES;

/**/