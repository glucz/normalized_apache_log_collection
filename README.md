# Normalized apache log collection
Conversion and normalization of apache logs into MySQL database for long term storage and research

## Table of Contents
- [About](#about)
- [Quick start](#quick-start)
  + [Prerequisites](#prerequisites)
  + [Run](#run)
  + [Build](#build)
- [Environment variables](#environment-variables)

## About
This script will read an apache log and dissect it into domains, IP addresses, user agents, query types and response codes.
Each nugget is stored in a separate table and the actual log is converted into a hits table with references to the original data.
This will make the data much more compact and ready for systematic analysis

## Quick start

### Prerequisites
- MySQL
- TokuDB storage engine
- Perl
- Perl DBD/DBI for MySQL

### Run
* Manually
`./proclog.pl <name_of_log_file>`

### Build
* No build is required


### Runtime variables
| RUNTIME VARIABLE       | DESCRIPTION                                            |
| ---------------------- | ------------------------------------------------------ |
| `agentinfo_database`   | Name of the log collection database                    |
| `agentinfo_username`   | MySQL username for the log collection database         |
| `agentinfo_password`   | MySQL password for the log collection database         |
| `iplocation_database`  | Name of IPLocation geolocation database                |
| `iplocation_username`  | MySQL username for the IPLocation collection database  |
| `iplocation_password`  | MySQL password for the IPLocation collection database  |
