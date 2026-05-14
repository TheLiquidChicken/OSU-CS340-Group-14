-- Project Group 14: 3Designs and Manufacturing
-- Members: Daniel Magann, Kaiden Hay
-- Date: 07MAY2026
-- This is a revised version of the DML based on the updated DDL. We should have finished edits on the DDL prior to starting
-- the DML, but this should now be a working product

-- ----------------------------------------------------------------------------
-- CUSTOMERS

/*Removed mostUsedMaterialType, mostUsedColor, totalOrders, and total Revenue from all in the customers section
*5/13/26
*Kaiden hay
*/

-- This displays customer information on the Customers page
SELECT customerID, email, phoneNumber, primaryContact, address 
FROM Customers;

-- This adds a customer to the database
INSERT INTO Customers (email, phoneNumber, primaryContact, address) 
VALUES (:emailInput, :phoneInput, :contactNameInput, :addressInput);

-- Thus updates an existing customer's information
UPDATE Customers 
SET email = :emailInput, 
    phoneNumber = :phoneInput, 
    primaryContact = :contactNameInput, 
    address = :addressInput
WHERE customerID = :customerID_from_row;

-- This deletes an existing customer, along with their order history
DELETE FROM Customers WHERE customerID = :customerID_from_row;


-----------------------------------------------------------------------------
-- ORDERS

-- This displays order information on the Orders page
SELECT Orders.orderID, Orders.revenue, Orders.date, Customers.primaryContact AS customerName
FROM Orders
JOIN Customers ON Orders.customers_customerID = Customers.customerID;

-- This adds an order to the database (we are tracking this is the most insecure way possible)
INSERT INTO Orders (revenue, customers_customerID, date) 
VALUES (:revenueInput, :customerID_from_dropdown, :dateInput);

-- This updates information on an existing order
UPDATE Orders 
SET revenue = :revenueInput, date = :dateInput 
WHERE orderID = :orderID_from_row;

-- This deletes an existing order. However, it does not delete the customer.
DELETE FROM Orders WHERE orderID = :orderID_from_row;


-----------------------------------------------------------------------------
-- PARTS

-- This searches parts by order and displays it on the Parts page
SELECT Parts.partID, Parts.partName, Parts.partPath, Parts.quantity, Parts.mass, Parts.infillDensity, Orders.orderID
FROM Parts
JOIN Orders ON Parts.orders_orderID = Orders.orderID;

-- This adds a part to the database
INSERT INTO Parts (partName, partPath, quantity, mass, infillDensity, orders_orderID)
VALUES (:nameInput, :pathInput, :qtyInput, :massInput, :infillInput, :orderID_from_dropdown);

-- This updates an existing part
UPDATE Parts 
SET partName = :nameInput,
    partPath = :pathInput,
    quantity = :qtyInput, 
    mass = :massInput, 
    infillDensity = :infillInput 
WHERE partID = :partID_from_row;

-- This deletes an existing part. However, it does not delete the entire order (hopefully)
DELETE FROM Parts WHERE partID = :partID_from_row;


-- ---------------------------------------------------------------------------
-- MATERIALS (Inventory)

-- This displays material data on the Inventory page
SELECT Materials.materialID, MaterialTypes.materialTypeDescription, Colors.colorDescription, Materials.kilograms
FROM Materials
JOIN MaterialTypes ON Materials.materialTypes_materialTypeID = MaterialTypes.materialTypeID
JOIN Colors ON Materials.colors_colorID = Colors.colorID;

-- This adds a new material to the database
INSERT INTO Materials (kilograms, materialTypes_materialTypeID, colors_colorID)
VALUES (:qtyInput, :typeID_from_dropdown, :colorID_from_dropdown);

-- This updates the amount of an existing materila
UPDATE Materials SET kilograms = :qtyInput WHERE materialID = :materialID_from_row;

-- This deletes an existing material
DELETE FROM Materials WHERE materialID = :materialID_from_row;

-- -----------------------------------------------------------------------------
-- MACHINES

-- This displayes 3D printers on the Machines page
SELECT machineID, machineDescription, lastServiceDate FROM Machines;

-- This adds a new machine to the database
INSERT INTO Machines (machineDescription, lastServiceDate) 
VALUES (:descInput, :dateInput);

-- This updates the last service date of an existing 3d printer
UPDATE Machines SET lastServiceDate = :dateInput WHERE machineID = :machineID_from_row;

-- This deletes an existing machine
DELETE FROM Machines WHERE machineID = :machineID_from_row;


-- -----------------------------------------------------------------------------
-- INTERSECTION TABLES (Many-to-Many Relationships)

-- View which Materials are used for which Parts
SELECT Parts.partName, MaterialTypes.materialTypeDescription, Colors.colorDescription
FROM PartMaterials
JOIN Parts ON PartMaterials.parts_partID = Parts.partID
JOIN Materials ON PartMaterials.materials_materialID = Materials.materialID
JOIN MaterialTypes ON Materials.materialTypes_materialTypeID = MaterialTypes.materialTypeID
JOIN Colors ON Materials.colors_colorID = Colors.colorID;

-- Assign a Material to a Part
INSERT INTO PartMaterials (parts_partID, materials_materialID) 
VALUES (:partID_from_dropdown, :materialID_from_dropdown);

-- View which Machines printed which Parts
SELECT Parts.partName, Machines.machineDescription
FROM PartMachines
JOIN Parts ON PartMachines.parts_partID = Parts.partID
JOIN Machines ON PartMachines.machines_machineID = Machines.machineID;

-- Assign a Machine to a Part
INSERT INTO PartMachines (parts_partID, machines_machineID) 
VALUES (:partID_from_dropdown, :machineID_from_dropdown);


/* This entire section is experimentational right now and untested.
-- We are commenting out to avoid complications in the initial draft 
-- UPDATE: adding into code but still untested. 07MAY2026
*/
-- --------------------------------------------------------------------------------
-- DROP-DOWN QUERIES
-- These are the queries that will populate the drop-downs on the various pages.

-- This gets the primary contact and customer ID for the Order page
SELECT customerID, primaryContact FROM Customers;

-- This gets the color ID and description of a material
SELECT colorID, colorDescription FROM Colors;

-- This gets the material type ID and description of a material
SELECT materialTypeID, materialTypeDescription FROM MaterialTypes;

-- This gets the order ID for the Parts page
SELECT orderID FROM Orders;

-- This gets the part name and id for the PartMaterials and PartMachines pages
SELECT partID, partName FROM Parts;

-- This gets the machine id and description for the Machine page
SELECT machineID, machineDescription FROM Machines;
