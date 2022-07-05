We are going to run simple scripts to setup our MongoDB replica set which will:

- Install MongoDB
- Create admin user
- Create keyfile for security purposes
- edit mongo config file

Launch 3 AWS EC2 instances. I have launched Ubuntu instances for our replica set.

On primary node:

`sh mongo-primary.sh DNS-address/Internal-IP replica-set-name`

Note: Change password of admin user in script in line 22

On secondary nodes:

`sh mongo-secondary.sh DNS-address/Internal-IP replica-set-name`

Copy contents of /opt/mongo-keyfile file from primary node to secondary nodes and restart mongod service:

`systemctl restart mongod`

**Start Replication and Add Members**

connect to the Mongo with the admin user:

`mongo -u admin -p --authenticationDatabase admin`

Initiate the replica set:

`rs.initiate()`

add second and third nodes as a member:

`rs.add("node-ip-address/DNS address")`

Check the status of all nodes:

`rs.status()`

Replica set is ready to serve mongoDB. You can connect to it either by URI or MongoDB compass.

**MongoDB Basic Commands**

Create user:

`db.createUser(
  {
    user: "test",
    pwd: "test123",
    roles: [ { role: "readWrite", db: "test" } ]
  }
)`

Update user:

`db.updateUser( "test",
               {
                 roles : ["clusterMonitor"]
                }
             )`
             
Delete user:

`db.dropUser("test")`

Create Collection in a database:

`db.createCollection("test_collection")`
