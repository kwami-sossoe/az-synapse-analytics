from pyspark.sql import DataFrame
from pyspark.sql.functions import col, concat, lit


def get_enriched_sales(
        df_factSales: DataFrame,
        df_dim_product: DataFrame,
        df_dim_customer: DataFrame
) -> DataFrame:
    """
    Applique la logique de jointure principale du notebook Contoso.
    J joint les ventes aux produits et aux clients, puis sélectionne
    les colonnes pertinentes pour l'analyse.

    Args:
        df_factSales: DataFrame des faits de vente.
        df_dim_product: DataFrame de la dimension produit.
        df_dim_customer: DataFrame de la dimension client.

    Returns:
        DataFrame enrichi avec les informations client et produit.
    """

    print("--- [Module contoso.transform] Démarrage de l'enrichissement ---")

    if not df_factSales or not df_dim_product or not df_dim_customer:
        raise ValueError("Les DataFrames d'entrée ne peuvent pas être None.")

    # Application de la logique de jointure
    full_sales = df_factSales \
        .join(df_dim_product, on="ProductKey", how="inner") \
        .join(df_dim_customer, on="CustomerKey", how="inner") \
        .select(
        "OnlineSalesKey",
        col("FirstName"),
        col("LastName"),
        concat(col("FirstName"), lit(" "), col("LastName")).alias("FullCustomerName"),
        col("ProductName"),
        col("SalesAmount"),
        col("TotalCost")
    )

    print(f"--- [Module contoso.transform] Enrichissement terminé. ---")
    return full_sales
