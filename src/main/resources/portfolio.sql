-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               10.4.12-MariaDB - mariadb.org binary distribution
-- Операционная система:         Win64
-- HeidiSQL Версия:              10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Дамп структуры базы данных portfolio
CREATE DATABASE IF NOT EXISTS `portfolio` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `portfolio`;

-- Дамп структуры для таблица portfolio.cash_flow_type
CREATE TABLE IF NOT EXISTS `cash_flow_type` (
  `id` int(10) unsigned NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Тип движения средств';

-- Дамп данных таблицы portfolio.cash_flow_type: ~12 rows (приблизительно)
/*!40000 ALTER TABLE `cash_flow_type` DISABLE KEYS */;
INSERT IGNORE INTO `cash_flow_type` (`id`, `name`) VALUES
	(0, 'Пополнение и снятие'),
	(1, 'Чистая стоимость сделки (без НКД)'),
	(2, 'НКД на день сделки'),
	(3, 'Комиссия'),
	(4, 'Амортизация облигации'),
	(5, 'Погашение облигации'),
	(6, 'Купонный доход'),
	(7, 'Дивиденды'),
	(8, 'Вариационная маржа'),
	(9, 'Гарантийное обеспечение'),
	(10, 'Налог уплаченный (с купона, с дивидендов)'),
	(11, 'Прогнозируемый налог');
/*!40000 ALTER TABLE `cash_flow_type` ENABLE KEYS */;

-- Дамп структуры для таблица portfolio.event_cash_flow
CREATE TABLE IF NOT EXISTS `event_cash_flow` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `isin` char(12) NOT NULL COMMENT 'ISIN инструмента, по которому произошло событие',
  `type` int(10) unsigned NOT NULL COMMENT 'Причина движения',
  `value` decimal(8,2) NOT NULL COMMENT 'Размер',
  `currency` char(3) NOT NULL DEFAULT 'RUR' COMMENT 'Код валюты',
  PRIMARY KEY (`id`),
  KEY `event_cash_flow_type_ix` (`type`),
  KEY `event_cash_flow_ticker_ix` (`isin`),
  CONSTRAINT `event_cash_flow_isin_fkey` FOREIGN KEY (`isin`) REFERENCES `security` (`isin`) ON UPDATE CASCADE,
  CONSTRAINT `event_cash_flow_type_fkey` FOREIGN KEY (`type`) REFERENCES `cash_flow_type` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8 COMMENT='Движение денежных средств';

-- Дамп данных таблицы portfolio.event_cash_flow: ~9 rows (приблизительно)
/*!40000 ALTER TABLE `event_cash_flow` DISABLE KEYS */;
INSERT IGNORE INTO `event_cash_flow` (`id`, `timestamp`, `isin`, `type`, `value`, `currency`) VALUES
	(1, '2020-02-16 20:09:22', 'RU000A1015S0', 1, -20.00, 'RUR');
/*!40000 ALTER TABLE `event_cash_flow` ENABLE KEYS */;

-- Дамп структуры для таблица portfolio.issuer
CREATE TABLE IF NOT EXISTS `issuer` (
  `inn` bigint(10) unsigned zerofill NOT NULL COMMENT 'ИНН',
  `name` varchar(100) NOT NULL COMMENT 'Наименование',
  PRIMARY KEY (`inn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Эмитенты';

-- Дамп данных таблицы portfolio.issuer: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `issuer` DISABLE KEYS */;
INSERT IGNORE INTO `issuer` (`inn`, `name`) VALUES
	(7203126844, '"Энерготехсервис", ООО');
/*!40000 ALTER TABLE `issuer` ENABLE KEYS */;

-- Дамп структуры для таблица portfolio.security
CREATE TABLE IF NOT EXISTS `security` (
  `isin` char(12) NOT NULL COMMENT 'ISIN код ценной бумаги',
  `ticker` varchar(16) DEFAULT NULL COMMENT 'Тикер',
  `name` varchar(100) DEFAULT NULL COMMENT 'Полное наименование ценной бумаги или дериватива',
  `issuer_inn` bigint(10) unsigned zerofill DEFAULT NULL COMMENT 'Эмитент (ИНН)',
  PRIMARY KEY (`isin`),
  KEY `security_issuer_inn_ix` (`issuer_inn`),
  CONSTRAINT `security_issuer_inn_fkey` FOREIGN KEY (`issuer_inn`) REFERENCES `issuer` (`inn`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Общая информация по ценным бумагам';

-- Дамп данных таблицы portfolio.security: ~1 rows (приблизительно)
/*!40000 ALTER TABLE `security` DISABLE KEYS */;
INSERT IGNORE INTO `security` (`isin`, `ticker`, `name`, `issuer_inn`) VALUES
	('RU000A1015S0', 'ЭТС1 Р01', 'Энерготехсервис серии 001Р-01', 7203126844);
/*!40000 ALTER TABLE `security` ENABLE KEYS */;

-- Дамп структуры для таблица portfolio.transaction
CREATE TABLE IF NOT EXISTS `transaction` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Номер транзакции',
  `isin` char(12) NOT NULL DEFAULT '' COMMENT 'Ценная бумага',
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время совершения сделки',
  `count` int(10) unsigned zerofill NOT NULL COMMENT 'Время сделки',
  PRIMARY KEY (`id`),
  KEY `transaction_ticker_ix` (`isin`),
  CONSTRAINT `transaction_isin_fkey` FOREIGN KEY (`isin`) REFERENCES `security` (`isin`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COMMENT='Сделки';

-- Дамп данных таблицы portfolio.transaction: ~1 rows (приблизительно)
/*!40000 ALTER TABLE `transaction` DISABLE KEYS */;
INSERT IGNORE INTO `transaction` (`id`, `isin`, `timestamp`, `count`) VALUES
	(7, 'RU000A1015S0', '2020-02-16 16:21:02', 0000000001);
/*!40000 ALTER TABLE `transaction` ENABLE KEYS */;

-- Дамп структуры для таблица portfolio.transaction_cash_flow
CREATE TABLE IF NOT EXISTS `transaction_cash_flow` (
  `transaction_id` int(10) unsigned NOT NULL COMMENT 'ID транзакции',
  `type` int(10) unsigned NOT NULL COMMENT 'Причина движения',
  `value` int(10) NOT NULL COMMENT 'Размер',
  `currency` char(3) NOT NULL DEFAULT 'RUR' COMMENT 'Код валюты',
  PRIMARY KEY (`transaction_id`,`type`),
  KEY `transaction_cash_flow_type_key` (`type`),
  KEY `transaction_cash_flow_transaction_id_ix` (`transaction_id`),
  CONSTRAINT `transaction_cash_flow_transaction_id_fkey` FOREIGN KEY (`transaction_id`) REFERENCES `transaction` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `transaction_cash_flow_type_fkey` FOREIGN KEY (`type`) REFERENCES `cash_flow_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC COMMENT='Движение денежных средств';

-- Дамп данных таблицы portfolio.transaction_cash_flow: ~0 rows (приблизительно)
/*!40000 ALTER TABLE `transaction_cash_flow` DISABLE KEYS */;
INSERT IGNORE INTO `transaction_cash_flow` (`transaction_id`, `type`, `value`, `currency`) VALUES
	(7, 1, -30, 'RUR');
/*!40000 ALTER TABLE `transaction_cash_flow` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;