CREATE TABLE Payment (
    Payment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID INT NOT NULL UNIQUE,
    Payment_Date DATE NOT NULL,
    Payment_Mode VARCHAR(30) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    Transaction_Amount DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (Order_ID)
        REFERENCES Orders(Order_ID),

    CHECK (Payment_Mode IN (
        'UPI', 'Credit Card', 'Debit Card',
        'Net Banking', 'Cash on Delivery'
    )),

    CHECK (Payment_Status IN (
        'Pending', 'Success', 'Failed'
    )),

    CHECK (Transaction_Amount >= 0)
);

INSERT INTO Payment
(Order_ID, Payment_Date, Payment_Mode,
 Payment_Status, Transaction_Amount)
VALUES
(1, CURDATE(), 'UPI', 'Success', 1300.00),
(2, CURDATE(), 'Credit Card', 'Pending', 2500.00),
(3, CURDATE(), 'Debit Card', 'Failed', 800.00),
(4, CURDATE(), 'Net Banking', 'Success', 1500.00),
(5, CURDATE(), 'Cash on Delivery', 'Pending', 600.00);

SELECT *
FROM Payment
WHERE Payment_Status = 'Success';

SELECT *
FROM Payment
WHERE Payment_Status IN ('Failed', 'Pending');

UPDATE Payment
SET Payment_Status = 'Success',
    Payment_Date = CURDATE()
WHERE Payment_ID = 3;

SELECT *
FROM Payment
WHERE Order_ID = 1;

SELECT c.Customer_ID,
       p.Payment_ID,
       o.Order_ID,
       o.Order_Date,
       p.Payment_Date,
       p.Payment_Mode,
       p.Payment_Status,
       p.Transaction_Amount
FROM Payment p
JOIN Orders o ON p.Order_ID = o.Order_ID
JOIN Customer c ON o.Customer_ID = c.Customer_ID;

SELECT Payment_Mode,
       COUNT(*) AS Total_Transactions
FROM Payment
GROUP BY Payment_Mode;

SELECT Payment_Mode,
       COUNT(*) AS Total_Transactions
FROM Payment
GROUP BY Payment_Mode
ORDER BY Total_Transactions DESC
LIMIT 1;

SELECT SUM(Transaction_Amount) AS Total_Revenue
FROM Payment
WHERE Payment_Status = 'Success';

SELECT Payment_Mode,
       SUM(Transaction_Amount) AS Revenue
FROM Payment
WHERE Payment_Status = 'Success'
GROUP BY Payment_Mode;

SELECT AVG(Transaction_Amount) AS Average_Amount
FROM Payment;

SELECT 
    c.Customer_ID,
    p.Order_ID,
    p.Payment_Mode,
    p.Payment_Status,
    p.Transaction_Amount,
    p.Payment_Date
FROM
    Customer c
        JOIN
    Orders o ON c.Customer_ID = o.Customer_ID
        JOIN
    Payment p ON o.Order_ID = p.Order_ID
ORDER BY c.Customer_ID , p.Payment_Date DESC;

SELECT o.Order_ID,
       o.Customer_ID,
       p.Payment_Mode,
       p.Payment_Status,
       p.Transaction_Amount
FROM Orders o
JOIN Payment p ON o.Order_ID = p.Order_ID
WHERE p.Payment_Status IN ('Failed', 'Pending');
