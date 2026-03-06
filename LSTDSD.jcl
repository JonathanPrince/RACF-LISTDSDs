//LSTDSD   JOB (ACCT),'RACF LISTDSD',CLASS=A,MSGCLASS=X,NOTIFY=&SYSUID
//*
//* Batch LISTDSD runner:
//* 1. Point EXEC in SYSTSIN to the fully-qualified REXX member DSN.
//* 2. Point INLIST to a sequential dataset with one DSN/pattern per line.
//* 3. OUTDD is the report dataset created by this job.
//*
//STEP1    EXEC PGM=IKJEFT01,DYNAMNBR=50,REGION=0M
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  *
  EXEC 'YOUR.REXX.EXEC.LIB(LSTRACF)'
/*
//INLIST   DD  DISP=SHR,DSN=YOUR.INPUT.DSN.LIST
//OUTDD    DD  DISP=(NEW,CATLG,DELETE),
//             DSN=YOUR.OUTPUT.LISTDSD.REPORT,
//             SPACE=(CYL,(5,5),RLSE),
//             DCB=(RECFM=VB,LRECL=255,BLKSIZE=0)
