/* REXX */
Address TSO

/* Read all dataset names from DD:INLIST into the 'IN.' stem */
"EXECIO * DISKR INLIST (STEM IN. FINIS" 

do i = 1 to IN.0
  dsn = strip(IN.i) 
  if dsn = '' then iterate

  say '------------------------------------------------------------'
  say 'Processing: ' dsn
  
  /* Trap the LISTDSD output so it actually goes to your report */
  x = outtrap("TRAP.")
  "LISTDSD DA('"dsn"') ALL GENERIC"
  x = outtrap("OFF")

  /* Write the trapped RACF details to SYSTSPRT */
  do j = 1 to TRAP.0
    say TRAP.j
  end
end

exit 0