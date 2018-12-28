import cx_Oracle
import time
import datetime

sys = cx_Oracle.connect(
    'sys/oracle@localhost:1521/orcl', mode=cx_Oracle.SYSDBA)
cur = sys.cursor()

jjnm = cx_Oracle.connect('jjnm/oracle@localhost:1521/orcl')
curI = jjnm.cursor()

#-------USERS-------#
users_del = """DELETE FROM USER_T"""
curI.execute(users_del)

users_ST = """
        SELECT USERNAME, ACCOUNT_STATUS, EXPIRY_DATE, CREATED,
        USER_ID, DEFAULT_TABLESPACE
        FROM DBA_USERS"""

res = cur.execute(users_ST)

for row in res:
    if row[2] is not None:
        ed =  row[2].strftime('%d.%m.%Y')
        query1 = """INSERT INTO USER_T(
        USER_ID,USERNAME,EXPIRATION_DATE,
        STATUS,CREATED_DATE)
        VALUES ('%d','%s',TO_DATE('%s','dd.mm.yyyy'),'%s',TO_DATE('%s','dd.mm.yyyy')) """ % (int(row[4]), row[0], ed, row[1], row[3].strftime('%d.%m.%Y'))
        curI.execute(query1)
    else:
        ed = 'null'
        query2 = """INSERT INTO USER_T(
        USER_ID,USERNAME,EXPIRATION_DATE,
        STATUS,CREATED_DATE)
        VALUES ('%d','%s',TO_DATE(%s,'dd.mm.yyyy'),'%s',TO_DATE('%s','dd.mm.yyyy')) """ % (int(row[4]), row[0],ed, row[1], row[3].strftime('%d.%m.%Y'))
        curI.execute(query2)
    jjnm.commit()


#--------ROLES--------#
roles_del = """DELETE FROM ROLE_T"""
curI.execute(roles_del)

roles_ST = """SELECT RLS.ROLE, RLS.ROLE_ID, RLS.AUTHENTICATION_TYPE, RLS.COMMON
                FROM DBA_ROLES RLS"""

res = cur.execute(roles_ST)

for row in res:
    query = """INSERT INTO ROLE_T(
                ROLE_ID,NAME_ROLE,COMMON,
                AUTHENTICATION_ROLE)
                VALUES('%d','%s','%s','%s')""" % (int(row[1]), row[0], row[3], row[2])
    curI.execute(query)
    jjnm.commit()

#---------TABLESPACES---------#
tab_del = """DELETE FROM TABLESPACE_T"""
curI.execute(tab_del)

tablespace_ST = """
                SELECT TBS.TABLESPACE_NAME,USG.USED_PERCENT,TBS.MAX_SIZE,TBS.STATUS,TBS.CONTENTS,DF.FILE_NAME,DF.AUTOEXTENSIBLE,
                USG.TABLESPACE_SIZE,(TABLESPACE_SIZE - USED_SPACE) AS FREE_SPACE
                FROM DBA_TABLESPACE_USAGE_METRICS  USG, DBA_TABLESPACES  TBS, DBA_DATA_FILES  DF
                WHERE TBS.TABLESPACE_NAME = USG.TABLESPACE_NAME AND TBS.TABLESPACE_NAME = DF.TABLESPACE_NAME
                """
res = cur.execute(tablespace_ST)

for row in res:
    query = """INSERT INTO TABLESPACE_T(
                NAME_TABLESPACE,SIZE_TABLESPACE,FREE_SPACE,
                USED,TYPE_TABLESPACE,DIRECTORY_TABLESPACE,
                AUTO_EXTEND,MAX_SIZE,STATUS)
                VALUES('%s','%d','%d','%d','%s','%s','%s','%d','%s')""" % (row[0],row[7], row[8], row[1],row[4], row[5],row[6],row[2],row[3])
    curI.execute(query)
    jjnm.commit()

#--------TABLESPACES_USERS---------#
tabus_del = """DELETE FROM TABLESPACE_USER"""
curI.execute(tabus_del)

tabl_user_ST = """
        SELECT TBS.TABLESPACE_NAME,US.USER_ID
        FROM DBA_TABLESPACES  TBS, DBA_USERS US
        """
res = cur.execute(tabl_user_ST)

for row in res:
        existeUser = """
                SELECT USER_ID FROM USER_T
                WHERE USER_ID = '%d' """ % row[1]
        ex = curI.execute(existeUser)
        c = ex.fetchall()
        existTable = """
                SELECT NAME_TABLESPACE FROM TABLESPACE_T
                WHERE NAME_TABLESPACE = '%s' """ % row[0]
        ex2 = curI.execute(existTable)

        query = """INSERT INTO TABLESPACE_USER(
                NAME_TABLESPACE,USER_ID)
                VALUES('%s','%d')""" % (row[0],row[1])
        
        if (len(c)>0 and len(ex2.fetchall())>0):
                curI.execute(query)
                jjnm.commit()
#----------DATAFILES--------#
data_del = """DELETE FROM DATAFILE_T"""
curI.execute(data_del)

datafiles_ST = """
        SELECT FILE_NAME, FILE_ID, TABLESPACE_NAME, BYTES, STATUS, AUTOEXTENSIBLE,
        USER_BYTES
        FROM DBA_DATA_FILES   
        """

res = cur.execute(datafiles_ST)

for row in res:
        query = """INSERT INTO DATAFILE_T(
                DATAFILE_ID,NAME_DATAFILE,USER_BYTES,AUTOEXTENSIBLE,
                STATUS,BYTES,NAME_TABLESPACE)
                VALUES('%d','%s','%d','%s','%s','%d','%s')""" % (row[1],row[0],row[6],row[5],row[4],row[3],row[2])
        existe = """
                SELECT NAME_TABLESPACE FROM TABLESPACE_T
                where NAME_TABLESPACE = '%s' """ % row[2]

        ex = curI.execute(existe)
        
        if len(ex.fetchall())>0:
                curI.execute(query)
                jjnm.commit()

#---------SESSIONS----------#
sessions_del = """DELETE FROM SESSIONS"""
curI.execute(sessions_del)

sessions_ST = """
        SELECT SECONDS_IN_WAIT
        FROM V_$SESSION;

        SELECT
        s.username,
        t.sid,
        s.serial#,
        s.seconds_in_wait,
        SUM(VALUE/100) as "cpu usage (seconds)"
        FROM
        v$session s,
        v$sesstat t,
        v$statname n
        WHERE
        t.STATISTIC# = n.STATISTIC#
        AND
        NAME like '%CPU used by this session%'
        AND
        t.SID = s.SID
        AND
        s.status='ACTIVE'
        AND
        s.username is not null
        GROUP BY username,t.sid,s.serial#,s.seconds_in_wait
        """

#res = cur.execute(sessions_ST)

for row in res:
        query = """INSERT INTO SESSIONS(
                SESSIONS_ID,CPU,WAIT_SESSIONS,USER_ID)
                VALUES('%d','%s','%d','%s','%s','%d','%s')""" % (row[1],row[0],row[6],row[5],row[4],row[3],row[2])
        #curI.execute(query)
        #jjnm.commit()

cur.close()
curI.close()
