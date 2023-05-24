import pandas as pd
import openpyxl
import psycopg2
import re
import decimal




nullCounter = 0


def read_fund_data(excel_file):
    df = pd.read_excel(excel_file, engine='openpyxl')

    fund_name_variations = df.iloc[:, 0].tolist() if df.shape[1] > 0 else []
    fund_names = df.iloc[:, 1].tolist() if df.shape[1] > 1 else []

    fund_data = {}
    for fund_name_variation, fund_name in zip(fund_name_variations, fund_names):
        if fund_name not in fund_data:
            fund_data[fund_name] = []
        fund_data[fund_name].append(fund_name_variation)

    return fund_data


def read_corrected_attribute_names(excel_file):
    df = pd.read_excel(excel_file, engine='openpyxl')
    
    original_attribute_names = df.iloc[:, 1].tolist()
    corrected_attribute_names = df.iloc[:, 2].tolist()
    
    corrected_dict = {original: corrected for original, corrected in zip(original_attribute_names, corrected_attribute_names)}
    
    return corrected_dict

def read_subfund_names(excel_file):
    # Read the Excel file with original and corrected subfund names
    df = pd.read_excel(excel_file, engine='openpyxl')
    
    original_subfund_names = df.iloc[:, 0].tolist()
    corrected_subfund_names = df.iloc[:, 1].tolist()
    
    names_dict = {original: corrected for original, corrected in zip(original_subfund_names, corrected_subfund_names)}
    
    return names_dict



def get_or_create_subfund_id(subfund_name, fund_id, names_dict, subfund_type=None):
    # Update the subfund_name based on the names from the Excel file
    updated_subfund_name = names_dict.get(subfund_name)

    if subfund_type is None:
        updated_subfund_name = "Samtrygging"
        subfund_type = "Samtrygging"
    
    if updated_subfund_name is None:
        raise ValueError(f"No matching name found for subfund '{subfund_name}'")
    subfund_name = updated_subfund_name

    cursor.execute("SELECT subfund_id FROM subfund WHERE subfund_name = %s AND fund_id = %s", (subfund_name, fund_id))
    subfund_id = cursor.fetchone()
    
    if subfund_id:
        return subfund_id[0]
    else:
        cursor.execute("INSERT INTO subfund (subfund_name, fund_id, subfund_type) VALUES (%s, %s, %s) RETURNING subfund_id", (subfund_name, fund_id, subfund_type))
        new_subfund_id = cursor.fetchone()[0]
        conn.commit()
        return new_subfund_id

########### MAIN ###########


database = "Symmetria"
user = "postgres"
password = "kukur123"
host = "localhost"

# Connect to the database
conn = psycopg2.connect(database=database, user=user, password=password, host=host)
cursor = conn.cursor()


# read the excel file with fund data
fund_data_excel_file = '/users/matthias/Desktop/pensionDB/mapping/unique_funds.xlsx'

fund_data = read_fund_data(fund_data_excel_file)
print(fund_data)
for fund_name, variations in fund_data.items():
    variations_string = '|'.join([re.escape(variation) for variation in variations])
    insert_stmt = "INSERT INTO fund (fund_name, regex_keyword) VALUES (%s, %s)"
    cursor.execute(insert_stmt, (fund_name, variations_string))
    conn.commit()

years = ["2021","2020","2019","2018","2017","2016","2015","2014","2013","2012","2011","2010","2009","2008","2007","2006","2005","2004","2003","2002","2001","2000","1999","1998","1997"]


corrected_attribute_names_excel_file = '/users/matthias/Desktop/pensionDB/mapping/unique_attribute_values.xlsx'


corrected_attribute_names_dict = read_corrected_attribute_names(corrected_attribute_names_excel_file)

subfund_names_excel_file = '/users/matthias/Desktop/pensionDB/mapping/unique_subfundsV3.xlsx'
names_dict = read_subfund_names(subfund_names_excel_file)

for year in years:
    print(year)

    excel_file = '/users/matthias/Desktop/pensionDB/data/Arsreikningar-lifeyrissjoda_'+year+'.xlsx'



    # Check if the year is "2021matticopy" - an old fix i want to keep in even though it is useless
    if year == "2021matticopy":
        sheet_names = ['funddata sam', 'funddata ser', 'funddata hluti 3']
    else:
        year_int = int(year)
        if year_int <= 2008:
            sheet_names = ['funddata sam', 'funddata ser']
        else:
            sheet_names = ['funddata sam', 'funddata ser', 'funddata hluti 3']

    for sheet_name in sheet_names:
        # Read the Excel file
        df = pd.read_excel(excel_file, sheet_name=sheet_name, engine='openpyxl')

        #print(df)

        # this is a sort of dict, since we know stuff in 0 in each list is interconnected
        funds = df.columns[5:].tolist()

        subfunds = df.iloc[0, 5:].tolist()

        attributes = df.iloc[2:, 0:4].values.tolist()

        values = df.iloc[2:, 5:].values.tolist()


        # Printing the extracted data
        #print("Funds:", funds)
        #print("Subfunds:", subfunds)
        #print("Attributes", attributes)
        #print("Values", values)


        cursor.execute("SELECT fund_id, regex_keyword FROM fund")
        result = cursor.fetchall()


        fund_id_dict = {row[1]: row[0] for row in result}
        print(fund_id_dict)

        fund_ids = []

        for fund_name in funds:
            print("INPUT",fund_name)
            fund_id = None
            for regex_keyword, id in fund_id_dict.items():
                if re.search(regex_keyword, fund_name):
                    fund_id = id
                    break

            if fund_id is None:
                print(f"No regex keyword found for fund '{fund_name}'")
                raise ValueError(f"No regex keyword found for fund '{fund_name}'")

            else:
                print("OUTPUT",fund_name)
                fund_ids.append(fund_id)

        #print(fund_ids)
        subfund_ids = []

        for i, subfund_name in enumerate(subfunds):
            if sheet_name == "funddata sam":
                subfund_type = "Samtrygging"
            elif sheet_name == "funddata ser":
                subfund_type = "Séreign"
            else:  # for "funddata hluti 3" or any other sheet
                subfund_type = None


            subfund_id = get_or_create_subfund_id(subfund_name, fund_ids[i], names_dict, subfund_type)
            subfund_ids.append(subfund_id)

        #print(subfund_ids)

        date = df.columns[1]  # Assuming the date is in the second column of the first row


        # Insert the data into the database

        for i, subfund_id in enumerate(subfund_ids):
            for j, attribute in enumerate(attributes):
                value = values[j][i]
                #print(year)
                #print(type(value))

                #print(value)
                #print(sheet_name)

                if value == '' or pd.isna(value):
                    #print(value)
                    value = None
                    nullCounter += 1
                elif isinstance(value, str):
                    # if value includes %, remove it and divide by 100
                    if '%' in value:
                        value = value.replace(',', '.').replace('*', '').replace('%','')
                        value = float(value)/100
                    else:
                        value = value.replace(',', '.').replace('*', '').replace('%','')



                    try:
                        value = float(value)
                    except ValueError:
                        pass
                if value == '':
                    #print(value)
                    value = None
                    nullCounter += 1
                if value == '-':
                    #print(value)
                    value = None
                    nullCounter += 1

                if pd.notnull(value) and value != None and value != "NULL":  # Only insert if the value is not NaN
                    # Replace this block of code inside the loop
                    cattribute1, cattribute2, cattribute3, cattribute4 = attribute
                    attribute1 = corrected_attribute_names_dict.get(cattribute1, cattribute1)
                    attribute2 = corrected_attribute_names_dict.get(cattribute2, cattribute2)
                    attribute3 = corrected_attribute_names_dict.get(cattribute3, cattribute3)
                    attribute4 = corrected_attribute_names_dict.get(cattribute4, cattribute4)

                    if year != "2021matticopy":
                        if int(year) <= 2005 and attribute1 == "Kennitölur" and attribute2 == "Hrein raunávöxtun (%)" or attribute2 == "Meðalraunávöxtun s.l. 5 ára (%)":
                            value = value
                        elif int(year) > 2005 and attribute1 == "Kennitölur" and attribute2 == "Hrein raunávöxtun (%)" or attribute2 == "Meðalraunávöxtun s.l. 5 ára (%)":
                            value = value/100
                    
                    cursor.execute(
                        "INSERT INTO funddata (value, fund_id, subfund_id, attribute1, attribute2, attribute3, attribute4, date) "
                        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
                        (value, fund_ids[i], subfund_id, attribute1, attribute2, attribute3, attribute4, date)
                    )
        conn.commit()




# Close the cursor and the connection
conn.commit()
cursor.close()
conn.close()

print(nullCounter,"plis vera 4000 og ehv")




