import csv
import sys
import os

TABLE_NAME = "ta_table"      # 🔴 à modifier
NEW_PRODUIT = "cbVISA"
OLD_PRODUIT = "VISA"

def format_bin(value):
    digits = "".join(c for c in value if c.isdigit())
    return " ".join(digits[i:i+4] for i in range(0, len(digits), 4))

def main():
    if len(sys.argv) != 2:
        print("Usage: python generate_updates.py <chemin_fichier_csv>")
        sys.exit(1)

    input_csv = sys.argv[1]

    if not os.path.isfile(input_csv):
        print("❌ Fichier introuvable :", input_csv)
        sys.exit(1)

    output_sql = os.path.splitext(input_csv)[0] + "_updates.sql"

    with open(input_csv, newline='', encoding='utf-8') as csvfile, \
         open(output_sql, 'w', encoding='utf-8') as outfile:

        reader = csv.DictReader(csvfile)

        required_cols = {"codebanque", "debutplagebin", "finPlageBin"}
        if not required_cols.issubset(reader.fieldnames):
            print("❌ Colonnes requises manquantes :", required_cols)
            sys.exit(1)

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

    print("✅ Fichier généré :", output_sql)

if __name__ == "__main__":
    main()