# Data Cleaning 

-- Data Cleaning
-- Raw Dataset contains: 9,780,190

SELECT
    *
FROM medicare_providers

-- 1. Remove Duplicates
-- 2. Standardize the data (checking for nonsensical data)
-- 3. Null/Blank Values

-- to avoid working on the raw dataset, i'm duplicating the data into a new table
CREATE TABLE medicare_providers_staging AS SELECT * FROM medicare_providers

-- checking for duplicates
WITH duplicates_row AS (SELECT
    *,
    ROW_NUMBER() OVER(PARTITION BY Rndrng_NPI, Place_Of_Srvc, HCPCS_Cd) as row_number
FROM medicare_providers_staging)
SELECT
    *
FROM duplicates_row
WHERE row_number > 1;
-- no duplicate rows were found!

-- checking if standardizing the data is needed: provider type, state abrvtn (for nonsensical data)
-- Provider_Type has included unkown/undefined categories for non target specialties
-- excluded from analysis via the cardiology filter
SELECT
    DISTINCT Rndrng_Prvdr_State_Abrvtn
FROM medicare_providers_staging
ORDER BY 1
-- provider type is fine
-- however, state_abrvtn returned 58 unique rows. should only be returning 50.
SELECT
    DISTINCT Rndrng_Prvdr_State_Abrvtn
FROM medicare_providers_staging
    WHERE Rndrng_Prvdr_State_Abrvtn NOT IN
('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY')

-- Only one of the 8 'extra' codes is nonsensical: 'XX'


SELECT
    COUNT(*)
FROM medicare_providers_staging
WHERE Rndrng_Prvdr_State_Abrvtn = 'XX' AND Rndrng_Prvdr_TYpe = 'Cardiology'

-- count is 0, won't affect analysis


-- checking column types for numerical columns
SELECT
    typeof(Tot_Srvcs) as srvc_type,
    typeof(Avg_Sbmtd_Chrg) as sbmtd_charge_type,
    typeof(Avg_Mdcr_Alowd_Amt) as mdcr_allowed_type
FROM medicare_providers_staging

-- numerical columns matched expected column types


-- checking for nulls
SELECT
    SUM(CASE WHEN Rndrng_NPI IS NULL THEN 1 ELSE 0 END) AS null_npi,
    SUM(CASE WHEN Rndrng_Prvdr_Last_Org_Name IS NULL THEN 1 ELSE 0 END) AS last_name_null,
    SUM(CASE WHEN Rndrng_Prvdr_First_Name IS NULL THEN 1 ELSE 0 END) AS first_name_null,
    SUM(CASE WHEN Rndrng_Prvdr_MI IS NULL THEN 1 ELSE 0 END) AS mi_null,
    SUM(CASE WHEN Rndrng_Prvdr_Crdntls IS NULL THEN 1 ELSE 0 END) AS crdntls_null,
    SUM(CASE WHEN Rndrng_Prvdr_Ent_Cd IS NULL THEN 1 ELSE 0 END) AS ent_cd_null,
    SUM(CASE WHEN Rndrng_Prvdr_St1 IS NULL THEN 1 ELSE 0 END) AS st1_null,
    SUM(CASE WHEN Rndrng_Prvdr_St2 IS NULL THEN 1 ELSE 0 END) AS st2_null,
    SUM(CASE WHEN Rndrng_Prvdr_City IS NULL THEN 1 ELSE 0 END) AS city_null,
    SUM(CASE WHEN Rndrng_Prvdr_State_Abrvtn IS NULL THEN 1 ELSE 0 END) AS state_null,
    SUM(CASE WHEN Rndrng_Prvdr_State_FIPS IS NULL THEN 1 ELSE 0 END) AS fips_null,
    SUM(CASE WHEN Rndrng_prvdr_Zip5 IS NULL THEN 1 ELSE 0 END) AS zip5_null,
    SUM(CASE WHEN Rndrng_Prvdr_RUCA IS NULL THEN 1 ELSE 0 END) AS ruca_null,
    SUM(CASE WHEN Rndrng_Prvdr_RUCA_Desc IS NULL THEN 1 ELSE 0 END) AS ruca_desc_null,
    SUM(CASE WHEN Rndrng_Prvdr_Cntry IS NULL THEN 1 ELSE 0 END) AS country_null,
    SUM(CASE WHEN Rndrng_Prvdr_Type IS NULL THEN 1 ELSE 0 END) AS prvdr_type_null,
    SUM(CASE WHEN Rndrng_Prvdr_Mdcr_Prtcptg_Ind IS NULL THEN 1 ELSE 0 END) AS ind_null,
    SUM(CASE WHEN HCPCS_Cd IS NULL THEN 1 ELSE 0 END) AS code_null,
    SUM(CASE WHEN HCPCS_Desc IS NULL THEN 1 ELSE 0 END) AS desc_code_null,
    SUM(CASE WHEN HCPCS_Drug_Ind IS NULL THEN 1 ELSE 0 END) AS drug_ind_null,
    SUM(CASE WHEN Place_Of_Srvc IS NULL THEN 1 ELSE 0 END) AS srvc_null,
    SUM(CASE WHEN Tot_Benes IS NULL THEN 1 ELSE 0 END) AS bene_null,
    SUM(CASE WHEN Tot_Srvcs IS NULL THEN 1 ELSE 0 END) AS srvcs_null,
    SUM(CASE WHEN Avg_Sbmtd_Chrg IS NULL THEN 1 ELSE 0 END) AS sbmtd_charge_null,
    SUM(CASE WHEN Avg_Mdcr_Alowd_Amt IS NULL THEN 1 ELSE 0 END) AS allowed_medicare_null,
    SUM(CASE WHEN Avg_Mdcr_Pymt_Amt IS NULL THEN 1 ELSE 0 END) AS mdcr_pymnt_null,
    SUM(CASE WHEN Avg_Mdcr_Stdzd_Amt IS NULL THEN 1 ELSE 0 END) AS stdzd_amnt_null,
    COUNT(*) AS total_rows
FROM medicare_providers_staging;

-- 5 nulls in the rendering provider state FIPS column
-- 4,168 nulls in the rendering provider ruca column

-- investigating those nulls further
SELECT
    DISTINCT(Rndrng_Prvdr_Type)
FROM medicare_providers_staging
WHERE Rndrng_Prvdr_RUCA IS NULL

-- i noticed that cardiology is one of the specialties which has these nulls, looking further into it
SELECT
    COUNT(*)
FROM medicare_providers_staging
WHERE Rndrng_Prvdr_RUCA IS NULL AND Rndrng_Prvdr_Type = 'Cardiology'

-- a total of 45 rows

SELECT
    COUNT(*)
FROM medicare_providers_staging
WHERE Rndrng_Prvdr_Type = 'Cardiology' AND Rndrng_Prvdr_State_Abrvtn = 'CA'

-- cardiology has 382,265 rows, 45 rows will have almost have no direct affect on analysis.


# Query 1 (Medicare Service Activity)
  
-- Who are the highest-volume CA cardiology providers, and how concentrated is the market — few dominant players or many small ones?
-- Northstar Metrics:
-- total services (primary)
-- total beneficiares and estimated medicarepaid



SELECT
    COUNT(DISTINCT Rndrng_NPI)
FROM medicare_providers_staging
WHERE Rndrng_Prvdr_Type = 'Cardiology' AND Rndrng_Prvdr_State_Abrvtn = 'CA' AND Rndrng_Prvdr_Ent_Cd = 'O'
-- There are zero organizational cardiologist NPI's. Meaning that this dataset only includes individual cardiologists


SELECT
    COUNT(DISTINCT Rndrng_NPI)
FROM medicare_providers_staging
WHERE Rndrng_Prvdr_Type = 'Cardiology' AND Rndrng_Prvdr_State_Abrvtn = 'CA'
-- There are 1822 unique cardiologists in California who accept Medicare
-- This serves as a baseline for further analysis


-- Calculating each of the providers total services, and the total services across california
SELECT
    Rndrng_NPI,
    CONCAT(Rndrng_Prvdr_First_Name, ' ', Rndrng_Prvdr_Last_Org_Name) AS Provider_Name,
    SUM(Tot_Srvcs) AS Providers_Total_Services,
    SUM(SUM(Tot_Srvcs)) OVER() AS Total_Services
FROM medicare_providers_staging
WHERE Rndrng_Prvdr_Type = 'Cardiology'
  AND Rndrng_Prvdr_State_Abrvtn = 'CA' AND Rndrng_Prvdr_Ent_Cd = 'I'
GROUP BY Rndrng_NPI, Provider_Name
ORDER BY Providers_Total_Services DESC

-- Three cardiologists provide more than 100k services, with one provider (Afshine) providing 306,323 services. 2.12X more than the next highest provider.
-- Upon further investigation these numbers are being inflated due to how certain services are billed. Which is not truly reflective of clinical encounters, let's seperate them.

-- Upon further investigation, measuring a cardiologists output through total services doesn't reflect clinical performance well and framing it as "service_volume" could be misleading.
-- I'll ensure to frame it as medicare service activity as that is a much more accurate depiction given the data limitations.


-- Taking a look at the top 25
SELECT
    *,
    (100.0 * services/Total_Services_Across_CA) AS percent_of_activity,
    (100.0 * benes/total_benes_across_CA) as percent_of_benes
FROM
(SELECT
    Rndrng_NPI,
    CONCAT(Rndrng_Prvdr_First_Name, ' ', Rndrng_Prvdr_Last_Org_Name) AS Provider_Name,
    SUM(Tot_Srvcs) as services,
    SUM(Tot_Benes) as benes,
    SUM(SUM(Tot_Srvcs)) OVER() AS Total_Services_Across_CA,
    SUM(SUM(Tot_Benes)) OVER() AS total_benes_across_CA,
    SUM(Tot_Benes) as beneficiaries
FROM medicare_providers_staging
WHERE Rndrng_Prvdr_Type = 'Cardiology' AND Rndrng_Prvdr_State_Abrvtn = 'CA'
GROUP BY Rndrng_NPI, Provider_Name
ORDER BY services DESC
LIMIT 25)


-- To see how much a certain # of provciders contribute to service activity. Change limit amount to see how much that number of providers contributes.
WITH counts AS (SELECT
    Rndrng_NPI,
    CONCAT(Rndrng_Prvdr_First_Name, ' ', Rndrng_Prvdr_Last_Org_Name) AS Provider_Name,
    SUM(Tot_Srvcs) as services,
    SUM(Tot_Benes) as benes,
    ROUND(SUM(Tot_Srvcs * Avg_Mdcr_Pymt_Amt), 2) AS Est_Mdcr_Paid,
    SUM(SUM(Tot_Srvcs)) OVER() AS Total_Services_Across_CA
FROM medicare_providers_staging
WHERE Rndrng_Prvdr_Type = 'Cardiology' AND Rndrng_Prvdr_State_Abrvtn = 'CA'
GROUP BY Rndrng_NPI, Provider_Name
ORDER BY services DESC)

SELECT
    SUM(contribution)
FROM
(SELECT
    *,
    (100.0 * services/Total_Services_Across_CA) AS contribution
FROM counts
LIMIT 25)

# Query 2 (Top 20 HCPCS Codes)
-- What are the top 20 HCPCS codes cardiologists are billing for most, ranked by Medicare paid?
-- Northstar Metrics:
-- Primary: Medicare Paid
-- Background: Avg Mdcr Paid, Total Services


-- Taking a look at the top 20 HCPCS Codes
SELECT
    HCPCS_Cd,
    HCPCS_Desc,
    COUNT(DISTINCT Rndrng_NPI) as providers_billing,
    ROUND(SUM(Tot_Srvcs * Avg_Mdcr_Pymt_Amt), 2) AS estimated_mdcr_paid,
    AVG(Avg_Mdcr_Pymt_Amt) as avg_mdcr_paid,
    SUM(Tot_Srvcs) as total_services
FROM medicare_providers_staging
WHERE Rndrng_Prvdr_Type = 'Cardiology' AND  Rndrng_Prvdr_State_Abrvtn = 'CA'
GROUP BY HCPCS_Cd, HCPCS_Desc
ORDER BY estimated_mdcr_paid DESC
LIMIT 20



-- Classifying based on standard eval or other
SELECT
    HCPCS_Cd,
    HCPCS_Desc,
    COUNT(DISTINCT Rndrng_NPI) as providers_billing,
    ROUND(SUM(Tot_Srvcs * Avg_Mdcr_Pymt_Amt), 2) AS estimated_mdcr_paid,
    SUM(Tot_Srvcs * Avg_Mdcr_Pymt_Amt) / SUM(Tot_Srvcs) as avg_mdcr_paid,
    SUM(Tot_Srvcs) as total_services,
    CASE WHEN
        HCPCS_Desc LIKE '%moderate level%'
        or HCPCS_Desc LIKE  '%low level%'
        or HCPCS_Desc LIKE '%high level%'
        or HCPCS_Desc LIKE '%low-level%' THEN 'standard-eval'
        ELSE 'other'
        END As proc_type
FROM medicare_providers_staging
WHERE Rndrng_Prvdr_Type = 'Cardiology'
GROUP BY HCPCS_Cd, HCPCS_Desc
ORDER BY estimated_mdcr_paid DESC
LIMIT 20

-- Due to this being a smaller query result, I decided to analyze further using Excel




