# Data-Analyst-Assessment

## Overview

This repository contains my solutions to the SQL proficiency assessment. Each SQL file corresponds to one question and includes a query that addresses the problem with clear formatting and comments.

---

## Question 1: High-Value Customers with Multiple Products

**Approach:**
- Joined customers to their plans and savings transactions.
- Counted distinct savings and investment plans per customer.
- Filtered to include only active plans.
- Summed deposits to get total deposits.
- Filtered customers who have at least one savings and one investment plan.
- Sorted by total deposits descending.

**Challenges:**
- Ensuring correct aggregation of deposits by filtering by plan and user.
- Combining first and last name for better readability.

---

## Question 2: Transaction Frequency Analysis

**Approach:**
- Calculated total transactions per customer and their tenure in months.
- Computed average transactions per month.
- Categorized customers into three frequency groups based on thresholds.
- Aggregated count and average transactions by category.

**Challenges:**
- Handling division by zero for customers with zero tenure.
- Defining clear frequency boundaries.

---

## Question 3: Account Inactivity Alert

**Approach:**
- Identified latest transaction date per plan.
- Filtered active plans only.
- Calculated inactivity days.
- Selected plans with no transaction for over 365 days.

**Challenges:**
- Joining multiple tables with conditions.
- Correctly identifying inactivity using datediff.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

**Approach:**
- Calculated total transactions and total transaction value per customer.
- Computed tenure in months from signup date.
- Calculated profit as 0.1% of transaction value.
- Estimated CLV using formula provided.
- Ordered customers by highest CLV.

**Challenges:**
- Avoiding division by zero in tenure or transactions.
- Correctly converting kobo to Naira for profit calculations.

---
