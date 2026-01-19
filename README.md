Bank account kata Think of your personal bank account experience When in doubt, go for the simplest solution Requirements

•            Deposit and Withdrawal

•            Account statement (date, amount, balance)

•            Statement printing


User Stories

•            US 1:

In order to save money

As a bank client

I want to make a deposit in my account

•            US 2:

In order to retrieve some or all of my savings

As a bank client

I want to make a withdrawal from my account

•            US 3:

In order to check my operations

As a bank client

I want to see the history (operation, date, amount, balance) of my operations

import csv

INPUT_CSV = "input.csv"
OUTPUT_SQL = "updates.sql"

TABLE_NAME = "ta_table"      # 🔴 change le nom de la table
NEW_PRODUIT = "cbVISA"
OLD_PRODUIT = "VISA"

def format_bin(value):
    # enlève les espaces et regroupe par 4 chiffres
    digits = "".join(c for c in value if c.isdigit())
    return " ".join(digits[i:i+4] for i in range(0, len(digits), 4))

with open(INPUT_CSV, newline='', encoding='utf-8') as csvfile, \
     open(OUTPUT_SQL, 'w', encoding='utf-8') as outfile:

    reader = csv.DictReader(csvfile)

    for row in reader:
        codebanque = row["codebanque"].strip()
        debut = format_bin(row["debutplagebin"])
        fin = format_bin(row["finPlageBin"])

        sql = (
            "UPDATE {table} "
            "SET produitCard = '{new}' "
            "WHERE CodeBanque = '{code}' "
            "AND debutPlageBin = '{debut}' "
            "AND finPlageBin = '{fin}' "
            "AND produitCard = '{old}';\n"
        ).format(
            table=TABLE_NAME,
            new=NEW_PRODUIT,
            code=codebanque,
            debut=debut,
            fin=fin,
            old=OLD_PRODUIT
        )

        outfile.write(sql)

print("✅ Fichier updates.sql généré avec succès")
