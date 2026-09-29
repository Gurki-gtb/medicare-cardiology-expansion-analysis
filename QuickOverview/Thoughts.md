# Medicare Cardiology Expansion Analysis
## Overview 
An exploratory analysis of CMS Medicare Physician & Other Practitioners data. Framed as a strategy consulting engagement for a medical group's expansion decision. Covers market concentration, service mix, and data-quality investigation using SQL, Excel and Power BI.

## Business Questions Answered 
- Who are the highest-volume cardiology providers in California right now, and how concentrated is that market — are we talking about a handful of big players or a lot of small ones?
- What are cardiologists actually billing for most? I want to understand the service mix so we know what we'd need to staff and equip if we went the "build" route.
- Based on what you find, does it look like we should be looking at acquiring an existing practice, or is there room to build our own and compete?

## Dataset 
- Source: CMS Medicare Physician & Other Practitioners — by Provider and Service
- 9.7M rows of data, filtered to Cardiologist specialty in California
- URL: https://data.cms.gov/provider-summary-by-type-of-service
- Year: 2024 (most recent year avaliable)

## Tools Used 
- SQL (SQLite): Data Loading, Cleaning, and Analytical Queries
  - Window Functions, CTE's, Case When, Data Cleaning, ETC.
  - Full SQL exploration is in the SQL file.
- Microsoft Excel: Query Result Analysis
  (!)[visualizations/excel.png]
- Power BI: Visualizations
  - Visualizations are in the main read me.
 
# To whomever may be reading:
This project was built using fully publicly online data. AI was used during this project for help with query wrangling, visualization settings, and other technical nuances. To best replicate the actual workflow of an analyst I used AI to approach me (the analyst) as a company representative who needed a report for a pressing issue. I purposefully prompted the AI to make the initial request open ended so I could practice my communication skills to get a clearer scope of NorthStar metrics and final deliverables. However, I'd like to stress that this project was built by me and AI was used as a tool to further enhance workflow and put me in the actual role of an analyst. 

My goal for this project is to display my technical skills, and ability to think as an analyst. Now, although this may be a 'healthcare' analytics project, the guidelines for my thinking and workflow could be applied across many industries. The only factor that would change is the context and the domain. 

With that, I'd like to say I hope you enjoy this project! Feel free to let me know your thoughts (good or not so good). It took quite a bit of time but I enjoyed every second of it. Thank you!

- Gurkirat Singh (Data Analyst)

