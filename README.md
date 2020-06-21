# SUDESA
Suivi Demographique et de Santé (Health Demographic Surveillance) for Lambarene town in Gabon.

## Description
This project will enable:

- To generate a report each week
- To show the daily working each field worker
- To perform the statistical demographical
- To perform the mapping
- To generate queries for constencies errors


## Functions developped:
- **SUDESA_report**: This function generates three differents reports. This function is going
    to connect automatically to CERMEL local server to have access to SUDESA
    data updated and saved on OpenHDS server and PostGIS.
    1. Report for Human Ressources Direction (Monthly)
    2. Summary Report for Research teams at CERMEL (Weekly)
    3. Full Report with the demographic statistics update and mapping
 
- **SUDESA_query**: This function generates the queries concerning the constencies errors done by fields workers each week.
