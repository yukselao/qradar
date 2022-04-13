
I have created two scripts. insert.sh and select.sh. insert.sh is used for inserting sample data to user table. select.sh is used for viewing data in the user table.

Before starting tests you should create database and database user.

Log Source settings:

![image](https://user-images.githubusercontent.com/2484823/163124517-306c31fe-a340-406a-bbed-81b8c037e4a8.png)



## create user and grant access for testdb
```
CREATE USER 'testdbuser'@'%' IDENTIFIED BY '9yLX795du%8b';
ALTER USER 'testdbuser'@'%' IDENTIFIED WITH mysql_native_password BY '9yLX795du%8b';
GRANT ALL ON testdb.* TO 'testdbuser'@'%';
```
## create user table and insert sample data
```
user testdb;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int DEFAULT NULL,
  `user_type` varchar(50) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO `user` (`employee_id`, `user_type`, `username`, `password`) VALUES
                   (NULL, 'SUPER ADMIN', 'admin', 'admin'),
                   (1, 'NORMAL', 'ali', 'password1'),
                   (2, 'ADMIN', 'veli', 'password2'),
                   (3, 'ADMIN', 'ayse', 'password3'),
                   (4, 'NORMAL', 'asya', 'password4'),
                   (7, 'ADMIN', 'emel', 'password5'),
                   (8, 'NORMAL', 'kartal', 'password6');
```

:octocat:
