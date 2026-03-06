/* REXX */
Address TSO

/* Read input list from DD:INLIST */
"EXECIO * DISKR INLIST (STEM IN. FINIS"
if rc <> 0 then do
  say 'ERROR: cannot read DD INLIST, RC='rc
  exit 12
end

do i = 1 to IN.0
  dsn = strip(IN.i)

  /* Skip blanks and simple comments */
  if dsn = '' then iterate
  if left(dsn,1) = '*' then iterate

  /* Optional quoted input handling */
  if left(dsn,1) = "'" & right(dsn,1) = "'" then
    dsn = substr(dsn,2,length(dsn)-2)

  hdr.1 = '============================================================'
  hdr.2 = 'LISTDSD DA('''dsn''') ALL GENERIC'
  hdr.3 = '============================================================'
  "EXECIO 3 DISKW OUTDD (STEM hdr."

  /* Trap LISTDSD output so we can write a clean report dataset */
  "OUTTRAP cmd."
  "LISTDSD DA('"dsn"') ALL GENERIC"
  lrc = rc
  "OUTTRAP OFF"

  if symbol('cmd.0') = 'VAR' & cmd.0 > 0 then
    "EXECIO" cmd.0 "DISKW OUTDD (STEM cmd."

  tail.1 = '---- COMMAND_RC='lrc
  tail.2 = ' '
  "EXECIO 2 DISKW OUTDD (STEM tail."
end

"EXECIO 0 DISKW OUTDD (FINIS"
exit 0
