-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 23, 2024 at 05:03 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `printer`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `info` text DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `user_id`, `name`, `info`, `parent_id`, `deleted_at`, `created_at`, `updated_at`) VALUES
(2, 53, '{\"ar\":\"تغليف\",\"en\":\"package\"}', '{\"ar\":\"وصف القسم\",\"en\":\"description\"}', NULL, NULL, '2024-05-09 20:04:57', '2024-05-09 20:04:57'),
(3, 53, '{\"ar\":\"تغليف\",\"en\":\"package\"}', '{\"ar\":\"وصف القسم\",\"en\":\"description\"}', NULL, NULL, '2024-05-09 20:05:33', '2024-05-09 20:05:33'),
(4, 53, '{\"ar\":\"تغليف\",\"en\":\"package\"}', '{\"ar\":\"وصف القسم\",\"en\":\"description\"}', NULL, NULL, '2024-05-09 20:21:55', '2024-05-09 20:21:55'),
(5, 53, '{\"ar\":\"تغليف\",\"en\":\"package\"}', '{\"ar\":\"وصف القسم\",\"en\":\"description\"}', NULL, NULL, '2024-05-09 20:22:12', '2024-05-09 20:22:12'),
(6, 53, '{\"ar\":\"تغليف\",\"en\":\"package\"}', '{\"ar\":\"وصف القسم\",\"en\":\"description\"}', NULL, NULL, '2024-05-09 20:22:26', '2024-05-09 20:22:26'),
(7, 53, '{\"ar\":\"تغليف تعديل\",\"en\":\"package\"}', '{\"ar\":\"وصف القسم\",\"en\":\"description\"}', NULL, '2024-05-09 20:38:26', '2024-05-09 20:22:29', '2024-05-09 20:38:26'),
(8, 53, '{\"ar\":\"تغليف\",\"en\":\"package\"}', '{\"ar\":\"وصف القسم\",\"en\":\"description\"}', NULL, NULL, '2024-05-09 20:30:28', '2024-05-09 20:30:28');

-- --------------------------------------------------------

--
-- Table structure for table `categories_properties`
--

CREATE TABLE `categories_properties` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `property_id` bigint(20) UNSIGNED NOT NULL,
  `price` double(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories_properties`
--

INSERT INTO `categories_properties` (`id`, `category_id`, `property_id`, `price`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 200.00, '2024-05-12 23:05:17', NULL),
(2, 2, 2, 200.00, '2024-05-12 23:05:17', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `coupons`
--

CREATE TABLE `coupons` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `serial` varchar(191) NOT NULL,
  `expiration_at` date DEFAULT NULL,
  `max_number_of_users` int(11) NOT NULL,
  `max_usage_per_user` int(11) NOT NULL,
  `type` varchar(191) NOT NULL,
  `value` double(8,2) NOT NULL,
  `max_value` double(8,2) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coupons`
--

INSERT INTO `coupons` (`id`, `user_id`, `name`, `serial`, `expiration_at`, `max_number_of_users`, `max_usage_per_user`, `type`, `value`, `max_value`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 56, '{\"ar\":\"كوبون العيد تعديل\",\"en\":\"Eid coupon\"}', 'eid30', '2024-12-12', 10, 2, 'percentage', 30.00, 250.00, NULL, '2024-05-12 19:50:08', '2024-05-12 19:52:56');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(191) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `imageable_id` varchar(191) NOT NULL,
  `imageable_type` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`id`, `imageable_id`, `imageable_type`, `name`, `created_at`, `updated_at`) VALUES
(2, '2', 'App\\Models\\categories', '17152959331808742113250_image.png', '2024-05-09 20:04:57', '2024-05-09 20:04:57'),
(3, '3', 'App\\Models\\categories', '17152959331808742113250_image.png', '2024-05-09 20:05:33', '2024-05-09 20:05:33'),
(4, '4', 'App\\Models\\categories', '17152969155000142592851_image.png', '2024-05-09 20:21:55', '2024-05-09 20:21:55'),
(5, '5', 'App\\Models\\categories', '17152969323239830337380_image.png', '2024-05-09 20:22:12', '2024-05-09 20:22:12'),
(6, '6', 'App\\Models\\categories', '17152969463024647620736_image.png', '2024-05-09 20:22:26', '2024-05-09 20:22:26'),
(9, '7', 'App\\Models\\categories', '17152974102514551924291_image.png', '2024-05-09 20:30:10', '2024-05-09 20:30:10'),
(10, '8', 'App\\Models\\categories', '17152974288263566231936_image.png', '2024-05-09 20:30:28', '2024-05-09 20:30:28'),
(12, '2', 'App\\Models\\services', 'services/default.png', '2024-05-11 15:51:19', '2024-05-11 15:51:19'),
(13, '3', 'App\\Models\\services', 'services/default.png', '2024-05-11 15:59:00', '2024-05-11 15:59:00'),
(14, '4', 'App\\Models\\services', '1715453946845917910499_image.png', '2024-05-11 15:59:06', '2024-05-11 15:59:06');

-- --------------------------------------------------------

--
-- Table structure for table `languages`
--

CREATE TABLE `languages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `prefix` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `languages`
--

INSERT INTO `languages` (`id`, `name`, `prefix`, `created_at`, `updated_at`) VALUES
(1, 'arabic', 'ar', '2024-05-09 22:22:45', NULL),
(2, 'english', 'en', '2024-05-09 22:22:45', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(2, '2014_10_12_000000_create_users_table', 1),
(3, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(4, '2019_08_19_000000_create_failed_jobs_table', 1),
(5, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(6, '2024_05_04_152612_create_images_table', 1),
(7, '2024_05_05_175821_create_categories_table', 1),
(8, '2024_05_05_180131_create_languages_table', 1),
(9, '2024_05_05_180228_create_services_table', 1),
(10, '2024_05_05_210900create_properties_headings_table', 1),
(11, '2024_05_05_210923_create_properties_table', 1),
(12, '2024_05_05_211142_create_categories_properties_table', 1),
(13, '2024_05_05_211433_create_orders_table', 1),
(14, '2024_05_05_211921_create_payments_table', 1),
(15, '2024_05_05_212232_create_coupons_table', 1),
(16, '2024_05_05_213041_create_orders_coupons_table', 1),
(17, '2024_05_05_213433_create_orders_items_table', 1),
(18, '2024_05_05_213523_create_orders_items_properties_table', 1),
(19, '2024_05_05_223234_create_orders_trackings_table', 1),
(20, '2024_05_05_231024_create_taxes_table', 1),
(21, '2024_05_06_184834_create_orders_rates_table', 1),
(24, '2024_05_07_172745_create_notifications_table', 2),
(28, '2024_05_21_035020_create_permission_tables', 3),
(29, '2024_05_22_195619_create_notifications_data_schedules_table', 4);

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(191) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(191) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(6, 'App\\Models\\User', 56),
(7, 'App\\Models\\User', 53),
(7, 'App\\Models\\User', 75);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `type` varchar(191) NOT NULL,
  `notifiable_type` varchar(191) NOT NULL,
  `notifiable_id` bigint(20) UNSIGNED NOT NULL,
  `data` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at`) VALUES
('12d863e8-4a28-4e84-affc-7d94b39f4783', 'App\\Notifications\\UserRegisteryNotification', 'App\\Models\\User', 56, '{\"data\":\"{\\\"ar\\\":\\\"mahmoud \\u0642\\u0627\\u0645 \\u0628\\u0627\\u0644\\u062a\\u0633\\u062c\\u064a\\u0644 \\u0628\\u0646\\u062c\\u0627\\u062d \\u0627\\u0644\\u064a \\u0627\\u0644\\u0645\\u0646\\u0635\\u0629 \\\",\\\"en\\\":\\\"mahmoud registered in our app\\\"}\",\"sender\":63}', NULL, '2024-05-18 12:18:28', '2024-05-18 12:18:28'),
('3cfb443c-7e5c-4dea-90ea-4e70d8458d4d', 'App\\Notifications\\AdminSendNotification', 'App\\Models\\User', 75, '{\"data\":\"{\\\"ar\\\":\\\"test two\\\",\\\"en\\\":\\\"test two\\\"}\",\"sender\":56}', NULL, '2024-05-22 23:55:52', '2024-05-22 23:55:52'),
('66bcf6b9-4158-4005-9ad4-05c6a960a238', 'App\\Notifications\\UserRegisteryNotification', 'App\\Models\\User', 56, '{\"data\":\"{\\\"ar\\\":\\\"fatma \\u0642\\u0627\\u0645 \\u0628\\u0627\\u0644\\u062a\\u0633\\u062c\\u064a\\u0644 \\u0628\\u0646\\u062c\\u0627\\u062d \\u0627\\u0644\\u064a \\u0627\\u0644\\u0645\\u0646\\u0635\\u0629 \\\",\\\"en\\\":\\\"fatma registered in our app\\\"}\",\"sender\":75}', NULL, '2024-05-22 00:28:59', '2024-05-22 00:28:59'),
('6a117fdc-eded-4629-87fd-11dcf4a06a23', 'App\\Notifications\\WalletChargingNotification', 'App\\Models\\User', 63, '{\"data\":\"{\\\"ar\\\":\\\"\\u062a\\u0645 \\u0634\\u062d\\u0646 \\u0631\\u0635\\u064a\\u062f \\u0627\\u0644\\u0645\\u062d\\u0641\\u0638\\u0647 \\u0628\\u0642\\u064a\\u0645\\u0647 10 \\u0648 \\u0627\\u0635\\u0628\\u062d \\u0627\\u0644\\u0631\\u0635\\u064a\\u062f \\u0627\\u0644\\u062d\\u0627\\u0644\\u064a \\u0647\\u0648 10\\\",\\\"en\\\":\\\"The wallet balance has been charged 10 The current balance becomes 10\\\"}\",\"sender\":56}', NULL, '2024-05-18 17:02:57', '2024-05-18 17:02:57'),
('8126f498-59ac-4c17-bc21-68d3fcf1e379', 'App\\Notifications\\OrderStatusNotification', 'App\\Models\\User', 56, '{\"data\":\"{\\\"ar\\\":\\\"\\u062d\\u0627\\u0644\\u0647 \\u0627\\u0644\\u0637\\u0644\\u0628 \\u0627\\u0644\\u062e\\u0627\\u0635\\u0647 \\u0628\\u0643 \\u0631\\u0642\\u0645 17\\u062a\\u0645 \\u062a\\u062d\\u062f\\u064a\\u062b \\u062d\\u0627\\u0644\\u062a\\u0647 \\u0627\\u0644\\u064a printing\\\",\\\"en\\\":\\\"Order number17 changed its status to printing\\\"}\"}', '2024-05-18 14:49:50', '2024-05-17 12:05:51', '2024-05-17 12:05:51'),
('94b942b4-ff68-4e93-9575-d64b149907a0', 'App\\Notifications\\UserRegisteryNotification', 'App\\Models\\User', 56, '{\"data\":\"{\\\"ar\\\":\\\"mahmoud \\u0642\\u0627\\u0645 \\u0628\\u0627\\u0644\\u062a\\u0633\\u062c\\u064a\\u0644 \\u0628\\u0646\\u062c\\u0627\\u062d \\u0627\\u0644\\u064a \\u0627\\u0644\\u0645\\u0646\\u0635\\u0629 \\\",\\\"en\\\":\\\"mahmoud registered in our app\\\"}\"}', '2024-05-18 14:49:53', '2024-05-18 11:29:13', '2024-05-18 11:29:13'),
('c309f2cf-773f-46cf-881a-754aa26b5a85', 'App\\Notifications\\UserRegisteryNotification', 'App\\Models\\User', 56, '{\"data\":\"{\\\"ar\\\":\\\"menna \\u0642\\u0627\\u0645 \\u0628\\u0627\\u0644\\u062a\\u0633\\u062c\\u064a\\u0644 \\u0628\\u0646\\u062c\\u0627\\u062d \\u0627\\u0644\\u064a \\u0627\\u0644\\u0645\\u0646\\u0635\\u0629 \\\",\\\"en\\\":\\\"menna registered in our app\\\"}\"}', '2024-05-18 14:49:56', '2024-05-18 11:25:46', '2024-05-18 11:25:46'),
('c3e3259a-eba2-4099-bd36-21db48fea06e', 'App\\Notifications\\UserRegisteryNotification', 'App\\Models\\User', 56, '{\"data\":\"{\\\"ar\\\":\\\"fatma \\u0642\\u0627\\u0645 \\u0628\\u0627\\u0644\\u062a\\u0633\\u062c\\u064a\\u0644 \\u0628\\u0646\\u062c\\u0627\\u062d \\u0627\\u0644\\u064a \\u0627\\u0644\\u0645\\u0646\\u0635\\u0629 \\\",\\\"en\\\":\\\"fatma registered in our app\\\"}\",\"sender\":73}', NULL, '2024-05-22 00:27:22', '2024-05-22 00:27:22'),
('d1a3e2c5-7794-4a71-9153-fb07812a1905', 'App\\Notifications\\AdminSendNotification', 'App\\Models\\User', 53, '{\"data\":\"{\\\"ar\\\":\\\"test two\\\",\\\"en\\\":\\\"test two\\\"}\",\"sender\":56}', NULL, '2024-05-22 23:55:52', '2024-05-22 23:55:52'),
('e2ae3d43-0888-469e-a72c-806fdea2427f', 'App\\Notifications\\UserRegisteryNotification', 'App\\Models\\User', 56, '{\"data\":\"{\\\"ar\\\":\\\"menna \\u0642\\u0627\\u0645 \\u0628\\u0627\\u0644\\u062a\\u0633\\u062c\\u064a\\u0644 \\u0628\\u0646\\u062c\\u0627\\u062d \\u0627\\u0644\\u064a \\u0627\\u0644\\u0645\\u0646\\u0635\\u0629 \\\",\\\"en\\\":\\\"58 registered in our app\\\"}\"}', '2024-05-18 12:14:44', '2024-05-08 19:27:21', '2024-05-18 12:14:44'),
('ed3e7b10-f905-4f96-8e33-8b62fc92fcbe', 'App\\Notifications\\OrderStatusNotification', 'App\\Models\\User', 56, '{\"data\":\"{\\\"ar\\\":\\\"\\u062d\\u0627\\u0644\\u0647 \\u0627\\u0644\\u0637\\u0644\\u0628 \\u0627\\u0644\\u062e\\u0627\\u0635\\u0647 \\u0628\\u0643 \\u0631\\u0642\\u0645 17\\u062a\\u0645 \\u062a\\u062d\\u062f\\u064a\\u062b \\u062d\\u0627\\u0644\\u062a\\u0647 \\u0627\\u0644\\u064a printing\\\",\\\"en\\\":\\\"Order number17 changed its status to printing\\\"}\"}', '2024-05-18 12:14:44', '2024-05-17 12:08:24', '2024-05-18 12:14:44');

-- --------------------------------------------------------

--
-- Table structure for table `notifications_data_schedules`
--

CREATE TABLE `notifications_data_schedules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications_data_schedules`
--

INSERT INTO `notifications_data_schedules` (`id`, `content`, `created_at`, `updated_at`) VALUES
(1, 'test', '2024-05-22 17:13:49', '2024-05-22 17:13:49'),
(2, 'test two', '2024-05-22 23:53:30', '2024-05-22 23:53:30'),
(5, 'test two', '2024-05-22 23:55:52', '2024-05-22 23:55:52');

-- --------------------------------------------------------

--
-- Table structure for table `notifications_data_schedule_users`
--

CREATE TABLE `notifications_data_schedule_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `notification_data_schedule_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications_data_schedule_users`
--

INSERT INTO `notifications_data_schedule_users` (`id`, `user_id`, `notification_data_schedule_id`, `created_at`, `updated_at`) VALUES
(1, 75, 2, '2024-05-22 23:53:30', '2024-05-22 23:53:30'),
(4, 75, 5, '2024-05-22 23:55:52', '2024-05-22 23:55:52'),
(5, 53, 5, '2024-05-22 23:55:52', '2024-05-22 23:55:52');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `address` varchar(191) NOT NULL,
  `city` varchar(191) NOT NULL,
  `region` varchar(191) NOT NULL,
  `street` varchar(191) NOT NULL,
  `house_number` varchar(191) NOT NULL,
  `coordinates` varchar(191) NOT NULL,
  `status` varchar(191) NOT NULL DEFAULT 'working',
  `note` text DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `address`, `city`, `region`, `street`, `house_number`, `coordinates`, `status`, `note`, `deleted_at`, `created_at`, `updated_at`) VALUES
(17, 56, 'بجوار مسجد ابو بكر', 'القاهره', 'التجمع الخامس', 'شارع ابو بكر الصديق', '0115226454', '12312312321,3213123123', 'working', '{\"system_refund\":\"\",\"client\":\"يجي بعد المغرب\"}', NULL, '2024-05-15 13:37:39', '2024-05-15 13:37:39'),
(19, 56, 'بجوار مسجد ابو بكر', 'القاهره', 'التجمع الخامس', 'شارع ابو بكر الصديق', '0115226454', '12312312321,3213123123', 'working', '{\"system_refund\":\"\",\"client\":\"يجي بعد المغرب\"}', NULL, '2024-05-15 16:27:32', '2024-05-15 16:27:32'),
(20, 56, 'بجوار مسجد ابو بكر', 'القاهره', 'التجمع الخامس', 'شارع ابو بكر الصديق', '0115226454', '12312312321,3213123123', 'working', '{\"system_refund\":\"\",\"client\":\"يجي بعد المغرب\"}', NULL, '2024-05-29 16:32:36', '2024-05-15 16:32:36');

-- --------------------------------------------------------

--
-- Table structure for table `orders_coupons`
--

CREATE TABLE `orders_coupons` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `coupon_id` bigint(20) UNSIGNED NOT NULL,
  `coupon_value` double(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders_coupons`
--

INSERT INTO `orders_coupons` (`id`, `order_id`, `coupon_id`, `coupon_value`, `created_at`, `updated_at`) VALUES
(4, 17, 1, 250.00, '2024-05-15 13:37:39', '2024-05-15 13:37:39'),
(6, 19, 1, 250.00, '2024-05-15 16:27:32', '2024-05-15 16:27:32');

-- --------------------------------------------------------

--
-- Table structure for table `orders_items`
--

CREATE TABLE `orders_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `service_id` bigint(20) UNSIGNED NOT NULL,
  `is_cancelled` varchar(191) DEFAULT NULL,
  `file` varchar(191) NOT NULL,
  `price` double(8,2) NOT NULL,
  `paper_number` int(11) NOT NULL,
  `copies_number` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders_items`
--

INSERT INTO `orders_items` (`id`, `order_id`, `service_id`, `is_cancelled`, `file`, `price`, `paper_number`, `copies_number`, `created_at`, `updated_at`) VALUES
(17, 17, 2, NULL, '17157910591875258965539_file.pdf', 20.00, 200, 5, '2024-05-15 13:37:39', '2024-05-15 13:37:39'),
(19, 19, 2, NULL, '17158012523450351587296_file.pdf', 20.00, 200, 5, '2024-05-15 16:27:32', '2024-05-15 16:27:32'),
(20, 20, 2, NULL, '17158015566324605421952_file.pdf', 20.00, 200, 5, '2024-05-15 16:32:36', '2024-05-15 16:32:36');

-- --------------------------------------------------------

--
-- Table structure for table `orders_items_properties`
--

CREATE TABLE `orders_items_properties` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_item_id` bigint(20) UNSIGNED NOT NULL,
  `property_id` bigint(20) UNSIGNED NOT NULL,
  `price` double(8,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders_items_properties`
--

INSERT INTO `orders_items_properties` (`id`, `order_item_id`, `property_id`, `price`, `created_at`, `updated_at`) VALUES
(17, 17, 1, 20.00, '2024-05-15 13:37:39', '2024-05-15 13:37:39'),
(19, 19, 1, 20.00, '2024-05-15 16:27:32', '2024-05-15 16:27:32'),
(20, 20, 1, 20.00, '2024-05-15 16:32:36', '2024-05-15 16:32:36');

-- --------------------------------------------------------

--
-- Table structure for table `orders_rates`
--

CREATE TABLE `orders_rates` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `print_rate` int(11) NOT NULL,
  `delivery_rate` int(11) NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders_rates`
--

INSERT INTO `orders_rates` (`id`, `order_id`, `print_rate`, `delivery_rate`, `comment`, `created_at`, `updated_at`) VALUES
(1, 20, 5, 4, 'dasd', '2024-05-22 00:13:32', '2024-05-22 00:13:32');

-- --------------------------------------------------------

--
-- Table structure for table `orders_trackings`
--

CREATE TABLE `orders_trackings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `status` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders_trackings`
--

INSERT INTO `orders_trackings` (`id`, `order_id`, `status`, `created_at`, `updated_at`) VALUES
(15, 17, 'pending', '2024-05-15 13:37:39', '2024-05-15 13:37:39'),
(17, 19, 'pending', '2024-05-15 16:27:32', '2024-05-15 16:27:32'),
(18, 20, 'pending', '2024-05-15 16:32:36', '2024-05-15 16:32:36'),
(20, 20, 'review', '2024-05-15 16:32:36', '2024-05-15 16:32:36'),
(21, 17, 'review', '2024-05-15 17:34:55', '2024-05-15 17:34:55'),
(23, 17, 'cancelled', '2024-05-17 11:44:05', '2024-05-17 11:44:05'),
(28, 17, 'printing', '2024-05-17 12:08:24', '2024-05-17 12:08:24');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `paymentable_id` varchar(191) NOT NULL,
  `paymentable_type` varchar(191) NOT NULL,
  `money` double(8,2) NOT NULL,
  `tax` double(8,2) NOT NULL,
  `type` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `paymentable_id`, `paymentable_type`, `money`, `tax`, `type`, `created_at`, `updated_at`) VALUES
(3, '17', 'App\\Models\\orders', 39750.00, 0.00, 'wallet', '2024-05-15 13:37:39', '2024-05-15 13:37:39'),
(4, '19', 'App\\Models\\orders', 39750.00, 0.00, 'wallet', '2024-05-15 16:27:32', '2024-05-15 16:27:32'),
(5, '20', 'App\\Models\\orders', 40000.00, 0.00, 'wallet', '2024-05-15 16:32:36', '2024-05-15 16:32:36');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `guard_name` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(6, 'facility-facility-settings', 'sanctum', '2024-05-21 01:08:38', '2024-05-21 01:08:38');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(191) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'ali@yahoo.com', '493243f302954dad01d2c22ae93001defeb126c236798442ee90aff9cdb555eb', '[\"*\"]', NULL, NULL, '2024-05-07 15:59:38', '2024-05-07 15:59:38'),
(2, 'App\\Models\\User', 2, 'ali@yahoo.com', '36a4bc56905239546039c600ba316b515e2ee691ccdb817c70235a4310d3f510', '[\"*\"]', NULL, NULL, '2024-05-07 16:02:49', '2024-05-07 16:02:49'),
(50, 'App\\Models\\User', 51, 'ali@yahoo.com', '99bf3a7f9ecbb6214f99c4b7ebb172a56f41ca7a598a5df13825a7615a38d023', '[\"*\"]', NULL, NULL, '2024-05-07 21:03:15', '2024-05-07 21:03:15'),
(51, 'App\\Models\\User', 52, 'ali@yahoo.com', '5dfae24b2ccbe195fda1674ff6c3dceb9beb0dfb610f7cd18807ab265eb2e389', '[\"*\"]', NULL, NULL, '2024-05-07 21:19:18', '2024-05-07 21:19:18'),
(52, 'App\\Models\\User', 53, 'ali@yahoo.com', '5e7d47ab2191e80fb7bd6ed7bd7006345b7f35f716f27679b7c37cf00089e94e', '[\"*\"]', NULL, NULL, '2024-05-07 21:19:59', '2024-05-07 21:19:59'),
(53, 'App\\Models\\User', 54, 'al1i@yahoo.com', '958a63172c19e0ca4e040b998775d766ce85fe621c078a4ba48de2357a04a778', '[\"*\"]', NULL, NULL, '2024-05-07 21:20:44', '2024-05-07 21:20:44'),
(54, 'App\\Models\\User', 55, 'al1111i@yahoo.com', 'f47dad855d87337c175b36b77a8b198cd4e4050307956ffa429d216905441f5f', '[\"*\"]', NULL, NULL, '2024-05-07 21:22:53', '2024-05-07 21:22:53'),
(55, 'App\\Models\\User', 57, 'menna@yahoo.com', '853079c0d0310ed7f70213c6014969dfe4b31ddb98aa6fca213bdc61eddc5ab1', '[\"*\"]', NULL, NULL, '2024-05-08 19:25:29', '2024-05-08 19:25:29'),
(56, 'App\\Models\\User', 58, 'menna@yahoo.com', 'f07c1b24e6546b2c168c138dd460b94fa84b98a4342fb0f0d2ef0bdd33beb407', '[\"*\"]', NULL, NULL, '2024-05-08 19:27:21', '2024-05-08 19:27:21'),
(57, 'App\\Models\\User', 53, 'ali@yahoo.com', 'f0e9869dbd2f3b8eb876190818ce68868e35c28ddda5346fa39634364cb3caf2', '[\"*\"]', NULL, NULL, '2024-05-08 20:02:17', '2024-05-08 20:02:17'),
(58, 'App\\Models\\User', 53, 'ali@yahoo.com', 'eeb00e2175f4d03b63da707b95a8f82b5058a98838129c894890f66ced39bae9', '[\"*\"]', NULL, NULL, '2024-05-08 20:05:30', '2024-05-08 20:05:30'),
(59, 'App\\Models\\User', 53, 'ali@yahoo.com', 'fda900d890b70da0379e6596f14f50eff428a7fb0e9fdac7fe6fc0cfe82c9342', '[\"*\"]', NULL, NULL, '2024-05-09 15:09:34', '2024-05-09 15:09:34'),
(60, 'App\\Models\\User', 53, 'ali@yahoo.com', 'd421707a3fef5ba16d7ae903d3c4a4410f4e4fc1251ce5b566c2e8c59a814c5f', '[\"*\"]', '2024-05-22 17:26:06', NULL, '2024-05-09 19:42:50', '2024-05-22 17:26:06'),
(61, 'App\\Models\\User', 56, 'mahmoud@yahoo.com', '4ba8557522067c53399f1647d310f3d008f970729efe95c82852ff37ccc15cf8', '[\"*\"]', '2024-05-22 23:55:52', NULL, '2024-05-11 15:35:16', '2024-05-22 23:55:52'),
(62, 'App\\Models\\User', 59, 'mahmoud_elzanklony@yahoo.com', '4b203b3d70ae36c5c9a519d4244c5db4d7ce2a38c492df21b1d5d157e94e7eb1', '[\"*\"]', NULL, NULL, '2024-05-18 11:25:46', '2024-05-18 11:25:46'),
(63, 'App\\Models\\User', 61, 'mahmoud_elzanklony@yahoo.com', '1707043fb50e9030dfffaa9a7f2b49d7b8ab3d4197610f072093bfb4a70937f0', '[\"*\"]', NULL, NULL, '2024-05-18 11:29:13', '2024-05-18 11:29:13'),
(64, 'App\\Models\\User', 56, 'mahmoud@yahoo.com', '70ae15572cfaa6c9d2f29cb05c0b9fd6cc9c381868ae4c7fd43073ed59c7aaf4', '[\"*\"]', NULL, NULL, '2024-05-18 11:34:51', '2024-05-18 11:34:51'),
(65, 'App\\Models\\User', 56, 'mahmoud@yahoo.com', '37f9af103a13d22ed50fe715f0beb6fcf448b17779f9c008a4333e5a3b475fe1', '[\"*\"]', NULL, NULL, '2024-05-18 11:34:59', '2024-05-18 11:34:59'),
(66, 'App\\Models\\User', 56, 'mahmoud@yahoo.com', '831b438af4334ef5cdc19523f643af1d4eaa7487b0f857030dbb337c0046c52d', '[\"*\"]', '2024-05-18 12:24:47', NULL, '2024-05-18 11:48:48', '2024-05-18 12:24:47'),
(67, 'App\\Models\\User', 62, 'mahmoud_elzanklony@yahoo.com', '1187f9b00730fd20dfc185de483a4379232e38e2067045980d78a53071a657ea', '[\"*\"]', NULL, NULL, '2024-05-18 12:17:22', '2024-05-18 12:17:22'),
(68, 'App\\Models\\User', 63, 'mahmoud_elzanklony@yahoo.com', '2d1e4a5f363ffc3480dbad4ab232839b0f19d509da9a92be293f2861d710acaf', '[\"*\"]', NULL, NULL, '2024-05-18 12:18:28', '2024-05-18 12:18:28'),
(69, 'App\\Models\\User', 73, 'fatma@gmail.com', 'ee7369b3dc236658fa38952b9f025cf6117ffe42a85beb15e6876fb337962913', '[\"*\"]', NULL, NULL, '2024-05-22 00:27:22', '2024-05-22 00:27:22'),
(70, 'App\\Models\\User', 75, 'fatma@gmail.com', '681df9d2a0e7abf08197c1bd2ef2ba6a1a197a65246bbd6ca222a3ca07d5e93e', '[\"*\"]', NULL, NULL, '2024-05-22 00:28:59', '2024-05-22 00:28:59'),
(71, 'App\\Models\\User', 75, 'fatma@gmail.com', '28ffbec28d8e42f5b107277ed57859868f7c89c153fb9a4f0d0c2a4bf7aae3c8', '[\"*\"]', NULL, NULL, '2024-05-22 00:35:26', '2024-05-22 00:35:26'),
(72, 'App\\Models\\User', 75, 'fatma@gmail.com', '8b3ddcdc39585d4a741b7472f81ba7d762455d0b1a7acc417b600ac1cf721bca', '[\"*\"]', '2024-05-22 01:12:20', NULL, '2024-05-22 00:53:54', '2024-05-22 01:12:20');

-- --------------------------------------------------------

--
-- Table structure for table `properties`
--

CREATE TABLE `properties` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `property_id_heading` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `price` double(8,2) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `properties`
--

INSERT INTO `properties` (`id`, `user_id`, `property_id_heading`, `name`, `price`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 56, 1, '{\"ar\":\"ابيض و اسود\",\"en\":\"white and black\"}', 20.00, NULL, '2024-05-22 18:20:17', NULL),
(2, 56, 1, '{\"ar\":\"الوان\",\"en\":\"colors\"}', 80.00, NULL, '2024-05-15 18:20:17', NULL),
(3, 56, 1, '{\"ar\":\"ابيض و اسود\",\"en\":\"white and black\"}', 300.00, NULL, '2024-05-12 20:03:34', '2024-05-12 20:03:34');

-- --------------------------------------------------------

--
-- Table structure for table `properties_headings`
--

CREATE TABLE `properties_headings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `properties_headings`
--

INSERT INTO `properties_headings` (`id`, `user_id`, `name`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 53, '{\"ar\":\"الالوان\",\"en\":\"colors\"}', NULL, '2024-05-09 22:01:00', '2024-05-09 22:01:00'),
(4, 53, '{\"ar\":\"الالوانss\",\"en\":\"colors edit\"}', NULL, '2024-05-09 22:02:38', '2024-05-09 22:19:22');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `guard_name` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `created_at`, `updated_at`) VALUES
(6, 'admin', 'sanctum', '2024-05-21 01:08:38', '2024-05-21 01:08:38'),
(7, 'client', 'sanctum', '2024-05-21 01:08:38', '2024-05-21 01:08:38');

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(6, 6);

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `info` text DEFAULT NULL,
  `price` double(8,2) NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`id`, `user_id`, `category_id`, `name`, `info`, `price`, `deleted_at`, `created_at`, `updated_at`) VALUES
(2, 56, 2, '{\"ar\":\"طباعه كتب مشروع تخرج\",\"en\":\"graduation project book printing\"}', NULL, 20.00, NULL, '2024-05-11 15:51:19', '2024-05-11 15:51:19'),
(3, 56, 2, '{\"ar\":\"طباعه كتب مشروع تخرج\",\"en\":\"graduation project book printing\"}', '{\"ar\":\"وصف القسم\",\"en\":\"description\"}', 60.00, NULL, '2024-05-11 15:59:00', '2024-05-11 15:59:00'),
(4, 56, 2, '{\"ar\":\"طباعه كتب مشروع تخرج\",\"en\":\"graduation project book printing\"}', '{\"ar\":\"وصف القسم\",\"en\":\"description\"}', 90.00, NULL, '2024-05-11 15:59:06', '2024-05-11 15:59:06');

-- --------------------------------------------------------

--
-- Table structure for table `taxes`
--

CREATE TABLE `taxes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `percentage` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `taxes`
--

INSERT INTO `taxes` (`id`, `name`, `percentage`, `created_at`, `updated_at`) VALUES
(1, 'tax24', '80', '2024-05-22 16:47:29', '2024-05-22 16:47:29');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(191) NOT NULL,
  `email` varchar(191) NOT NULL,
  `phone_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) NOT NULL,
  `phone` varchar(191) NOT NULL,
  `otp_secret` varchar(191) NOT NULL,
  `wallet` int(11) NOT NULL DEFAULT 0,
  `remember_token` varchar(100) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `phone_verified_at`, `password`, `phone`, `otp_secret`, `wallet`, `remember_token`, `deleted_at`, `created_at`, `updated_at`) VALUES
(53, 'ali', 'ali@yahoo.com', NULL, '$2y$10$a/HzYZtW/H1kZhSoM9UbsO5VPRdluIMKIA0VCs23tKEorOmjwDmTy', '01152296656', '4372', 0, NULL, NULL, '2024-05-07 21:19:59', '2024-05-09 15:09:28'),
(56, 'mahmoud', 'mahmoud@yahoo.com', NULL, '$2y$10$alAD6KxFAl9oCPlfG8D7oOlYlA7P7THKT6gtGNv/j9nCRWdmrWT3W', '01152296656', '6047', 40250, NULL, NULL, '2024-05-07 21:19:59', '2024-05-17 11:44:05'),
(58, 'menna', 'menna@yahoo.com', '2024-05-08 20:01:47', '$2y$10$wPTQQ7OOIVBzCzAgc0Ehv.B7kYW6uLE7z5MNjd95GnjPlt7Zsm9z6', '01152296656', '5560', 0, NULL, NULL, '2024-05-08 19:27:21', '2024-05-08 20:01:47'),
(63, 'mahmoud', 'mahmoud_elzanklony@yahoo.com', NULL, '$2y$10$muaFE.rIxz6XG90wK57v5Ozalyj.DHPqJb5kuYnifdYaeriugfhg.', '01152296656', '8303', 230, NULL, NULL, '2024-05-18 12:18:28', '2024-05-18 17:04:18'),
(75, 'Fatma ali', 'fatma@gmail.com', '2023-05-22 00:52:41', '$2y$10$zZp/Eth1HYUtSTsOmcWPyuF.GzhDWmiqEDNxsMeRF2aYsVLPBndZ.', '01152216001', '4998', 0, NULL, NULL, '2024-05-22 00:28:59', '2024-05-22 01:10:46');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `categories_properties`
--
ALTER TABLE `categories_properties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categories_properties_category_id_foreign` (`category_id`),
  ADD KEY `categories_properties_property_id_foreign` (`property_id`);

--
-- Indexes for table `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`);

--
-- Indexes for table `notifications_data_schedules`
--
ALTER TABLE `notifications_data_schedules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications_data_schedule_users`
--
ALTER TABLE `notifications_data_schedule_users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_data_schedule_users_user_id_foreign` (`user_id`),
  ADD KEY `notification_data_schedule_id` (`notification_data_schedule_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

--
-- Indexes for table `orders_coupons`
--
ALTER TABLE `orders_coupons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_coupons_order_id_foreign` (`order_id`),
  ADD KEY `orders_coupons_coupon_id_foreign` (`coupon_id`);

--
-- Indexes for table `orders_items`
--
ALTER TABLE `orders_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_items_order_id_foreign` (`order_id`),
  ADD KEY `orders_items_service_id_foreign` (`service_id`);

--
-- Indexes for table `orders_items_properties`
--
ALTER TABLE `orders_items_properties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_items_properties_order_item_id_foreign` (`order_item_id`),
  ADD KEY `orders_items_properties_property_id_foreign` (`property_id`);

--
-- Indexes for table `orders_rates`
--
ALTER TABLE `orders_rates`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_rates_order_id_foreign` (`order_id`);

--
-- Indexes for table `orders_trackings`
--
ALTER TABLE `orders_trackings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_trackings_order_id_foreign` (`order_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `properties_property_id_heading_foreign` (`property_id_heading`);

--
-- Indexes for table `properties_headings`
--
ALTER TABLE `properties_headings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `services_category_id_foreign` (`category_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `taxes`
--
ALTER TABLE `taxes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `categories_properties`
--
ALTER TABLE `categories_properties`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `images`
--
ALTER TABLE `images`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `languages`
--
ALTER TABLE `languages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `notifications_data_schedules`
--
ALTER TABLE `notifications_data_schedules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `notifications_data_schedule_users`
--
ALTER TABLE `notifications_data_schedule_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `orders_coupons`
--
ALTER TABLE `orders_coupons`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `orders_items`
--
ALTER TABLE `orders_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `orders_items_properties`
--
ALTER TABLE `orders_items_properties`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `orders_rates`
--
ALTER TABLE `orders_rates`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `orders_trackings`
--
ALTER TABLE `orders_trackings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `properties`
--
ALTER TABLE `properties`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `properties_headings`
--
ALTER TABLE `properties_headings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `taxes`
--
ALTER TABLE `taxes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `categories_properties`
--
ALTER TABLE `categories_properties`
  ADD CONSTRAINT `categories_properties_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `categories_properties_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `coupons`
--
ALTER TABLE `coupons`
  ADD CONSTRAINT `coupons_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `notifications_data_schedule_users`
--
ALTER TABLE `notifications_data_schedule_users`
  ADD CONSTRAINT `notifications_data_schedule_users_ibfk_1` FOREIGN KEY (`notification_data_schedule_id`) REFERENCES `notifications_data_schedules` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `notifications_data_schedule_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders_coupons`
--
ALTER TABLE `orders_coupons`
  ADD CONSTRAINT `orders_coupons_coupon_id_foreign` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_coupons_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders_items`
--
ALTER TABLE `orders_items`
  ADD CONSTRAINT `orders_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_items_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders_items_properties`
--
ALTER TABLE `orders_items_properties`
  ADD CONSTRAINT `orders_items_properties_order_item_id_foreign` FOREIGN KEY (`order_item_id`) REFERENCES `orders_items` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_items_properties_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders_rates`
--
ALTER TABLE `orders_rates`
  ADD CONSTRAINT `orders_rates_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders_trackings`
--
ALTER TABLE `orders_trackings`
  ADD CONSTRAINT `orders_trackings_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `properties`
--
ALTER TABLE `properties`
  ADD CONSTRAINT `properties_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `properties_property_id_heading_foreign` FOREIGN KEY (`property_id_heading`) REFERENCES `properties_headings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `properties_headings`
--
ALTER TABLE `properties_headings`
  ADD CONSTRAINT `properties_headings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `services`
--
ALTER TABLE `services`
  ADD CONSTRAINT `services_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `services_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
