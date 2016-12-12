DROP DATABASE IF EXISTS `db_techopark`;
CREATE DATABASE `db_techopark`
USE `db_techopark`;
DROP TABLE IF EXISTS `forum`;
CREATE TABLE `forum` (
  `fID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(40) CHARACTER SET utf8 NOT NULL,
  `short_name` char(40) CHARACTER SET utf8 NOT NULL,
  `user` char(30) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`fID`),
  UNIQUE KEY `name_UNIQUE` (`name`),
  UNIQUE KEY `short_name_UNIQUE` (`short_name`),
  KEY `fk_forum_user` (`user`),
  CONSTRAINT `fk_forum_user` FOREIGN KEY (`user`) REFERENCES `user` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `post`;
CREATE TABLE `post` (
  `pID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parent` int(11) DEFAULT NULL,
  `isApproved` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `isHighlighted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `isEdited` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `isSpam` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `isDeleted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  `message` text CHARACTER SET utf8 NOT NULL,
  `user` char(30) CHARACTER SET utf8 NOT NULL,
  `forum` char(40) CHARACTER SET utf8 NOT NULL,
  `tID` int(11) unsigned NOT NULL,
  `likes` smallint(5) unsigned NOT NULL DEFAULT '0',
  `dislikes` smallint(5) unsigned NOT NULL DEFAULT '0',
  `points` smallint(6) NOT NULL DEFAULT '0',
  `mpath` char(200) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`pID`),
  KEY `user_date` (`user`,`date`),
  KEY `forum_date` (`forum`,`date`),
  KEY `thread_date` (`tID`,`date`)
) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `thread`;
CREATE TABLE `thread` (
  `tID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `isDeleted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `forum` char(40) CHARACTER SET utf8 NOT NULL,
  `isClosed` tinyint(1) unsigned NOT NULL,
  `user` char(30) CHARACTER SET utf8 NOT NULL,
  `date` datetime NOT NULL,
  `message` text COLLATE utf8_unicode_ci NOT NULL,
  `slug` char(50) CHARACTER SET utf8 NOT NULL,
  `dislikes` smallint(5) unsigned DEFAULT '0',
  `likes` smallint(5) unsigned DEFAULT '0',
  `points` smallint(6) DEFAULT '0',
  `posts` smallint(5) unsigned DEFAULT '0',
  `title` char(50) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`tID`),
  KEY `user_date` (`user`,`date`),
  KEY `forum_date` (`forum`,`date`),
  CONSTRAINT `fk_thread_user` FOREIGN KEY (`user`) REFERENCES `user` (`email`) ON DELETE CASCADE,
  CONSTRAINT `ft_thread_forum` FOREIGN KEY (`forum`) REFERENCES `forum` (`short_name`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `uID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `isAnonymous` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `username` char(30) CHARACTER SET utf8 DEFAULT NULL,
  `about` text CHARACTER SET utf8,
  `name` char(50) CHARACTER SET utf8 DEFAULT NULL,
  `email` char(30) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`uID`),
  UNIQUE KEY `email_UNIQUE` (`email`) USING BTREE,
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `user_thread`;
CREATE TABLE `user_thread` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user` char(30) NOT NULL,
  `tID` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ut_user` (`user`),
  KEY `fk_ut_thread` (`tID`),
  CONSTRAINT `fk_ut_thread` FOREIGN KEY (`tID`) REFERENCES `thread` (`tID`) ON DELETE CASCADE,
  CONSTRAINT `fk_ut_user` FOREIGN KEY (`user`) REFERENCES `user` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
DROP TABLE IF EXISTS `user_user`;
CREATE TABLE `user_user` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `follower` char(30) NOT NULL,
  `followee` char(30) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_uu_user_2` (`follower`),
  KEY `fk_uu_user_1` (`followee`),
  CONSTRAINT `fk_uu_user_1` FOREIGN KEY (`followee`) REFERENCES `user` (`email`) ON DELETE CASCADE,
  CONSTRAINT `fk_uu_user_2` FOREIGN KEY (`follower`) REFERENCES `user` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `clear`()
BEGIN
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE user;
TRUNCATE TABLE forum;
TRUNCATE TABLE thread;
TRUNCATE TABLE post;
TRUNCATE TABLE user_thread;
TRUNCATE TABLE user_user;
SET FOREIGN_KEY_CHECKS = 1;
END ;;
DELIMITER ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_post`(_date DATETIME, threadID INT(11), message TEXT, user CHAR(30), forum CHAR(40), parent INT(11), isApproved TINYINT(1), isHighlighted TINYINT(1), isEdited TINYINT(1), isSpam TINYINT(1), isDeleted TINYINT(1))
BEGIN
DECLARE ID INT(8) ZEROFILL;
DECLARE MATPATH CHAR(200);
DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

START TRANSACTION;

INSERT INTO post (date, tID, message, user, forum, parent, isApproved, isHighlighted, isEdited, isSpam, isDeleted) VALUES (_date, threadID, message, user, forum, parent, isApproved, isHighlighted, isEdited, isSpam, isDeleted);
SET ID = IF((SELECT COUNT(*) FROM post)=0, LAST_INSERT_ID()-1, LAST_INSERT_ID());
SET MATPATH=IF(parent IS NULL, CAST(ID AS CHAR), CONCAT_WS('.', (SELECT mpath FROM post WHERE pID=parent), CAST(ID AS CHAR)));
UPDATE post SET mpath=MATPATH WHERE pID=ID;
UPDATE thread SET posts=posts+1 WHERE tID = threadID;

COMMIT;


SELECT ID;
END ;;
DELIMITER ;
ALTER DATABASE `db_techopark` CHARACTER SET utf8 COLLATE utf8_general_ci ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `status`()
BEGIN
DECLARE user INT;
DECLARE thread INT;
DECLARE forum INT;
DECLARE post INT;

SELECT COUNT(*) INTO user FROM user;
SELECT COUNT(*) INTO thread FROM thread;
SELECT COUNT(*) INTO forum FROM forum;
SELECT COUNT(*) INTO post FROM post;

SELECT user, thread, forum, post;
END ;;
DELIMITER ;

ALTER DATABASE `db_techopark` CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
