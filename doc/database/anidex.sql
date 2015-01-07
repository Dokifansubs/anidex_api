-- MySQL Script generated by MySQL Workbench
-- 01/07/15 22:22:02
-- Model: New Model    Version: 1.0
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema anidex
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `anidex` ;
CREATE SCHEMA IF NOT EXISTS `anidex` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `anidex` ;

-- -----------------------------------------------------
-- Table `anidex`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`user` ;

CREATE TABLE IF NOT EXISTS `anidex`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `email` VARCHAR(200) NOT NULL,
  `password` VARCHAR(200) NOT NULL,
  `login_attempts` INT NOT NULL DEFAULT 0,
  `last_login` DATETIME NOT NULL,
  `joined_date` DATETIME NOT NULL,
  `api_key` VARCHAR(200) NOT NULL,
  `email_verified` TINYINT(2) NOT NULL DEFAULT 0,
  `active` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `api_key_UNIQUE` (`api_key` ASC),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';


-- -----------------------------------------------------
-- Table `anidex`.`group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`group` ;

CREATE TABLE IF NOT EXISTS `anidex`.`group` (
  `id` INT NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `website` VARCHAR(200) NULL,
  `tag` VARCHAR(200) NOT NULL,
  `irc_channel` VARCHAR(200) NULL,
  `irc_server` VARCHAR(200) NULL,
  `pseudo` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC),
  UNIQUE INDEX `tag_UNIQUE` (`tag` ASC))
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';


-- -----------------------------------------------------
-- Table `anidex`.`category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`category` ;

CREATE TABLE IF NOT EXISTS `anidex`.`category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`torrent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`torrent` ;

CREATE TABLE IF NOT EXISTS `anidex`.`torrent` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `size` INT NOT NULL,
  `owner_id` INT NOT NULL,
  `category` INT NOT NULL,
  `batch` TINYINT(1) NOT NULL DEFAULT 0,
  `comments` INT NOT NULL DEFAULT 0,
  `created_date` DATETIME NOT NULL,
  `deleted_date` DATETIME NULL,
  `data` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_torrent_user_idx` (`owner_id` ASC),
  INDEX `fk_torrent_category_idx` (`category` ASC),
  CONSTRAINT `fk_torrent_user`
    FOREIGN KEY (`owner_id`)
    REFERENCES `anidex`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_torrent_category`
    FOREIGN KEY (`category`)
    REFERENCES `anidex`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';


-- -----------------------------------------------------
-- Table `anidex`.`tracker`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`tracker` ;

CREATE TABLE IF NOT EXISTS `anidex`.`tracker` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `url` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';


-- -----------------------------------------------------
-- Table `anidex`.`torrent_stats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`torrent_stats` ;

CREATE TABLE IF NOT EXISTS `anidex`.`torrent_stats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `info_hash` VARCHAR(40) NOT NULL,
  `seeders` INT UNSIGNED NOT NULL,
  `leechers` INT UNSIGNED NOT NULL,
  `completed` INT UNSIGNED NOT NULL,
  `torrent_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `info_hash_UNIQUE` (`info_hash` ASC),
  INDEX `fk_torrent_stats_torrent1_idx` (`torrent_id` ASC),
  UNIQUE INDEX `torrent_id_UNIQUE` (`torrent_id` ASC),
  CONSTRAINT `fk_torrent_stats_torrent1`
    FOREIGN KEY (`torrent_id`)
    REFERENCES `anidex`.`torrent` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`torrent_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`torrent_group` ;

CREATE TABLE IF NOT EXISTS `anidex`.`torrent_group` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `group_id` INT NOT NULL,
  `torrent_id` INT NOT NULL,
  `api_key` VARCHAR(200) NOT NULL,
  INDEX `fk_group_has_torrent_torrent1_idx` (`torrent_id` ASC),
  INDEX `fk_group_has_torrent_group1_idx` (`group_id` ASC),
  PRIMARY KEY (`id`),
  UNIQUE INDEX `api_key_UNIQUE` (`api_key` ASC),
  CONSTRAINT `fk_group_has_torrent_group`
    FOREIGN KEY (`group_id`)
    REFERENCES `anidex`.`group` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_has_torrent_torrent`
    FOREIGN KEY (`torrent_id`)
    REFERENCES `anidex`.`torrent` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';


-- -----------------------------------------------------
-- Table `anidex`.`torrent_tracker`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`torrent_tracker` ;

CREATE TABLE IF NOT EXISTS `anidex`.`torrent_tracker` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tracker_id` INT NOT NULL,
  `torrent_id` INT NOT NULL,
  INDEX `fk_tracker_has_torrent_torrent1_idx` (`torrent_id` ASC),
  INDEX `fk_tracker_has_torrent_tracker1_idx` (`tracker_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_tracker_has_torrent_tracker1`
    FOREIGN KEY (`tracker_id`)
    REFERENCES `anidex`.`tracker` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tracker_has_torrent_torrent1`
    FOREIGN KEY (`torrent_id`)
    REFERENCES `anidex`.`torrent` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';


-- -----------------------------------------------------
-- Table `anidex`.`user_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`user_group` ;

CREATE TABLE IF NOT EXISTS `anidex`.`user_group` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `group_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  INDEX `fk_group_has_user_user1_idx` (`user_id` ASC),
  INDEX `fk_group_has_user_group1_idx` (`group_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_group_has_user_group1`
    FOREIGN KEY (`group_id`)
    REFERENCES `anidex`.`group` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_has_user_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `anidex`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';


-- -----------------------------------------------------
-- Table `anidex`.`comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`comment` ;

CREATE TABLE IF NOT EXISTS `anidex`.`comment` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `text` TEXT NOT NULL,
  `date_posted` DATETIME NOT NULL,
  `user_id` INT NOT NULL,
  `torrent_id` INT NOT NULL,
  `parent_comment` INT NULL,
  `deleted` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_comment_user1_idx` (`user_id` ASC),
  INDEX `fk_comment_torrent1_idx` (`torrent_id` ASC),
  CONSTRAINT `fk_comment_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `anidex`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_torrent1`
    FOREIGN KEY (`torrent_id`)
    REFERENCES `anidex`.`torrent` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`user_settings_upload`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`user_settings_upload` ;

CREATE TABLE IF NOT EXISTS `anidex`.`user_settings_upload` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `default_tt` TINYINT(1) NOT NULL DEFAULT 0,
  `default_category` INT NOT NULL DEFAULT 1,
  `default_adult` TINYINT(1) NOT NULL DEFAULT 0,
  `default_description` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_settings_upload_category_idx` (`default_category` ASC),
  INDEX `fk_user_user_settings_upload_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_settings_upload_category`
    FOREIGN KEY (`default_category`)
    REFERENCES `anidex`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_user_settings_upload`
    FOREIGN KEY (`user_id`)
    REFERENCES `anidex`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`user_settings_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`user_settings_view` ;

CREATE TABLE IF NOT EXISTS `anidex`.`user_settings_view` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `default_adult` TINYINT(1) NULL DEFAULT 0,
  `theme` INT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `fk_user_user_settings_view_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_user_settings_view`
    FOREIGN KEY (`user_id`)
    REFERENCES `anidex`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`group_permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`group_permissions` ;

CREATE TABLE IF NOT EXISTS `anidex`.`group_permissions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_group_id` INT NOT NULL,
  `add_torrent` TINYINT(1) NOT NULL DEFAULT 0,
  `delete_torrent` TINYINT(1) NOT NULL DEFAULT 0,
  `edit_torrent` TINYINT(1) NOT NULL DEFAULT 0,
  `add_member` TINYINT(1) NOT NULL DEFAULT 0,
  `delete_member` TINYINT(1) NOT NULL DEFAULT 0,
  `change_permissions` TINYINT(1) NOT NULL DEFAULT 0,
  `approve_pseudo` TINYINT(1) NOT NULL DEFAULT 0,
  `request_tag` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_user_group_group_permissions_idx` (`user_group_id` ASC),
  CONSTRAINT `fk_user_group_group_permissions`
    FOREIGN KEY (`user_group_id`)
    REFERENCES `anidex`.`user_group` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';


-- -----------------------------------------------------
-- Table `anidex`.`admin_permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`admin_permissions` ;

CREATE TABLE IF NOT EXISTS `anidex`.`admin_permissions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `view_log` TINYINT(1) NOT NULL DEFAULT 0,
  `approve_user` TINYINT(1) NOT NULL DEFAULT 0,
  `remove_user` TINYINT(1) NOT NULL DEFAULT 0,
  `approve_group` TINYINT(1) NOT NULL DEFAULT 0,
  `edit_group` TINYINT(1) NOT NULL DEFAULT 0,
  `delete_group` TINYINT(1) NOT NULL DEFAULT 0,
  `approve_tag` TINYINT(1) NOT NULL DEFAULT 0,
  `edit_torrent` TINYINT(1) NOT NULL DEFAULT 0,
  `delete_torrent` TINYINT(1) NOT NULL DEFAULT 0,
  `approve_comment` TINYINT(1) NOT NULL DEFAULT 0,
  `edit_comment` TINYINT(1) NOT NULL DEFAULT 0,
  `delete_comment` TINYINT(1) NOT NULL DEFAULT 0,
  `edit_settings` TINYINT(1) NOT NULL DEFAULT 0,
  `change_permissions` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_user_admin_permission_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_admin_permission`
    FOREIGN KEY (`user_id`)
    REFERENCES `anidex`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`log`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`log` ;

CREATE TABLE IF NOT EXISTS `anidex`.`log` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `action` TEXT NOT NULL,
  `error` TEXT NULL,
  `level` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_log_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_log`
    FOREIGN KEY (`user_id`)
    REFERENCES `anidex`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`user_rss`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`user_rss` ;

CREATE TABLE IF NOT EXISTS `anidex`.`user_rss` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `torrent_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_id_idx` (`user_id` ASC),
  INDEX `fk_torrent_id_idx` (`torrent_id` ASC),
  CONSTRAINT `fk_user_user_rss_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `anidex`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_torrent_user_rss_id`
    FOREIGN KEY (`torrent_id`)
    REFERENCES `anidex`.`torrent` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`server_settings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`server_settings` ;

CREATE TABLE IF NOT EXISTS `anidex`.`server_settings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `option` VARCHAR(255) NOT NULL,
  `value` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `option_UNIQUE` (`option` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`peers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`peers` ;

CREATE TABLE IF NOT EXISTS `anidex`.`peers` (
  `id` VARCHAR(80) NOT NULL,
  `peer_id` VARCHAR(40) NOT NULL,
  `info_hash` VARCHAR(40) NOT NULL,
  `ipv4` VARCHAR(45) NULL,
  `ipv6` VARCHAR(45) NULL,
  `port` INT UNSIGNED NOT NULL,
  `uploaded` INT UNSIGNED NOT NULL,
  `downloaded` INT UNSIGNED NOT NULL,
  `left` INT UNSIGNED NOT NULL,
  `last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_info_hash_idx` (`info_hash` ASC),
  CONSTRAINT `fk_info_hash`
    FOREIGN KEY (`info_hash`)
    REFERENCES `anidex`.`torrent_stats` (`info_hash`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`group_announce`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`group_announce` ;

CREATE TABLE IF NOT EXISTS `anidex`.`group_announce` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `group_id` INT NOT NULL,
  `irc_channel` VARCHAR(45) NOT NULL,
  `irc_server` VARCHAR(45) NOT NULL,
  `use_anidex` TINYINT(1) NOT NULL DEFAULT 1,
  `message` TEXT NULL,
  `use_botserv` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `fk_group_group_announce_idx` (`group_id` ASC),
  CONSTRAINT `fk_group_group_announce`
    FOREIGN KEY (`group_id`)
    REFERENCES `anidex`.`group` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `anidex` ;

-- -----------------------------------------------------
-- Placeholder table for view `anidex`.`torrents_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `anidex`.`torrents_view` (`name` INT, `comments` INT, `size` INT, `created_date` INT, `category_name` INT, `seeders` INT, `leechers` INT, `completed` INT);

-- -----------------------------------------------------
-- View `anidex`.`torrents_view`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `anidex`.`torrents_view` ;
DROP TABLE IF EXISTS `anidex`.`torrents_view`;
USE `anidex`;
CREATE  OR REPLACE VIEW `torrents_view` AS SELECT `torrent`.`name`, `torrent`.`comments`, `torrent`.`size`, `torrent`.`created_date`,
	`category`.`name` AS `category_name`,
	`torrent_stats`.`seeders`, `torrent_stats`.`leechers`, `torrent_stats`.`completed`
FROM `torrent`
INNER JOIN `torrent_stats`
ON `torrent`.`id` = `torrent_stats`.`torrent_id`
INNER JOIN `category`
ON `category`.`id` = `torrent`.`category`;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `anidex`;

DELIMITER $$

USE `anidex`$$
DROP TRIGGER IF EXISTS `anidex`.`user_AINS` $$
USE `anidex`$$
CREATE TRIGGER `user_AINS` AFTER INSERT ON `user` FOR EACH ROW
BEGIN
	INSERT INTO `user_settings_view` (`user_id`) VALUES(NEW.`id`);
	INSERT INTO `admin_permissions` (`user_id`) VALUES(NEW.`id`);
	INSERT INTO `user_settings_view` (`user_id`) VALUES(NEW.`id`);
END$$


USE `anidex`$$
DROP TRIGGER IF EXISTS `anidex`.`user_group_AINS` $$
USE `anidex`$$
CREATE TRIGGER `user_group_AINS` AFTER INSERT ON `user_group` FOR EACH ROW
BEGIN
	INSERT INTO `group_permissions` (`user_group_id`) VALUES(NEW.`id`);
END$$


USE `anidex`$$
DROP TRIGGER IF EXISTS `anidex`.`comment_AINS` $$
USE `anidex`$$
CREATE TRIGGER `comment_AINS` AFTER INSERT ON `comment` FOR EACH ROW
BEGIN
	UPDATE `torrent` SET `comments` = `comments` + 1 WHERE `id` = NEW.`torrent_id`;
END$$


USE `anidex`$$
DROP TRIGGER IF EXISTS `anidex`.`comment_ADEL` $$
USE `anidex`$$
CREATE TRIGGER `comment_ADEL` AFTER DELETE ON `comment` FOR EACH ROW
BEGIN
	UPDATE `torrent` SET `comments` = `comments` - 1 WHERE `id` = OLD.`torrent_id`;
END$$


USE `anidex`$$
DROP TRIGGER IF EXISTS `anidex`.`peers_ADEL` $$
USE `anidex`$$
CREATE TRIGGER `peers_ADEL` AFTER DELETE ON `peers` FOR EACH ROW
BEGIN
	IF old.`left` > 0 THEN
		UPDATE `torrent_stats` SET `leechers` = `leechers` - 1 WHERE `info_hash` = OLD.`info_hash`;
	ELSE
		UPDATE `torrent_stats` SET `seeders` = `seeders` - 1 WHERE `info_hash` = OLD.`info_hash`;
	END IF;
END$$


USE `anidex`$$
DROP TRIGGER IF EXISTS `anidex`.`peers_AINS` $$
USE `anidex`$$
CREATE TRIGGER `peers_AINS` AFTER INSERT ON `peers` FOR EACH ROW
BEGIN
	IF new.`left` > 0 THEN
		UPDATE `torrent_stats` SET `leechers` = `leechers` + 1 WHERE `info_hash` = NEW.`info_hash`;
	ELSE
		UPDATE `torrent_stats` SET `seeders` = `seeders` + 1 WHERE `info_hash` = NEW.`info_hash`;
	END IF;
END$$


USE `anidex`$$
DROP TRIGGER IF EXISTS `anidex`.`peers_AUPD` $$
USE `anidex`$$
CREATE TRIGGER `peers_AUPD` AFTER UPDATE ON `peers` FOR EACH ROW
BEGIN
	IF OLD.`left` > 0 AND NEW.`left` = 0 THEN
		UPDATE `torrent_stats` SET `leechers` = `leechers` - 1, `seeders` = `seeders` + 1, `completed` = `completed` + 1 WHERE `info_hash` = NEW.`info_hash`;
	END IF;
END$$


DELIMITER ;
