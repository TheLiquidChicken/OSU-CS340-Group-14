INSERT INTO Parts (partName, partPath, quantity, mass, infillDensity, Orders_orderID, Orders_Customers_customerID) VALUES
('Boat', 'files/boat.stl', 15, 12, 20, (SELECT orderID FROM orders WHERE (revenue = 300.32)), (SELECT Customers_customerID FROM orders WHERE (revenue = 300.32))),
('Bracket', 'files/bracket.stl', 4, 53, 80, (SELECT orderID FROM orders WHERE (revenue = 832.56)), (SELECT Customers_customerID FROM orders WHERE (revenue = 832.56))),
('Gear', 'files/gear.stl', 30, 34, 90, (SELECT orderID FROM orders WHERE (revenue = 983.87)), (SELECT Customers_customerID FROM orders WHERE (revenue = 983.87))),
('SidePanelLower', 'files/SidePanelLower.stl', 2, 300, 100, (SELECT orderID FROM orders WHERE (revenue = 895.34)), (SELECT Customers_customerID FROM orders WHERE (revenue = 895.34))),
('SidePanelUpper', 'files/SidePanelUpper.stl', 2, 300, 100, (SELECT orderID FROM orders WHERE (revenue = 895.34)), (SELECT Customers_customerID FROM orders WHERE (revenue = 895.34)));