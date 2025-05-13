CREATE DATABASE eCommerce;
USE eCommerce;

CREATE TABLE Stores (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100)
);

CREATE TABLE Brand (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100)
);

CREATE TABLE Categories (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100)
);

CREATE TABLE Templates (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Description TEXT,
    Price DECIMAL(10,2),
    Size VARCHAR(50),
    Color VARCHAR(50),
    BrandID INT,
    FOREIGN KEY (BrandID) REFERENCES Brand(Id)
);

CREATE TABLE Template_Categories (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    TemplateID INT,
    CategoriesID INT,
    FOREIGN KEY (TemplateID) REFERENCES Templates(Id),
    FOREIGN KEY (CategoriesID) REFERENCES Categories(Id)
);

CREATE TABLE Products (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Quantity INT,
    TemplateID INT,
    StoreID INT,
    FOREIGN KEY (TemplateID) REFERENCES Templates(Id),
    FOREIGN KEY (StoreID) REFERENCES Stores(Id)
);

CREATE TABLE Vouchers (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Code VARCHAR(50),
    Value DECIMAL(10,2),
    StartDate DATE,
    EndDate DATE,
    Quantity INT
);

CREATE TABLE PaymentType (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100)
);

CREATE TABLE Users (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    Sex VARCHAR(10),
    Mail VARCHAR(100),
    Phone VARCHAR(20),
    Province VARCHAR(100),
    Commune VARCHAR(100),
    District VARCHAR(100),
    DetailAddress TEXT,
    HousingType VARCHAR(50)
);

CREATE TABLE Orders (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    StatusPayment VARCHAR(50),
    PaymentID INT,
    GrandTotal DECIMAL(10,2),
    DiscountTotal DECIMAL(10,2),
    SubTotal DECIMAL(10,2),
    UserID INT,
    FOREIGN KEY (PaymentID) REFERENCES PaymentType(Id),
    FOREIGN KEY (UserID) REFERENCES Users(Id)
);

CREATE TABLE Order_Voucher (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    VoucherID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(Id),
    FOREIGN KEY (VoucherID) REFERENCES Vouchers(Id)
);

CREATE TABLE Order_Product (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    OrderID INT,
    Quantity INT,
    PriceAtThisTime DECIMAL(10,2),
    Total DECIMAL(10,2),
    FOREIGN KEY (ProductID) REFERENCES Products(Id),
    FOREIGN KEY (OrderID) REFERENCES Orders(Id)
);

--  Trigger for total
DELIMITER $$

CREATE TRIGGER trg_update_order_product_total
BEFORE INSERT ON Order_Product
FOR EACH ROW
BEGIN
    DECLARE product_price DECIMAL(10,2);

    SELECT T.Price
    INTO product_price
    FROM Products P
    JOIN Templates T ON P.TemplateID = T.Id
    WHERE P.Id = NEW.ProductID;

    SET NEW.Total = product_price * NEW.Quantity;
END$$

CREATE TRIGGER trg_update_order_product_total_update
BEFORE UPDATE ON Order_Product
FOR EACH ROW
BEGIN
    DECLARE product_price DECIMAL(10,2);

    SELECT T.Price
    INTO product_price
    FROM Products P
    JOIN Templates T ON P.TemplateID = T.Id
    WHERE P.Id = NEW.ProductID;

    SET NEW.Total = product_price * NEW.Quantity;
END$$

CREATE TRIGGER trg_update_order_totals
AFTER INSERT ON Order_Product
FOR EACH ROW
BEGIN
    DECLARE sub DECIMAL(10,2);
    DECLARE dis DECIMAL(10,2);

    SELECT IFNULL(SUM(Total), 0) INTO sub
    FROM Order_Product
    WHERE OrderID = NEW.OrderID;

    SELECT IFNULL(SUM(V.Value), 0) INTO dis
    FROM Order_Voucher OV
    JOIN Vouchers V ON OV.VoucherID = V.Id
    WHERE OV.OrderID = NEW.OrderID;

    UPDATE Orders
    SET SubTotal = sub,
        DiscountTotal = dis,
        GrandTotal = sub - dis
    WHERE Id = NEW.OrderID;
END$$

-- Update trigger cho Order_Product
CREATE TRIGGER trg_update_order_totals_on_update
AFTER UPDATE ON Order_Product
FOR EACH ROW
BEGIN
    DECLARE sub DECIMAL(10,2);
    DECLARE dis DECIMAL(10,2);

    SELECT IFNULL(SUM(Total), 0) INTO sub
    FROM Order_Product
    WHERE OrderID = NEW.OrderID;

    SELECT IFNULL(SUM(V.Value), 0) INTO dis
    FROM Order_Voucher OV
    JOIN Vouchers V ON OV.VoucherID = V.Id
    WHERE OV.OrderID = NEW.OrderID;

    UPDATE Orders
    SET SubTotal = sub,
        DiscountTotal = dis,
        GrandTotal = sub - dis
    WHERE Id = NEW.OrderID;
END$$

-- Khi thêm voucher vào đơn hàng
CREATE TRIGGER trg_update_order_totals_voucher
AFTER INSERT ON Order_Voucher
FOR EACH ROW
BEGIN
    DECLARE sub DECIMAL(10,2);
    DECLARE dis DECIMAL(10,2);

    SELECT IFNULL(SUM(Total), 0) INTO sub
    FROM Order_Product
    WHERE OrderID = NEW.OrderID;

    SELECT IFNULL(SUM(V.Value), 0) INTO dis
    FROM Order_Voucher OV
    JOIN Vouchers V ON OV.VoucherID = V.Id
    WHERE OV.OrderID = NEW.OrderID;

    UPDATE Orders
    SET SubTotal = sub,
        DiscountTotal = dis,
        GrandTotal = sub - dis
    WHERE Id = NEW.OrderID;
END$$

DELIMITER ;