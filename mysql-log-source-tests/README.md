Let's say you are working on a scenario where you want to redirect a stream from a table in a mysql database to QRadar. In this case, you may want to test whether the stream is working properly. The contents in this project were created to test whether data is transmitted over the stream in a healthy way.

I have created two scripts. insert.sh and select.sh. insert.sh is used for inserting sample data to user table. select.sh is used for viewing data in the user table.

Before starting tests you should create database and database user.

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

insert.sh usage:
```
[root@IBM-QRadar mysql-test]#  ./insert.sh <record-count> <sleep-in-seconds>
```

select.sh usage:
```
[root@IBM-QRadar mysql-test]# ./select.sh
+----+-------------+------------+----------+--------------+
| id | employee_id | user_type  | username | password     |
+----+-------------+------------+----------+--------------+
| 17 |        NULL | testuser10 | testuser | testpassword |
| 16 |        NULL | testuser9  | testuser | testpassword |
| 15 |        NULL | testuser8  | testuser | testpassword |
| 14 |        NULL | testuser7  | testuser | testpassword |
| 13 |        NULL | testuser6  | testuser | testpassword |
| 12 |        NULL | testuser5  | testuser | testpassword |
| 11 |        NULL | testuser4  | testuser | testpassword |
| 10 |        NULL | testuser3  | testuser | testpassword |
|  9 |        NULL | testuser2  | testuser | testpassword |
|  8 |        NULL | testuser1  | testuser | testpassword |
+----+-------------+------------+----------+--------------+
```



Log Source settings:

![image](https://user-images.githubusercontent.com/2484823/163124517-306c31fe-a340-406a-bbed-81b8c037e4a8.png)

Log Source management legacy interface url:

https://XX.XX.XX.XX/console/do/core/genericsearchlist?appName=eventviewer&pageId=SensorDeviceList

