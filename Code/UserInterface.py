import mysql.connector
from mysql.connector import Error
from tabulate import tabulate
from datetime import date



def adminInterface(cur):
    while True:
        print("\nWelcome, Database Administrator!")
        print("Choose an option:")
        print("1. Type and execute an SQL script")
        print("2. Execute SQL script from file")
        print("Q. Quit")

        option = input("Enter your choice (1, 2, or Q): ")

        if option.upper() == 'Q':
            print("Program Exited")
            break

        if option == '1':
            sql_script = input("Enter your SQL script:\n")
        elif option == '2':
            file_path = input("Enter the path of the SQL script file:\n")
            file_name = input("Enter the file name of the SQL script:\n")
            file_full_path = f"{file_path}/{file_name}"
            try:
                with open(file_full_path, 'r') as file:
                    sql_script = file.read()
            except FileNotFoundError:
                print("File not found. Please try again.")
                continue
        else:
            print("Invalid option. Please enter 1, 2, or Q.")
            continue
        
        sqlQueries = sql_script.split(';')

        for query in sqlQueries:

            try:
                if query.strip() != '':
                    cur.execute(query)
                    result = cur.fetchall()
                    # Fetch and print results
                    if result:
                        headers = [desc[0] for desc in cur.description]

                         # Colalign parameter to left-align all columns
                        table = tabulate(result, headers=headers, tablefmt='grid', colalign=('left',) * len(headers))
                        print(table)
                    # Commit the changes
                cnx.commit()
                

            except Error as e:
                print(f"Error executing script: {e}")

                # Revert the changes in case of an error
                cnx.rollback()



def guestInterface(cur):
    print("\nWelcome guest!\n")
    while True:
        print("What information are you looking for?")
        print("1. Exhibitions")
        print("2. Artworks")
        print("3. Artists")

        selection = input("Enter your choice (1, 2, 3, or Q):\n")

        if selection.upper() == 'Q':
                print("Program Exited.")
                break
        if selection == '1':
            exb_info(cur)
        elif selection == '2':
            art_info(cur)
        elif selection == '3':
            artist_info(cur)
        else:
            print("\nInvalid option. Please enter 1, 2, 3, or Q to quit:")


def exb_info(cur):
    while True:
        print("\n")
        print("What exhibitions would you like to view?")
        print("1. Previous Exhibitions")
        print("2. Current Exhibitions")
        print("3. All Exhibitions")

        today = date.today()

        exb = input("Enter your choice:\nTo go back, enter B\n")

        if exb.upper() == 'B':
                break

        if exb == '1':
            instr = "select * from exhibitions where Exb_End_date < %(oid)s"
        elif exb == '2':
            instr = "select * from exhibitions where Exb_End_date > %(oid)s"
        elif exb == '3':
            instr = "select * from exhibitions"
        else:
            print("Invalid option. Please enter 1, 2, 3 or B.")
            continue

        try:
            cur.execute(instr,{'oid':today})
            result = cur.fetchall()
            
            if result:
                table = tabulate(result, headers=['Exhibition Name', "Start", "End"], tablefmt='grid')
                print(table)
                cnx.commit()

        except Error as e:
            print(f"Error executing script: {e}")
            cnx.rollback()
            

def art_info(cur):
    while True:
        print("\n")
        print("What Artworks would you like to view?")
        print("1. Paintings")
        print("2. Sculptures")
        print("3. Statues")
        print("4. Others")

        artwork = input("Enter your choice:\nTo go back, enter B\n")

        if artwork.upper() == 'B':
                break
        
        if artwork == '1':
            table = 1
        elif artwork == '2':
            table = 2
        elif artwork == '3':
            table = 3
        elif artwork == '4':
            table = 4
        else:
            print("Invalid option. Please enter 1, 2, 3 or B.")
            continue
        
        try:
            if table == 1:
                cur.execute("select * from painting")
                result = cur.fetchall()
            elif table == 2:
                cur.execute("select * from sculpture")
                result = cur.fetchall()
            elif table == 3:
                cur.execute("select * from statue")
                result = cur.fetchall()
            elif table == 4:
                cur.execute("select * from other")
                result = cur.fetchall()
            
            if result:
                headers = [desc[0] for desc in cur.description]
                table = tabulate(result, headers=headers, tablefmt='grid')
                print(table)
                cnx.commit()
        except Error as e:
            print(f"Error executing script: {e}")
            cnx.rollback()

def artist_info(cur):
    while True:
        print("\n")
        print("What would you like to view?")
        print("1. All Artists")
        print("2. A specific Artist")

        artist = input("Enter your choice:\nTo go back, enter B\n")

        if artist.upper() == 'B':
                break
        try:
            if artist == '1':
                cur.execute("select ArtistName,DateBorn,Date_died,Country_of_origin as 'Country', Epoch, Main_style from artist")
                result = cur.fetchall()

            elif artist == '2':
                subselection = input("\nEnter the name of the Artist you would like to view, or B to go back: ")
                if subselection.upper() == 'B':
                    break
                instr = "select ArtistName,DateBorn,Date_died,Country_of_origin as 'Country', Epoch, Main_style from artist where ArtistName = (%s)"
                data = (subselection,)
                cur.execute(instr, data)
                result = cur.fetchall()
            else:
                print("Invalid option. Please enter 1, 2 or B.")
                continue

            if result:
                headers = [desc[0] for desc in cur.description]
                table = tabulate(result, headers=headers, tablefmt='grid')
                print(table)
                cnx.commit()
        except Error as e:
            print(f"Error executing script: {e}")
            cnx.rollback()



def displayMenu():
    print('1 - DB Admin')
    print('2 - Browse as guest')
    return

# Determine user role

print('\nWelcome to the artmuseum database!')
print('In order to proceed, please select your role from the list below:\n')
displayMenu()

selection = input("Please type 1 or 2 to select your role: ")

if selection == '1':
    username = input("username: ")
    passcode = input("password: ")
else:
    username = "guest"
    passcode = None

# Connect to database based on user's roles and restrictions
try:
    cnx = mysql.connector.connect(
            host="127.0.0.1",
            port=3306,
            user=username,
            password=passcode
        )

    # Get a cursor
    cur = cnx.cursor()

    # Execute a query
    cur.execute("USE artmuseum")

    if selection == '1':
        print("\n")
        adminInterface(cur)  # Call the admin interface function for DB Admins
    elif selection == '2':
        print("\n")
        guestInterface(cur)
    else:
        print("Invalid option. Program Terminated.")
except Error as e:
    print(f"Error connecting to MySQL: {e}")



# Close connection
finally:
    if 'cur' in locals() and cur is not None:
        cur.close()
    if 'cnx' in locals() and cnx is not None:
        cnx.close()