SELECT round(SUM(Price * Quantity)) AS sales, Country
FROM OrderDetails
JOIN Orders ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON OrderDetails.ProductID = Products.ProductID
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
GROUP BY Country
ORDER BY sales DESC;