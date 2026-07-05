# CAPSTONE Lab 3 – Corporate_Auditor_Report (Troubleshooting Guide)

### Auditor

*Omari (Zeek) Miller*

---

## Overview
This auditor project was deliberately distributed and contains with syntax errors, logic errors, runtime errors, and data validation problems. 

### Objective: 
- Troubleshoot and run this application with the original conditions & requirements 
- DO NOT completely rewrite the project! 

### Components: 
 - Python programs (3)
 - Bash orchestration script (1)
 - Functional evaluator (1)

---

## Errors That Prevented Execution Before Runtime

These errors prevented the programs from running until they were corrected.

### account_audit.py

* Missing colon after the `elif days >= 30` statement, causing a Python `SyntaxError`.
* The interpreter stopped before executing the remainder of the program.

### add_employee.py

* Missing colon after the `elif not days.isdigit()` statement, producing a Python `SyntaxError`.

These syntax errors had to be repaired before any functional testing could begin.

---

## Errors that permitted actual execution of scripts, but produced unwanted behavior

Several scripts were executed produced incorrect results due to logic or runtime errors (such as audit_menu script allowing for selection, yet every option is invalid).

### account_audit.py

* `line.strip()` was called without assigning the result back to `line`, preventing proper removal of newline characters (i.e. "\n").
* The blank-line detection failed due to newline characters remaining, invalidating the "Status" variable.
* Employee tuple indexes were reversed:

  * Department was retrieved from index 2 (instead of index 1).
  * Days were retrieved from index 1 (instead of index 2).
* Comparing a department string to an integer caused a runtime `TypeError`.
* Malformed records and invalid inactivity values required validation before processing (this can be rectified via the line.strip fix).

### department_summary.py

* Dictionary initialization used the comparison operator (`==`) instead of the assignment operator (`=`).
* New departments were never added correctly to the dictionary.
* The corrected version properly initialized each department count before incrementing it.

### add_employee.py

* Username and department validation incorrectly used the `and` operator instead of validating each field independently (using the "or" operator).
* Employee data was stored as a tuple and passed directly to `file.write()`.
* `file.write()` accepts only strings, resulting in a `TypeError`.
* The employee record needed to be written as a properly formatted CSV string.

### audit_menu.sh

* User input was stored in the variable `choice`, but the `case` statement examined `selection`.
* Option 2 incorrectly executed `account_audit.py` (instead of `department_summary.py`).
* Report archiving did not verify that report files existed before copying them.

---

## The importance of validating external data

Operational automation frequently processes information supplied by a variety of sources (i.e. users, databases, external applications). And each source must be checked for validity/integrity.

Input validation prevents:

* application crashes,
* invalid reports,
* corrupted data files,
* incorrect audit results,
* security issues caused by erroneous input.

During this lab, the supplied employee file intentionally contained malformed records, invalid numeric values, and incorrectly formatted CSV entries. The repaired programs skipped invalid records while continuing to process valid employee information.

---

## Usefulness of Tuples for fixed data records, yet but not as data written directly to a File

Tuples (a convenient way to store a fixed collection of comparable values, particularly during processing).

Example:

* username
* department
* days since last login


On further inspection, the `file.write()` function only accepts a string, while attempting to write a tuple directly produces a `TypeError`.

Solution: Employee information must first be converted into a properly formatted CSV string, before being written to the data file.

---

## The orchestration script (audit_menu.sh) as verification prior to archiving

Automation scripts should always verify that required files exist before attempting operations (such as copying/archiving).

Without validation:

* copy commands can fail,
* error messages may confuse users,
* incomplete archives may be created,
* automated workflows may terminate unexpectedly.

Confirmation of report files' existence prior to archiving, proves reliability in various production environments.

---

## The Lesson...

This troubleshooting exercise established:
- The recognition and differentiation of error types (i.e. syntax, logic, runtime)
- Understanding of proper input verification, CSV processing, Bash menu mapping and Python data structures
- Proper git branching and collaboration practices


