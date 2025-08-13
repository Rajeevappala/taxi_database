# 🚖 Taxi Project Database (taxi_project_DB)

## 📌 Project Overview
The **Taxi Project Database** demonstrates the process of transforming large, raw taxi trip datasets into a **structured, normalized relational database** using **SQL Server**.  

Starting from the original **TripData** and **TripFares** tables, the project involves:
- Extracting relevant fields
- Cleaning and converting data types
- Creating multiple normalized tables
- Defining **primary keys, foreign keys, and constraints** to ensure data integrity

---

## 🛠 Features Implemented
- **Data Extraction & Transformation**
  - Used `ROW_NUMBER()` to avoid duplicate medallion entries when creating the vendor table.
  - Converted latitude and longitude from `nvarchar` to `decimal` with range validation.
- **Database Normalization**
  - Separated data into logical tables (`TripVendor`, `TripPic`, `TripDetails`, etc.).
- **Constraints for Data Integrity**
  - Implemented `PRIMARY KEY`, `FOREIGN KEY`, and `CHECK` constraints.
- **Data Cleaning**
  - Used `TRY_CAST` to handle invalid coordinate values before inserting them into location tables.

---

## 🗄 Database Schema
The final structured database contains the following tables:

| Table Name       | Description |
|------------------|-------------|
| **TripVendor**   | Stores unique medallion & vendor details. |
| **TripPic**      | Stores pickup and dropoff timestamps. |
| **TripDetails**  | Stores passenger count, trip duration, and trip distance. |
| **TripLocation** | Stores pickup and dropoff coordinates with validation checks. |
| **FareDetails**  | Stores fare amounts, tips, tolls, and total fare details. |
| **Payment**      | Stores payment type and total amount paid for each trip. |

---

## 📂 Files in Repository
- **`taxi_project.sql`** → Full SQL script for creating the database schema and inserting data.
- **`database_diagram.png`** *(optional)* → ER diagram showing relationships between tables.

---

## 🚀 How to Run
1. Open **SQL Server Management Studio (SSMS)**.
2. Create a new database:
   ```sql
   CREATE DATABASE taxi_project_DB;
3. Select the taxi_project_DB database and run the taxi_project.sql script.
4. Verify data:
```sql
SELECT * FROM TripVendor;
SELECT * FROM TripLocation;
```
5.Technologies Used
- SQL Server
- T-SQL
- Database Normalization
- Data Cleaning & Transformation


