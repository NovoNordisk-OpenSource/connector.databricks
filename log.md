## Issues found trying to use connector.databricks for a contributor

- Where to go internally to get connector.databricks to setup the accesses i.e. NovoAccess , it may be hard because its opensource but can help the user..
- Similar to issue above, Also from NovoAccess it doesnt show how to get the databricks URL.

Next step is to setup the YAML, what I did is just to copy the .yml file save it to root 

**connect**(**config** **=** **"_connector.yml"**)´

Gives me an error, could be more. verbose it says no URL, what field is it reading.

Error in `purrr::map()`:

ℹ In index: 1.

Caused by error in `try_connect()`:

! Problem in connection to the backend:

Error in DBI::dbConnect() : No Databricks workspace URL provided. ℹ Either supply `workspace` argument or set env var `DATABRICKS_HOST`.
