# Purposefully broken: troubleshoot this file.
# Business requirement:
#   Prompt for username, department, and days since last login.
#   Reject blank username or department and non-numeric days.
#   Append one correctly formatted CSV line for valid input.

username = input("Username: ")
department = input("Department: ")
days = input("Days since last login: ")

if username == "" or department == "":          # Corrected: original code was "if username == "" and department == "":" (should be "or")
    print("Username and department must not be blank.")

elif not days.isdigit():                         # Corrected: original code was "elif days.isdigit():" (should be not)
    print("Days since last login must be a whole number.")

else:
    new_employee = (username, department, days)

    with open("data/employees.txt", "a") as file:
        file.write(f"{new_employee[0]},{new_employee[1]},{new_employee[2]}\n")         # Wrong data type

    print(f"Employee {username} added successfully. ****************")