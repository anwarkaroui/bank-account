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




import csv
import sys
import os

TEMPLATE = """UPDATE otc.t_binrange br
SET producttype_id = CASE
  WHEN rv_old.label = 'Visa' THEN rv_cbvisa.id
  WHEN rv_old.label = 'Mastercard' THEN rv_cbmaster.id
  ELSE br.producttype_id
END
FROM otc.t_issuer i,
     otc.t_bank b,
     otc.t_referentialvalue rv_old,
     (SELECT id FROM otc.t_referentialvalue WHERE label = 'CbVisa'   LIMIT 1) rv_cbvisa,
     (SELECT id FROM otc.t_referentialvalue WHERE label = 'CbMaster' LIMIT 1) rv_cbmaster
WHERE br.issuer_id = i.id
  AND b.id = i.externalbankid
  AND rv_old.id = br.producttype_id
  AND b.bankcode = '{bankcode}'
  AND br.bincardtrackstart = '{bincardtrackstart}'
  AND br.bincardtrackend   = '{bincardtrackend}'
  AND rv_old.label IN ('Visa', 'Mastercard');
"""

def main():
    if len(sys.argv) != 2:
        print("Usage: python3 generate_updates.py <chemin_fichier_csv>")
        sys.exit(1)

    input_csv = sys.argv[1]
    if not os.path.isfile(input_csv):
        print("❌ Fichier introuvable :", input_csv)
        sys.exit(1)

    output_sql = os.path.splitext(input_csv)[0] + "_updates.sql"

    with open(input_csv, newline="", encoding="latin-1") as csvfile, \
         open(output_sql, "w", encoding="utf-8") as outfile:

        reader = csv.DictReader(csvfile)

        required_cols = {"codebanque", "debutplagebin", "finPlageBin"}
        if not required_cols.issubset(set(reader.fieldnames or [])):
            print("❌ Colonnes manquantes. Attendu:", required_cols)
            print("📌 Colonnes trouvées:", reader.fieldnames)
            sys.exit(1)

        count = 0
        for row in reader:
            bankcode = (row.get("codebanque") or "").strip()
            start_bin = (row.get("debutplagebin") or "").strip()
            end_bin = (row.get("finPlageBin") or "").strip()

            if not bankcode or not start_bin or not end_bin:
                continue

            sql = TEMPLATE.format(
                bankcode=bankcode.replace("'", "''"),
                bincardtrackstart=start_bin.replace("'", "''"),
                bincardtrackend=end_bin.replace("'", "''")
            )

            outfile.write(sql)
            outfile.write("\n-- ------------------------------------------------------------\n\n")
            count += 1

    print("✅ Fichier généré :", output_sql, "| Requêtes:", count)

if __name__ == "__main__":
    main()