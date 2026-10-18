
/*
CREATE TABLE menu (
  itemName VARCHAR(50) PRIMARY KEY NOT NULL,
  category VARCHAR(50) NOT NULL,
  price DECIMAL(5,2)
);

INSERT INTO menu(itemName, category, price) VALUES('Vegetable Soup', 'Soups', 5);
INSERT INTO menu(itemName, category, price) VALUES('Spaghetti Bolognese', 'Mains', 6);

Update the price by 10 percent
*/
--We need to divide by 100.0 instead of 100 as we need to make sure that we calculate the decimal points also else if the 10 is less that 1 then it will show as 0 only.

update menu
set price = price + (10/100.0)*price
where category = 'Soups'

--I have added 100.00, inorder to get the decimal value from the update query