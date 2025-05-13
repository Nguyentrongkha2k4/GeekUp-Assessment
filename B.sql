-- b)
-- Brand
INSERT INTO Brand (Name) VALUES ('KAPPA');

-- Category
INSERT INTO Categories (Name) VALUES ('Women''s Sneakers');

-- Template (sản phẩm chuẩn, không tính tồn kho)
INSERT INTO Templates (Name, Size, Color, Price, BrandID)
VALUES (
    'KAPPA Women''s Sneakers',
    36,
    'yellow',
    980000,
    (SELECT Id FROM Brand WHERE Name = 'KAPPA')
);

-- Giả sử có 5 đôi tồn kho
INSERT INTO Products (TemplateID, Quantity)
VALUES (
    (SELECT Id FROM Templates WHERE Name = 'KAPPA Women''s Sneakers' AND Size = 36 AND Color = 'yellow'),
    5
);

INSERT INTO Users (
    Name, Mail, Phone, Province, District, Commune, DetailAddress, HousingType
)
VALUES (
    'assessment',
    'gu@gmail.com',
    '328355333',
    'Bắc Kạn',
    'Ba Bể',
    'Phúc Lộc',
    '73 tân hoà 2',
    'nhà riêng'
);

INSERT INTO PaymentType (Name) VALUES ('Credit Card');  

-- Insert order 
INSERT INTO Orders (StatusPayment, PaymentID, GrandTotal, DiscountTotal, SubTotal, UserID)
VALUES ('Pending', 1, 0, 0, 0, 1);

INSERT INTO Order_Product (ProductID, OrderID, Quantity, PriceAtThisTime)
VALUES (1, 1, 1, 980000);