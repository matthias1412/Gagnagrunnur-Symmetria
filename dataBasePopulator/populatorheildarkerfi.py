import pandas as pd
import openpyxl
import psycopg2
import re
import decimal
from datetime import datetime





nullCounter = 0

def read_dates(excel_file):
    # Read the Excel file with original and corrected subfund names
    df = pd.read_excel(excel_file, engine='openpyxl')
    
    original_subfund_names = df.iloc[:, 0].tolist()
    corrected_subfund_names = df.iloc[:, 1].tolist()
    
    names_dict = {original: corrected for original, corrected in zip(original_subfund_names, corrected_subfund_names)}
    
    return names_dict

########### MAIN ###########


database = "Symmetria"
user = "postgres"
password = "kukur123"
host = "localhost"

# Connect to the database
conn = psycopg2.connect(database=database, user=user, password=password, host=host)
cursor = conn.cursor()



insert_stmt = "INSERT INTO fund (fund_name, regex_keyword) VALUES (%s, %s)"
cursor.execute(insert_stmt, ('Heildarkerfi', 'Heildarkerfi'))
conn.commit()


# Fetch the fund_id of the fund with name 'Heildarkerfi'
cursor.execute("SELECT fund_id FROM fund WHERE fund_name = %s", ('Heildarkerfi',))
result = cursor.fetchone()

if result:
    fund_id = result[0]
    print("Fund ID of 'Heildarkerfi':", fund_id)
else:
    print("Fund 'Heildarkerfi' not found.")


cursor.execute("INSERT INTO subfund (subfund_name, fund_id) VALUES (%s, %s) RETURNING subfund_id", ('Samtrygging', fund_id))
new_subfund_id_SAM = cursor.fetchone()[0]
conn.commit()

cursor.execute("INSERT INTO subfund (subfund_name, fund_id) VALUES (%s, %s) RETURNING subfund_id", ('Séreign', fund_id))
new_subfund_id_SER = cursor.fetchone()[0]
conn.commit()

cursor.execute("INSERT INTO subfund (subfund_name, fund_id) VALUES (%s, %s) RETURNING subfund_id", ('Samtals', fund_id))
new_subfund_id_SAMTALS = cursor.fetchone()[0]
conn.commit()


excel_file = '/users/matthias/Desktop/pensionDB/data/Heildarkerfi.xlsx'

sheet_names = ['Timaradir_SAM','Timaradir_SER','Timaradir_SAMTALS']


for sheet_name in sheet_names:
    # Read the Excel file
    df = pd.read_excel(excel_file, sheet_name=sheet_name, engine='openpyxl')

    #print(df)

    # this is a sort of dict, since we know stuff in 0 in each list is interconnected
    funds = df.columns[5:].tolist()

    dates = df.iloc[0, 5:].tolist()

    attributes = df.iloc[2:, 0:5].values.tolist()

    values = df.iloc[2:, 5:].values.tolist()


    # Printing the extracted data
    #print("Funds:", funds)
    #print("Subfunds:", dates)
    #print("Attributes", attributes)
    #print("Values", values)



    fund_ids = []
    subfund_ids = []


    for fund_name in funds:
        fund_ids.append(fund_id)

        if sheet_name == 'Timaradir_SAM':
            subfund_ids.append(new_subfund_id_SAM)
        elif sheet_name == 'Timaradir_SER':
            subfund_ids.append(new_subfund_id_SER)
        else:
            subfund_ids.append(new_subfund_id_SAMTALS)




    # Insert the data into the database

    for i, subfund_id in enumerate(subfund_ids):
        for j, attribute in enumerate(attributes):
            value = values[j][i]
            date = dates[i]
            #print(year)
            #print(type(value))

            #print(value)
            #print(sheet_name)

            if value == 'NULL':
                value = None
                nullCounter += 1

            if pd.notnull(value) and value != None and value != "NULL":  # Only insert if the value is not NaN
                attribute1, attribute2, attribute3, attribute4, attribute5 = [attr.strip() if isinstance(attr, str) else attr for attr in attribute]





                cursor.execute(
                    "INSERT INTO funddata (value, fund_id, subfund_id, attribute1, attribute2, attribute3, attribute4, attribute5, date) "
                    "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
                    (value, fund_ids[i], subfund_id, attribute1, attribute2, attribute3, attribute4, attribute5, date)
                )
    conn.commit()




# Close the cursor and the connection
conn.commit()
cursor.close()
conn.close()

print(nullCounter,"plis vera 4000 og ehv")


