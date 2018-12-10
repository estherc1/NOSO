library(RSQLite)
library(data.table)


csvpath = "/Users/hee-wonchang/Downloads/shiny_db_demo/flights14.csv"
dbname = "./flights.sqlite"
tblname = "flights"
## read csv
data <- fread(input = csvpath,
              sep = ",",
              header = TRUE)
## connect to database
conn <- dbConnect(drv = SQLite(), 
                  dbname = dbname)
## write table
dbWriteTable(conn = conn,
             name = tblname,
             value = data)
## list tables
dbListTables(conn)
## disconnect
dbDisconnect(conn)
