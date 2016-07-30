################################# Importing data from relational databases #################################

################## Step 1: Establish a connection ##################
# Load the DBI package
library(DBI)

# Edit dbConnect() call
# Change the port argument (3306) and user argument ("student").
con <- dbConnect(
    RMySQL::MySQL(), 
    dbname = "tweater", 
    host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com", 
    port = 3306,
    user = "student",
    password = "datacamp"
    )
  
# Print out con
con

################## Step 2: List the database tables ##################
# Build a vector of table names: tables
tables <- dbListTables(con)

# Display structure of tables
str(tables)

################## Step 3: Import data from a table ##################
# Import the users table from tweater: users
users <- dbReadTable(con, "users")

# Print users
users

# Import and print the tweats table from tweater: tweats
tweats <- dbReadTable(con, "tweats")
tweats

# Import and print the comments table from tweater: comments
comments <- dbReadTable(con,"comments")
comments

################################# SQL Queries from inside R #################################

################## My very first SQL query ##################
# Connect to the database
library(DBI)
con <- dbConnect(
    RMySQL::MySQL(), 
    dbname = "tweater", 
    host = "courses.csrrinzqubik.us-east-1.rds.amazonaws.com", 
    port = 3306,
    user = "student",
    password = "datacamp"
    )

# Import post column of tweats where date is higher than "2015-09-21": latest
latest <- dbGetQuery(con, "SELECT post FROM tweats WHERE date > '2015-09-21'")

# Import tweat_id column of comments where user_id is 1: elisabeth
elisabeth <- dbGetQuery(con, "SELECT tweat_id FROM comments WHERE user_id = 1")

# Print latest and elisabeth
latest
elisabeth

################## More advanced SQL queries ##################
# Create data frame specific
# Select the message column from the comments table where the tweat_id is 77 and the user_id is greater than 4.
specific <- dbGetQuery(
            con, 
            "SELECT message 
            FROM comments 
            WHERE tweat_id = 77 AND user_id > 4"
            )

# Create data frame short
# Select the id and name columns from the users table where the number of characters in the name is under 5
short <- dbGetQuery(
            con, 
            "SELECT id, name 
            FROM users 
            WHERE CHAR_LENGTH(name) < 5"
            )

# Print specific and short
specific
short

################## Send - Fetch - Clear ##################
# Send query to the database
res <- dbSendQuery(con, "SELECT message FROM comments WHERE user_id > 4")

# Use dbFetch() twice
# In the first call, import only two records of the query result by setting the n argument to 2.
dbFetch(res, n = 2)
# In the second call, import all remaning queries (don't specify n). 
dbFetch(res)

# Clear res
dbClearResult(res)

################## Be polite and ... ##################
# Create the data frame  long_tweats
# Select the post and date columns from the observations in tweats where the character length of the post variable exceeds 40
long_tweats <- dbGetQuery(con, "SELECT post, date FROM tweats WHERE CHAR_LENGTH(post) > 40")

# Print long_tweats
print(long_tweats)

# Disconnect from the database
dbDisconnect(con)
