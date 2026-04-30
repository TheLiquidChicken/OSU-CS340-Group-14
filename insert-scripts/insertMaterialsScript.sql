INSERT INTO Materials (kilograms, MaterialTypes_materialTypeID, Colors_colorID) VALUES 
(5, (SELECT materialTypeId FROM materialTypes WHERE (materialTypeDescription = 'PLA')), (SELECT colorID FROM colors WHERE (colorDescription = 'Red'))),
(8, (SELECT materialTypeId FROM materialTypes WHERE (materialTypeDescription = 'PETG')), (SELECT colorID FROM colors WHERE (colorDescription = 'Blue'))),
(11, (SELECT materialTypeId FROM materialTypes WHERE (materialTypeDescription = 'NYLON')), (SELECT colorID FROM colors WHERE (colorDescription = 'Purple')));