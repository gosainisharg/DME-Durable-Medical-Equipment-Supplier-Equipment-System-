#This is the simplified script for understanding purposes
#Please use the Main script to create schema and all its tables including Func,Triggers,Stored procedures and Views

#Creating all the tables
CREATE TABLE `business` (
  `business_id` int NOT NULL AUTO_INCREMENT,
  `business_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`business_id`)
) ENGINE=InnoDB AUTO_INCREMENT=32768 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `city` (
  `city_id` int NOT NULL AUTO_INCREMENT,
  `city_name` varchar(255) DEFAULT NULL,
  `state_id` int DEFAULT NULL,
  PRIMARY KEY (`city_id`),
  KEY `state_id` (`state_id`),
  CONSTRAINT `city_ibfk_1` FOREIGN KEY (`state_id`) REFERENCES `state` (`state_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16384 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `country` (
  `country_id` int NOT NULL AUTO_INCREMENT,
  `country_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `customer` (
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
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`),
  CONSTRAINT `customer_ibfk_2` FOREIGN KEY (`customertype_id`) REFERENCES `customertype` (`customertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `customertype` (
  `customertype_id` int NOT NULL AUTO_INCREMENT,
  `customertype_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `equipment` (
  `equipment_id` int NOT NULL AUTO_INCREMENT,
  `equipment_name` varchar(255) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`equipment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `login` (
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`email`),
  CONSTRAINT `fk_email_customer` FOREIGN KEY (`email`) REFERENCES `customer` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `medical_data_temp` (
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

CREATE TABLE `orders` (
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
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplierequipmentlist` (`supplier_id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`equipment_id`) REFERENCES `supplierequipmentlist` (`equipment_id`),
  CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `orders_ibfk_4` FOREIGN KEY (`ordertype_id`) REFERENCES `ordertype` (`ordertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `ordertype` (
  `ordertype_id` int NOT NULL AUTO_INCREMENT,
  `ordertype_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ordertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `providertype` (
  `providertype_id` int NOT NULL AUTO_INCREMENT,
  `providertype_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`providertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `specialty` (
  `specialty_id` int NOT NULL AUTO_INCREMENT,
  `specialty_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`specialty_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `state` (
  `state_id` int NOT NULL AUTO_INCREMENT,
  `state_name` varchar(255) DEFAULT NULL,
  `country_id` int DEFAULT NULL,
  PRIMARY KEY (`state_id`),
  KEY `country_id` (`country_id`),
  CONSTRAINT `state_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `supplier` (
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
  CONSTRAINT `supplier_ibfk_1` FOREIGN KEY (`business_id`) REFERENCES `business` (`business_id`),
  CONSTRAINT `supplier_ibfk_2` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`),
  CONSTRAINT `supplier_ibfk_3` FOREIGN KEY (`specialty_id`) REFERENCES `specialty` (`specialty_id`),
  CONSTRAINT `supplier_ibfk_4` FOREIGN KEY (`providertype_id`) REFERENCES `providertype` (`providertype_id`)
) ENGINE=InnoDB AUTO_INCREMENT=29883881 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `supplierequipmentlist` (
  `equipment_id` int NOT NULL,
  `supplier_id` int NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`equipment_id`,`supplier_id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `supplierequipmentlist_ibfk_1` FOREIGN KEY (`equipment_id`) REFERENCES `equipment` (`equipment_id`),
  CONSTRAINT `supplierequipmentlist_ibfk_2` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`supplier_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


#Create VIEWS
CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER
VIEW `average_sales_order_date` AS
SELECT
    `orders`.`order_date` AS `order_date`,
    CAST(AVG((`orders`.`quantity` * `equipment`.`price`)) AS SIGNED) AS `average_sales`
FROM
    (`orders`
    JOIN `equipment` ON (`orders`.`equipment_id` = `equipment`.`equipment_id`))
GROUP BY
    `orders`.`order_date`
ORDER BY
    `orders`.`order_date`,
    AVG((`orders`.`quantity` * `equipment`.`price`));

CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER
VIEW `average_sales_state_wise` AS
SELECT
    `state`.`state_name` AS `state_name`,
    CAST(AVG((`orders`.`quantity` * `equipment`.`price`)) AS SIGNED) AS `average_sales`
FROM
    ((((`orders`
    JOIN `supplier` ON (`orders`.`supplier_id` = `supplier`.`supplier_id`))
    JOIN `city` ON (`city`.`city_id` = `supplier`.`city_id`))
    JOIN `state` ON (`state`.`state_id` = `city`.`state_id`))
    JOIN `equipment` ON (`orders`.`equipment_id` = `equipment`.`equipment_id`))
GROUP BY
    `state`.`state_name`
ORDER BY
    AVG((`orders`.`quantity` * `equipment`.`price`));

CREATE ALGORITHM = UNDEFINED DEFINER = `root`@`localhost` SQL SECURITY DEFINER
VIEW `best_selling_product_overall` AS
SELECT
    `equipment`.`equipment_name` AS `equipment_name`,
    COUNT(`orders`.`order_id`) AS `total_orders`
FROM
    (`orders`
    JOIN `equipment` ON (`orders`.`equipment_id` = `equipment`.`equipment_id`))
GROUP BY
    `orders`.`equipment_id`
ORDER BY
    COUNT(`orders`.`order_id`) DESC
LIMIT 10;



# Create STORED PROCEDURES
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `up_delete_order`(
IN orderid int)
BEGIN

Delete from orders where order_id=orderid;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `up_read_equipment`()
BEGIN

select * from Equipment
order by equipment_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `up_read_supplier_by_equipment`(
IN cityid int
)
BEGIN

select  distinct SEL.supplier_id,supplier_name from SupplierEquipmentList SEL 
inner join Supplier S on SEL.supplier_id = S.supplier_id 
where  city_id  = cityid ;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `up_update_order`(
IN orderid int,
IN quantitynew int)
BEGIN

DECLARE stock_available INT;

    -- Retrieve equipment and supplier for the given order
DECLARE equipment_id_val INT;
DECLARE supplier_id_val INT;
SELECT equipment_id, supplier_id INTO equipment_id_val, supplier_id_val FROM `Orders` WHERE order_id = orderid;

    -- Check if the equipment is available in SupplierEquipmentList with sufficient stock
SELECT stock INTO stock_available 
FROM SupplierEquipmentList 
WHERE equipment_id = equipment_id_val AND supplier_id = supplier_id_val;

    -- Update order quantity if the requested quantity is less than or equal to available stock
IF stock_available >= quantitynew THEN
	UPDATE `Orders` SET quantity = quantitynew WHERE order_id = orderid;
END IF;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `up_write_order`(
supplierid Int,
equipmentid Int,
ordername varchar(255),
orderdate date,
customerid int,
ordertypeid int,
quantity int
)
BEGIN

INSERT INTO `Medical_equipment_system`.`Orders`
(
`supplier_id`,
`equipment_id`,
`order_name`,
`order_date`,
`customer_id`,
`ordertype_id`,
`quantity`)
VALUES
(
supplierid ,
equipmentid ,
ordername ,
orderdate ,
customerid ,
ordertypeid ,
quantity
);

END$$
DELIMITER ;



#Create FUNCTIONS
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `CountDistinctEquipments`() RETURNS int
    DETERMINISTIC
BEGIN

DECLARE distinct_equipment_count INT;

SELECT COUNT(DISTINCT equipment_id) INTO distinct_equipment_count
FROM Orders;

RETURN distinct_equipment_count;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `CountDistinctStates`() RETURNS int
    DETERMINISTIC
BEGIN

DECLARE distinct_state_count INT;

SELECT COUNT(DISTINCT State.state_id) Into distinct_state_count
FROM State inner join City on City.state_id=State.state_id
inner join Supplier on City.city_id=Supplier.city_id
inner join Orders on Orders.supplier_id=Supplier.supplier_id;

RETURN distinct_state_count;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `CountDistinctSuppliers`() RETURNS int
    DETERMINISTIC
BEGIN


DECLARE distinct_supplier_count INT;

SELECT COUNT(DISTINCT supplier_id) INTO distinct_supplier_count
FROM Orders;

RETURN distinct_supplier_count;

END$$
DELIMITER ;

#Create TRIGGERS
DELIMITER //
CREATE TRIGGER update_stock_on_insert
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    UPDATE SupplierEquipmentList
    SET stock = stock - NEW.quantity
    WHERE supplier_id = NEW.supplier_id
    AND equipment_id = NEW.equipment_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_stock_on_update
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    UPDATE SupplierEquipmentList
    SET stock = stock + OLD.quantity - NEW.quantity
    WHERE supplier_id = NEW.supplier_id
    AND equipment_id = NEW.equipment_id;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER update_stock_on_delete
AFTER DELETE ON Orders
FOR EACH ROW
BEGIN
    UPDATE SupplierEquipmentList
    SET stock = stock + OLD.quantity
    WHERE supplier_id = OLD.supplier_id
    AND equipment_id = OLD.equipment_id;
END;
//
DELIMITER ;

