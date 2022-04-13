
### create user and grant access for testdb
```
CREATE USER 'testdbuser'@'%' IDENTIFIED BY '9yLX795du%8b';
ALTER USER 'testdbuser'@'%' IDENTIFIED WITH mysql_native_password BY '9yLX795du%8b';
GRANT ALL ON testdb.* TO 'testdbuser'@'%';
```
### create user table and insert sample data
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
