# GPIS Federal Benefits and Retirement Analysis Workbook
## Functional Specification Document

**Project:** GrovesCompany Salesforce — Federal Workbook  
**Prepared by:** Development Team  
**Date:** May 19, 2026  
**Version:** 1.0  

---

## Purpose of This Document

This document describes the full functionality of the **Federal Benefits and Retirement Analysis Workbook** as it currently exists in the Salesforce system. It is intended for client review to confirm that the described behavior matches the expected requirements.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Entry Point — Federal Form Button](#2-entry-point--federal-form-button)
3. [Workbook Navigation](#3-workbook-navigation)
4. [Page 1 — About Us / Cover Page](#4-page-1--about-us--cover-page)
5. [Page 2 — Federal Employee Information Form](#5-page-2--federal-employee-information-form)
6. [FEGLI Section — Life Insurance](#6-fegli-section--life-insurance)
   - 6a. Basic Life
   - 6b. Option A (Standard Optional)
   - 6c. Option B (Additional Optional)
   - 6d. Option C (Family Optional)
7. [FERS Retirement System Section](#7-fers-retirement-system-section)
8. [FERS Special Groups Section](#8-fers-special-groups-section)
9. [CSRS Retirement System Section](#9-csrs-retirement-system-section)
10. [TSP — Thrift Savings Plan Section](#10-tsp--thrift-savings-plan-section)
11. [Financial Snapshot Section](#11-financial-snapshot-section)
12. [OBEF — Office Benefit Evaluation Form](#12-obef--office-benefit-evaluation-form)
13. [Notes Section](#13-notes-section)
14. [PDF Generation and File Attachments](#14-pdf-generation-and-file-attachments)
15. [Data Persistence and Auto-Save Behavior](#15-data-persistence-and-auto-save-behavior)
16. [Calculations Reference](#16-calculations-reference)
17. [TSP Contribution Limits Reference Data](#17-tsp-contribution-limits-reference-data)

---

## 1. Overview

The Federal Workbook is a Salesforce Visualforce application designed for GPIS (Groves Insurance Group) specialists to use during appointments with federal government employees. Its purpose is to guide a comprehensive benefits and retirement analysis covering:

- **Federal Employee Group Life Insurance (FEGLI)** — Basic Life, Option A, Option B, and Option C
- **Retirement System** — FERS (Federal Employees Retirement System) and Special Groups (LEOs, Firefighters, ATCs)
- **Thrift Savings Plan (TSP)** — balances, contributions, and projected withdrawals
- **Financial Snapshot** — current income vs. projected retirement income and expenses
- **OBEF** — Office Benefit Evaluation Form for capturing appointment outcomes

The workbook is tied to a **Lead record** in Salesforce. All data entered in the workbook is saved directly to fields on that Lead. A PDF version of the completed workbook can be generated and attached to the Lead record at any time.

**Technology components involved:**
- `Federal_Form` — Custom button on the Lead object (entry point)
- `GPIS_Federal_Workbook` — Main Visualforce page
- `Federal_LeadControllerExtension` — Apex controller that handles data loading, calculations, and save/PDF actions
- Supporting sub-pages: `BasicLife`, `FEGLIAC`, `OptionB`, `FERS_System`, `FERS_Special_Groups`, `Federal_FinancialSnapshot_Insert`, `obefForm`
- PDF rendering pages: `Federal_Workbook_PDF`, `BasicLife_PDF`, `FEGLIAC_PDF`, `optionB_PDF`, `FERS_Special_Groups_PDF`, `Federal_FinancialSnapshot_Insert_PDF`, `OBEF_Locked_PDF`
- Custom Metadata: `TSP_Contribution__mdt` (stores IRS contribution limits for 2025 and 2026)

---

## 2. Entry Point — Federal Form Button

**Button name:** Federal Form  
**Object:** Lead  
**Location:** Lead record page layout (button bar)

When a specialist clicks the **Federal Form** button on a Lead record, the system opens a **new browser window** with the following characteristics:

| Setting | Value |
|---|---|
| Window type | New window (not a tab or overlay) |
| Toolbar | Hidden |
| Menubar | Hidden |
| Scrollbars | Enabled |
| Initial height | 600 px (resizable) |
| URL target | `GPIS_Federal_Workbook` Visualforce page |
| Lead context | Passed via `?id={Lead.Id}` in the URL |
| Environment | `inouvia` sandbox org (`groves-insurancegroup--inouvia--c.vf.force.com`) |

The workbook opens pre-loaded with all data from the selected Lead record.

---

## 3. Workbook Navigation

A **sticky navigation bar** is fixed to the top of the screen and remains visible as the user scrolls. It contains anchor links to each major section of the workbook, plus action buttons.

### Navigation Sections

| Nav Item | Shown When | Links To |
|---|---|---|
| About Us | Always | Cover page |
| Federal Employee Info | Always | Employee information form |
| FEGLI (dropdown) | Always | FEGLI subsections |
| — Basic | `Basic Life` is selected | Basic Life section |
| — Option A | `Option A` is selected | Option A section |
| — Option B | `Option B` is selected | Option B section |
| — Option C | `Option C` is selected | Option C section |
| FERS (dropdown) | FERS checkbox is checked | FERS subsections |
| — FERS Pension | FERS is active | Pension calculation area |
| — FERS Gap / Survivor | FERS is active | Gap and survivor benefits |
| — FERS Special Supplement | Retirement age < 62 | Special supplement section |
| Special Groups | Special Groups is checked | Special Groups section |
| TSP Info | Always | TSP section |
| Notes | Always | Notes area |
| Financial SnapShot | Always | Financial Snapshot form |
| OBEF | Always | OBEF form |

### Navigation Action Buttons

| Button | Action |
|---|---|
| Save Attachment | Generates the full workbook PDF and attaches it to the Lead record |
| Download OBEF | Generates the OBEF PDF and downloads it directly to the browser |
| Cancel | Closes the workbook and returns to the Lead record |

---

## 4. Page 1 — About Us / Cover Page

The first page of the workbook is a **cover/introduction page** displaying the GPIS company logo.

**Static content displayed:**
- GPIS logo image
- Title: *"GPIS Federal Benefits and Retirement Analysis"*
- Authorship and description metadata
- Overview of the workbook's purpose: *"This workbook is designed to help you start building your retirement income plan."*
- Statement of scope: *"In retirement two things will occur: Income Will Decrease and Costs Will Increase."*
- List of benefits covered:
  - Federal Employees Group Life Insurance (FEGLI)
  - Federal Retirement System (FERS / CSRS)
  - Retirement Annuities
  - FERS Supplement
  - Thrift Savings Plan (TSP)
  - Social Security
  - Financial Snapshot

This page has no editable fields. In PDF output, it serves as the title page with a page break before the next section.

---

## 5. Page 2 — Federal Employee Information Form

This is the primary data entry form. Most fields trigger an **automatic save to Salesforce** the moment they are changed (on-change save). The page header displays the current date and the specialist's name, phone, and email.

A disclaimer is shown: *"Information used in this analysis is provided by the federal employee."*

### Read-Only Display Fields

These fields are calculated by Salesforce formulas and displayed for reference only:

| Label | Data Source |
|---|---|
| Full Name | `Lead.Name` |
| Mobile Phone | `Lead.MobilePhone_Formatted__c` |
| Email | `Lead.Email` |
| Street, City, State, Zip | `Lead.Address` fields |
| Current Age | `Lead.Contact_Age__c` (formula field) |
| Expected Retirement Age | `Lead.Expected_Retirement_Age__c` |
| Federal Indicator | `Lead.Federal_Indicator__c` |
| Years of Creditable Service | `Lead.Years_of_Employment__c` |

### Editable Input Fields

| Label | Field | Notes |
|---|---|---|
| Hire Date | `Date_of_Hire__c` | Date picker |
| Job Title | `Title` | Free text |
| Agency | `Company` | Free text |
| Date of Birth | `Date_of_Birth__c` | Date picker; drives age calculation |
| Expected Retirement Date | `Expected_Retirement_Date__c` | Date picker |
| Federal Employee | `Federal_Employee__c` | Checkbox |
| Marital Status | `Marital_Status__c` | Picklist |
| Spouse Name | `Spouse_Name__r.Name` | Shown only when Married or Registered Partnership |
| Update Spouse Info | — | Button that opens a Salesforce Flow (`contact_create_update_spouse`) in a new tab to create or update the spouse Contact record |
| Base Salary | `Base_Salary__c` | Currency |
| Salary Interval | `Salary_Interval__c` | Picklist (e.g., Annual, Monthly) |
| Affiliation | `Affiliation__c` | Picklist |

### TSP Contribution Inputs

The employee can enter TSP contributions either as a **percentage** of salary or as a **dollar amount** (toggle switches control which mode is active):

| Toggle | Field | Mode |
|---|---|---|
| TSP % toggle | `percTSP__c` | Shows `TSP_Contribution__c` (percentage entry) |
| TSP $ toggle | `dollarTSP__c` | Shows `Monthly_Contribution__c` (dollar entry) |
| ROTH % toggle | `percROTH__c` | Shows `ROTH_TSP_Contribution__c` |
| ROTH $ toggle | `dollarROTH__c` | Shows `Monthly_ROTH_Contribution__c` |

If TSP contribution is 5% or more (or ROTH is 5% or more), a **"5% Govt. Match"** indicator is displayed.

| Label | Field |
|---|---|
| TSP Balance ($) | `TSP_Total__c` |
| Tax-Free TSP (ROTH) Balance ($) | `ROTH_Total__c` |

### Retirement System Selection

These checkboxes are **mutually exclusive** — selecting one clears the other:

| Checkbox | Field | Effect |
|---|---|---|
| FERS | `FERS__c` | Enables FERS pension sections |
| Special Groups | `Special_Group_Member__c` | Enables Special Groups section; disables FERS |

### FEGLI Selection

FEGLI coverage can be selected in two ways:

**Option 1 — Individual checkboxes:**

| Checkbox | Field |
|---|---|
| Basic Life | `Basic__c` |
| Option A | `OptionA__c` |
| Option B | `OptionB__c` |
| Option C | `OptionC__c` |

**Option 2 — FEGLI Code Picklist (`FEGLI_Code_Picklist__c`):**  
When a FEGLI code is selected from the picklist, the system automatically decodes it and sets the appropriate checkboxes and multipliers. A human-readable description of the code is displayed (e.g., *"BL, A, C2"*). The Option B multiplier and Option C multiples derived from the code are shown.

Clicking the **"FEGLI Code:"** label link clears all FEGLI selections back to a blank state (`--`).

---

## 6. FEGLI Section — Life Insurance

The FEGLI section is composed of four sub-sections, each rendered only if the corresponding coverage option is active on the Lead. Each sub-section includes both an **interactive form view** and a **PDF-renderable view**.

---

### 6a. Basic Life

**Shown when:** `Basic Life` checkbox is checked, or a FEGLI code other than none/Option A only/Option B only is selected.

#### Explanatory Content
- FEGLI is a group term life policy administered by OFEGLI (MetLife) under OPM contract.
- Basic Life has three components: (I) Basic Life, (II) Extra Benefit (age multiplication factor), (III) Accidental Death & Dismemberment (AD&D).
- Employee pays 2/3 of cost; Government pays 1/3. USPS postal employees: Government pays full cost.
- Rate: **$0.16 bi-weekly / $0.3467 per month per $1,000 of coverage**.

#### Calculations and Displayed Fields

| Label | Formula / Source |
|---|---|
| Annual Base Pay | `Lead.Base_Salary__c` |
| Base Pay (rounded up to next $1,000) | `formula_basePay__c` (Salesforce formula field) |
| BIA — Basic Insurance Amount | `formula_basePay__c + $2,000` |
| Current Age | Age input (manual: `Age_Option_Basic_Manual__c`) or auto-filled from `Contact_Age__c` when a FEGLI code is present |
| Extra Benefit Factor | Determined by age band (see table below) |
| Extra Benefit Dollar Amount | `BIA × age factor` |
| Total Current Benefit | `BIA + (BIA × age factor)` — displayed in red |
| Extra Benefit Years Remaining | `45 − current age` (shown only if age ≤ 45) |

#### Extra Benefit Age Factor Table

| Age | Factor |
|---|---|
| Under 35 | 1.0 (doubles coverage) |
| 36 | 0.9 |
| 37 | 0.8 |
| 38 | 0.7 |
| 39 | 0.6 |
| 40 | 0.5 |
| 41 | 0.4 |
| 42 | 0.3 |
| 43 | 0.2 |
| 44 | 0.1 |
| 45+ | 0.0 (no extra benefit) |

#### Retirement Options — Cost and Coverage

Three reduction options are presented for retirement, with both pre-65 and post-65 costs shown:

| Option | Pre-65 Monthly Cost | Post-65 Monthly Cost | Post-65 Coverage |
|---|---|---|---|
| No Reduction | $2.5967 per $1,000 | $2.25 per $1,000 | Full BIA maintained |
| 50% Reduction | $1.0967 per $1,000 | $0.75 per $1,000 | Reduces 1%/month starting at 65; ends at 50% of BIA |
| 75% Reduction (Free) | $0.3467 per $1,000 | No cost | Reduces 2%/month starting at 65; ends at 25% of BIA |

---

### 6b. Option A — Standard Optional Insurance

**Shown when:** `Option A` checkbox is checked, or FEGLI code contains an Option A indicator.

#### Key Facts
- Fixed coverage amount: **$10,000**
- AD&D of equal amount ($10,000) — available only while employed, not in retirement
- After retirement: coverage reduces **2% per month** starting at age 65 (or later retirement date) over 50 months, reaching a **75% reduction** — final value: **$2,500**

#### Age Band Cost Table

| Age Band | Bi-Weekly Cost | Monthly Cost |
|---|---|---|
| Under 35 | $0.20 | $0.43 |
| 35–39 | $0.20 | $0.43 |
| 40–44 | $0.30 | $0.65 |
| 45–49 | $0.60 | $1.30 |
| 50–54 | $1.00 | $2.17 |
| 55–59 | $1.80 | $3.90 |
| 60+ | $6.00 | $13.00 |

The current age band row is **highlighted in blue** for quick reference.

---

### 6c. Option B — Additional Optional Insurance

**Shown when:** `Option B` checkbox is checked, or FEGLI code contains an Option B multiplier letter.

#### Key Facts
- Coverage = **Annual base pay (rounded up to next $1,000) × multiplier (1–5)**
- Multiplier is entered manually (`Multiples_B_Manual__c`) when no FEGLI code is present, or derived automatically from the FEGLI code letter when a code is set
- Employee pays full cost; rates are per $1,000 of coverage by age band

#### Cost Per $1,000 of Coverage

| Age Band | Bi-Weekly | Monthly |
|---|---|---|
| Under 35 | $0.02 | $0.043 |
| 35–39 | $0.02 | $0.043 |
| 40–44 | $0.03 | $0.065 |
| 45–49 | $0.06 | $0.130 |
| 50–54 | $0.10 | $0.217 |
| 55–59 | $0.18 | $0.390 |
| 60–64 | $0.36 | $0.780 |
| 65–69 | $0.72 | $1.560 |
| 70–74 | $1.44 | $3.120 |
| 75–79 | $2.16 | $4.680 |
| 80+ | $2.88 | $6.240 |

**Option B Insurance Coverage** = `formula_basePay__c × multiplier` — displayed prominently in red.

#### Age Band Year Entry Table
When the age band table is unlocked, the specialist can enter how many years the employee expects to remain in each age band (fields: `Years_34`, `Years_35_39`, `Years_40_44`, `Years_45_49`, `Years_50_54`, `Years_55_59`, `Years_60_64`, `Years_65_69`, `Years_70_74`, `Years_75_79`, `Years_80`). This projects lifetime premium costs and feeds `Standard_Monthly__c` and `Standard_Amount__c`.

| Action | Button | Effect |
|---|---|---|
| Lock age table | "Set Age" button | Saves the entered ages (`Starting_Age_Set__c = true`); locks table from editing |
| Unlock age table | "Unlock" button | Re-enables age band editing |
| Reset age table | "Reset" button | Clears all age band year entries and resets amounts to zero |

**Option B Choice at Retirement** (`Option_B_Choice_Selection__c`): Picklist field capturing the employee's retirement reduction election.

---

### 6d. Option C — Family Optional Insurance

**Shown when:** `Option C` checkbox is checked, or FEGLI code contains a digit 1–5.

#### Key Facts
- Coverage per multiple: **Spouse = $5,000 × multiples; each eligible child = $2,500 × multiples**
- Multiples range 1–5 (entered manually via `Multiples_C_Manual__c` or derived from FEGLI code digit)
- Employee pays full cost
- Age refers to the employee's age (not the spouse's)

#### Cost Per Multiple by Age Band

| Age Band | Bi-Weekly | Monthly |
|---|---|---|
| Under 35 | $0.20 | $0.43 |
| 35–39 | $0.24 | $0.52 |
| 40–44 | $0.37 | $0.80 |
| 45–49 | $0.53 | $1.15 |
| 50–54 | $0.83 | $1.80 |
| 55–59 | $1.33 | $2.88 |
| 60–64 | $2.43 | $5.27 |
| 65–69 | $2.83 | $6.13 |
| 70–74 | $3.83 | $8.30 |
| 75–79 | $5.76 | $12.48 |
| 80+ | $7.80 | $16.90 |

**Total bi-weekly cost** = `age band rate × number of multiples`  
**Spouse benefit amount** = `multiples × $5,000`  
**Per-child benefit amount** = `multiples × $2,500`

#### Retirement Reduction (Option B and C)
Under the full reduction option, Option B and C coverage reduces **2% per month** starting at age 65 (or later retirement date) until coverage ends after 50 months. Alternatively, the employee may elect to continue coverage after retirement by paying the per-$1,000 monthly premium rates (effective April 24, 1999).

---

## 7. FERS Retirement System Section

**Shown when:** `FERS__c` checkbox is checked on the Lead.

### Introductory Content
Describes FERS as effective January 1, 1987, with three pillars:
1. Basic Benefit Plan (FERS Annuity)
2. Social Security
3. Thrift Savings Plan (TSP)

### Retirement Scenarios

The workbook supports **two retirement scenarios** side-by-side (Scenario 1 and Scenario 2), allowing the specialist to compare different retirement ages or timelines. Each scenario stores:

| Field | Description |
|---|---|
| `Scenario1_Primary__c` / `Scenario2_Primary__c` | Flags which scenario is the "active" primary plan (mutually exclusive) |
| `Scenario1_Retirement_Age__c` / `Scenario2_Retirement_Age__c` | Target retirement age for each scenario |
| `Scenario1_YOS__c` / `Scenario2_YOS__c` | Years of service at retirement for each scenario |
| `scenario1XYOS` / `scenario2XYOS` | Calculated: years from hire date to reach that retirement age |

### FERS Pension Formula
Standard FERS annuity is calculated at **1% per year of service** of High-3 average salary, or **1.1% per year** if retiring at age 62 or older with 20+ years of service.

The workbook displays:
- High-3 salary (`High_3_Salary__c`, `High_3_Salary2__c`)
- Projected annual pension
- Projected monthly pension
- Survivor benefit options (full, partial, none) and their effect on the monthly amount

### Survivor Benefit Reductions
| Option | Monthly Reduction |
|---|---|
| Full survivor benefit | Reduces annuity by 10% |
| Partial survivor benefit | Reduces annuity by 5% |
| No survivor benefit | No reduction |

`pensionMinValue` and `pensionMaxValue` represent the monthly pension after applying these reductions.

### FERS Special Supplement

**Shown when:** The primary scenario has a retirement age below 62, OR if no scenario is flagged as primary and `Expected_Retirement_Age__c < 62`.

The FERS Special Supplement bridges the gap between early FERS retirement and Social Security eligibility at age 62. It is calculated as:

> **`floor(Predicted_Social_Security__c × (YOS_Special_Supplement__c ÷ 40))`**

This mirrors the official OPM formula: the employee's projected Social Security benefit multiplied by the fraction of FERS service years out of 40.

The supplement is displayed in the summary until the employee turns 62 (or re-employed in certain cases).

### Social Security

`SocialSecurityValue` is displayed as the projected monthly Social Security benefit (`Predicted_Social_Security__c`) when the primary retirement scenario has an age of 62 or older. If retirement is before 62, Social Security is shown as **$0** in the retirement income summary (replaced by the Special Supplement).

### Income Summary in FERS Section

The FERS section displays a combined retirement income summary:
- FERS Monthly Pension (min / max based on survivor election)
- FERS Special Supplement (if retirement age < 62) or Social Security (if age ≥ 62)
- TSP Monthly Withdrawal Estimate (`TspCalculateValue`)
- Gap/shortfall analysis compared to current income

---

## 8. FERS Special Groups Section

**Shown when:** `Special_Group_Member__c` checkbox is checked on the Lead.

**Applies to:** Law Enforcement Officers (LEOs), Firefighters, and Air Traffic Controllers.

### Eligibility Rules (displayed as informational text)
- Can retire at **age 50 with 20+ years** of service, or
- At **any age with 25+ years** of service (unreduced benefit)

### Pension Formula

Special Groups use a **higher accrual rate** than standard FERS:

| Service Component | Formula |
|---|---|
| First 20 years | `1.7% × High-3 Salary × 20` |
| Years beyond 20 | `1.0% × High-3 Salary × Remaining Years` |
| **Total Annual Annuity** | Sum of above two components |
| **Monthly Annuity** | Total ÷ 12 |

**Inputs:**
- `High_3_Salary__c` — editable
- `Remaining_Years__c` — years of service beyond the initial 20 (editable)

**Example shown on page:** $115,000 high-3 salary, 23 years service = **$42,550 annually** ($3,546/month).

### Step-by-Step Calculation Display

The page shows each arithmetic step:
1. `High-3 × 1.7% = per-year rate`
2. `per-year rate × 20 = 20-year component`
3. `High-3 × 1.0% = additional per-year rate`
4. `additional per-year rate × Remaining_Years = additional component`
5. Total annual annuity and monthly annuity

### Survivor Benefit Impact
The controller exposes `pensionMinValue` (after 5% survivor reduction) and `pensionMaxValue` (after 10% survivor reduction) using this same formula, displayed in the retirement income summary.

---

## 9. CSRS Retirement System Section

**Current status:** The CSRS section (`CSRS_Section` Visualforce page) exists in the codebase but is **currently commented out** in the main workbook page and does **not render**. CSRS and CSRS Offset fields are stored on the Lead record (`CSRS__c`, `CSRS_Offset__c`, `CSRS_Annuity_Retirement__c`) but the section is not displayed to users at this time.

> **Confirmation needed:** Is the CSRS section intentionally disabled, or should it be re-enabled?

---

## 10. TSP — Thrift Savings Plan Section

This section is always visible and covers TSP education, contribution limits, and a reference table of federal forms.

### Contribution Limits Table

Pulled from Salesforce Custom Metadata (`TSP_Contribution__mdt`):

| | 2025 | 2026 |
|---|---|---|
| Regular Contribution Limit | $23,000 | $23,000 |
| Catch-Up Contribution (age 50+) | $7,500 | $7,500 |
| **Total Maximum** | **$30,500** | **$30,500** |

### Government Matching Rules (displayed as static content)

| Retirement System | Matching |
|---|---|
| CSRS / CSRS Offset | No government matching |
| FERS — Automatic | 1% agency contribution regardless of employee contribution |
| FERS — Matched 100% | Employee contributions 1%–3% matched dollar-for-dollar |
| FERS — Matched 50% | Employee contributions 4%–5% matched at 50 cents per dollar |

Maximum government match for FERS employees: **5% of salary**.

### TSP Options at Retirement (informational text)
1. Monthly Payments — withdraw a fixed amount monthly
2. Annuitize — convert balance to a lifetime annuity
3. Rollover — roll to an IRA or other qualified plan
4. Do Nothing — leave funds in TSP account

### Military Time Recapture Reference
Contact addresses for DFAS (Defense Finance and Accounting Service) are listed for each branch:
- Army, Navy, Air Force, Marines, Coast Guard

### TSP Monthly Withdrawal Estimate (`TspCalculateValue`)

Calculated by the controller using the employee's entered withdrawal rate and tax rate:

| Scenario | Formula |
|---|---|
| TSP only (no ROTH) | `((TSP Balance × Annual Withdrawal Rate%) ÷ 12) × (1 − Tax Rate%)` |
| ROTH only (no TSP) | `(ROTH Balance × Annual Withdrawal Rate%) ÷ 12` |
| Both TSP and ROTH | Sum of the two above |
| Neither / no rate | $0 |

**Inputs used:**
- `TSP_Balance_No_Match__c` — TSP balance without government match
- `AnnualWithdraw1__c` — TSP annual withdrawal rate (% string)
- `AnnualWithdraw2__c` — ROTH annual withdrawal rate (% string)
- `taxRate5_Picklist__c` — applicable tax rate (% string)

### Federal Forms Reference Table (static, page 16)

| Form | Purpose |
|---|---|
| SF-2817 | FEGLI life insurance election |
| SF-2823 | FEGLI beneficiary designation |
| SF-3107 (FERS) / SF-2801 (CSRS) | Retirement application |
| SF-3106 (FERS) / SF-2802 (CSRS) | Refund of retirement deductions |
| SF-3104 (FERS) / SF-2800 (CSRS) | Death benefits claim |
| SF-3105 (FERS) / SF-2824 (CSRS) | Disability retirement |
| SF-3106 (FERS) / SF-2803 (CSRS) | Deposit / re-deposit |
| TSP-1 | TSP contribution election |
| TSP-3 | TSP beneficiary designation |
| TSP-9 | TSP address change |
| TSP-11C | Spousal rights |
| TSP-15 | Name change |
| TSP-16 | Spousal waiver exception |
| TSP-17 | Deceased participant account |
| TSP-20 | TSP loan |

---

## 11. Financial Snapshot Section

The Financial Snapshot is a multi-page income and expense analysis comparing the employee's **current financial situation** with their projected **retirement financial situation**. It is presented as an interactive form (`Federal_FinancialSnapshot_Insert`) embedded in the main workbook and can also be rendered as a standalone PDF (`Federal_FinancialSnapshot_Insert_PDF`).

The form is organized into pages (referenced internally as Pg7 through Pg10 in field naming):

### Income Section (Pg7 rows)

| Row | Employee Field | Spouse Field |
|---|---|---|
| Social Security | `Predicted_Social_Security__c` | `Spouse_Social_Security__c` |
| Pension | `Predicted_Pension__c` | `Spouse_Pension__c` |
| Additional Income rows 5–10 | `Pg7Rw5__c` – `Pg7Rw10__c` | `Pg7Rw5_Spouse__c` – `Pg7Rw10_Spouse__c` |

### Expense Section (Pg8 rows)

11 rows of living expense line items, with separate employee and spouse columns:
- Fields: `Pg8Rw1__c` through `Pg8Rw11__c` (employee) and `Pg8Rw1_Spouse__c` through `Pg8Rw11_Spouse__c`

### Tax Section (Pg9 rows)

21 rows of tax line items with employee/spouse columns:
- Fields: `Pg9Rw01__c` through `Pg9Rw21__c` (employee) and spouse equivalents
- Tax rate picklists: `taxRate1_Picklist__c` through `taxRate4_Picklist__c`
- Hidden formula fields compute tax amounts: `hiddenTaxFormula1__c` through `hiddenTaxFormula4__c`

### TSP/IRA Withdrawal Section (Pg10 rows)

23 rows covering TSP, ROTH TSP, and IRA withdrawal analysis:
- Fields: `Pg10Rw01__c` through `Pg10Rw23__c` (employee and spouse)
- Withdrawal rate inputs: `AnnualWithdraw1__c`, `AnnualWithdraw2__c`
- Tax rate on withdrawals: `taxRate5_Picklist__c`
- Hidden formula fields: `hiddentaxFormula_TSP_Tax__c`, `hiddentaxFormula_TSP__c`, `hiddentaxformula_ROTHTSP__c`, `hiddenTaxFormula_IRAFree__c`, `hiddenTaxFormula_IRA_Tax__c`, `hiddenTaxFormula_IRA__c`

### Summary Totals Displayed

| Label | Field |
|---|---|
| Total Health Costs | `formula_totalHealth__c` |
| Additional Insurance | `formula_addlInsurance__c` |
| Combined Expenses | `combined_Expenses__c` |
| Income Subtotal | `subTotal__c` |
| Current Net Income | `currentNET__c` |
| Bottom Line | `BottomLine__c` |
| Income Gap | `GAP_Difference__c` |
| Total Taxes | `totalTaxes__c` / `totalTaxes_Currency__c` |
| Total Expenses (Employee) | `formula_totalExpenses__c` |
| Total Expenses (Spouse) | `formula_totalExpenses_Spouse__c` |

### Investment Risk Questions

Four investment risk assessment questions are included:
- Fields: `Investment_Risk_Question_1__c` through `Investment_Risk_Question_4__c`

---

## 12. OBEF — Office Benefit Evaluation Form

The OBEF (Office Benefit Evaluation Form) is an appointment intake and outcome summary form. It has two modes:
- **Interactive version** (`obefForm.page`) — editable during the appointment
- **Locked PDF version** (`OBEF_Locked_PDF.page`) — generated when "Download OBEF" is clicked, attaches to the Lead and downloads to the browser

### OBEF Sections and Fields

**Appointment Header:**
| Field | Source |
|---|---|
| Specialist Name | `$User` (logged-in Salesforce user) |
| Appointment Date | Today's date |
| Appointment Time | `Lead.Appointment_Time__c` |
| Referral | `Lead.Referral__c` |
| Referred By | `Lead.Referred_By__c` |
| Office | `Lead.Office__c` |
| Specialist field | `Lead.Specialist__c` |

**Federal Employee Information:**
| Field | Source |
|---|---|
| Full Name | `Lead.Name` |
| Agency | `Lead.Company` |
| Date of Birth | `Lead.Date_of_Birth__c` |
| Date of Hire | `Lead.Date_of_Hire__c` |
| Years of Service | `Lead.Years_of_Employment__c` |
| Expected Retirement Date | `Lead.Expected_Retirement_Date__c` |
| Retirement Age | `Lead.Expected_Retirement_Age__c` |
| Marital Status | `Lead.Marital_Status__c` |
| Spouse Name | `Lead.Spouse_Name__r.Name` |
| Base Salary | `Lead.Base_Salary__c` |
| Salary Interval | `Lead.Salary_Interval__c` |

**Union/Association:**
| Field | Source |
|---|---|
| Union/Association | `Union_Association__c` |
| Local | `Local__c` |
| Chapter | `Chapter__c` |
| Branch / Branch No. | `Branch__c` / `Branch_No__c` |
| President | `President__c` |
| President Phone | `President_Phone__c` |
| President Email | `President_Email__c` |
| Union Website | `Union_Website__c` |

**FEGLI Summary:** Checkboxes for Basic, Option A, Option B, Option C; FEGLI Code; Option B multiplier; Option C multiples.

**Retirement System:** FERS / Special Groups / CSRS checkboxes; retirement scenarios; High-3 salary.

**TSP:** Balance, contribution amounts, ROTH amounts.

**Appointment Outcome:**
| Field | Source |
|---|---|
| Appointment Results | `Appointment_Results__c` |
| Reset Date | `Reset_Date__c` |
| Reset Time | `Reset_Time__c` |
| Call Back Date | `Call_Back_Date__c` |
| Call Back Time | `Call_Back_Time__c` |
| OBEF Notes | `OBEF_Notes__c` |

**Policy/Carrier:**
| Field | Source |
|---|---|
| Carrier | `Carrier__c` |
| Policy Issue Date | `Policy_Issue_Date__c` |
| Policy Number | `Policy__c` |

---

## 13. Notes Section

A free-text notes area (`Lead.Notes__c`) is accessible from the navigation bar. This captures any general notes from the appointment or analysis that do not fit into structured fields.

---

## 14. PDF Generation and File Attachments

The workbook provides two PDF generation actions:

### Save Attachment — Full Workbook PDF

**Trigger:** "Save Attachment" button (in nav bar and also within the workbook body)  
**Apex method:** `pdfAction()`

**Process:**
1. Renders `Federal_Workbook_PDF` page as a PDF blob
2. Creates a `ContentVersion` (Salesforce File) record with name: `GPIS Federal Retirement Planning Workbook_v{N}_{date}.pdf` where `{N}` is an auto-incrementing version number stored in `Lead.Workbook_Version__c`
3. Increments `Workbook_Version__c` on the Lead
4. Creates a `ContentDocumentLink` to attach the file to the Lead record
5. Redirects the user back to the Lead record

There is also a commented-out variant (`pdfActionEmail()`) that, when activated, would perform the same PDF generation and then redirect to a Salesforce Flow (`Send_Client_Email`) to email the file directly to the client.

### Download OBEF PDF

**Trigger:** "Download OBEF" button (in nav bar)  
**Apex method:** `downloadFile()`

**Process:**
1. Renders `OBEF_Locked_PDF` page as a PDF blob
2. Creates a `ContentVersion` record titled: `OBEF Form_v{N}_{date}.pdf`
3. Increments `OBEF_Version__c` on the Lead
4. Creates a `ContentDocumentLink` to attach to the Lead
5. Redirects to the Salesforce file download servlet — the PDF **downloads directly to the browser**

### PDF Page Content

All PDF pages are read-only versions of their corresponding interactive sections. The same Salesforce formula fields and calculated values are displayed, but all input fields are replaced with output-only fields. No editing is possible in PDF mode. Static resource stylesheets (`workbookStyles`, `modal`) are applied identically.

---

## 15. Data Persistence and Auto-Save Behavior

### Server-Side Auto-Save

Almost every input field in the workbook triggers a **server-side save to Salesforce** on change (using `apex:actionSupport event="onchange"`). The `save()` Apex method:
1. Enforces mutual exclusion rules (FERS vs. Special Groups; Scenario 1 vs. Scenario 2 primary; Min vs. Max survivor election)
2. Runs an `UPDATE` DML operation on the Lead record
3. Re-queries the Lead to refresh all calculated/formula fields
4. Triggers a re-render of the affected page panels

### Client-Side localStorage Backup

In addition to server saves, a JavaScript layer stores all input values in the browser's `localStorage` using a Lead-specific key prefix: `GPIS_Federal_Workbook:{Lead.Id}:elementId`.

**Behavior:**
- **On page load:** All previously stored values are restored to their input elements
- **On any input change:** The new value is written to localStorage immediately
- **On form submit:** All localStorage keys for this Lead are cleared

**Purpose:** Protects unsaved data if the browser tab is accidentally closed or refreshed before a server save completes.

---

## 16. Calculations Reference

| Calculation | Formula |
|---|---|
| Basic Insurance Amount (BIA) | `ROUND_UP(Base_Salary, 1000) + $2,000` |
| Basic Extra Benefit | `BIA × age_factor (from table)` |
| Total Basic Benefit | `BIA + Extra Benefit` |
| Option B Coverage | `ROUND_UP(Base_Salary, 1000) × multiplier` |
| Option C Spouse Benefit | `multiples × $5,000` |
| Option C Child Benefit | `multiples × $2,500` |
| FERS Special Supplement | `FLOOR(Social_Security × (FERS_YOS ÷ 40))` |
| Special Groups Pension (20 yr) | `High_3 × 1.7% × 20` |
| Special Groups Pension (extra yrs) | `High_3 × 1.0% × Remaining_Years` |
| Special Groups Monthly (Min) | `(Total Annual Annuity ÷ 12) × 0.95` |
| Special Groups Monthly (Max) | `(Total Annual Annuity ÷ 12) × 0.90` |
| TSP Withdrawal (taxable) | `((TSP_Balance × Withdrawal_Rate%) ÷ 12) × (1 − Tax_Rate%)` |
| TSP Withdrawal (ROTH) | `(ROTH_Balance × Withdrawal_Rate%) ÷ 12` |
| Scenario YOS | `Retirement_Age − Years_from_DOB_to_DOH` |

---

## 17. TSP Contribution Limits Reference Data

The following IRS limits are stored in Salesforce Custom Metadata (`TSP_Contribution__mdt`) and are displayed in the TSP section of the workbook:

| Year | Regular Limit | Catch-Up Limit (age 50+) | Total |
|---|---|---|---|
| 2025 | $23,000 | $7,500 | $30,500 |
| 2026 | $23,000 | $7,500 | $30,500 |

> **Note:** Both years currently show identical limits. If the 2026 IRS limits are updated, the Custom Metadata record `TSP_Contribution.X2026` should be updated accordingly.

---

## Questions for Client Confirmation

The following items were identified during analysis and require client confirmation:

1. **CSRS Section** — The CSRS retirement section exists in the codebase but is currently **commented out** and not displayed to users. Is this intentional, or should it be re-enabled?

2. **Email to Client button** — The `pdfActionEmail()` action (which would generate the PDF and redirect to a "Send Client Email" flow) exists in the code but is **commented out**. Should this be activated?

3. **FEGLI Code Picklist** — The decode logic supports approximately 70 FEGLI code combinations. Should the full list of supported codes be included in this document for client review?

4. **TSP Contribution Limits** — The 2025 and 2026 limits are currently identical ($23,000 regular / $7,500 catch-up). Is this correct, or should 2026 reflect updated IRS limits?

5. **Hardcoded Lead ID** — The controller contains a hardcoded Lead ID (`00QDz00000HCQKDMA5`) as a class variable. This appears to be a leftover from development/testing. Confirm whether this should be removed.

6. **`inouvia` sandbox URL** — The Federal Form button currently points to the `inouvia` sandbox environment. Does this need to be updated to the production org URL for go-live?

---

*End of Functional Specification — Version 1.0*
