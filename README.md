# Convert-ClubspotExport
A simple parser to convert Clubspot entry export files into contact import files.

.\Convert-ClubsportExport –importfile filename –skipperonly –unique > exportfile
  -importfile mandatory, path and name of data file exported from Clubspot to convert
  -skipperonly include only first name in the list of participants for each entry
  -unique export only unique email addresses
