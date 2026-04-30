INSERT INTO Orders (Customers_customerID, revenue, date) VALUES
((SELECT customerID FROM Customers WHERE (Customers.primaryContact = 'Beverly Hanson')),300.32, '2024-01-05'),
((SELECT customerID FROM Customers WHERE (Customers.primaryContact = 'Sam Alexander')),832.56, '2025-03-16'),
((SELECT customerID FROM Customers WHERE (Customers.primaryContact = 'Chris Fabela')),983.87, '2025-06-21'),
((SELECT customerID FROM Customers WHERE (Customers.primaryContact = 'Chris Fabela')),895.34, '2026-02-03');