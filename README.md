# 🏨 Serendib Grand Hotel — Database Management System (DBMS)

> **Portfolio Showcase:** Detailed Relational Database Design, Schema Normalization, and Enterprise SQL Implementation for Hospitality Management.

[![DBMS](https://img.shields.io/badge/Database-MS%20SQL%20Server-red.svg)](https://www.microsoft.com/en-us/sql-server/)
[![Normalization](https://img.shields.io/badge/Normalization-1NF%20to%20BCNF-blue.svg)]()
[![Status](https://img.shields.io/badge/Project%20Status-Completed-success.svg)]()

---

## 📌 Project Overview

This repository contains a complete, end-to-end Relational Database Management System (RDBMS) engineered for **Serendib Grand Hotel** (Single-branch model). 

The goal of this project was to transition from raw business requirements into a fully optimized, secure, and production-ready physical database schema. It covers core hospitality workflows including guest management, room allocation, service tracking, billing and payment processing, staff administration, and housekeeping logistics.

---

## 🏗 Key Features & System Architecture

### 1. Core Modules Covered
* **Guest & Booking Management:** Tracks guest registrations, contact info, reservation timelines, check-in/check-out statuses, and billing references.
* **Room Specialization:** Implemented using **Disjoint Specialization (Inheritance)** for Room categories (*Standard*, *Deluxe*, *Suite*) with specific attributes.
* **Services & Billing System:** Tracks additional guest requests (room service, laundry, spa) with automated cost calculations using N:M junction relationships.
* **Staff & Department Hierarchy:** Tracks organizational units, employee allocations, department telephone extensions, and managerial supervision (incorporating Weak Entities).
* **Housekeeping Operations:** Automated tracking of room maintenance tasks, assignment to operational staff, and real-time room cleanliness statuses.

### 2. Database Engineering & Design Workflow
1. **Conceptual Design:** Entity-Relationship (ER) modeling using Chen Notation to capture real-world constraints and relationships.
2. **Logical Schema Mapping:** Conversion of ER constructs (Weak Entities, Composite/Multivalued Attributes, Supertype/Subtype relationships) into normalized relational tables.
3. **Normalization (1NF → BCNF):** Systematically eliminated insertion, update, and deletion anomalies through rigorous dependency analysis.
4. **Physical Implementation:** Executed via Microsoft SQL Server using DDL, DML, and DCL scripts with comprehensive integrity constraints (`PK`, `FK`, `CHECK`, `DEFAULT`, `CASCADE`).

---

## 📂 Repository File Structure

```text
├── 📂 docs/
│   └── Hotel_Database_Report.docx       # Full technical report (Conceptual, Logical & Physical Design)
├── 📂 diagrams/
│   └── Hotel_ER_Diagram.html            # Interactive HTML/SVG ER Diagram (Chen Notation)
├── 📂 sql/
│   └── Hotel_Database_SQL_Script.sql    # Complete SQL script (DDL, DML, DCL, and Advanced Analytical Queries)
├── 📂 backup/
│   └── Serendib_Grand_Hotel.bak         # Full SQL Server database backup for direct restoration
└── 📂 proposal/
    └── Hotel_Project_Proposal.docx      # Project scope statement and requirement analysis