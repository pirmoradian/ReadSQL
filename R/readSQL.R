library(RSQLite)

# Path to the database file
fn = "/Users/sahar/Documents/Courses&Books/Database/ReadSQL-github/R/co"
drv = SQLite()
con = dbConnect(drv, fn)

# List tables
tblNames = dbListTables(con)
print(tblNames)

# List field names of a particular table
fldNames = dbListFields(con, "orders")
print(fldNames)

# Read a table
vals = dbReadTable(con, "orders")
print(vals)

sapply(vals, class)

# sends query, waits for it to finish, returns results
o = dbGetQuery(con, "SELECT * FROM orders")
print(o)
class(o)
sapply(o, class)

# only submits the SQL query to the database engine. It does not extract any records
rs = dbSendQuery(con, "SELECT * FROM orders LIMIT 1")
# To extract any records, you need to use the function dbFetch
fetch(rs, 1)
# when you finish fetching the records you need, rrees all resources (local and remote) associated with a result set.
dbClearResult(rs)


# Record functions in SQL and alias column name using AS
o = dbGetQuery(con, "SELECT amount * 2 AS amount_mult FROM orders")
print(o)

# multiple columns
o = dbGetQuery(con, "SELECT amount * 2 AS amount_mult, ROUND(amount) AS amount_round FROM orders")
print(o)

# Aggregate functiosn in SQL
o = dbGetQuery(con, "SELECT COUNT(amount) AS amount_count, AVG(amount) AS amount_avg, MAX(amount) AS amount_max FROM orders")
print(o)

# Group by - aggregate the subgroups
o = dbGetQuery(con, "SELECT customer_id, SUM(amount) FROM orders GROUP BY customer_id;")
print(o)

# Having - settign condition on the result of a query (WHERE is only used on the primary table, not on the result)
o = dbGetQuery(con, "SELECT customer_id, SUM(amount) AS total 
                     FROM orders GROUP BY customer_id
                     HAVING total > 100;")
print(o)

# Dynamic Query Strings in R
avg = dbGetQuery(con, "SELECT AVG(amount) FROM orders")
print(avg)
qry = sprintf("select * from orders where amount >= %f;", avg)
o = dbGetQuery(con, qry)
print(o)

# Using subqueries instead
o = dbGetQuery(con , "SELECT * FROM orders
                      WHERE amount >= (SELECT AVG(amount) FROM orders);")
print(o)

# You get Error because of misusing aggregation:
o = dbGetQuery(con , "SELECT amount, AVG(amount) as avg FROM orders
                      WHERE amount >= avg;")


# Inner join
o = dbGetQuery(con, "SELECT first_name, last_name, order_date, amount
                      FROM customer c
                      INNER JOIN orders o
                      ON c.customer_id = o.customer_id;")
print(o)

# disconnects from database
dbDisconnect(con)
