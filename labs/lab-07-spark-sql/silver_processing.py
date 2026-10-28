from pyspark.sql import SparkSession
from pyspark.sql.functions import col, lower, trim, lit

def main():
    # 1. Initialiser la SparkSession (orientée DataFrames / SQL)
    spark = SparkSession.builder \
        .appName("Lab 7 - Spark SQL and DataFrames Silver") \
        .master("local[*]") \
        .getOrCreate()

    print("--- 1. Session Spark initialisée avec succès ---")

    # 2. Simulation ou chargement de données (par exemple depuis vos fichiers CSV ou S3)
    # Vous pouvez adapter le chemin vers vos fichiers de données (ex: s3://...) ou utiliser un DataFrame de test
    data = [
        ("1", "Alice ", "ALICE@EXAMPLE.COM"),
        ("2", "Bob", "BOB.TEST@EXAMPLE.ORG"),
        ("3", " Charlie", "charlie@example.com")
    ]
    columns = ["id", "username", "email"]

    df_raw = spark.createDataFrame(data, columns)
    
    print("\n--- 2. Données brutes (Bronze) ---")
    df_raw.show()

    # 3. Transformations de nettoyage (Couche Silver) :
    # - Cast des types
    # - Nettoyage des espaces (trim) et mise en minuscules (lower)
    df_silver = df_raw \
        .withColumn("user_id", col("id").cast("integer")) \
        .withColumn("username", trim(col("username"))) \
        .withColumn("email", lower(trim(col("email")))) \
        .drop("id") # Supprimer l'ancienne colonne id

    print("\n--- 3. Données nettoyées (Couche Silver) ---")
    df_silver.show()

    # 4. Utilisation de Spark SQL (Création d'une vue temporaire)
    df_silver.createOrReplaceTempView("users_silver")

    print("\n--- 4. Requête Spark SQL ---")
    df_sql_result = spark.sql("""
        SELECT user_id, username, email 
        FROM users_silver 
        WHERE email LIKE '%@example.com'
        ORDER BY user_id DESC
    """)
    df_sql_result.show()

    # Stopper proprement la session Spark
    spark.stop()

if __name__ == "__main__":
    main()