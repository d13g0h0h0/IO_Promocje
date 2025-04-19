--To odkomentować sobie, gdy chce się utworzyć nową bazę danych

/*
CREATE DATABASE Test

GO

USE Test

GO
*/
IF OBJECT_ID('GetAllGiveawaysPerPromotion', 'P') IS NOT NULL
    DROP PROCEDURE GetAllGiveawaysPerPromotion;
IF OBJECT_ID('GiveawaysLog', 'U') IS NOT NULL
	DROP TABLE GiveawaysLog;
IF OBJECT_ID('Products', 'U') IS NOT NULL
	DROP TABLE Products;
IF OBJECT_ID('Producers', 'U') IS NOT NULL
	DROP TABLE Producers;
IF OBJECT_ID('Promotions', 'U') IS NOT NULL
	DROP TABLE Promotions;
IF OBJECT_ID('PromotionTypes', 'U') IS NOT NULL
	DROP TABLE PromotionTypes;
IF OBJECT_ID('GasStations', 'U') IS NOT NULL
	DROP TABLE GasStations;

CREATE TABLE GasStations(
	ID INT,
	Name NVARCHAR(256) UNIQUE NOT NULL,
	CONSTRAINT PK_GasStations PRIMARY KEY(ID)
);

CREATE TABLE PromotionTypes(
	ID INT,
	Description NVARCHAR(256) UNIQUE NOT NULL,
	CONSTRAINT PK_PromotionTypes PRIMARY KEY(ID)
);

CREATE TABLE Promotions(
	ID INT,
	Name NVARCHAR(256) NOT NULL,
	PromotionType INT,
	CONSTRAINT PK_Promotions PRIMARY KEY(ID),
	CONSTRAINT FK_PromotionType_Promotions FOREIGN KEY(PromotionType) REFERENCES PromotionTypes(ID)
);

CREATE TABLE Producers(
	ID INT,
	Name NVARCHAR(256) UNIQUE NOT NULL,
	CONSTRAINT PK_Producers PRIMARY KEY(ID),
);

CREATE TABLE Products(
	ID INT,
	Name NVARCHAR(256) UNIQUE NOT NULL,
	ProducerID INT,
	CONSTRAINT PK_Products PRIMARY KEY(ID),
	CONSTRAINT FK_ProducerID_Product FOREIGN KEY(ProducerID) REFERENCES Producers(ID)
);

CREATE TABLE GiveawaysLog(
	ID INT IDENTITY(0, 1),
	ProductID INT,
	PromotionID INT,
	Quantity INT NOT NULL,
	GasStationID INT,
	Timestamp DATETIME,
	CONSTRAINT PK_GiveawaysLog PRIMARY KEY(ID),
	CONSTRAINT FK_ProductID_GiveawaysLog FOREIGN KEY(ProductID) REFERENCES Products(ID),
	CONSTRAINT FK_PromotionID_GiveawaysLog FOREIGN KEY(PromotionID) REFERENCES Promotions(ID),
	CONSTRAINT FK_GastStationID_GiveawaysLog FOREIGN KEY(GasStationID) REFERENCES GasStations(ID)
);

INSERT INTO GasStations VALUES
(1, N'Kurczaki 34'),
(2, N'Paderewskiego 57'),
(3, N'Zamenhofa 13'),
(4, N'Kilińskiego 5')

INSERT INTO PromotionTypes VALUES
(1, N'Po wydaniu X złotych w ramach jednych zakupów.'),
(2, N'Po kupieniu X produktów firmy Y w ramach jednych zakupów.'),
(3, N'Po wydaniu X złotych na produkty firmy Y w ramach jednych zakupów.')

INSERT INTO Promotions VALUES
(1, N'Zestaw Ferrero Rocher za każde wydane 100 złotych.', 1),
(2, N'Pluszak Miś Uszatek za każde wydane 80 złotych na produkty firmy Lotos.', 3),
(3, N'Długopis w kształcie zwierzęcia za każde kupione 5 produktów firmy Powerade.', 2)


INSERT INTO Producers VALUES
(1, N'Lotos'),
(2, N'Ferrero'),
(3, N'Lajkonik'),
(4, N'Powerade'),
(5, N'Haribo'),
(6, N'Bukowski'),
(7, N'OpenGift')

INSERT INTO Products VALUES
(1, N'Ferrero Rocher', 2),
(2, N'Kinder Bueno', 2),
(3, N'Miś Uszatek', 6),
(4, N'Długopis w kształcie zwierzęcia', 7),
(5, N'Długopis z logiem stacji', 7)

INSERT INTO GiveawaysLog VALUES
(2, 1, 3, 2, '01/01/2025 09:01:03'),
(2, 1, 1, 3, '01/01/2025 09:31:25'),
(2, 1, 1, 2, '01/01/2025 13:51:52'),
(3, 2, 2, 4, '01/01/2025 12:33:00'),
(3, 2, 1, 3, '01/01/2025 14:27:15'),
(4, 3, 1, 1, '01/01/2025 16:21:22')

GO

/*
Trzeba przetestować poniższą procedurę, np. czy da się bezpośrednio
wywołać coś w postaci GetAllGiveawaysPerPromotion(1),
albo czy da się wprowadzić następującą komendę:
EXECUTE GetAllGiveawaysPerPromotion @PromotionId = 1

Warto też przetestować, czy da się wprowadzić wprost dwa poniższe zapytania:
1.
SELECT
	GS.Name,
	GL.Timestamp,
	GL.Quantity
FROM
	GiveawaysLog GL
JOIN
	GasStations GS ON GL.GasStationID = GS.ID
WHERE
	GL.PromotionID = 1;

2.
SELECT * FROM Giveaways WHERE PromotionID = 1
*/
CREATE PROCEDURE GetAllGiveawaysPerPromotion
(
	@PromotionID INT
)
AS
SELECT
	GS.Name,
	GL.Timestamp,
	GL.Quantity
FROM
	GiveawaysLog GL
JOIN
	GasStations GS ON GL.GasStationID = GS.ID
WHERE
	GL.PromotionID = @PromotionID;

GO

--To jest na sam koniec do automatycznego usunięcia bazy

/*
USE master
DROP DATABASE Test
*/