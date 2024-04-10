-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 10, 2024 at 11:18 AM
-- Server version: 8.0.36-0ubuntu0.22.04.1
-- PHP Version: 8.1.2-1ubuntu2.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `v2`
--

-- --------------------------------------------------------

--
-- Table structure for table `approval_relations`
--

CREATE TABLE `approval_relations` (
  `id` int UNSIGNED NOT NULL,
  `program_approval_id` int UNSIGNED NOT NULL,
  `awarder_position_id` int UNSIGNED NOT NULL,
  `approver_position_id` int UNSIGNED NOT NULL,
  `created_by` int UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `notifications_enabled` smallint NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `award_approvals`
--

CREATE TABLE `award_approvals` (
  `award_approvals_id` int NOT NULL,
  `program_id` int DEFAULT NULL,
  `event_id` int DEFAULT NULL,
  `awarder_id` int DEFAULT '0',
  `receiver_user_id` int DEFAULT NULL,
  `approver_user_id` int DEFAULT NULL,
  `needs_approval` tinyint(1) DEFAULT '0',
  `has_fixed_budget` tinyint(1) DEFAULT '0',
  `amount_override` tinyint(1) DEFAULT '0',
  `budget_period` int DEFAULT NULL,
  `event_fixed_amount` int DEFAULT NULL,
  `event_name` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_type_name` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `award_amount` int DEFAULT NULL,
  `award_amount_approved` int DEFAULT NULL,
  `award_note` mediumtext COLLATE utf8mb4_unicode_ci,
  `award_message` mediumtext COLLATE utf8mb4_unicode_ci,
  `approved` tinyint(1) DEFAULT '0',
  `awarder_user_object` longblob,
  `budget_object` longblob,
  `declined_reason` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `budget_scenario` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `update_user_id` int DEFAULT NULL,
  `create_date` datetime DEFAULT '0000-00-00 00:00:00',
  `update_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `processed` tinyint(1) DEFAULT '0',
  `award_level_id` int DEFAULT NULL,
  `grades_program_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Store the detail of the Award that needs to be approved';

-- --------------------------------------------------------

--
-- Table structure for table `award_approval_err_log`
--

CREATE TABLE `award_approval_err_log` (
  `award_approval_log_id` int NOT NULL,
  `award_approval_log_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `award_approval_log_user` int NOT NULL,
  `award_approval_log_note` longtext COLLATE utf8mb4_unicode_ci,
  `award_approvals_id` int NOT NULL DEFAULT '0',
  `award_approval_ext_note` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `budgets_cascading`
--

CREATE TABLE `budgets_cascading` (
  `budgets_cascading_id` int NOT NULL,
  `sub_program_external_id` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `budget_holder_external-user_id` varchar(45) COLLATE utf8mb4_unicode_ci NOT NULL,
  `employee_count` int DEFAULT NULL,
  `budget_percentage` decimal(3,2) DEFAULT NULL,
  `budget_amount` decimal(10,2) DEFAULT NULL,
  `budget_awaiting_approval` decimal(10,2) DEFAULT NULL,
  `budget_amount_remaining` decimal(10,2) DEFAULT NULL,
  `date_updated` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT 'NOW()',
  `parent_program_id` int DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  `program_budget_id` int DEFAULT NULL,
  `budget_start_date` date DEFAULT NULL,
  `budget_end_date` date DEFAULT NULL,
  `flag` smallint DEFAULT NULL,
  `status` smallint NOT NULL DEFAULT '1',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int NOT NULL,
  `reason_for_budget_change` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `budgets_cascading`
--
DELIMITER $$
CREATE TRIGGER `budgets_cascading_AFTER_DELETE` AFTER DELETE ON `budgets_cascading` FOR EACH ROW BEGIN
	INSERT INTO budgets_cascading_log
    ( `budgets_cascading_id`, `action`, `sub_program_external_id`, `budget_holder_external-user_id`, `employee_count`, `budget_percentage`, `old_budget_amount`, `new_budget_amount`, `old_budget_awaiting_approval`, `new_budget_awaiting_approval`, `old_budget_amount_remaining`, `new_budget_amount_remaining`, `parent_program_id`, `program_id`, `program_budget_id`, `budget_start_date`, `budget_end_date`, `old_flag`, `new_flag`, `old_status`, `new_status`, `created_by`)
    VALUES
    ( old.`budgets_cascading_id`,'Delete', old.`sub_program_external_id`, old.`budget_holder_external-user_id`, old.`employee_count`, old.`budget_percentage`, old.`budget_amount`, NULL, old.`budget_awaiting_approval`, NULL, old.`budget_amount_remaining`, NULL, old.`parent_program_id`, old.`program_id`, old.`program_budget_id`, old.`budget_start_date`, old.`budget_end_date`, old.`flag`, NULL, old.`status`, NULL, old.`updated_by`);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `budgets_cascading_AFTER_INSERT` AFTER INSERT ON `budgets_cascading` FOR EACH ROW BEGIN
	INSERT INTO budgets_cascading_log
    ( `budgets_cascading_id`, `action`, `sub_program_external_id`, `budget_holder_external-user_id`, `employee_count`, `budget_percentage`, `old_budget_amount`, `new_budget_amount`, `old_budget_awaiting_approval`, `new_budget_awaiting_approval`, `old_budget_amount_remaining`, `new_budget_amount_remaining`, `parent_program_id`, `program_id`, `program_budget_id`, `budget_start_date`, `budget_end_date`, `old_flag`, `new_flag`, `old_status`, `new_status`, `created_by`, `reason_for_budget_change`)
    VALUES
    ( new.`budgets_cascading_id`,'Create', new.`sub_program_external_id`, new.`budget_holder_external-user_id`, new.`employee_count`, new.`budget_percentage`, NULL, new.`budget_amount`, NULL, new.`budget_awaiting_approval`, NULL, new.`budget_amount_remaining`, new.`parent_program_id`, new.`program_id`, new.`program_budget_id`, new.`budget_start_date`, new.`budget_end_date`, NULL, new.`flag`, NULL, new.`status`, new.`created_by`, new.`reason_for_budget_change`);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `budgets_cascading_AFTER_UPDATE` AFTER UPDATE ON `budgets_cascading` FOR EACH ROW BEGIN
	DECLARE action VARCHAR(10) DEFAULT 'Update';
	IF (old.`status` != new.`status`) THEN
		SET action = 'Disable';
    END IF;
	INSERT INTO budgets_cascading_log
    ( `budgets_cascading_id`, `action`, `sub_program_external_id`, `budget_holder_external-user_id`, `employee_count`, `budget_percentage`, `old_budget_amount`, `new_budget_amount`, `old_budget_awaiting_approval`, `new_budget_awaiting_approval`, `old_budget_amount_remaining`, `new_budget_amount_remaining`, `parent_program_id`, `program_id`, `program_budget_id`, `budget_start_date`, `budget_end_date`, `old_flag`, `new_flag`, `old_status`, `new_status`, `created_by`, `reason_for_budget_change`)
    VALUES
    ( new.`budgets_cascading_id`, action, new.`sub_program_external_id`, new.`budget_holder_external-user_id`, new.`employee_count`, new.`budget_percentage`, old.`budget_amount`, new.`budget_amount`, old.`budget_awaiting_approval`, new.`budget_awaiting_approval`, old.`budget_amount_remaining`, new.`budget_amount_remaining`, new.`parent_program_id`, new.`program_id`, new.`program_budget_id`, new.`budget_start_date`, new.`budget_end_date`, old.`flag`, new.`flag`, old.`status`, new.`status`, new.`updated_by`, new.`reason_for_budget_change`);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `budgets_cascading_log`
--

CREATE TABLE `budgets_cascading_log` (
  `id` bigint NOT NULL,
  `budgets_cascading_id` int NOT NULL,
  `action` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub_program_external_id` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `budget_holder_external-user_id` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `employee_count` int DEFAULT NULL,
  `budget_percentage` decimal(3,2) DEFAULT NULL,
  `old_budget_amount` decimal(10,2) DEFAULT NULL,
  `new_budget_amount` decimal(10,2) DEFAULT NULL,
  `old_budget_awaiting_approval` decimal(10,2) DEFAULT NULL,
  `new_budget_awaiting_approval` decimal(10,2) DEFAULT NULL,
  `old_budget_amount_remaining` decimal(10,2) DEFAULT NULL,
  `new_budget_amount_remaining` decimal(10,2) DEFAULT NULL,
  `parent_program_id` int DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  `program_budget_id` int DEFAULT NULL,
  `budget_start_date` date DEFAULT NULL,
  `budget_end_date` date DEFAULT NULL,
  `old_flag` smallint DEFAULT NULL,
  `new_flag` smallint DEFAULT NULL,
  `old_status` smallint DEFAULT NULL,
  `new_status` smallint DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `reason_for_budget_change` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `budget_cascading_approvals`
--

CREATE TABLE `budget_cascading_approvals` (
  `id` int NOT NULL,
  `parent_id` int NOT NULL,
  `awarder_id` int NOT NULL,
  `user_id` int NOT NULL,
  `requestor_id` int NOT NULL,
  `manager_id` int NOT NULL,
  `event_id` int NOT NULL,
  `award_id` int NOT NULL,
  `program_approval_id` int DEFAULT '0',
  `amount` double(15,4) NOT NULL,
  `approved` tinyint NOT NULL DEFAULT '0' COMMENT '0 - no action taken\n1 - approved\n2 - rejected\n3 - approved and awarded',
  `award_data` text COLLATE utf8mb4_unicode_ci,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `program_id` int NOT NULL,
  `include_in_budget` tinyint(1) DEFAULT '1',
  `budgets_cascading_id` int DEFAULT NULL,
  `action_by` int DEFAULT NULL,
  `rejection_note` text COLLATE utf8mb4_unicode_ci,
  `scheduled_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `budget_programs`
--

CREATE TABLE `budget_programs` (
  `id` int NOT NULL,
  `budget_type_id` int DEFAULT NULL,
  `parent_program_id` int DEFAULT NULL,
  `budget_amount` double DEFAULT '0',
  `remaining_amount` double DEFAULT '0' COMMENT '1- active, 2- Inactive',
  `budget_start_date` date DEFAULT NULL COMMENT 'Budget start date for when we start the budget, means Jan-Dec, April-March',
  `budget_end_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `updated_by` int DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `status` smallint DEFAULT '1' COMMENT '1 - Open, 2 - Closed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Triggers `budget_programs`
--
DELIMITER $$
CREATE TRIGGER `budget_programs_AFTER_DELETE` AFTER DELETE ON `budget_programs` FOR EACH ROW BEGIN
	INSERT INTO budget_programs_log
    ( `budget_program_id`, `action`, `budget_type_id`, `parent_program_id`, `old_budget_amount`, `new_budget_amount`, `old_remaining_amount`, `new_remaining_amount`, `budget_start_date`, `budget_end_date`, `old_status`, `new_status`, `created_by`)
    VALUES
    ( old.`id`,'Delete', old.`budget_type_id`, old.`parent_program_id`, old.`budget_amount`, NULL, old.`remaining_amount`, old.`remaining_amount`, old.`budget_start_date`, old.`budget_end_date`, old.`status`, NULL, old.`updated_by`);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `budget_programs_AFTER_INSERT` AFTER INSERT ON `budget_programs` FOR EACH ROW BEGIN
	INSERT INTO budget_programs_log
    ( `budget_program_id`, `action`, `budget_type_id`, `parent_program_id`, `old_budget_amount`, `new_budget_amount`, `old_remaining_amount`, `new_remaining_amount`, `budget_start_date`, `budget_end_date`, `old_status`, `new_status`, `created_by`)
    VALUES
    ( new.`id`,'Create', new.`budget_type_id`, new.`parent_program_id`, NULL, new.`budget_amount`, NULL, new.`remaining_amount`, new.`budget_start_date`, new.`budget_end_date`, NULL, new.`status`, new.`created_by`);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `budget_programs_AFTER_UPDATE` AFTER UPDATE ON `budget_programs` FOR EACH ROW BEGIN
	DECLARE action VARCHAR(10) DEFAULT 'Update';
	IF (old.`status` != new.`status`) THEN
		SET action = 'Closed';
    END IF;
	INSERT INTO budget_programs_log
    ( `budget_program_id`, `action`, `budget_type_id`, `parent_program_id`, `old_budget_amount`, `new_budget_amount`, `old_remaining_amount`, `new_remaining_amount`, `budget_start_date`, `budget_end_date`, `old_status`, `new_status`, `created_by`)
    VALUES
    ( new.`id`,action, new.`budget_type_id`, new.`parent_program_id`, old.`budget_amount`, new.`budget_amount`, old.`remaining_amount`, new.`remaining_amount`, new.`budget_start_date`, new.`budget_end_date`, old.`status`, new.`status`, new.`updated_by`);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `budget_programs_log`
--

CREATE TABLE `budget_programs_log` (
  `id` bigint NOT NULL,
  `budget_program_id` int DEFAULT NULL,
  `action` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `budget_type_id` int DEFAULT NULL,
  `parent_program_id` int DEFAULT NULL,
  `old_budget_amount` double DEFAULT '0',
  `new_budget_amount` double DEFAULT '0',
  `old_remaining_amount` double DEFAULT '0',
  `new_remaining_amount` double DEFAULT '0',
  `budget_start_date` date DEFAULT NULL COMMENT 'Budget start date for when we start the budget, means Jan-Dec, April-March',
  `budget_end_date` date DEFAULT NULL,
  `old_status` smallint DEFAULT NULL,
  `new_status` smallint DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `budget_type`
--

CREATE TABLE `budget_type` (
  `id` int NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `entrata_grade_schemas`
--

CREATE TABLE `entrata_grade_schemas` (
  `grade_schema_id` int NOT NULL,
  `parent_program_id` int NOT NULL,
  `grade` int NOT NULL,
  `hierachy_level` int DEFAULT '0',
  `approval_rights` tinyint DEFAULT '0',
  `view_rights` tinyint DEFAULT '0',
  `super_user` tinyint DEFAULT NULL,
  `create_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update_user_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `grades_id` int NOT NULL,
  `program_id` int NOT NULL,
  `enabled` tinyint DEFAULT '0',
  `activated` tinyint DEFAULT '0',
  `activate_sub_programs` tinyint DEFAULT '0',
  `date_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `date_created` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `create_user_id` int DEFAULT NULL,
  `deactivated` tinyint DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_authorizations`
--

CREATE TABLE `grades_authorizations` (
  `grades_authorizations_id` int NOT NULL,
  `auth_code` int DEFAULT '0',
  `all_modules` tinyint DEFAULT '0',
  `grades_module` tinyint DEFAULT '0',
  `budgets_module` tinyint DEFAULT '0',
  `staff_module` tinyint DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_auth_budget_authorizations`
--

CREATE TABLE `grades_auth_budget_authorizations` (
  `grades_auth_budgets_codes_id` int NOT NULL,
  `auth_codes` int NOT NULL,
  `authority` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `authority_description` varchar(65) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='The codes with Budget requests and approvals';

-- --------------------------------------------------------

--
-- Table structure for table `grades_auth_permissions`
--

CREATE TABLE `grades_auth_permissions` (
  `grades_auth_permissions_id` int NOT NULL,
  `permission_code` int NOT NULL,
  `permission` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permission_description` varchar(65) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='The read write permission codes';

-- --------------------------------------------------------

--
-- Table structure for table `grades_awards_issued_log`
--

CREATE TABLE `grades_awards_issued_log` (
  `grades_budgets_awards_issued_id` int NOT NULL,
  `awarder_user_id` int NOT NULL,
  `recipient_user_id` int NOT NULL,
  `program_id` int DEFAULT '0',
  `master_id` int DEFAULT '0',
  `budget_id` int DEFAULT '0',
  `input_parameters` longtext COLLATE utf8mb4_unicode_ci,
  `award_issued` tinyint DEFAULT '1',
  `budget_calc_failed` tinyint DEFAULT '0',
  `user_message` longtext COLLATE utf8mb4_unicode_ci,
  `notes` longtext COLLATE utf8mb4_unicode_ci,
  `create_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_date` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `remedial_actions_taken` tinyint DEFAULT '0',
  `award_amount` double DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_award_approval_requests`
--

CREATE TABLE `grades_award_approval_requests` (
  `grades_award_approval_requests_id` int NOT NULL,
  `master_id` int NOT NULL,
  `recipient_user_id` int DEFAULT '0',
  `recipient_email` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `grades_budget_approval_requests_id` int DEFAULT '0',
  `award_issued` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_budgets`
--

CREATE TABLE `grades_budgets` (
  `grades_budgets_id` int NOT NULL,
  `enabled` tinyint DEFAULT NULL,
  `grades_id` int DEFAULT NULL,
  `budget_total` double DEFAULT '0',
  `activate_sub_programs` tinyint DEFAULT NULL,
  `date_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `date_created` timestamp NULL DEFAULT NULL,
  `create_user_id` int DEFAULT NULL,
  `update_user_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_budgets_by_entity`
--

CREATE TABLE `grades_budgets_by_entity` (
  `grades_budgets_entity_id` int NOT NULL,
  `grades_budgets_id` int NOT NULL,
  `sub_program_id` int NOT NULL,
  `master_id` varchar(39) COLLATE utf8mb4_unicode_ci NOT NULL,
  `budget` double DEFAULT '0',
  `budget_amnt_used` double DEFAULT '0',
  `budget_amnt_approved` double DEFAULT '0',
  `budget_amnt_approval_pending` double DEFAULT '0',
  `awards_edited_approved` double DEFAULT '0',
  `awards_rejected` double DEFAULT '0',
  `awards_approved` double DEFAULT '0',
  `awards_approval_requested` double DEFAULT '0',
  `awarded_from_budget` double DEFAULT '0',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user_id` int DEFAULT NULL,
  `create_user_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_budgets_entity_details`
--

CREATE TABLE `grades_budgets_entity_details` (
  `grades_budget_entity_details_id` int NOT NULL,
  `grades_budgets_id` int NOT NULL,
  `grades_budgets_entity_id` int NOT NULL DEFAULT '0',
  `sub_program_id` int NOT NULL DEFAULT '0',
  `master_id` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `internal_id` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `l_one_entity_nme` varchar(165) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `l_one_entity_type` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `l_one_legal_entity` longtext COLLATE utf8mb4_unicode_ci,
  `l_one_str_adress` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `l_one_city` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `l_one_state` varchar(4) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `l_one_zip_code` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `update_user_id` int DEFAULT NULL,
  `create_user_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_budgets_rules`
--

CREATE TABLE `grades_budgets_rules` (
  `grades_budgets_rules_id` int NOT NULL,
  `grades_budgets_id` int NOT NULL,
  `grades_budgets_entity_id` int DEFAULT '0',
  `grades_budget_entity_details_id` int DEFAULT '0',
  `sub_program_id` int DEFAULT '0',
  `master_id` int NOT NULL DEFAULT '0',
  `budget_period` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `budget_control_period` varchar(15) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `period_start_date` date DEFAULT '0000-00-00',
  `period_end_date` date DEFAULT '0000-00-00',
  `approve_level_one` tinyint DEFAULT '0',
  `level_one_max_amnt` double DEFAULT '0',
  `level_one_manager_id` int DEFAULT '0',
  `level_one_manager_title` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approve_level_two` tinyint DEFAULT '0',
  `level_two_max_amnt` double DEFAULT '0',
  `level_two_manager_id` int DEFAULT '0',
  `level_two_title` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approve_level_three` tinyint DEFAULT '0',
  `level_three_max_amnt` double DEFAULT '0',
  `level_three_manager_id` int DEFAULT '0',
  `level_three_title` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approve_level_four` tinyint DEFAULT '0',
  `level_four_max_amnt` double DEFAULT '0',
  `level_four_manager_id` int DEFAULT '0',
  `level_four_title` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `approve_level_five` tinyint DEFAULT '0',
  `level_five_max_amnt` double DEFAULT '0',
  `level_five_manager_id` int DEFAULT '0',
  `level_five_title` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ballance_to_next_period` tinyint DEFAULT '0',
  `date_created` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `update_user_id` int DEFAULT NULL,
  `create_user_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_budget_approval_log`
--

CREATE TABLE `grades_budget_approval_log` (
  `grades_budget_approval_by_level_id` int NOT NULL,
  `approver_id` int DEFAULT '0',
  `grades_budget_approval_requests_id` int DEFAULT '0',
  `notes` longtext COLLATE utf8mb4_unicode_ci,
  `approve_result` longtext COLLATE utf8mb4_unicode_ci,
  `date_approved` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='These are approvals done by each level';

-- --------------------------------------------------------

--
-- Table structure for table `grades_budget_approval_requests`
--

CREATE TABLE `grades_budget_approval_requests` (
  `grades_budget_approval_requests_id` int NOT NULL,
  `master_id` int NOT NULL,
  `requester_user_id` int DEFAULT NULL,
  `approver_user_id` int DEFAULT NULL,
  `request_amount` double DEFAULT NULL,
  `approved_amount` double DEFAULT NULL,
  `approved` tinyint DEFAULT '0',
  `rejected_or_edited` tinyint DEFAULT '0',
  `rejected_reason` longtext COLLATE utf8mb4_unicode_ci,
  `request_motivation` longtext COLLATE utf8mb4_unicode_ci,
  `user_id` int NOT NULL,
  `month_requested_for` int DEFAULT '100',
  `year_requested_for` int DEFAULT '1900',
  `date_requested` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `date_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `date_approved` timestamp NULL DEFAULT '0000-00-00 00:00:00',
  `is_award` tinyint(1) DEFAULT '0',
  `grades_award_approval_request_id` int DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_budget_transactions_log`
--

CREATE TABLE `grades_budget_transactions_log` (
  `grades_budget_transaction_id` int NOT NULL,
  `grades_budgets_entity_id` int NOT NULL,
  `grades_budget_id` int DEFAULT '0',
  `amnt_in` double DEFAULT NULL,
  `amnt_out` double DEFAULT NULL,
  `transaction_type` int NOT NULL,
  `create_user_id` int DEFAULT NULL,
  `date_created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `program_id` int DEFAULT '0',
  `journal_event_id` int DEFAULT '0',
  `master_id` int DEFAULT '0',
  `postings_id` int DEFAULT '0',
  `receiver_user_id` int DEFAULT '0',
  `recipient_program_id` int DEFAULT '0',
  `escrow_account_type_name` varchar(65) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `transaction_fee` float DEFAULT '0',
  `event_name` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_amount_override` tinyint(1) DEFAULT '0',
  `event_notification_body` mediumtext COLLATE utf8mb4_unicode_ci,
  `event_type_id` int DEFAULT '0',
  `transaction_type_id` int DEFAULT '0',
  `budget_request_id` int DEFAULT '0',
  `budget_award_request_id` int DEFAULT '0',
  `request_sp` varchar(165) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_budget_transaction_types`
--

CREATE TABLE `grades_budget_transaction_types` (
  `grades_budget_transaction_type_id` int NOT NULL,
  `type_id` int NOT NULL,
  `type_name` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type_description` varchar(165) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `grades_budget_usage_posting-old`
--

CREATE TABLE `grades_budget_usage_posting-old` (
  `grades_budget_usage_posting_id` int NOT NULL,
  `program_id` int NOT NULL,
  `master_id` int NOT NULL,
  `amount` float(12,2) NOT NULL,
  `postings_id` int NOT NULL,
  `this_year` int NOT NULL DEFAULT '0',
  `this_month` int NOT NULL DEFAULT '0',
  `month_day` int NOT NULL DEFAULT '0',
  `year_day` int NOT NULL DEFAULT '0',
  `qtr` int NOT NULL DEFAULT '0',
  `date_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `awarder_user_id` int NOT NULL,
  `journal_event_id` int DEFAULT NULL,
  `medium_type` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `position_assignment`
--

CREATE TABLE `position_assignment` (
  `id` int NOT NULL,
  `position_level_id` int DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `status` smallint DEFAULT '1' COMMENT '0 - inactive, 1 - active',
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `position_levels`
--

CREATE TABLE `position_levels` (
  `id` int NOT NULL,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `level` int DEFAULT NULL,
  `parent_program_id` int DEFAULT NULL,
  `status` smallint DEFAULT '1' COMMENT '0 - inactive, 1 - active',
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `position_permission`
--

CREATE TABLE `position_permission` (
  `id` int NOT NULL,
  `name` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `title` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `position_permission_assignment`
--

CREATE TABLE `position_permission_assignment` (
  `id` int NOT NULL,
  `position_level_id` int DEFAULT NULL,
  `position_permission_id` int DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `program_approvals`
--

CREATE TABLE `program_approvals` (
  `id` int NOT NULL,
  `program_id` int DEFAULT NULL,
  `program_parent_id` int DEFAULT NULL,
  `step` smallint DEFAULT NULL,
  `status` smallint DEFAULT '1' COMMENT '0 - inactive, 1 - active',
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `program_approval_assignment`
--

CREATE TABLE `program_approval_assignment` (
  `id` bigint NOT NULL,
  `program_approval_id` int DEFAULT NULL,
  `position_level_id` int DEFAULT NULL,
  `status` smallint DEFAULT '1' COMMENT '0 - inactive, 1 - active',
  `created_by` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_by` int DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `notifications_enabled` smallint NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `approval_relations`
--
ALTER TABLE `approval_relations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `award_approvals`
--
ALTER TABLE `award_approvals`
  ADD PRIMARY KEY (`award_approvals_id`),
  ADD KEY `event_id_id` (`event_id`),
  ADD KEY `receiver_id_ix` (`receiver_user_id`),
  ADD KEY `program_id_ix` (`program_id`),
  ADD KEY `approver_id_ix` (`approver_user_id`),
  ADD KEY `awarder_id_ix` (`awarder_id`);

--
-- Indexes for table `award_approval_err_log`
--
ALTER TABLE `award_approval_err_log`
  ADD PRIMARY KEY (`award_approval_log_id`);

--
-- Indexes for table `budgets_cascading`
--
ALTER TABLE `budgets_cascading`
  ADD PRIMARY KEY (`budgets_cascading_id`);

--
-- Indexes for table `budgets_cascading_log`
--
ALTER TABLE `budgets_cascading_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `budget_cascading_approvals`
--
ALTER TABLE `budget_cascading_approvals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `index2` (`program_id`),
  ADD KEY `index3` (`program_approval_id`);

--
-- Indexes for table `budget_programs`
--
ALTER TABLE `budget_programs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_budget_programs_1_idx` (`budget_type_id`);

--
-- Indexes for table `budget_programs_log`
--
ALTER TABLE `budget_programs_log`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `budget_type`
--
ALTER TABLE `budget_type`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `entrata_grade_schemas`
--
ALTER TABLE `entrata_grade_schemas`
  ADD PRIMARY KEY (`grade_schema_id`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`grades_id`),
  ADD KEY `programid` (`program_id`),
  ADD KEY `gradesid` (`grades_id`);

--
-- Indexes for table `grades_authorizations`
--
ALTER TABLE `grades_authorizations`
  ADD PRIMARY KEY (`grades_authorizations_id`),
  ADD KEY `authcode` (`auth_code`);

--
-- Indexes for table `grades_auth_budget_authorizations`
--
ALTER TABLE `grades_auth_budget_authorizations`
  ADD PRIMARY KEY (`grades_auth_budgets_codes_id`);

--
-- Indexes for table `grades_auth_permissions`
--
ALTER TABLE `grades_auth_permissions`
  ADD PRIMARY KEY (`grades_auth_permissions_id`);

--
-- Indexes for table `grades_awards_issued_log`
--
ALTER TABLE `grades_awards_issued_log`
  ADD PRIMARY KEY (`grades_budgets_awards_issued_id`);

--
-- Indexes for table `grades_award_approval_requests`
--
ALTER TABLE `grades_award_approval_requests`
  ADD PRIMARY KEY (`grades_award_approval_requests_id`),
  ADD KEY `master_id_ind` (`master_id`),
  ADD KEY `recipient_user_id_ind` (`recipient_user_id`),
  ADD KEY `approval_req_id` (`grades_budget_approval_requests_id`);

--
-- Indexes for table `grades_budgets`
--
ALTER TABLE `grades_budgets`
  ADD PRIMARY KEY (`grades_budgets_id`),
  ADD KEY `grades_id_ind` (`grades_id`),
  ADD KEY `create_user_id_ind` (`create_user_id`);

--
-- Indexes for table `grades_budgets_by_entity`
--
ALTER TABLE `grades_budgets_by_entity`
  ADD PRIMARY KEY (`grades_budgets_entity_id`),
  ADD UNIQUE KEY `sub_program` (`grades_budgets_id`,`master_id`),
  ADD KEY `master_id_ix` (`master_id`),
  ADD KEY `budg_id_ix` (`grades_budgets_id`);

--
-- Indexes for table `grades_budgets_entity_details`
--
ALTER TABLE `grades_budgets_entity_details`
  ADD PRIMARY KEY (`grades_budget_entity_details_id`),
  ADD KEY `gradesbudgetsid` (`grades_budgets_id`),
  ADD KEY `budgetentityid` (`grades_budgets_entity_id`),
  ADD KEY `subprogram` (`sub_program_id`),
  ADD KEY `masterid` (`master_id`);

--
-- Indexes for table `grades_budgets_rules`
--
ALTER TABLE `grades_budgets_rules`
  ADD PRIMARY KEY (`grades_budgets_rules_id`),
  ADD KEY `budgetsid` (`grades_budgets_id`),
  ADD KEY `entityid` (`grades_budgets_entity_id`),
  ADD KEY `detailid` (`grades_budget_entity_details_id`),
  ADD KEY `subprogram` (`sub_program_id`),
  ADD KEY `masterid` (`master_id`),
  ADD KEY `lone_user_id_ind` (`level_one_manager_id`),
  ADD KEY `ltwo_man_id_ind` (`level_two_manager_id`),
  ADD KEY `lthree_man_id_ind` (`level_three_manager_id`),
  ADD KEY `lfour_man_id_ind` (`level_four_manager_id`);

--
-- Indexes for table `grades_budget_approval_log`
--
ALTER TABLE `grades_budget_approval_log`
  ADD PRIMARY KEY (`grades_budget_approval_by_level_id`),
  ADD KEY `approver_id_ind` (`approver_id`),
  ADD KEY `approve_request_id_in` (`grades_budget_approval_requests_id`);

--
-- Indexes for table `grades_budget_approval_requests`
--
ALTER TABLE `grades_budget_approval_requests`
  ADD PRIMARY KEY (`grades_budget_approval_requests_id`),
  ADD KEY `mater_id_ind` (`master_id`),
  ADD KEY `requester_id_ind` (`requester_user_id`),
  ADD KEY `approver_id_ind` (`approver_user_id`),
  ADD KEY `user_id_ind` (`user_id`),
  ADD KEY `award_approval_id_ind` (`grades_award_approval_request_id`);

--
-- Indexes for table `grades_budget_transactions_log`
--
ALTER TABLE `grades_budget_transactions_log`
  ADD PRIMARY KEY (`grades_budget_transaction_id`),
  ADD KEY `entity_id_ind` (`grades_budgets_entity_id`),
  ADD KEY `budgets_id` (`grades_budget_id`),
  ADD KEY `create_user_id_in` (`create_user_id`),
  ADD KEY `program_id_ind` (`program_id`),
  ADD KEY `journal_event_id_ind` (`journal_event_id`),
  ADD KEY `master_id_ind` (`master_id`),
  ADD KEY `receiver_user_id_ind` (`receiver_user_id`);

--
-- Indexes for table `grades_budget_transaction_types`
--
ALTER TABLE `grades_budget_transaction_types`
  ADD PRIMARY KEY (`grades_budget_transaction_type_id`),
  ADD UNIQUE KEY `type_id_UNIQUE` (`type_id`),
  ADD UNIQUE KEY `type_name_UNIQUE` (`type_name`);

--
-- Indexes for table `grades_budget_usage_posting-old`
--
ALTER TABLE `grades_budget_usage_posting-old`
  ADD PRIMARY KEY (`grades_budget_usage_posting_id`);

--
-- Indexes for table `position_assignment`
--
ALTER TABLE `position_assignment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Unique_compopsit` (`program_id`,`user_id`),
  ADD KEY `index3` (`position_level_id`),
  ADD KEY `index4` (`status`);

--
-- Indexes for table `position_levels`
--
ALTER TABLE `position_levels`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `position_permission`
--
ALTER TABLE `position_permission`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `position_permission_assignment`
--
ALTER TABLE `position_permission_assignment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `program_approvals`
--
ALTER TABLE `program_approvals`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `composit_unique` (`step`,`program_id`,`program_parent_id`),
  ADD KEY `index3` (`status`);

--
-- Indexes for table `program_approval_assignment`
--
ALTER TABLE `program_approval_assignment`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `index2` (`program_approval_id`,`position_level_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `approval_relations`
--
ALTER TABLE `approval_relations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `award_approvals`
--
ALTER TABLE `award_approvals`
  MODIFY `award_approvals_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `award_approval_err_log`
--
ALTER TABLE `award_approval_err_log`
  MODIFY `award_approval_log_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `budgets_cascading`
--
ALTER TABLE `budgets_cascading`
  MODIFY `budgets_cascading_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `budgets_cascading_log`
--
ALTER TABLE `budgets_cascading_log`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `budget_cascading_approvals`
--
ALTER TABLE `budget_cascading_approvals`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `budget_programs`
--
ALTER TABLE `budget_programs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `budget_programs_log`
--
ALTER TABLE `budget_programs_log`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `budget_type`
--
ALTER TABLE `budget_type`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `entrata_grade_schemas`
--
ALTER TABLE `entrata_grade_schemas`
  MODIFY `grade_schema_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `grades_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_authorizations`
--
ALTER TABLE `grades_authorizations`
  MODIFY `grades_authorizations_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_auth_budget_authorizations`
--
ALTER TABLE `grades_auth_budget_authorizations`
  MODIFY `grades_auth_budgets_codes_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_auth_permissions`
--
ALTER TABLE `grades_auth_permissions`
  MODIFY `grades_auth_permissions_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_awards_issued_log`
--
ALTER TABLE `grades_awards_issued_log`
  MODIFY `grades_budgets_awards_issued_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_award_approval_requests`
--
ALTER TABLE `grades_award_approval_requests`
  MODIFY `grades_award_approval_requests_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_budgets`
--
ALTER TABLE `grades_budgets`
  MODIFY `grades_budgets_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_budgets_by_entity`
--
ALTER TABLE `grades_budgets_by_entity`
  MODIFY `grades_budgets_entity_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_budgets_entity_details`
--
ALTER TABLE `grades_budgets_entity_details`
  MODIFY `grades_budget_entity_details_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_budgets_rules`
--
ALTER TABLE `grades_budgets_rules`
  MODIFY `grades_budgets_rules_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_budget_approval_log`
--
ALTER TABLE `grades_budget_approval_log`
  MODIFY `grades_budget_approval_by_level_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_budget_approval_requests`
--
ALTER TABLE `grades_budget_approval_requests`
  MODIFY `grades_budget_approval_requests_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_budget_transactions_log`
--
ALTER TABLE `grades_budget_transactions_log`
  MODIFY `grades_budget_transaction_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_budget_transaction_types`
--
ALTER TABLE `grades_budget_transaction_types`
  MODIFY `grades_budget_transaction_type_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `grades_budget_usage_posting-old`
--
ALTER TABLE `grades_budget_usage_posting-old`
  MODIFY `grades_budget_usage_posting_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `position_assignment`
--
ALTER TABLE `position_assignment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `position_levels`
--
ALTER TABLE `position_levels`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `position_permission`
--
ALTER TABLE `position_permission`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `position_permission_assignment`
--
ALTER TABLE `position_permission_assignment`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `program_approvals`
--
ALTER TABLE `program_approvals`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `program_approval_assignment`
--
ALTER TABLE `program_approval_assignment`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `budget_programs`
--
ALTER TABLE `budget_programs`
  ADD CONSTRAINT `fk_budget_programs_1` FOREIGN KEY (`budget_type_id`) REFERENCES `budget_type` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
