# Purposefully broken: troubleshoot this file.
# Business requirement:
#   Read employee data, ignore malformed records, and classify accounts:
#   ACTIVE  = fewer than 30 inactive days
#   REVIEW  = 30 through 89 inactive days
#   DISABLE = 90 or more inactive days

employees = []
input_file = "data/employees.txt"

with open(input_file, "r") as file:
    for line in file:
                       # Corrected: Assign the stripped string back to the variable 
                       # "line.strip()" changed to "line = line.strip()" 
        line = line.strip()

        if line == "":      # Now this parameter will catch empty lines
            continue

        parts = line.split(",")

        if len(parts) != 3:
            print(f"Skipping malformed record: {line}")
            continue

        username = parts[0]
        department = parts[1]
        days = parts[2]
        

        if not days.isdigit():
            print(f"Skipping invalid inactivity value: {line}")
            continue

        days = int(days)

        employee_record = (username, department, days)
        employees.append(employee_record)

print("********************************** ACCOUNT AUDIT REPORT ")
print("====================")

for employee in employees:
    username = employee[0]
    department = employee[1]                # Corrected error: original code was "department = employee[2]" (should be employee[1])
    days = employee[2]                      # Corrected error: original code was "days = employee[1]" (should be employee[2])

    if days >= 90:
        status = "DISABLE"
    elif days >= 30:               # Corrected: original code was "elif days >= 30" (missing :)
        status = "REVIEW"
    else:
        status = "ACTIVE"

    print(f"{username} | {department} | {days} days | {status}")