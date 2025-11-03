
# Projet Synapse "Deep Dive" - Formation Contoso

Ce dépôt contient le matériel de formation pour une session avancée sur Azure Synapse Analytics, destinée aux Data Engineers PySpark.

## 🏛️ Structure du Dépôt

-   `/synapse-workspace`: Contient les artefacts Synapse (notebooks) gérés par l'intégration Git.
-   `/py`: Contient le code source Python pur (logique métier), destiné à être packagé en `.whl`.
-   `/sql`: Contient les scripts DDL et les procédures stockées (sprocs) pour le pattern ELT dans le Pool SQL Dédié.

## 🏃 Scénarios de Formation

### Scénario 1 : Refactoriser PySpark (Pattern ETL)

1.  **Objectif :** Transformer la logique PySpark d'un notebook en un module Python réutilisable (`.whl`).
2.  **Code :**
    -   `py/contoso/transformations.py`: La logique métier (ex: `get_enriched_sales`).
    -   `py/setup.py`: Le script pour packager le code.
3.  **Action (Pré-requis) :**
    -   Naviguez vers le dossier `/py`.
    -   Exécutez `python setup.py bdist_wheel`.
    -   Téléversez le fichier `.whl` généré (dans `py/dist/`) dans les "Workspace packages" de votre Pool Spark.
4.  **Exécution :**
    -   Ouvrez et exécutez `synapse-workspace/notebook/1_PySpark_ETL.ipynb`.
    -   Le notebook importera `contoso.transformations` et exécutera la logique centralisée.

### Scénario 2 : Implémenter le Pattern ELT

1.  **Objectif :** Montrer l'alternative au "tout PySpark" en chargeant des données brutes dans le Pool SQL et en les transformant avec T-SQL.
2.  **Code :**
    -   `sql/ddl/create_tables_elt.sql`: Crée les tables de staging (`stg.`) et la table cible (`dbo.`).
    -   `sql/sprocs/sp_Transform_Sales_ELT.sql`: Crée la procédure qui contient la logique de jointure et de transformation.
3.  **Exécution (Pipeline Synapse) :**
    -   **Étape 1 (Manuelle) :** Exécutez les scripts de `sql/ddl/` et `sql/sprocs/` sur votre Pool SQL Dédié pour mettre en place la structure.
    -   **Étape 2 (Pipeline) :** Créez un pipeline `PL_Run_SQL_ELT` qui :
        1.  Copie `FactOnlineSales.csv`, `DimCustomer.csv`, `DimProduct.csv` vers les tables `stg.*` correspondantes.
        2.  Exécute l'activité "Stored Procedure" `dbo.sp_Transform_Sales_ELT`.
