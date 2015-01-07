-- MySQL Script generated by MySQL Workbench
-- 01/07/15 02:36:20
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
-- Table `anidex`.`settings_upload`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`settings_upload` ;

CREATE TABLE IF NOT EXISTS `anidex`.`settings_upload` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `api_key` VARCHAR(45) NULL,
  `default_tt` TINYINT(1) NULL DEFAULT 0,
  `default_category` INT NOT NULL DEFAULT 1,
  `default_adult` TINYINT(1) NULL DEFAULT 0,
  `default_description` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_settings_upload_category_idx` (`default_category` ASC),
  CONSTRAINT `fk_user_settings_upload_category`
    FOREIGN KEY (`default_category`)
    REFERENCES `anidex`.`category` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`user_settings_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`user_settings_view` ;

CREATE TABLE IF NOT EXISTS `anidex`.`user_settings_view` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `default_adult` TINYINT(1) NULL DEFAULT 0,
  `default_category` INT NULL DEFAULT 1,
  `theme` INT NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`admin_permission`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`admin_permission` ;

CREATE TABLE IF NOT EXISTS `anidex`.`admin_permission` (
  `id` INT NOT NULL AUTO_INCREMENT,
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
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


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
  `settings_upload_id` INT NOT NULL,
  `settings_view_id` INT NOT NULL,
  `permissions` INT NOT NULL,
  `api_key` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_user_settings_view1_idx` (`settings_view_id` ASC),
  INDEX `fk_user_settings_upload_idx` (`settings_upload_id` ASC),
  INDEX `fk_user_permissions_idx` (`permissions` ASC),
  UNIQUE INDEX `api_key_UNIQUE` (`api_key` ASC),
  CONSTRAINT `fk_user_settings_upload`
    FOREIGN KEY (`settings_upload_id`)
    REFERENCES `anidex`.`settings_upload` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_settings_view`
    FOREIGN KEY (`settings_view_id`)
    REFERENCES `anidex`.`user_settings_view` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_permissions`
    FOREIGN KEY (`permissions`)
    REFERENCES `anidex`.`admin_permission` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';


-- -----------------------------------------------------
-- Table `anidex`.`group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`group` ;

CREATE TABLE IF NOT EXISTS `anidex`.`group` (
  `id` INT NOT NULL,
  `name` VARCHAR(200) NULL,
  `website` VARCHAR(200) NULL,
  `tag` VARCHAR(200) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';


-- -----------------------------------------------------
-- Table `anidex`.`torrent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`torrent` ;

CREATE TABLE IF NOT EXISTS `anidex`.`torrent` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `likes` INT NULL,
  `size` INT NULL,
  `owner_id` INT NOT NULL,
  `created_date` DATETIME NOT NULL,
  `deleted_date` DATETIME NULL,
  `category` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_torrent_user_idx` (`owner_id` ASC),
  INDEX `fk_torrent_category_idx` (`category` ASC),
  CONSTRAINT `fk_torrent_user`
    FOREIGN KEY (`owner_id`)
    REFERENCES `anidex`.`user` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_torrent_category`
    FOREIGN KEY (`category`)
    REFERENCES `anidex`.`category` (`id`)
    ON DELETE CASCADE
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
-- Table `anidex`.`torrent_fileinfo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`torrent_fileinfo` ;

CREATE TABLE IF NOT EXISTS `anidex`.`torrent_fileinfo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `torrent_id` INT NOT NULL,
  `name` VARCHAR(200) NULL,
  `data` TEXT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_torrent_fileinfo_torrent1`
    FOREIGN KEY (`torrent_id`)
    REFERENCES `anidex`.`torrent` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `anidex`.`torrent_stats`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`torrent_stats` ;

CREATE TABLE IF NOT EXISTS `anidex`.`torrent_stats` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `info_hash` VARCHAR(40) NULL,
  `seeders` INT NULL,
  `leechers` INT NULL,
  `completed` INT NULL,
  `torrent_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `info_hash_UNIQUE` (`info_hash` ASC),
  INDEX `fk_torrent_stats_torrent1_idx` (`torrent_id` ASC),
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
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '<double-click to overwrite multiple objects>';


-- -----------------------------------------------------
-- Table `anidex`.`group_permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `anidex`.`group_permissions` ;

CREATE TABLE IF NOT EXISTS `anidex`.`group_permissions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `add_torrent` TINYINT(1) NOT NULL DEFAULT 0,
  `delete_torrent` TINYINT(1) NOT NULL DEFAULT 0,
  `edit_torrent` TINYINT(1) NOT NULL DEFAULT 0,
  `add_member` TINYINT(1) NOT NULL DEFAULT 0,
  `delete_member` TINYINT(1) NOT NULL DEFAULT 0,
  `change_permissions` TINYINT(1) NOT NULL DEFAULT 0,
  `approve_pseudo` TINYINT(1) NOT NULL DEFAULT 0,
  `request_tag` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`))
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
  `pseudo` TINYINT(1) NOT NULL DEFAULT 0,
  `permission_id` INT NOT NULL,
  INDEX `fk_group_has_user_user1_idx` (`user_id` ASC),
  INDEX `fk_group_has_user_group1_idx` (`group_id` ASC),
  INDEX `fk_permissions_idx` (`permission_id` ASC),
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
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_permissions`
    FOREIGN KEY (`permission_id`)
    REFERENCES `anidex`.`group_permissions` (`id`)
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
  PRIMARY KEY (`id`),
  INDEX `fk_comment_user1_idx` (`user_id` ASC),
  INDEX `fk_comment_torrent1_idx` (`torrent_id` ASC),
  CONSTRAINT `fk_comment_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `anidex`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_torrent1`
    FOREIGN KEY (`torrent_id`)
    REFERENCES `anidex`.`torrent` (`id`)
    ON DELETE NO ACTION
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
  `level` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_user_id_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `anidex`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
