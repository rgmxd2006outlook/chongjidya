CREATE DATABASE IF NOT EXISTS `daily_report`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `daily_report`;

CREATE TABLE IF NOT EXISTS `workfaces` (
  `id` VARCHAR(64) NOT NULL,
  `name` VARCHAR(255) DEFAULT NULL,
  `type` VARCHAR(64) DEFAULT '采煤',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `fields` (
  `field_id` VARCHAR(128) NOT NULL,
  `name` VARCHAR(255) DEFAULT NULL,
  `group_name` VARCHAR(255) DEFAULT NULL,
  `dept` VARCHAR(255) DEFAULT '',
  `sort_order` INT DEFAULT 0,
  PRIMARY KEY (`field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `users` (
  `id` VARCHAR(36) NOT NULL,
  `username` VARCHAR(191) NOT NULL,
  `password` VARCHAR(255) DEFAULT NULL,
  `role` VARCHAR(32) DEFAULT NULL,
  `workface` TEXT,
  `fields` TEXT,
  `name` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_users_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `members` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_members_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `daily` (
  `id` VARCHAR(36) NOT NULL,
  `date` DATE DEFAULT NULL,
  `workface` VARCHAR(64) DEFAULT NULL,
  `suggestedRings` DOUBLE DEFAULT NULL,
  `suggestedBy` TEXT,
  `actualNight` DOUBLE DEFAULT NULL,
  `actualNightBy` TEXT,
  `actualMorning` DOUBLE DEFAULT NULL,
  `actualMorningBy` TEXT,
  `actualMiddle` DOUBLE DEFAULT NULL,
  `actualMiddleBy` TEXT,
  `jiaoyunLane` TEXT,
  `jiaoyunLaneBy` TEXT,
  `huifengLane` TEXT,
  `huifengLaneBy` TEXT,
  `deformationValue` DOUBLE DEFAULT NULL,
  `deformationValueBy` TEXT,
  `deformationNormalMin` DOUBLE DEFAULT NULL,
  `deformationNormalMax` DOUBLE DEFAULT NULL,
  `pressureCycle` TEXT,
  `pressureCycleBy` TEXT,
  `daysSincePressure` INT DEFAULT NULL,
  `hangingRoof` DOUBLE DEFAULT NULL,
  `hangingRoofBy` TEXT,
  `surfaceSettlement` DOUBLE DEFAULT NULL,
  `surfaceSettlementBy` TEXT,
  `conclusion` TEXT,
  `conclusionBy` TEXT,
  `remark` TEXT,
  `filledBy` TEXT,
  `createdAt` DATETIME DEFAULT NULL,
  `status` VARCHAR(32) DEFAULT 'draft',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_date_workface` (`date`, `workface`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `logs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(191) DEFAULT NULL,
  `action` VARCHAR(64) DEFAULT NULL,
  `table_name` VARCHAR(64) DEFAULT NULL,
  `record_id` VARCHAR(64) DEFAULT NULL,
  `field_name` VARCHAR(128) DEFAULT NULL,
  `old_value` TEXT,
  `new_value` TEXT,
  `timestamp` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `workfaces` (`id`, `name`, `type`) VALUES
  ('30210', '30210工作面', '采煤'),
  ('30102', '30102工作面', '采煤')
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `type` = VALUES(`type`);

INSERT INTO `fields` (`field_id`, `name`, `group_name`, `dept`, `sort_order`) VALUES
  ('suggestedRings', '建议刀数', '采煤', '防冲管理部', 1),
  ('actualMiddle', '中班刀数', '采煤', '综采队', 2),
  ('actualNight', '夜班刀数', '采煤', '综采队', 3),
  ('actualMorning', '早班刀数', '采煤', '综采队', 4),
  ('jiaoyunLane', '胶运巷位置', '掘进', '综采队', 5),
  ('huifengLane', '回风巷位置', '掘进', '综采队', 6),
  ('deformationValue', '变形监测', '掘进', '监测员', 7),
  ('pressureCycle', '周期来压', '掘进', '防冲管理部', 8),
  ('hangingRoof', '悬顶情况', '掘进', '综采队', 9),
  ('surfaceSettlement', '沉降情况', '掘进', '地测部', 10),
  ('conclusion', '综合结论', '掘进', '防冲管理部', 11)
ON DUPLICATE KEY UPDATE
  `name` = VALUES(`name`),
  `group_name` = VALUES(`group_name`),
  `dept` = VALUES(`dept`),
  `sort_order` = VALUES(`sort_order`);

DELETE FROM `fields`
WHERE `field_id` IN ('dailyMaxRings', 'shiftMaxRings');

INSERT INTO `users` (`id`, `username`, `password`, `role`, `workface`, `fields`, `name`) VALUES
  (
    '00000000-0000-0000-0000-000000000001',
    'admin',
    '102184',
    'admin',
    '30210,30102',
    'suggestedRings,actualNight,actualMorning,actualMiddle,jiaoyunLane,huifengLane,deformationValue,pressureCycle,hangingRoof,surfaceSettlement,conclusion',
    '管理员'
  )
ON DUPLICATE KEY UPDATE
  `password` = VALUES(`password`),
  `role` = VALUES(`role`),
  `workface` = VALUES(`workface`),
  `fields` = VALUES(`fields`),
  `name` = VALUES(`name`);
