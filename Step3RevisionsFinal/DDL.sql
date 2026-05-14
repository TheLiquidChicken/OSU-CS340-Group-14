-- Project Group 14: 3Designs and Manufacturing
-- Members: Daniel Magann, Kaiden Hay
-- Date: 30APR2026

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
START TRANSACTION;

-- -----------------------------------------------------------------------------
-- This section drops tables if they exist prior to the table creation queries
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS PartMaterials;
DROP TABLE IF EXISTS PartMachines;
DROP TABLE IF EXISTS Materials;
DROP TABLE IF EXISTS Parts;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS MaterialTypes;
DROP TABLE IF EXISTS Colors;
DROP TABLE IF EXISTS Machines;

-- ----------------------------------------------------------
-- This is the revised version of the MySQL forward engineer
-- ----------------------------------------------------------

CREATE TABLE Colors (
  colorID VARCHAR(45) NOT NULL,
  colorDescription VARCHAR(45) NOT NULL,
  PRIMARY KEY (colorID),
  UNIQUE (colorID)
) ENGINE = InnoDB;

CREATE TABLE MaterialTypes (
  materialTypeID VARCHAR(45) NOT NULL,
  materialTypeDescription VARCHAR(45) NOT NULL,
  PRIMARY KEY (materialTypeID),
  UNIQUE (materialTypeID)
) ENGINE = InnoDB;

CREATE TABLE Machines (
  machineID INT NOT NULL AUTO_INCREMENT,
  machineDescription VARCHAR(45) NOT NULL,
  lastServiceDate DATE NOT NULL,
  PRIMARY KEY (machineID),
  UNIQUE (machineID)
) ENGINE = InnoDB;


/*Removed mostUsedMaterialType, mostUsedColor, totalOrders, and total Revenue from all in the customers section
*5/13/26
*Kaiden hay
*/
CREATE TABLE Customers (
  customerID INT NOT NULL AUTO_INCREMENT,
  email VARCHAR(45) NOT NULL,
  phoneNumber VARCHAR(45) NOT NULL,
  primaryContact VARCHAR(45) NOT NULL,
  address VARCHAR(180) NOT NULL,
  PRIMARY KEY (customerID),
  UNIQUE (customerID)
) ENGINE = InnoDB;

-- Creates Orders. Deletes row if Customers are deleted.
CREATE TABLE Orders (
  orderID INT NOT NULL AUTO_INCREMENT,
  revenue DECIMAL(19,2) NOT NULL,
  customers_customerID INT NOT NULL,
  date DATE NOT NULL,
  PRIMARY KEY (orderID),
  UNIQUE (orderID),
  FOREIGN KEY (customers_customerID) 
	REFERENCES Customers(customerID)
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- Creates Parts. Deletes row if orders is deleted.
CREATE TABLE Parts (
  partID INT NOT NULL AUTO_INCREMENT,
  partName VARCHAR(45) NOT NULL,
  partPath VARCHAR(180) NOT NULL,
  quantity INT NOT NULL,
  mass INT NOT NULL,
  infillDensity TINYINT NOT NULL,
  orders_orderID INT NOT NULL,
  PRIMARY KEY (partID),
  UNIQUE (partID),
  FOREIGN KEY (orders_orderID) 
	REFERENCES Orders(orderID)
	ON DELETE CASCADE
) ENGINE = InnoDB;


/*Added ON UPDATE CASCADE so if colors or materialTypes change primary keys, for example, if a brand like POLY changes to something else, the primary key can be updated and will update here.
*This is useful as primary keys for MaterialTypes and Colors are user generated to be better structured.
*Sourced from https://www.geeksforgeeks.org/sql/cascade-in-sql/
*Only information on how to use ON UPDATE CASCADE used
*5/13/26
*Kaiden hay
*/
-- Creates Materials. Deletes row if color or materialType is deleted, this deletes as well as PartMaterials.
CREATE TABLE Materials (
  materialID INT NOT NULL AUTO_INCREMENT,
  kilograms INT NOT NULL,
  materialTypes_materialTypeID VARCHAR(45) NOT NULL,
  colors_colorID VARCHAR(45) NOT NULL,
  PRIMARY KEY (materialID),
  UNIQUE (materialID),
  FOREIGN KEY (materialTypes_materialTypeID) 
	REFERENCES MaterialTypes(materialTypeID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (colors_colorID) 
	REFERENCES Colors(colorID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT colorMaterial UNIQUE (materialTypes_materialTypeID, colors_colorID)
) ENGINE = InnoDB;

-- Creates PartMaterials. Deletes row if materials is deleted, but does not go higher than this.
CREATE TABLE PartMaterials (
  partMaterialsID INT NOT NULL AUTO_INCREMENT,
  parts_partID INT NOT NULL,
  materials_materialID INT NOT NULL,
  PRIMARY KEY (partMaterialsID),
  UNIQUE (partMaterialsID),
  FOREIGN KEY (parts_partID) 
	REFERENCES Parts(partID)
	ON DELETE CASCADE,
  FOREIGN KEY (materials_materialID) 
	REFERENCES Materials(materialID)
    ON DELETE CASCADE
) ENGINE = InnoDB;

-- Creates PartMachines. Deletes row if machine is deleted, but does not go higher than this.
CREATE TABLE PartMachines (
  partMachinesID INT NOT NULL AUTO_INCREMENT,
  parts_partID INT NOT NULL,
  machines_machineID INT NOT NULL,
  PRIMARY KEY (partMachinesID),
  UNIQUE (partMachinesID),
  FOREIGN KEY (parts_partID) 
	REFERENCES Parts(partID)
	ON DELETE CASCADE,
  FOREIGN KEY (machines_machineID) 
	REFERENCES Machines(machineID)
    ON DELETE CASCADE
) ENGINE = InnoDB;
-- ---------------------------------------------------------------------------------
-- These are the Insert queries created by Haiden to populate data in the database
-- ---------------------------------------------------------------------------------

INSERT INTO Colors (colorID, colorDescription) VALUES ('OVTR-RED','Red'), ('OVTR-BLUE', 'Blue'), ('OVTR-PURPLE', 'Purple');
-- [cite: 12]

INSERT INTO MaterialTypes (materialTypeID, materialTypeDescription) VALUES ('OVTR-PETG', 'PETG'), ('OVTR-PLA', 'PLA'), ('OVTR-NYLON', 'NYLON');
-- [cite: 9]

INSERT INTO Machines (machineDescription, lastservicedate) VALUES 
('Ultimaker S3', '2026-04-29'), 
('Ultimaker S5', '2026-04-22'), 
('Bambu X1C', '2026-04-18');
-- [cite: 10]

INSERT INTO Customers (email, phoneNumber, primaryContact, address) VALUES
('BevH@amail.com', '(800)555-1285', 'Beverly Hanson', '2500 Victory Park Lane, 87143 Corvallis Oregon'),
('SamA@amail.com', '(800)555-7836', 'Sam Alexander', '8935 1st Street, 84783 Eugene Oregon'),
('ChrisF@amail.com', '(800)555-5983', 'Chris Fabela', '7496 20th Street, 98542 Hillsboro Oregon');
-- [cite: 11]

INSERT INTO Orders (Customers_customerID, revenue, date) VALUES
((SELECT customerID FROM Customers WHERE primaryContact = 'Beverly Hanson'), 300.32, '2024-01-05'),
((SELECT customerID FROM Customers WHERE primaryContact = 'Sam Alexander'), 832.56, '2025-03-16'),
((SELECT customerID FROM Customers WHERE primaryContact = 'Chris Fabela'), 983.87, '2025-06-21'),
((SELECT customerID FROM Customers WHERE primaryContact = 'Chris Fabela'), 895.34, '2026-02-03');
-- [cite: 7]

INSERT INTO Materials (kilograms, materialTypes_materialTypeID, colors_colorID) VALUES 
(5, (SELECT materialTypeId FROM MaterialTypes WHERE materialTypeDescription = 'PLA'), (SELECT colorID FROM Colors WHERE colorDescription = 'Red')),
(8, (SELECT materialTypeId FROM MaterialTypes WHERE materialTypeDescription = 'PETG'), (SELECT colorID FROM Colors WHERE colorDescription = 'Blue')),
(11, (SELECT materialTypeId FROM MaterialTypes WHERE materialTypeDescription = 'NYLON'), (SELECT colorID FROM Colors WHERE colorDescription = 'Purple'));
-- [cite: 8]

INSERT INTO Parts (partName, partPath, quantity, mass, infillDensity, Orders_orderID) VALUES
('Boat', 'files/boat.stl', 15, 12, 20, (SELECT orderID FROM Orders WHERE revenue = 300.32)),
('Bracket', 'files/bracket.stl', 4, 53, 80, (SELECT orderID FROM Orders WHERE revenue = 832.56)),
('Gear', 'files/gear.stl', 30, 34, 90, (SELECT orderID FROM Orders WHERE revenue = 983.87)),
('SidePanelLower', 'files/SidePanelLower.stl', 2, 300, 100, (SELECT orderID FROM Orders WHERE revenue = 895.34)),
('SidePanelUpper', 'files/SidePanelUpper.stl', 2, 300, 100, (SELECT orderID FROM Orders WHERE revenue = 895.34));
-- [cite: 4]

INSERT INTO PartMachines (parts_partID, machines_machineID) VALUES
((SELECT partID FROM Parts WHERE partName = 'Boat'), (SELECT machineID FROM Machines WHERE machineDescription = 'Ultimaker S3')),
((SELECT partID FROM Parts WHERE partName = 'Bracket'), (SELECT machineID FROM Machines WHERE machineDescription = 'Ultimaker S3')),
((SELECT partID FROM Parts WHERE partName = 'Gear'), (SELECT machineID FROM Machines WHERE machineDescription = 'Ultimaker S5')),
((SELECT partID FROM Parts WHERE partName = 'SidePanelLower'), (SELECT machineID FROM Machines WHERE machineDescription = 'Bambu X1C')),
((SELECT partID FROM Parts WHERE partName = 'SidePanelUpper'), (SELECT machineID FROM Machines WHERE machineDescription = 'Bambu X1C'));
-- [cite: 6]

INSERT INTO PartMaterials (parts_partID, materials_materialID) VALUES
((SELECT partID FROM Parts WHERE partName = 'Boat'), (SELECT materialID FROM Materials WHERE kilograms = 5)),
((SELECT partID FROM Parts WHERE partName = 'Bracket'), (SELECT materialID FROM Materials WHERE kilograms = 8)),
((SELECT partID FROM Parts WHERE partName = 'Gear'), (SELECT materialID FROM Materials WHERE kilograms = 11)),
((SELECT partID FROM Parts WHERE partName = 'SidePanelLower'), (SELECT materialID FROM Materials WHERE kilograms = 11)),
((SELECT partID FROM Parts WHERE partName = 'SidePanelUpper'), (SELECT materialID FROM Materials WHERE kilograms = 11));
-- [cite: 5]

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
