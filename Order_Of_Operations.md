# This is the Order of Operations:

## 1. Syntax (Checking files & permissions precedes this step)
### 1.1:
- "pwd"
- "cd /path/to/CAPSTONE_Lab3/zeek"
- "find . -maxdepth 2 -type f | sort"
- "chmod +x audit_menu.sh evaluate_lab.sh"

<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/1.1-Permissions.png" height="400" width="600" title="hover text">
</p>
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/1.2-Versioning_Syntax-error.png" width="600" title="hover text">
</p>
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/1.3-py_files_direct-syntax.png" width="600" title="hover text">
</p>

### 1.2:
- "bash -n audit_menu.sh"

- "python -m py_compile scripts/account_audit.py"
- "python -m py_compile scripts/department_summary.py"
- "python -m py_compile scripts/add_employee.py"
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/1.4-py_files_compile-syntax.png" width="600" title="hover text">
</p>

  (**Fix anything that stops the files from running at all!!**)
  
## 2. Fix up "Menu"
Confirm:
- "3" --> runs add_employee.py
- "1" --> runs account_audit.py > reports/account_report.txt
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/2.2-audit_menu_3%2B1_option.png" width="600" title="hover text">
</p>

- "2" --> runs department_summary.py > reports/department_report.txt
- "4" --> copies reports/*.txt to archive/
- "5" --> exits cleanly

<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/2.3-audit_menu_2%2B4%2B5_option.png" width="600" title="hover text">
</p>

  (**Do NOT finalize the Python files yet...First make sure the menu dispatch works!!**)
  
  - Example of non-functioning .py scripts:
  <p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/2.1-audit_menu_broken.png" width="600" title="hover text">
</p>
  
  
## 3. Account Audit
Points of interest:
- reading data/employees.txt
- skipping blank lines
- skipping malformed lines
- skipping non-numeric days
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/3.1-employees_txt_roster.png" width="600" title="hover text">
</p>

Classify:
- 0-29 --> ACTIVE
- 30-89 --> REVIEW
- 90+ --> DISABLE
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/3.3-account_audit-account_report-result.png" width="600" title="hover text">
</p>

Test out this file:
- "python scripts/account_audit.py"
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/3.2-account_audit_result.png" width="600" title="hover text">
</p>
  
## 4. Department Summary

Points of interest:
- only counting valid records
- printing department counts
- skipping malformed lines
- skipping non-numeric days

Test out this file:
- "python scripts/department_summary.py"
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/4.1-department_summary-result.png" width="600" title="hover text">
</p>

## 5. Add Employee
Points of interest (validation):
- blank username = reject
- blank department = reject
- non-numeric days = reject
- valid record = append one line

  (**Test invalid input first, THEN valid input!!**)
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/add_employee_result.png" width="600" title="hover text">
</p>
  
## 6. Test flow & Archive 
- "./audit_menu.sh" (Run this script!)

Enter the following selections (in order):
- "1"
- "2"
- "4"
- "5"

^ Refer to section 2 for flow testing 

Next, check these parameters:
- "ls -al reports"
- "ls -al archive"
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/6.1-list_archive.png" width="600" title="hover text">
</p>

- "cat reports/account_report.txt"
- "cat reports/department_report.txt"
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/cat_reports-account-dept.png" width="600" title="hover text">
</p>

## 7. Evaluation (Moment of Truth)
- "./evaluate_lab.sh" (Run this script!)

### Expectation:
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/7.1-evaluation_successful.png" width="600" title="hover text">
</p>

- "Results: 15 passed, 0 failed."
- "Lab evaluation passed."

### Troublesome error #1: 
- line.strip() was called without assigning the result back to line, preventing proper removal of newline characters and proper classification via the "Status" variable within this project.
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/7.3-Fail_update.png" width="600" title="hover text">
</p>

### Troublesome error #2: 
- In the evaluate_lab bash script, "python3" used to initiate python scripts, instead of "python" (resulting in a syntax error) on a Windows OS.
<p align="center">
  <img src="https://github.com/ChuckKeyes/CAPSTONE_Lab3/blob/main/zeek/Audit_Evidence/7.2-Fail_tyme.png" width="500" title="hover text">
</p>
