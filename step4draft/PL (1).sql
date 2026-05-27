-- Project Group 14: 3Designs and Manufacturing
-- Members: Daniel Magann, Kaiden Hay
-- Date: 27MAY2026
-- This file houses all of the stored procedures for the 3Designs and Manufacturing database. 
-- It is organized by entity. After that, dropdown helper SPs are included for the UI.


-- Project Group 14: 3Designs and Manufacturing Stored Procedures
-- Format matches PL.sql template

-- ---------------
-- Reset Database
-- ---------------

DROP PROCEDURE IF EXISTS sp_ResetDatabase;
DELIMITER //
CREATE PROCEDURE sp_ResetDatabase()
BEGIN
    CALL sp_load_3designs_db();
END //
DELIMITER ;


-- ----------
-- CUSTOMERS
-- ----------

-- Select * from customers
DROP PROCEDURE IF EXISTS sp_SelectCustomers;
DELIMITER //
CREATE PROCEDURE sp_SelectCustomers()
BEGIN
    SELECT customerID, email, phoneNumber, primaryContact, address 
    FROM Customers;
END //
DELIMITER ;

-- Insert new customer
DROP PROCEDURE IF EXISTS sp_InsertCustomer;
DELIMITER //
CREATE PROCEDURE sp_InsertCustomer(
    IN p_email VARCHAR(45),
    IN p_phoneNumber VARCHAR(45),
    IN p_primaryContact VARCHAR(45),
    IN p_address VARCHAR(180),
    OUT p_newCustomerID INT
)
BEGIN
    INSERT INTO Customers (email, phoneNumber, primaryContact, address) 
    VALUES (p_email, p_phoneNumber, p_primaryContact, p_address);
    
    SET p_newCustomerID = LAST_INSERT_ID();
END //
DELIMITER ;

-- Update existing customer
DROP PROCEDURE IF EXISTS sp_UpdateCustomer;
DELIMITER //
CREATE PROCEDURE sp_UpdateCustomer(
    IN p_customerID INT,
    IN p_email VARCHAR(45),
    IN p_phoneNumber VARCHAR(45),
    IN p_primaryContact VARCHAR(45),
    IN p_address VARCHAR(180)
)
BEGIN
    UPDATE Customers 
    SET email = p_email, 
        phoneNumber = p_phoneNumber, 
        primaryContact = p_primaryContact, 
        address = p_address
    WHERE customerID = p_customerID;
END //
DELIMITER ;

-- Delete customer and associated orders
DROP PROCEDURE IF EXISTS sp_DeleteCustomer;
DELIMITER //
CREATE PROCEDURE sp_DeleteCustomer(
    IN p_customerID INT
)
BEGIN
    DELETE FROM Customers WHERE customerID = p_customerID;
END //
DELIMITER ;

-- ----------
-- COLORS
-- ----------

-- Select * from colors
DROP PROCEDURE IF EXISTS sp_SelectColors;
DELIMITER //
CREATE PROCEDURE sp_SelectColors()
BEGIN
    SELECT colorID, colorDescription
    FROM Colors;
END //
DELIMITER ;

-- Insert new color
DROP PROCEDURE IF EXISTS sp_InsertColor;
DELIMITER //
CREATE PROCEDURE sp_InsertColor(
    IN p_colorID VARCHAR(45),
    IN p_colorDescription VARCHAR(45),
    OUT p_newColorID VARCHAR(45)
)
BEGIN
    INSERT INTO Colors (colorID, colorDescription) 
    VALUES (p_colorID, p_colorDescription);
    
    SET p_newColorID = LAST_INSERT_ID();
END //
DELIMITER ;

-- Update existing color
DROP PROCEDURE IF EXISTS sp_UpdateColor;
DELIMITER //
CREATE PROCEDURE sp_UpdateColor(
	IN p_oldColorID VARCHAR(45),
    IN p_colorID VARCHAR(45),
    IN p_colorDescription VARCHAR(45)
)
BEGIN
    UPDATE Colors 
    SET colorID = p_colorID, 
        colorDescription = p_colorDescription
    WHERE colorID = p_oldColorID;
END //
DELIMITER ;

-- Delete color and associated materials
DROP PROCEDURE IF EXISTS sp_DeleteColor;
DELIMITER //
CREATE PROCEDURE sp_DeleteColor(
    IN p_colorID VARCHAR(45)
)
BEGIN
    DELETE FROM Colors WHERE colorID = p_colorID;
END //
DELIMITER ;

-- ----------
-- MaterialTypes
-- ----------

-- Select * from material types
DROP PROCEDURE IF EXISTS sp_SelectMaterialTypes;
DELIMITER //
CREATE PROCEDURE sp_SelectMaterialTypes()
BEGIN
    SELECT materialTypeID, materialTypeDescription
    FROM MaterialTypes;
END //
DELIMITER ;

-- Insert new material type
DROP PROCEDURE IF EXISTS sp_InsertMaterialType;
DELIMITER //
CREATE PROCEDURE sp_InsertMaterialType(
    IN p_materialTypeID VARCHAR(45),
    IN p_materialTypeDescription VARCHAR(45),
    OUT p_newMaterialTypeID VARCHAR(45)
)
BEGIN
    INSERT INTO MaterialTypes (materialTypeID, materialTypeDescription) 
    VALUES (p_materialTypeID, p_materialTypeDescription);
    
    SET p_newMaterialTypeID = LAST_INSERT_ID();
END //
DELIMITER ;

-- Update existing material type
DROP PROCEDURE IF EXISTS sp_UpdateMaterialType;
DELIMITER //
CREATE PROCEDURE sp_UpdateMaterialType(
	IN p_oldMaterialTypeID VARCHAR(45),
    IN p_materialTypeID VARCHAR(45),
    IN p_materialTypeDescription VARCHAR(45)
)
BEGIN
    UPDATE MaterialTypes 
    SET materialTypeID = p_materialTypeID, 
        materialTypeDescription = p_materialTypeDescription
    WHERE materialTypeID = p_oldMaterialTypeID;
END //
DELIMITER ;

-- Delete material type and associated materials
DROP PROCEDURE IF EXISTS sp_DeleteMaterialType;
DELIMITER //
CREATE PROCEDURE sp_DeleteMaterialType(
    IN p_materialTypeID VARCHAR(45)
)
BEGIN
    DELETE FROM MaterialTypes WHERE materialTypeID = p_materialTypeID;
END //
DELIMITER ;


-- -------
-- ORDERS
-- -------

-- Select all orders with specific customer name
DROP PROCEDURE IF EXISTS sp_SelectOrders;
DELIMITER //
CREATE PROCEDURE sp_SelectOrders()
BEGIN
    SELECT Orders.orderID, Orders.revenue, Orders.date, Orders.customers_customerID
    FROM Orders;
END //
DELIMITER ;

-- Insert new order
DROP PROCEDURE IF EXISTS sp_InsertOrder;
DELIMITER //
CREATE PROCEDURE sp_InsertOrder(
    IN p_revenue DECIMAL(19,2),
    IN p_customerID INT,
    IN p_date DATE,
    OUT p_newOrderID INT
)
BEGIN
    INSERT INTO Orders (revenue, customers_customerID, date) 
    VALUES (p_revenue, p_customerID, p_date);
    
    SET p_newOrderID = LAST_INSERT_ID();
END //
DELIMITER ;

-- Update existing order
DROP PROCEDURE IF EXISTS sp_UpdateOrder;
DELIMITER //
CREATE PROCEDURE sp_UpdateOrder(
    IN p_orderID INT,
    IN p_revenue DECIMAL(19,2),
    IN p_date DATE
)
BEGIN
    UPDATE Orders 
    SET revenue = p_revenue, date = p_date 
    WHERE orderID = p_orderID;
END //
DELIMITER ;

-- Delete order but not customer
DROP PROCEDURE IF EXISTS sp_DeleteOrder;
DELIMITER //
CREATE PROCEDURE sp_DeleteOrder(
    IN p_orderID INT
)
BEGIN
    DELETE FROM Orders WHERE orderID = p_orderID;
END //
DELIMITER ;


-- ------
-- PARTS
-- ------

-- Select * from parts
DROP PROCEDURE IF EXISTS sp_SelectParts;
DELIMITER //
CREATE PROCEDURE sp_SelectParts()
BEGIN
    SELECT Parts.partID, Parts.partName, Parts.partPath, Parts.quantity, Parts.mass, Parts.infillDensity, Parts.orders_orderID
    FROM Parts;
END //
DELIMITER ;

-- Insert new part and ID
DROP PROCEDURE IF EXISTS sp_InsertPart;
DELIMITER //
CREATE PROCEDURE sp_InsertPart(
    IN p_partName VARCHAR(45),
    IN p_partPath VARCHAR(180),
    IN p_quantity INT,
    IN p_mass INT,
    IN p_infillDensity TINYINT,
    IN p_orderID INT,
    OUT p_newPartID INT
)
BEGIN
    INSERT INTO Parts (partName, partPath, quantity, mass, infillDensity, orders_orderID)
    VALUES (p_partName, p_partPath, p_quantity, p_mass, p_infillDensity, p_orderID);
    
    SET p_newPartID = LAST_INSERT_ID();
END //
DELIMITER ;

-- Update existing part
DROP PROCEDURE IF EXISTS sp_UpdatePart;
DELIMITER //
CREATE PROCEDURE sp_UpdatePart(
    IN p_partID INT,
    IN p_partName VARCHAR(45),
    IN p_partPath VARCHAR(180),
    IN p_quantity INT,
    IN p_mass INT,
    IN p_infillDensity TINYINT,
    IN p_orders_orderID INT
)
BEGIN
    UPDATE Parts 
    SET partName = p_partName,
        partPath = p_partPath,
        quantity = p_quantity, 
        mass = p_mass, 
        infillDensity = p_infillDensity,
        orders_orderID = p_orders_orderID
    WHERE partID = p_partID;
END //
DELIMITER ;

-- Delete part
DROP PROCEDURE IF EXISTS sp_DeletePart;
DELIMITER //
CREATE PROCEDURE sp_DeletePart(
    IN p_partID INT
)
BEGIN
    DELETE FROM Parts WHERE partID = p_partID;
END //
DELIMITER ;


-- ----------
-- MATERIALS
-- ----------

-- Select * from materials
DROP PROCEDURE IF EXISTS sp_SelectMaterials;
DELIMITER //
CREATE PROCEDURE sp_SelectMaterials()
BEGIN
    SELECT Materials.materialID, Materials.MaterialTypes_materialTypeID, Materials.Colors_colorID, Materials.kilograms
    FROM Materials;
END //
DELIMITER ;

-- Insert new material
DROP PROCEDURE IF EXISTS sp_InsertMaterial;
DELIMITER //
CREATE PROCEDURE sp_InsertMaterial(
    IN p_materialTypeID VARCHAR(45),
    IN p_colorID VARCHAR(45),
    IN p_kilograms INT,
    OUT p_newMaterialID INT
)
BEGIN
    INSERT INTO Materials (kilograms, materialTypes_materialTypeID, colors_colorID)
    VALUES (p_kilograms, p_materialTypeID, p_colorID);
    
    SET p_newMaterialID = LAST_INSERT_ID();
END //
DELIMITER ;

-- Update material
DROP PROCEDURE IF EXISTS sp_UpdateMaterial;
DELIMITER //
CREATE PROCEDURE sp_UpdateMaterial(
    IN p_materialID INT,
    IN p_kilograms INT
)
BEGIN
    UPDATE Materials SET kilograms = p_kilograms WHERE materialID = p_materialID;
END //
DELIMITER ;

-- Delete material
DROP PROCEDURE IF EXISTS sp_DeleteMaterial;
DELIMITER //
CREATE PROCEDURE sp_DeleteMaterial(
    IN p_materialID INT
)
BEGIN
    DELETE FROM Materials WHERE materialID = p_materialID;
END //
DELIMITER ;


-- ---------
-- MACHINES
-- ---------

-- Select * from machines
DROP PROCEDURE IF EXISTS sp_SelectMachines;
DELIMITER //
CREATE PROCEDURE sp_SelectMachines()
BEGIN
    SELECT machineID, machineDescription, lastServiceDate FROM Machines;
END //
DELIMITER ;

-- Insert machine 
DROP PROCEDURE IF EXISTS sp_InsertMachine;
DELIMITER //
CREATE PROCEDURE sp_InsertMachine(
    IN p_machineDescription VARCHAR(45),
    IN p_lastServiceDate DATE,
    OUT p_newMachineID INT
)
BEGIN
    INSERT INTO Machines (machineDescription, lastServiceDate) 
    VALUES (p_machineDescription, p_lastServiceDate);
    
    SET p_newMachineID = LAST_INSERT_ID();
END //
DELIMITER ;

-- Update machine service
DROP PROCEDURE IF EXISTS sp_UpdateMachine;
DELIMITER //
CREATE PROCEDURE sp_UpdateMachine(
    IN p_machineID INT,
    IN p_machineDescription VARCHAR(45),
    IN p_lastServiceDate DATE
)
BEGIN
    UPDATE Machines SET lastServiceDate = p_lastServiceDate, machineDescription = p_machineDescription WHERE machineID = p_machineID;
END //
DELIMITER ;

-- Delete machine
DROP PROCEDURE IF EXISTS sp_DeleteMachine;
DELIMITER //
CREATE PROCEDURE sp_DeleteMachine(
    IN p_machineID INT
)
BEGIN
    DELETE FROM Machines WHERE machineID = p_machineID;
END //
DELIMITER ;


-- -----------------
-- CATEGORY  TABLES
-- -----------------

-- Select * from Colors
DROP PROCEDURE IF EXISTS sp_SelectColors;
DELIMITER //
CREATE PROCEDURE sp_SelectColors()
BEGIN
    SELECT colorID, colorDescription FROM Colors;
END //
DELIMITER ;

-- Select * from MaterialTypes
DROP PROCEDURE IF EXISTS sp_SelectMaterialTypes;
DELIMITER //
CREATE PROCEDURE sp_SelectMaterialTypes()
BEGIN
    SELECT materialTypeID, materialTypeDescription FROM MaterialTypes;
END //
DELIMITER ;


-- --------------------
-- INTERSECTION TABLES
-- --------------------

-- View PartMaterial relationships
DROP PROCEDURE IF EXISTS sp_SelectPartMaterials;
DELIMITER //
CREATE PROCEDURE sp_SelectPartMaterials()
BEGIN
    SELECT PartMaterials.partMaterialID, PartMaterials.parts_partID, PartMaterials.materials_materialID
    FROM PartMaterials;

END //
DELIMITER ;

-- Link Material to Part
DROP PROCEDURE IF EXISTS sp_InsertPartMaterial;
DELIMITER //
CREATE PROCEDURE sp_InsertPartMaterial(
    IN p_partID INT,
    IN p_materialID INT,
    OUT p_newPartMaterialID INT
)
BEGIN
    INSERT INTO PartMaterials (parts_partID, materials_materialID) 
    VALUES (p_partID, p_materialID);
	SET p_newPartMaterialID = LAST_INSERT_ID();
END //
DELIMITER ;

-- Update part material
DROP PROCEDURE IF EXISTS sp_UpdatePartMaterial;
DELIMITER //
CREATE PROCEDURE sp_UpdatePartMaterial(
	IN p_partMaterialID INT,
    IN p_parts_partID INT,
    IN p_materials_materialID INT
)
BEGIN
    UPDATE PartMaterials SET parts_partID = p_parts_partID, materials_materialID = p_materials_materialID WHERE partMaterialID = p_partMaterialID;
END //
DELIMITER ;

-- de-link Material and Part
DROP PROCEDURE IF EXISTS sp_DeletePartMaterial;
DELIMITER //
CREATE PROCEDURE sp_DeletePartMaterial(
    IN p_partMaterialID INT
)
BEGIN
    DELETE FROM PartMaterials WHERE partMaterialID = p_partMaterialID;
END //
DELIMITER ;

-- View PartMachine relationships
DROP PROCEDURE IF EXISTS sp_SelectPartMachines;
DELIMITER //
CREATE PROCEDURE sp_SelectPartMachines()
BEGIN
    SELECT PartMachines.partMachineID, PartMachines.machines_machineID, PartMachines.parts_partID
    FROM PartMachines;
END //
DELIMITER ;

-- Link Machine to a Part
DROP PROCEDURE IF EXISTS sp_InsertPartMachine;
DELIMITER //
CREATE PROCEDURE sp_InsertPartMachine(
    IN p_partID INT,
    IN p_machineID INT,
    OUT p_newPartMachineID INT
)
BEGIN
    INSERT INTO PartMachines (parts_partID, machines_machineID) 
    VALUES (p_partID, p_machineID);
	SET p_newPartMachineID = LAST_INSERT_ID();
END //
DELIMITER ;

-- Update part machine
DROP PROCEDURE IF EXISTS sp_UpdatePartMachine;
DELIMITER //
CREATE PROCEDURE sp_UpdatePartMachine(
	IN p_partMachineID INT,
    IN p_parts_partID INT,
    IN p_machines_machineID INT
)
BEGIN
    UPDATE PartMaterials SET parts_partID = p_parts_partID, machines_machineID = p_machines_machineID WHERE partMachineID = p_partMachineID;
END //
DELIMITER ;

-- de-link Machine and Part
DROP PROCEDURE IF EXISTS sp_DeletePartMachine;
DELIMITER //
CREATE PROCEDURE sp_DeletePartMachine(
    IN p_partMachineID INT
)
BEGIN
    DELETE FROM PartMachines WHERE partMachineID = p_partMachineID;
END //
DELIMITER ;


-- ----------------------------------
-- User Interface Dropdown Helper SPs
-- Gets data for UI dropdowns.
-- ----------------------------------

-- Customer dropdown
DROP PROCEDURE IF EXISTS sp_GetCustomersDropdown;
DELIMITER //
CREATE PROCEDURE sp_GetCustomersDropdown()
BEGIN
    SELECT customerID, primaryContact FROM Customers;
END //
DELIMITER ;

-- Color dropdown
DROP PROCEDURE IF EXISTS sp_GetColorsDropdown;
DELIMITER //
CREATE PROCEDURE sp_GetColorsDropdown()
BEGIN
    SELECT colorID, colorDescription FROM Colors;
END //
DELIMITER ;

-- MaterialType dropdown
DROP PROCEDURE IF EXISTS sp_GetMaterialTypesDropdown;
DELIMITER //
CREATE PROCEDURE sp_GetMaterialTypesDropdown()
BEGIN
    SELECT materialTypeID, materialTypeDescription FROM MaterialTypes;
END //
DELIMITER ;

-- Order dropdown
DROP PROCEDURE IF EXISTS sp_GetOrdersDropdown;
DELIMITER //
CREATE PROCEDURE sp_GetOrdersDropdown()
BEGIN
    SELECT orderID FROM Orders;
END //
DELIMITER ;

-- Part dropdown
DROP PROCEDURE IF EXISTS sp_GetPartsDropdown;
DELIMITER //
CREATE PROCEDURE sp_GetPartsDropdown()
BEGIN
    SELECT partID, partName FROM Parts;
END //
DELIMITER ;

-- Machine dropdown
DROP PROCEDURE IF EXISTS sp_GetMachinesDropdown;
DELIMITER //
CREATE PROCEDURE sp_GetMachinesDropdown()
BEGIN
    SELECT machineID, machineDescription FROM Machines;
END //
DELIMITER ;