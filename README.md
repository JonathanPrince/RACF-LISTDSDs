# RACF LISTDSD Batch Runner

This repository contains a basic batch pattern for running RACF `LISTDSD` for many dataset names/patterns on z/OS.

## Files

- `LSTDSD.jcl`: JCL that runs `IKJEFT01` and invokes the REXX exec.
- `LSTRACF.rexx`: REXX exec that reads input DSNs and runs:
  - `LISTDSD DA('<dsn>') ALL GENERIC`
- `DSNLIST.txt`: Example input list format (one dataset or pattern per line).

## How It Works

1. `IKJEFT01` starts a TSO batch environment.
2. `EXEC 'YOUR.REXX.EXEC.LIB(LSTRACF)'` is called from `SYSTSIN`.
3. `LSTRACF` reads `DD INLIST`.
4. For each entry, it runs `LISTDSD`.
5. Output is trapped with `OUTTRAP` and written with `SAY` to `DD SYSTSPRT`.

## Prerequisites

- RACF command authority to run `LISTDSD` for target profiles.
- A REXX library (PDS/PDSE) containing member `LSTRACF`.
- Input dataset allocated and referenced by `INLIST`.

## Setup

Update these DSNs in `LSTDSD.jcl`:

- `SYSTSIN` command: `EXEC 'YOUR.REXX.EXEC.LIB(LSTRACF)'`
- `INLIST DD DSN=YOUR.INPUT.DSN.LIST`
- `SYSTSPRT DD DSN=YOUR.OUTPUT.LISTDSD.REPORT`

Copy the REXX source into your exec library as member `LSTRACF`, and reference that fully-qualified member DSN in `SYSTSIN`.

## Input Format

`INLIST` should contain one value per line, for example:

```txt
HLQ.APP.FILE1
HLQ.APP.**
SYS1.PARMLIB
```

Notes:
- Blank lines are ignored.
- Comment lines are not currently handled specially.
- Optional surrounding single quotes are not currently removed.

## Run

Submit `LSTDSD.jcl` after updating DSNs.

## Output

- Primary report and runtime messages: `SYSTSPRT` dataset (`YOUR.OUTPUT.LISTDSD.REPORT`).
