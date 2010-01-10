SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';


-- -----------------------------------------------------
-- Table `countries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `countries` ;

CREATE TABLE IF NOT EXISTS `countries` (
  `id` int(3) NOT NULL AUTO_INCREMENT,
  `iso` char(2) NOT NULL,
  `iso3` char(3) DEFAULT NULL,
  `name` varchar(255) NOT NULL COMMENT 'International Direct Dialling (IDD) (also called a international call prefix or international access code) code used to dial out of the country',
  `lat` double DEFAULT NULL,
  `lng` double DEFAULT NULL,
  `adjectival` varchar(255) DEFAULT NULL,
  `denonym` varchar(255) DEFAULT NULL,
  `colloquial` varchar(255) DEFAULT NULL,
  `numcode` smallint(6) DEFAULT NULL,
  `article` tinyint(1) NOT NULL DEFAULT '0',
  `continent` char(2) NOT NULL,
  PRIMARY KEY (`id`) )
  ENGINE=InnoDB;

CREATE INDEX `iso_idx` ON `countries` (`iso` ASC) ;

CREATE INDEX `name_idx` ON `countries` (`name` ASC) ;

CREATE INDEX `continent_idx` ON `countries` (`continent` ASC) ;


-- -----------------------------------------------------
-- Table `number_types`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `number_types` ;

CREATE  TABLE IF NOT EXISTS `number_types` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(255) NOT NULL ,
  `desc` MEDIUMTEXT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

CREATE INDEX `title_idx` ON `number_types` (`title` ASC) ;


-- -----------------------------------------------------
-- Table `area_codes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `area_codes` ;

CREATE  TABLE IF NOT EXISTS `area_codes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `code` VARCHAR(15) NOT NULL ,
  `type_id` INT(11) NOT NULL ,
  `exchange` VARCHAR(255) NULL ,
  `town` VARCHAR(255) NULL ,
  `state` VARCHAR(255) NULL ,
  `country` CHAR(2) NOT NULL ,
  `lat` DOUBLE NULL ,
  `lng` DOUBLE NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `ac_country_fk`
    FOREIGN KEY (`country` )
    REFERENCES `countries` (`iso` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ac_type_fk`
    FOREIGN KEY (`type_id` )
    REFERENCES `number_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `ac_country_fk` ON `area_codes` (`country` ASC) ;

CREATE INDEX `ac_type_fk` ON `area_codes` (`type_id` ASC) ;

CREATE INDEX `code_idx` ON `area_codes` (`code` ASC) ;

CREATE INDEX `type_idx` ON `area_codes` (`type_id` ASC) ;

CREATE INDEX `exchange_idx` ON `area_codes` (`exchange` ASC) ;

CREATE INDEX `town_idx` ON `area_codes` (`town` ASC) ;

CREATE INDEX `state_idx` ON `area_codes` (`state` ASC) ;

CREATE INDEX `country_idx` ON `area_codes` (`country` ASC) ;


-- -----------------------------------------------------
-- Table `numbers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `numbers` ;

CREATE  TABLE IF NOT EXISTS `numbers` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `tel` VARCHAR(255) NOT NULL ,
  `area_code` INT(11) NULL ,
  `country` CHAR(2) NOT NULL ,
  `company_id` INT(11) NULL ,
  `creation_date` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `n_area_code_fk`
    FOREIGN KEY (`area_code` )
    REFERENCES `area_codes` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `n_country_fk`
    FOREIGN KEY (`country` )
    REFERENCES `countries` (`iso` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `n_area_code_fk` ON `numbers` (`area_code` ASC) ;

CREATE INDEX `n_country_fk` ON `numbers` (`country` ASC) ;

CREATE INDEX `tel_idx` ON `numbers` (`tel` ASC) ;

CREATE INDEX `area_code_idx` ON `numbers` (`area_code` ASC) ;

CREATE INDEX `country_idx` ON `numbers` (`country` ASC) ;

CREATE INDEX `creation_date_idx` ON `numbers` (`creation_date` ASC) ;


-- -----------------------------------------------------
-- Table `companies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `companies` ;

CREATE  TABLE IF NOT EXISTS `companies` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `street` VARCHAR(255) NULL ,
  `locale` VARCHAR(255) NULL ,
  `town` VARCHAR(255) NULL ,
  `state` VARCHAR(255) NULL ,
  `country` CHAR(2) NULL ,
  `desc` MEDIUMTEXT NULL ,
  `url` VARCHAR(255) NULL ,
  `creation_date` DATETIME NOT NULL ,
  `edit_date` DATETIME NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `comp_country_fk`
    FOREIGN KEY (`country` )
    REFERENCES `countries` (`iso` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `comp_country_fk` ON `companies` (`country` ASC) ;

CREATE INDEX `name_idx` ON `companies` (`name` ASC) ;

CREATE INDEX `town_idx` ON `companies` (`town` ASC) ;

CREATE INDEX `state_idx` ON `companies` (`state` ASC) ;

CREATE INDEX `country_idx` ON `companies` (`country` ASC) ;

CREATE INDEX `creation_date_idx` ON `companies` (`creation_date` ASC) ;

CREATE INDEX `edit_date_idx` ON `companies` (`edit_date` ASC) ;


-- -----------------------------------------------------
-- Table `comments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `comments` ;

CREATE  TABLE IF NOT EXISTS `comments` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(255) NOT NULL ,
  `comment` MEDIUMTEXT NULL ,
  `caller_id` VARCHAR(255) NULL ,
  `company_id` INT(11) NULL ,
  `company` VARCHAR(255) NULL ,
  `status` ENUM('moderated', 'reported', 'removed') NOT NULL ,
  `creation_date` DATETIME NOT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `comments_company_fk`
    FOREIGN KEY (`company_id` )
    REFERENCES `companies` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `comments_company_fk` ON `comments` (`company_id` ASC) ;

CREATE INDEX `name_idx` ON `comments` (`name` ASC) ;

CREATE INDEX `company_idx` ON `comments` (`company_id` ASC) ;

CREATE INDEX `status` ON `comments` (`status` ASC) ;

CREATE INDEX `creation_date_idx` ON `comments` (`creation_date` ASC) ;


-- -----------------------------------------------------
-- Table `reports`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `reports` ;

CREATE  TABLE IF NOT EXISTS `reports` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `comment_id` INT(11) NOT NULL ,
  `type` ENUM('spam', 'abuse', 'other') NOT NULL ,
  `reason` MEDIUMTEXT NULL ,
  `name` VARCHAR(255) NOT NULL ,
  `email` VARCHAR(255) NULL ,
  `report_date` DATETIME NOT NULL ,
  `status` ENUM('open', 'resolved', 'closed') NOT NULL ,
  `resolve_date` DATETIME NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `r_comment_fk`
    FOREIGN KEY (`comment_id` )
    REFERENCES `comments` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `r_comment_fk` ON `reports` (`comment_id` ASC) ;

CREATE INDEX `comment_idx` ON `reports` (`comment_id` ASC) ;

CREATE INDEX `type_idx` ON `reports` (`type` ASC) ;

CREATE INDEX `report_date_idx` ON `reports` (`report_date` ASC) ;

CREATE INDEX `status_idx` ON `reports` (`status` ASC) ;

CREATE INDEX `resolve_date_idx` ON `reports` (`resolve_date` ASC) ;


-- -----------------------------------------------------
-- Table `international_call_prefixes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `international_call_prefixes` ;

CREATE  TABLE IF NOT EXISTS `international_call_prefixes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `idd` CHAR(5) NOT NULL ,
  `country` CHAR(2) NOT NULL ,
  `desc` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `icp_country_fk`
    FOREIGN KEY (`country` )
    REFERENCES `countries` (`iso` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `icp_country_fk` ON `international_call_prefixes` (`country` ASC) ;

CREATE INDEX `idd_idx` ON `international_call_prefixes` (`idd` ASC) ;

CREATE INDEX `country_idx` ON `international_call_prefixes` (`country` ASC) ;


-- -----------------------------------------------------
-- Table `calling_codes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `calling_codes` ;

CREATE  TABLE IF NOT EXISTS `calling_codes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT ,
  `code` INT(5) NOT NULL ,
  `country` CHAR(2) NOT NULL ,
  `desc` VARCHAR(255) NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `cc_country_fk`
    FOREIGN KEY (`country` )
    REFERENCES `countries` (`iso` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `cc_country_fk` ON `calling_codes` (`country` ASC) ;

CREATE INDEX `code_idx` ON `calling_codes` (`code` ASC) ;

CREATE INDEX `country_idx` ON `calling_codes` (`country` ASC) ;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;












INSERT INTO `countries` (`id`, `iso`, `iso3`, `name`, `lat`, `lng`, `adjectival`, `denonym`, `colloquial`, `numcode`, `article`, `continent`) VALUES
(1, 'af', 'afg', 'Afghanistan', NULL, NULL, NULL, NULL, NULL, 4, 0, 'as'),
(2, 'al', 'alb', 'Albania', NULL, NULL, NULL, NULL, NULL, 8, 0, 'eu'),
(3, 'dz', 'dza', 'Algeria', NULL, NULL, NULL, NULL, NULL, 12, 0, 'af'),
(4, 'as', 'asm', 'American Samoa', NULL, NULL, NULL, NULL, NULL, 16, 0, 'oc'),
(5, 'ad', 'and', 'Andorra', NULL, NULL, NULL, NULL, NULL, 20, 0, 'eu'),
(6, 'ao', 'ago', 'Angola', NULL, NULL, NULL, NULL, NULL, 24, 0, 'af'),
(7, 'ai', 'aia', 'Anguilla', NULL, NULL, NULL, NULL, NULL, 660, 0, 'na'),
(8, 'aq', NULL, 'Antarctica', NULL, NULL, NULL, NULL, NULL, NULL, 0, 'an'),
(9, 'ag', 'atg', 'Antigua and Barbuda', NULL, NULL, NULL, NULL, NULL, 28, 0, 'na'),
(10, 'ar', 'arg', 'Argentina', NULL, NULL, NULL, NULL, NULL, 32, 0, 'sa'),
(11, 'am', 'arm', 'Armenia', NULL, NULL, NULL, NULL, NULL, 51, 0, 'as'),
(12, 'aw', 'abw', 'Aruba', NULL, NULL, NULL, NULL, NULL, 533, 0, 'na'),
(13, 'au', 'aus', 'Australia', NULL, NULL, NULL, NULL, NULL, 36, 0, 'oc'),
(14, 'at', 'aut', 'Austria', NULL, NULL, NULL, NULL, NULL, 40, 0, 'eu'),
(15, 'az', 'aze', 'Azerbaijan', NULL, NULL, NULL, NULL, NULL, 31, 0, 'as'),
(16, 'bs', 'bhs', 'Bahamas', NULL, NULL, NULL, NULL, NULL, 44, 1, 'na'),
(17, 'bh', 'bhr', 'Bahrain', NULL, NULL, NULL, NULL, NULL, 48, 0, 'as'),
(18, 'bd', 'bgd', 'Bangladesh', NULL, NULL, NULL, NULL, NULL, 50, 0, 'as'),
(19, 'bb', 'brb', 'Barbados', NULL, NULL, NULL, NULL, NULL, 52, 0, 'na'),
(20, 'by', 'blr', 'Belarus', NULL, NULL, NULL, NULL, NULL, 112, 0, 'eu'),
(21, 'be', 'bel', 'Belgium', NULL, NULL, NULL, NULL, NULL, 56, 0, 'eu'),
(22, 'bz', 'blz', 'Belize', NULL, NULL, NULL, NULL, NULL, 84, 0, 'na'),
(23, 'bj', 'ben', 'Benin', NULL, NULL, NULL, NULL, NULL, 204, 0, 'af'),
(24, 'bm', 'bmu', 'Bermuda', NULL, NULL, NULL, NULL, NULL, 60, 0, 'na'),
(25, 'bt', 'btn', 'Bhutan', NULL, NULL, NULL, NULL, NULL, 64, 0, 'as'),
(26, 'bo', 'bol', 'Bolivia', NULL, NULL, NULL, NULL, NULL, 68, 0, 'sa'),
(27, 'ba', 'bih', 'Bosnia and Herzegovina', NULL, NULL, NULL, NULL, NULL, 70, 0, 'eu'),
(28, 'bw', 'bwa', 'Botswana', NULL, NULL, NULL, NULL, NULL, 72, 0, 'af'),
(29, 'bv', NULL, 'Bouvet Island', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'an'),
(30, 'br', 'bra', 'Brazil', NULL, NULL, NULL, NULL, NULL, 76, 0, 'sa'),
(31, 'io', NULL, 'British Indian Ocean Territory', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'as'),
(32, 'bn', 'brn', 'Brunei Darussalam', NULL, NULL, NULL, NULL, NULL, 96, 0, 'as'),
(33, 'bg', 'bgr', 'Bulgaria', NULL, NULL, NULL, NULL, NULL, 100, 0, 'eu'),
(34, 'bf', 'bfa', 'Burkina Faso', NULL, NULL, NULL, NULL, NULL, 854, 0, 'af'),
(35, 'bi', 'bdi', 'Burundi', NULL, NULL, NULL, NULL, NULL, 108, 0, 'af'),
(36, 'kh', 'khm', 'Cambodia', NULL, NULL, NULL, NULL, NULL, 116, 0, 'as'),
(37, 'cm', 'cmr', 'Cameroon', NULL, NULL, NULL, NULL, NULL, 120, 0, 'af'),
(38, 'ca', 'can', 'Canada', NULL, NULL, NULL, NULL, NULL, 124, 0, 'na'),
(39, 'cv', 'cpv', 'Cape Verde', NULL, NULL, NULL, NULL, NULL, 132, 0, 'af'),
(40, 'ky', 'cym', 'Cayman Islands', NULL, NULL, NULL, NULL, NULL, 136, 1, 'na'),
(41, 'cf', 'caf', 'Central African Republic', NULL, NULL, NULL, NULL, NULL, 140, 1, 'af'),
(42, 'td', 'tcd', 'Chad', NULL, NULL, NULL, NULL, NULL, 148, 0, 'af'),
(43, 'cl', 'chl', 'Chile', NULL, NULL, NULL, NULL, NULL, 152, 0, 'sa'),
(44, 'cn', 'chn', 'China', NULL, NULL, NULL, NULL, NULL, 156, 0, 'as'),
(45, 'cx', NULL, 'Christmas Island', NULL, NULL, NULL, NULL, NULL, NULL, 0, 'as'),
(46, 'cc', NULL, 'Cocos (Keeling) Islands', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'as'),
(47, 'co', 'col', 'Colombia', NULL, NULL, NULL, NULL, NULL, 170, 0, 'sa'),
(48, 'km', 'com', 'Comoros', NULL, NULL, NULL, NULL, NULL, 174, 0, 'af'),
(49, 'cg', 'cog', 'Congo', NULL, NULL, NULL, NULL, NULL, 178, 0, 'af'),
(50, 'cd', 'cod', 'Congo, the Democratic Republic of the', NULL, NULL, NULL, NULL, NULL, 180, 1, 'af'),
(51, 'ck', 'cok', 'Cook Islands', NULL, NULL, NULL, NULL, NULL, 184, 1, 'oc'),
(52, 'cr', 'cri', 'Costa Rica', NULL, NULL, NULL, NULL, NULL, 188, 0, 'na'),
(53, 'ci', 'civ', 'Cote D''Ivoire', NULL, NULL, NULL, NULL, NULL, 384, 0, 'af'),
(54, 'hr', 'hrv', 'Croatia', NULL, NULL, NULL, NULL, NULL, 191, 0, 'eu'),
(55, 'cu', 'cub', 'Cuba', NULL, NULL, NULL, NULL, NULL, 192, 0, 'na'),
(56, 'cy', 'cyp', 'Cyprus', NULL, NULL, NULL, NULL, NULL, 196, 0, 'as'),
(57, 'cz', 'cze', 'Czech Republic', NULL, NULL, NULL, NULL, NULL, 203, 0, 'eu'),
(58, 'dk', 'dnk', 'Denmark', NULL, NULL, NULL, NULL, NULL, 208, 0, 'eu'),
(59, 'dj', 'dji', 'Djibouti', NULL, NULL, NULL, NULL, NULL, 262, 0, 'af'),
(60, 'dm', 'dma', 'Dominica', NULL, NULL, NULL, NULL, NULL, 212, 0, 'na'),
(61, 'do', 'dom', 'Dominican Republic', NULL, NULL, NULL, NULL, NULL, 214, 1, 'na'),
(62, 'ec', 'ecu', 'Ecuador', NULL, NULL, NULL, NULL, NULL, 218, 0, 'sa'),
(63, 'eg', 'egy', 'Egypt', NULL, NULL, NULL, NULL, NULL, 818, 0, 'af'),
(64, 'sv', 'slv', 'El Salvador', NULL, NULL, NULL, NULL, NULL, 222, 0, 'na'),
(65, 'gq', 'gnq', 'Equatorial Guinea', NULL, NULL, NULL, NULL, NULL, 226, 0, 'af'),
(66, 'er', 'eri', 'Eritrea', NULL, NULL, NULL, NULL, NULL, 232, 0, 'af'),
(67, 'ee', 'est', 'Estonia', NULL, NULL, NULL, NULL, NULL, 233, 0, 'eu'),
(68, 'et', 'eth', 'Ethiopia', NULL, NULL, NULL, NULL, NULL, 231, 0, 'af'),
(69, 'fk', 'flk', 'Falkland Islands (Malvinas)', NULL, NULL, NULL, NULL, NULL, 238, 1, 'sa'),
(70, 'fo', 'fro', 'Faroe Islands', NULL, NULL, NULL, NULL, NULL, 234, 1, 'eu'),
(71, 'fj', 'fji', 'Fiji', NULL, NULL, NULL, NULL, NULL, 242, 0, 'oc'),
(72, 'fi', 'fin', 'Finland', NULL, NULL, NULL, NULL, NULL, 246, 0, 'eu'),
(73, 'fr', 'fra', 'France', NULL, NULL, NULL, NULL, NULL, 250, 0, 'eu'),
(74, 'gf', 'guf', 'French Guiana', NULL, NULL, NULL, NULL, NULL, 254, 0, 'sa'),
(75, 'pf', 'pyf', 'French Polynesia', NULL, NULL, NULL, NULL, NULL, 258, 0, 'oc'),
(76, 'tf', NULL, 'French Southern Territories', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'an'),
(77, 'ga', 'gab', 'Gabon', NULL, NULL, NULL, NULL, NULL, 266, 0, 'af'),
(78, 'gm', 'gmb', 'Gambia', NULL, NULL, NULL, NULL, NULL, 270, 0, 'af'),
(79, 'ge', 'geo', 'Georgia', NULL, NULL, NULL, NULL, NULL, 268, 0, 'as'),
(80, 'de', 'deu', 'Germany', NULL, NULL, NULL, NULL, NULL, 276, 0, 'eu'),
(81, 'gh', 'gha', 'Ghana', NULL, NULL, NULL, NULL, NULL, 288, 0, 'af'),
(82, 'gi', 'gib', 'Gibraltar', NULL, NULL, NULL, NULL, NULL, 292, 0, 'eu'),
(83, 'gr', 'grc', 'Greece', NULL, NULL, NULL, NULL, NULL, 300, 0, 'eu'),
(84, 'gl', 'grl', 'Greenland', NULL, NULL, NULL, NULL, NULL, 304, 0, 'na'),
(85, 'gd', 'grd', 'Grenada', NULL, NULL, NULL, NULL, NULL, 308, 0, 'na'),
(86, 'gp', 'glp', 'Guadeloupe', NULL, NULL, NULL, NULL, NULL, 312, 0, 'na'),
(87, 'gu', 'gum', 'Guam', NULL, NULL, NULL, NULL, NULL, 316, 0, 'oc'),
(88, 'gt', 'gtm', 'Guatemala', NULL, NULL, NULL, NULL, NULL, 320, 0, 'na'),
(89, 'gn', 'gin', 'Guinea', NULL, NULL, NULL, NULL, NULL, 324, 0, 'af'),
(90, 'gw', 'gnb', 'Guinea-Bissau', NULL, NULL, NULL, NULL, NULL, 624, 0, 'af'),
(91, 'gy', 'guy', 'Guyana', NULL, NULL, NULL, NULL, NULL, 328, 0, 'sa'),
(92, 'ht', 'hti', 'Haiti', NULL, NULL, NULL, NULL, NULL, 332, 0, 'na'),
(93, 'hm', NULL, 'Heard Island and Mcdonald Islands', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'an'),
(94, 'va', 'vat', 'Holy See (Vatican City State)', NULL, NULL, NULL, NULL, NULL, 336, 1, 'eu'),
(95, 'hn', 'hnd', 'Honduras', NULL, NULL, NULL, NULL, NULL, 340, 0, 'na'),
(96, 'hk', 'hkg', 'Hong Kong', NULL, NULL, NULL, NULL, NULL, 344, 0, 'as'),
(97, 'hu', 'hun', 'Hungary', NULL, NULL, NULL, NULL, NULL, 348, 0, 'eu'),
(98, 'is', 'isl', 'Iceland', NULL, NULL, NULL, NULL, NULL, 352, 0, 'eu'),
(99, 'in', 'ind', 'India', NULL, NULL, NULL, NULL, NULL, 356, 0, 'as'),
(100, 'id', 'idn', 'Indonesia', NULL, NULL, NULL, NULL, NULL, 360, 0, 'as'),
(101, 'ir', 'irn', 'Iran, Islamic Republic of', NULL, NULL, NULL, NULL, NULL, 364, 0, 'as'),
(102, 'iq', 'irq', 'Iraq', NULL, NULL, NULL, NULL, NULL, 368, 0, 'as'),
(103, 'ie', 'irl', 'Ireland', NULL, NULL, NULL, NULL, NULL, 372, 0, 'eu'),
(104, 'il', 'isr', 'Israel', NULL, NULL, NULL, NULL, NULL, 376, 0, 'as'),
(105, 'it', 'ita', 'Italy', NULL, NULL, NULL, NULL, NULL, 380, 0, 'eu'),
(106, 'jm', 'jam', 'Jamaica', NULL, NULL, NULL, NULL, NULL, 388, 0, 'na'),
(107, 'jp', 'jpn', 'Japan', NULL, NULL, NULL, NULL, NULL, 392, 0, 'as'),
(108, 'jo', 'jor', 'Jordan', NULL, NULL, NULL, NULL, NULL, 400, 0, 'as'),
(109, 'kz', 'kaz', 'Kazakhstan', NULL, NULL, NULL, NULL, NULL, 398, 0, 'as'),
(110, 'ke', 'ken', 'Kenya', NULL, NULL, NULL, NULL, NULL, 404, 0, 'af'),
(111, 'ki', 'kir', 'Kiribati', NULL, NULL, NULL, NULL, NULL, 296, 0, 'oc'),
(112, 'kp', 'prk', 'Korea, Democratic People''s Republic of', NULL, NULL, NULL, NULL, NULL, 408, 0, 'as'),
(113, 'kr', 'kor', 'Korea, Republic of', NULL, NULL, NULL, NULL, NULL, 410, 0, 'as'),
(114, 'kw', 'kwt', 'Kuwait', NULL, NULL, NULL, NULL, NULL, 414, 0, 'as'),
(115, 'kg', 'kgz', 'Kyrgyzstan', NULL, NULL, NULL, NULL, NULL, 417, 0, 'as'),
(116, 'la', 'lao', 'Lao People''s Dem. Republic', NULL, NULL, NULL, NULL, NULL, 418, 0, 'as'),
(117, 'lv', 'lva', 'Latvia', NULL, NULL, NULL, NULL, NULL, 428, 0, 'eu'),
(118, 'lb', 'lbn', 'Lebanon', NULL, NULL, NULL, NULL, NULL, 422, 0, 'as'),
(119, 'ls', 'lso', 'Lesotho', NULL, NULL, NULL, NULL, NULL, 426, 0, 'af'),
(120, 'lr', 'lbr', 'Liberia', NULL, NULL, NULL, NULL, NULL, 430, 0, 'af'),
(121, 'ly', 'lby', 'Libyan Arab Jamahiriya', NULL, NULL, NULL, NULL, NULL, 434, 0, 'af'),
(122, 'li', 'lie', 'Liechtenstein', NULL, NULL, NULL, NULL, NULL, 438, 0, 'eu'),
(123, 'lt', 'ltu', 'Lithuania', NULL, NULL, NULL, NULL, NULL, 440, 0, 'eu'),
(124, 'lu', 'lux', 'Luxembourg', NULL, NULL, NULL, NULL, NULL, 442, 0, 'eu'),
(125, 'mo', 'mac', 'Macao', NULL, NULL, NULL, NULL, NULL, 446, 0, 'as'),
(126, 'mk', 'mkd', 'Macedonia, the Former Yugoslav Republic of', NULL, NULL, NULL, NULL, NULL, 807, 0, 'eu'),
(127, 'mg', 'mdg', 'Madagascar', NULL, NULL, NULL, NULL, NULL, 450, 0, 'af'),
(128, 'mw', 'mwi', 'Malawi', NULL, NULL, NULL, NULL, NULL, 454, 0, 'af'),
(129, 'my', 'mys', 'Malaysia', NULL, NULL, NULL, NULL, NULL, 458, 0, 'as'),
(130, 'mv', 'mdv', 'Maldives', NULL, NULL, NULL, NULL, NULL, 462, 0, 'as'),
(131, 'ml', 'mli', 'Mali', NULL, NULL, NULL, NULL, NULL, 466, 0, 'af'),
(132, 'mt', 'mlt', 'Malta', NULL, NULL, NULL, NULL, NULL, 470, 0, 'eu'),
(133, 'mh', 'mhl', 'Marshall Islands', NULL, NULL, NULL, NULL, NULL, 584, 1, 'oc'),
(134, 'mq', 'mtq', 'Martinique', NULL, NULL, NULL, NULL, NULL, 474, 0, 'na'),
(135, 'mr', 'mrt', 'Mauritania', NULL, NULL, NULL, NULL, NULL, 478, 0, 'af'),
(136, 'mu', 'mus', 'Mauritius', NULL, NULL, NULL, NULL, NULL, 480, 0, 'af'),
(137, 'yt', NULL, 'Mayotte', NULL, NULL, NULL, NULL, NULL, NULL, 0, 'af'),
(138, 'mx', 'mex', 'Mexico', NULL, NULL, NULL, NULL, NULL, 484, 0, 'na'),
(139, 'fm', 'fsm', 'Micronesia, Federated States of', NULL, NULL, NULL, NULL, NULL, 583, 0, 'oc'),
(140, 'md', 'mda', 'Moldova, Republic of', NULL, NULL, NULL, NULL, NULL, 498, 0, 'eu'),
(141, 'mc', 'mco', 'Monaco', NULL, NULL, NULL, NULL, NULL, 492, 0, 'eu'),
(142, 'mn', 'mng', 'Mongolia', NULL, NULL, NULL, NULL, NULL, 496, 0, 'as'),
(143, 'ms', 'msr', 'Montserrat', NULL, NULL, NULL, NULL, NULL, 500, 0, 'na'),
(144, 'ma', 'mar', 'Morocco', NULL, NULL, NULL, NULL, NULL, 504, 0, 'af'),
(145, 'mz', 'moz', 'Mozambique', NULL, NULL, NULL, NULL, NULL, 508, 0, 'af'),
(146, 'mm', 'mmr', 'Myanmar', NULL, NULL, NULL, NULL, NULL, 104, 0, 'as'),
(147, 'na', 'nam', 'Namibia', NULL, NULL, NULL, NULL, NULL, 516, 0, 'af'),
(148, 'nr', 'nru', 'Nauru', NULL, NULL, NULL, NULL, NULL, 520, 0, 'oc'),
(149, 'np', 'npl', 'Nepal', NULL, NULL, NULL, NULL, NULL, 524, 0, 'as'),
(150, 'nl', 'nld', 'Netherlands', NULL, NULL, NULL, NULL, NULL, 528, 1, 'eu'),
(151, 'an', 'ant', 'Netherlands Antilles', NULL, NULL, NULL, NULL, NULL, 530, 1, 'na'),
(152, 'nc', 'ncl', 'New Caledonia', NULL, NULL, NULL, NULL, NULL, 540, 0, 'oc'),
(153, 'nz', 'nzl', 'New Zealand', NULL, NULL, NULL, NULL, NULL, 554, 0, 'oc'),
(154, 'ni', 'nic', 'Nicaragua', NULL, NULL, NULL, NULL, NULL, 558, 0, 'na'),
(155, 'ne', 'ner', 'Niger', NULL, NULL, NULL, NULL, NULL, 562, 0, 'af'),
(156, 'ng', 'nga', 'Nigeria', NULL, NULL, NULL, NULL, NULL, 566, 0, 'af'),
(157, 'nu', 'niu', 'Niue', NULL, NULL, NULL, NULL, NULL, 570, 0, 'oc'),
(158, 'nf', 'nfk', 'Norfolk Island', NULL, NULL, NULL, NULL, NULL, 574, 0, 'oc'),
(159, 'mp', 'mnp', 'Northern Mariana Islands', NULL, NULL, NULL, NULL, NULL, 580, 1, 'oc'),
(160, 'no', 'nor', 'Norway', NULL, NULL, NULL, NULL, NULL, 578, 0, 'eu'),
(161, 'om', 'omn', 'Oman', NULL, NULL, NULL, NULL, NULL, 512, 0, 'as'),
(162, 'pk', 'pak', 'Pakistan', NULL, NULL, NULL, NULL, NULL, 586, 0, 'as'),
(163, 'pw', 'plw', 'Palau', NULL, NULL, NULL, NULL, NULL, 585, 0, 'oc'),
(164, 'ps', NULL, 'Palestinian Territory, Occupied', NULL, NULL, NULL, NULL, NULL, NULL, 0, 'as'),
(165, 'pa', 'pan', 'Panama', NULL, NULL, NULL, NULL, NULL, 591, 0, 'na'),
(166, 'pg', 'png', 'Papua New Guinea', NULL, NULL, NULL, NULL, NULL, 598, 0, 'oc'),
(167, 'py', 'pry', 'Paraguay', NULL, NULL, NULL, NULL, NULL, 600, 0, 'sa'),
(168, 'pe', 'per', 'Peru', NULL, NULL, NULL, NULL, NULL, 604, 0, 'sa'),
(169, 'ph', 'phl', 'Philippines', NULL, NULL, NULL, NULL, NULL, 608, 1, 'as'),
(170, 'pn', 'pcn', 'Pitcairn', NULL, NULL, NULL, NULL, NULL, 612, 0, 'oc'),
(171, 'pl', 'pol', 'Poland', NULL, NULL, NULL, NULL, NULL, 616, 0, 'eu'),
(172, 'pt', 'prt', 'Portugal', NULL, NULL, NULL, NULL, NULL, 620, 0, 'eu'),
(173, 'pr', 'pri', 'Puerto Rico', NULL, NULL, NULL, NULL, NULL, 630, 0, 'na'),
(174, 'qa', 'qat', 'Qatar', NULL, NULL, NULL, NULL, NULL, 634, 0, 'as'),
(175, 're', 'reu', 'Reunion', NULL, NULL, NULL, NULL, NULL, 638, 0, 'af'),
(176, 'ro', 'rom', 'Romania', NULL, NULL, NULL, NULL, NULL, 642, 0, 'eu'),
(177, 'ru', 'rus', 'Russian Federation', NULL, NULL, NULL, NULL, NULL, 643, 1, 'eu'),
(178, 'rw', 'rwa', 'Rwanda', NULL, NULL, NULL, NULL, NULL, 646, 0, 'af'),
(179, 'sh', 'shn', 'Saint Helena', NULL, NULL, NULL, NULL, NULL, 654, 0, 'af'),
(180, 'kn', 'kna', 'Saint Kitts and Nevis', NULL, NULL, NULL, NULL, NULL, 659, 0, 'na'),
(181, 'lc', 'lca', 'Saint Lucia', NULL, NULL, NULL, NULL, NULL, 662, 0, 'na'),
(182, 'pm', 'spm', 'Saint Pierre and Miquelon', NULL, NULL, NULL, NULL, NULL, 666, 0, 'na'),
(183, 'vc', 'vct', 'Saint Vincent and the Grenadines', NULL, NULL, NULL, NULL, NULL, 670, 0, 'na'),
(184, 'ws', 'wsm', 'Samoa', NULL, NULL, NULL, NULL, NULL, 882, 0, 'oc'),
(185, 'sm', 'smr', 'San Marino', NULL, NULL, NULL, NULL, NULL, 674, 0, 'eu'),
(186, 'st', 'stp', 'Sao Tome and Principe', NULL, NULL, NULL, NULL, NULL, 678, 0, 'af'),
(187, 'sa', 'sau', 'Saudi Arabia', NULL, NULL, NULL, NULL, NULL, 682, 0, 'as'),
(188, 'sn', 'sen', 'Senegal', NULL, NULL, NULL, NULL, NULL, 686, 0, 'af'),
(189, 'cs', NULL, 'Serbia and Montenegro', NULL, NULL, NULL, NULL, NULL, NULL, 0, ''),
(190, 'sc', 'syc', 'Seychelles', NULL, NULL, NULL, NULL, NULL, 690, 1, 'af'),
(191, 'sl', 'sle', 'Sierra Leone', NULL, NULL, NULL, NULL, NULL, 694, 0, 'af'),
(192, 'sg', 'sgp', 'Singapore', NULL, NULL, NULL, NULL, NULL, 702, 0, 'as'),
(193, 'sk', 'svk', 'Slovakia', NULL, NULL, NULL, NULL, NULL, 703, 0, 'eu'),
(194, 'si', 'svn', 'Slovenia', NULL, NULL, NULL, NULL, NULL, 705, 0, 'eu'),
(195, 'sb', 'slb', 'Solomon Islands', NULL, NULL, NULL, NULL, NULL, 90, 1, 'oc'),
(196, 'so', 'som', 'Somalia', NULL, NULL, NULL, NULL, NULL, 706, 0, 'af'),
(197, 'za', 'zaf', 'South Africa', NULL, NULL, NULL, NULL, NULL, 710, 0, 'af'),
(198, 'gs', NULL, 'South Georgia and the South Sandwich Islands', NULL, NULL, NULL, NULL, NULL, NULL, 0, 'an'),
(199, 'es', 'esp', 'Spain', NULL, NULL, NULL, NULL, NULL, 724, 0, 'eu'),
(200, 'lk', 'lka', 'Sri Lanka', NULL, NULL, NULL, NULL, NULL, 144, 0, 'as'),
(201, 'sd', 'sdn', 'Sudan', NULL, NULL, NULL, NULL, NULL, 736, 0, 'af'),
(202, 'sr', 'sur', 'Suriname', NULL, NULL, NULL, NULL, NULL, 740, 0, 'sa'),
(203, 'sj', 'sjm', 'Svalbard and Jan Mayen', NULL, NULL, NULL, NULL, NULL, 744, 0, 'eu'),
(204, 'sz', 'swz', 'Swaziland', NULL, NULL, NULL, NULL, NULL, 748, 0, 'af'),
(205, 'se', 'swe', 'Sweden', NULL, NULL, NULL, NULL, NULL, 752, 0, 'eu'),
(206, 'ch', 'che', 'Switzerland', NULL, NULL, NULL, NULL, NULL, 756, 0, 'eu'),
(207, 'sy', 'syr', 'Syrian Arab Republic', NULL, NULL, NULL, NULL, NULL, 760, 1, 'as'),
(208, 'tw', 'twn', 'Taiwan, Province of China', NULL, NULL, NULL, NULL, NULL, 158, 0, 'as'),
(209, 'tj', 'tjk', 'Tajikistan', NULL, NULL, NULL, NULL, NULL, 762, 0, 'as'),
(210, 'tz', 'tza', 'Tanzania, United Republic of', NULL, NULL, NULL, NULL, NULL, 834, 0, 'af'),
(211, 'th', 'tha', 'Thailand', NULL, NULL, NULL, NULL, NULL, 764, 0, 'as'),
(212, 'tl', NULL, 'Timor-Leste', NULL, NULL, NULL, NULL, NULL, NULL, 0, 'as'),
(213, 'tg', 'tgo', 'Togo', NULL, NULL, NULL, NULL, NULL, 768, 0, 'af'),
(214, 'tk', 'tkl', 'Tokelau', NULL, NULL, NULL, NULL, NULL, 772, 0, 'oc'),
(215, 'to', 'ton', 'Tonga', NULL, NULL, NULL, NULL, NULL, 776, 0, 'oc'),
(216, 'tt', 'tto', 'Trinidad and Tobago', NULL, NULL, NULL, NULL, NULL, 780, 0, 'na'),
(217, 'tn', 'tun', 'Tunisia', NULL, NULL, NULL, NULL, NULL, 788, 0, 'af'),
(218, 'tr', 'tur', 'Turkey', NULL, NULL, NULL, NULL, NULL, 792, 0, 'as'),
(219, 'tm', 'tkm', 'Turkmenistan', NULL, NULL, NULL, NULL, NULL, 795, 0, 'as'),
(220, 'tc', 'tca', 'Turks and Caicos Islands', NULL, NULL, NULL, NULL, NULL, 796, 1, 'na'),
(221, 'tv', 'tuv', 'Tuvalu', NULL, NULL, NULL, NULL, NULL, 798, 0, 'oc'),
(222, 'ug', 'uga', 'Uganda', NULL, NULL, NULL, NULL, NULL, 800, 0, 'af'),
(223, 'ua', 'ukr', 'Ukraine', NULL, NULL, NULL, NULL, NULL, 804, 0, 'eu'),
(224, 'ae', 'are', 'United Arab Emirates', NULL, NULL, NULL, NULL, NULL, 784, 1, 'as'),
(225, 'gb', 'gbr', 'United Kingdom', NULL, NULL, NULL, NULL, NULL, 826, 1, 'eu'),
(226, 'us', 'usa', 'United States', NULL, NULL, NULL, NULL, NULL, 840, 1, 'na'),
(227, 'um', NULL, 'United States Minor Outlying Islands', NULL, NULL, NULL, NULL, NULL, NULL, 1, 'oc'),
(228, 'uy', 'ury', 'Uruguay', NULL, NULL, NULL, NULL, NULL, 858, 0, 'sa'),
(229, 'uz', 'uzb', 'Uzbekistan', NULL, NULL, NULL, NULL, NULL, 860, 0, 'as'),
(230, 'vu', 'vut', 'Vanuatu', NULL, NULL, NULL, NULL, NULL, 548, 0, 'oc'),
(231, 've', 'ven', 'Venezuela', NULL, NULL, NULL, NULL, NULL, 862, 0, 'sa'),
(232, 'vn', 'vnm', 'Viet Nam', NULL, NULL, NULL, NULL, NULL, 704, 0, 'as'),
(233, 'vg', 'vgb', 'British Virgin Islands', NULL, NULL, NULL, NULL, NULL, 92, 1, 'na'),
(234, 'vi', 'vir', 'US Virgin Islands', NULL, NULL, NULL, NULL, NULL, 850, 1, 'na'),
(235, 'wf', 'wlf', 'Wallis and Futuna', NULL, NULL, NULL, NULL, NULL, 876, 0, 'oc'),
(236, 'eh', 'esh', 'Western Sahara', NULL, NULL, NULL, NULL, NULL, 732, 0, 'af'),
(237, 'ye', 'yem', 'Yemen', NULL, NULL, NULL, NULL, NULL, 887, 0, 'as'),
(238, 'zm', 'zmb', 'Zambia', NULL, NULL, NULL, NULL, NULL, 894, 0, 'af'),
(239, 'zw', 'zwe', 'Zimbabwe', NULL, NULL, NULL, NULL, NULL, 716, 0, 'af');
