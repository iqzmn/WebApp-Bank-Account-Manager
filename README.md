# WebApp-Bank-Account-Manager
Simple web application where you can create and control finance accounts as by user or admin role.

###### Used technologies:
- JDK 10
- Apache Tomcat 9
- Spring 5: Spring MVC, Spring Security
  
- MySQL 8
- Hibernate 5.3.0
- Maven

- WEB: JSP, Bootstrap 4, jQuery

###### Screenshots:

![login](https://github.com/Qzmin/WebApp-Bank-Account-Manager/blob/master/data/login.png)
![admin](https://github.com/Qzmin/WebApp-Bank-Account-Manager/blob/master/data/admin.png)
![profile](https://github.com/Qzmin/WebApp-Bank-Account-Manager/blob/master/data/profile.png)
![accounts](https://github.com/Qzmin/WebApp-Bank-Account-Manager/blob/master/data/accounts.png)
![handle](https://github.com/Qzmin/WebApp-Bank-Account-Manager/blob/master/data/handle.png)


###### Tables to create:

```sql
CREATE TABLE `app_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sso_id` varchar(30) NOT NULL,
  `password` varchar(100) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sso_id` (`sso_id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8
```

```sql
CREATE TABLE `app_user_user_profile` (
  `user_id` bigint(20) NOT NULL,
  `user_profile_id` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`,`user_profile_id`),
  KEY `FK_USER_PROFILE` (`user_profile_id`),
  CONSTRAINT `FK_APP_USER` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`),
  CONSTRAINT `FK_USER_PROFILE` FOREIGN KEY (`user_profile_id`) REFERENCES `user_profile` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```

```sql
CREATE TABLE `persistent_logins` (
  `username` varchar(64) NOT NULL,
  `series` varchar(64) NOT NULL,
  `token` varchar(64) NOT NULL,
  `last_used` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`series`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```

```sql
CREATE TABLE `user_account` (
  `user_id` bigint(20) NOT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_number` bigint(20) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `date_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `amount_user` (`user_id`),
  CONSTRAINT `amount_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8
```

```sql
CREATE TABLE `user_avatar` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `content` longblob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `avatar_user` (`user_id`),
  CONSTRAINT `avatar_user` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8
```

```sql
CREATE TABLE `user_profile` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8
```

```sql
INSERT INTO USER_PROFILE(type)
VALUES ('USER');
INSERT INTO USER_PROFILE(type)
VALUES ('ADMIN');
```
