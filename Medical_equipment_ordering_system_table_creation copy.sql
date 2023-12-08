CREATE TABLE `Business` (
  `business_id` int NOT NULL AUTO_INCREMENT,
  `business_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`business_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `City` (
  `city_id` int NOT NULL AUTO_INCREMENT,
  `city_name` varchar(255) DEFAULT NULL,
  `state_id` int DEFAULT NULL,
  PRIMARY KEY (`city_id`),
  KEY `state_id` (`state_id`),
  CONSTRAINT `city_ibfk_1` FOREIGN KEY (`state_id`) REFERENCES `State` (`state_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16384 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `Country` (
  `country_id` int NOT NULL AUTO_INCREMENT,
  `country_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(255) DEFAULT NULL,
  `address1` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `address3` varchar(255) DEFAULT NULL,
  `zipcode` varchar(10) DEFAULT NULL,
  `city_id` int DEFAULT NULL,
  `customertype_id` int DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`customer_id`),
  KEY `city_id` (`city_id`),
  KEY `customertype_id` (`customertype_id`),
  KEY `email` (`email`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `City` (`city_id`),
  CONSTRAINT `customer_ibfk_2` FOREIGN KEY (`customertype_id`) REFERENCES `CustomerType` (`customertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `CustomerType` (
  `customertype_id` int NOT NULL AUTO_INCREMENT,
  `customertype_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Equipment` (
  `equipment_id` int NOT NULL AUTO_INCREMENT,
  `equipment_name` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`equipment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Login` (
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`email`),
  CONSTRAINT `fk_email_customer` FOREIGN KEY (`email`) REFERENCES `Customer` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Medical_data_temp` (
  `provider_id` int DEFAULT NULL,
  `acceptsassignement` varchar(45) DEFAULT NULL,
  `participationbegindate` varchar(45) DEFAULT NULL,
  `businessname` varchar(200) DEFAULT NULL,
  `practicename` varchar(205) DEFAULT NULL,
  `practiceaddress1` varchar(1000) DEFAULT NULL,
  `practiceaddress2` varchar(1000) DEFAULT NULL,
  `practicecity` varchar(200) DEFAULT NULL,
  `practicestate` varchar(100) DEFAULT NULL,
  `practicezip9code` varchar(45) DEFAULT NULL,
  `telephonenumber` varchar(1000) DEFAULT NULL,
  `specialitieslist` varchar(2000) DEFAULT NULL,
  `providertypelist` varchar(1000) DEFAULT NULL,
  `supplieslist` varchar(1000) DEFAULT NULL,
  `latitude` varchar(45) DEFAULT NULL,
  `longitude` varchar(45) DEFAULT NULL,
  `is_contracted_for_cba` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `supplier_id` int DEFAULT NULL,
  `equipment_id` int DEFAULT NULL,
  `order_name` varchar(255) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `customer_id` int DEFAULT NULL,
  `ordertype_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `customer_id` (`customer_id`),
  KEY `ordertype_id` (`ordertype_id`),
  KEY `orders_ibfk_1_idx` (`supplier_id`),
  KEY `orders_ibfk_2_idx` (`equipment_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `SupplierEquipmentList` (`supplier_id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`equipment_id`) REFERENCES `SupplierEquipmentList` (`equipment_id`),
  CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `Customer` (`customer_id`),
  CONSTRAINT `orders_ibfk_4` FOREIGN KEY (`ordertype_id`) REFERENCES `OrderType` (`ordertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `OrderType` (
  `ordertype_id` int NOT NULL AUTO_INCREMENT,
  `ordertype_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ordertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ProviderType` (
  `providertype_id` int NOT NULL AUTO_INCREMENT,
  `providertype_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`providertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Specialty` (
  `specialty_id` int NOT NULL AUTO_INCREMENT,
  `specialty_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`specialty_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `State` (
  `state_id` int NOT NULL AUTO_INCREMENT,
  `state_name` varchar(255) DEFAULT NULL,
  `country_id` int DEFAULT NULL,
  PRIMARY KEY (`state_id`),
  KEY `country_id` (`country_id`),
  CONSTRAINT `state_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `Country` (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `Supplier` (
  `supplier_id` int NOT NULL AUTO_INCREMENT,
  `supplier_name` varchar(255) DEFAULT NULL,
  `business_id` int DEFAULT NULL,
  `address1` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `address3` varchar(255) DEFAULT NULL,
  `zipcode` varchar(10) DEFAULT NULL,
  `city_id` int DEFAULT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `specialty_id` int DEFAULT NULL,
  `providertype_id` int DEFAULT NULL,
  PRIMARY KEY (`supplier_id`),
  KEY `business_id` (`business_id`),
  KEY `city_id` (`city_id`),
  KEY `specialty_id` (`specialty_id`),
  KEY `providertype_id` (`providertype_id`),
  CONSTRAINT `supplier_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `Business` (`business_id`),
  CONSTRAINT `supplier_ibfk_2` FOREIGN KEY (`city_id`) REFERENCES `City` (`city_id`),
  CONSTRAINT `supplier_ibfk_3` FOREIGN KEY (`specialty_id`) REFERENCES `Specialty` (`specialty_id`),
  CONSTRAINT `supplier_ibfk_4` FOREIGN KEY (`providertype_id`) REFERENCES `ProviderType` (`providertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29883881 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `SupplierEquipmentList` (
  `equipment_id` int NOT NULL,
  `supplier_id` int NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`equipment_id`,`supplier_id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `supplierequipmentlist_ibfk_1` FOREIGN KEY (`equipment_id`) REFERENCES `Equipment` (`equipment_id`),
  CONSTRAINT `supplierequipmentlist_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `Supplier` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



