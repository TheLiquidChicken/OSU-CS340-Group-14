-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Colors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Colors` (
  `colorID` INT NOT NULL AUTO_INCREMENT,
  `colorDescription` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`colorID`),
  UNIQUE INDEX `colorID_UNIQUE` (`colorID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`MaterialTypes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`MaterialTypes` (
  `materialTypeID` INT NOT NULL AUTO_INCREMENT,
  `materialTypeDescription` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`materialTypeID`),
  UNIQUE INDEX `colorID_UNIQUE` (`materialTypeID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Customers` (
  `customerID` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NOT NULL,
  `phoneNumber` VARCHAR(45) NOT NULL,
  `primaryContact` VARCHAR(45) NOT NULL,
  `totalOrders` INT NULL,
  `totalSpent` DECIMAL(19,2) NULL,
  `address` VARCHAR(45) NOT NULL,
  `mostUsedColor` INT NULL,
  `mostUsedMaterialType` INT NULL,
  PRIMARY KEY (`customerID`),
  UNIQUE INDEX `customerID_UNIQUE` (`customerID` ASC) VISIBLE,
  INDEX `fk_Customers_Colors1_idx` (`mostUsedColor` ASC) VISIBLE,
  INDEX `fk_Customers_MaterialTypes1_idx` (`mostUsedMaterialType` ASC) VISIBLE,
  CONSTRAINT `fk_Customers_Colors1`
    FOREIGN KEY (`mostUsedColor`)
    REFERENCES `mydb`.`Colors` (`colorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Customers_MaterialTypes1`
    FOREIGN KEY (`mostUsedMaterialType`)
    REFERENCES `mydb`.`MaterialTypes` (`materialTypeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Orders` (
  `orderID` INT NOT NULL AUTO_INCREMENT,
  `revenue` DECIMAL(19,2) NOT NULL,
  `Customers_customerID` INT NOT NULL,
  `date` DATE NOT NULL,
  PRIMARY KEY (`orderID`, `Customers_customerID`),
  UNIQUE INDEX `orderID_UNIQUE` (`orderID` ASC) VISIBLE,
  INDEX `fk_Orders_Customers1_idx` (`Customers_customerID` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Customers1`
    FOREIGN KEY (`Customers_customerID`)
    REFERENCES `mydb`.`Customers` (`customerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Parts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Parts` (
  `partID` INT NOT NULL AUTO_INCREMENT,
  `partName` VARCHAR(45) NOT NULL,
  `partPath` VARCHAR(180) NOT NULL,
  `quantity` INT NOT NULL,
  `mass` INT NOT NULL,
  `infillDensity` TINYINT NOT NULL,
  `Orders_orderID` INT NOT NULL,
  `Orders_Customers_customerID` INT NOT NULL,
  PRIMARY KEY (`partID`, `Orders_orderID`, `Orders_Customers_customerID`),
  UNIQUE INDEX `idManufacturingMethod_UNIQUE` (`partID` ASC) VISIBLE,
  INDEX `fk_Part_Order1_idx` (`Orders_orderID` ASC, `Orders_Customers_customerID` ASC) VISIBLE,
  CONSTRAINT `fk_Part_Order1`
    FOREIGN KEY (`Orders_orderID` , `Orders_Customers_customerID`)
    REFERENCES `mydb`.`Orders` (`orderID` , `Customers_customerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Machines`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Machines` (
  `machineID` INT NOT NULL AUTO_INCREMENT,
  `machineDescription` VARCHAR(45) NOT NULL COMMENT 'Allows for different types of printers, resin versus FDM, etc',
  `lastServiceDate` DATE NOT NULL,
  PRIMARY KEY (`machineID`),
  UNIQUE INDEX `colorID_UNIQUE` (`machineID` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Materials`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Materials` (
  `materialID` INT NOT NULL AUTO_INCREMENT,
  `kilograms` INT NOT NULL,
  `MaterialTypes_materialTypeID` INT NOT NULL,
  `Colors_colorID` INT NOT NULL,
  PRIMARY KEY (`materialID`, `MaterialTypes_materialTypeID`, `Colors_colorID`),
  UNIQUE INDEX `materialID_UNIQUE` (`materialID` ASC) VISIBLE,
  INDEX `fk_Material_MaterialType1_idx` (`MaterialTypes_materialTypeID` ASC) VISIBLE,
  INDEX `fk_Material_Color1_idx` (`Colors_colorID` ASC) VISIBLE,
  CONSTRAINT `fk_Material_MaterialType1`
    FOREIGN KEY (`MaterialTypes_materialTypeID`)
    REFERENCES `mydb`.`MaterialTypes` (`materialTypeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Material_Color1`
    FOREIGN KEY (`Colors_colorID`)
    REFERENCES `mydb`.`Colors` (`colorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PartMachines`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PartMachines` (
  `partMachinesID` INT NOT NULL AUTO_INCREMENT,
  `Parts_partID` INT NOT NULL,
  `Parts_Orders_orderID` INT NOT NULL,
  `Part_Order_Customer_customerID` INT NOT NULL,
  `Machines_machineID` INT NOT NULL,
  PRIMARY KEY (`partMachinesID`, `Parts_partID`, `Parts_Orders_orderID`, `Part_Order_Customer_customerID`, `Machines_machineID`),
  INDEX `fk_Part_has_Machine_Machine1_idx` (`Machines_machineID` ASC) VISIBLE,
  INDEX `fk_Part_has_Machine_Part1_idx` (`Parts_partID` ASC, `Parts_Orders_orderID` ASC, `Part_Order_Customer_customerID` ASC) VISIBLE,
  UNIQUE INDEX `partMachinesID_UNIQUE` (`partMachinesID` ASC) VISIBLE,
  CONSTRAINT `fk_Part_has_Machine_Part1`
    FOREIGN KEY (`Parts_partID` , `Parts_Orders_orderID` , `Part_Order_Customer_customerID`)
    REFERENCES `mydb`.`Parts` (`partID` , `Orders_orderID` , `Orders_Customers_customerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Part_has_Machine_Machine1`
    FOREIGN KEY (`Machines_machineID`)
    REFERENCES `mydb`.`Machines` (`machineID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`PartMaterials`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PartMaterials` (
  `partMaterialsID` INT NOT NULL AUTO_INCREMENT,
  `Parts_partID` INT NOT NULL,
  `Parts_Orders_orderID` INT NOT NULL,
  `Part_Order_Customer_customerID` INT NOT NULL,
  `Materials_materialID` INT NOT NULL,
  `Material_MaterialType_materialTypeID` INT NOT NULL,
  `Materials_Colors_colorID` INT NOT NULL,
  PRIMARY KEY (`partMaterialsID`, `Parts_partID`, `Parts_Orders_orderID`, `Part_Order_Customer_customerID`, `Materials_materialID`, `Material_MaterialType_materialTypeID`, `Materials_Colors_colorID`),
  INDEX `fk_Part_has_Material_Material1_idx` (`Materials_materialID` ASC, `Material_MaterialType_materialTypeID` ASC, `Materials_Colors_colorID` ASC) VISIBLE,
  INDEX `fk_Part_has_Material_Part1_idx` (`Parts_partID` ASC, `Parts_Orders_orderID` ASC, `Part_Order_Customer_customerID` ASC) VISIBLE,
  UNIQUE INDEX `partMaterialsID_UNIQUE` (`partMaterialsID` ASC) VISIBLE,
  CONSTRAINT `fk_Part_has_Material_Part1`
    FOREIGN KEY (`Parts_partID` , `Parts_Orders_orderID` , `Part_Order_Customer_customerID`)
    REFERENCES `mydb`.`Parts` (`partID` , `Orders_orderID` , `Orders_Customers_customerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Part_has_Material_Material1`
    FOREIGN KEY (`Materials_materialID` , `Material_MaterialType_materialTypeID` , `Materials_Colors_colorID`)
    REFERENCES `mydb`.`Materials` (`materialID` , `MaterialTypes_materialTypeID` , `Colors_colorID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
