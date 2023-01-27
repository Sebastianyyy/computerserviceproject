CREATE FUNCTION UrzadzeniaKlienta(@id_klienta INT) 
RETURNS @Klient TABLE(
ID INT,
Imie NVARCHAR(32) NOT NULL,
Nazwisko NVARCHAR(32) NOT NULL,
Email NVARCHAR(320),
[Nr Telefonu] CHAR (9) UNIQUE,
Miejscowosc NVARCHAR(50),
[ID Urzadzenia] INT,
[Typ] NVARCHAR(15),
[Marka] NVARCHAR(15),
Model NVARCHAR(50) ,
[Nr seryjny] NVARCHAR(50)
)
AS
BEGIN
    IF EXISTS (SELECT * FROM Urzadzenia WHERE Urzadzenia.
	INSERT INTO @Klient
	SELECT  Osoby.ID,Osoby.Imie,Osoby.Nazwisko,Osoby.Email,Osoby.[Nr Telefonu],Osoby.Miejscowosc,Urzadzenia.ID,Urzadzenia.Typ,Urzadzenia.Marka,Urzadzenia.Model,Urzadzenia.[Nr seryjny] 
	FROM Osoby JOIN Urzadzenia ON Urzadzenia.[ID klienta]=Osoby.ID
	WHERE [ID klienta]=@id_klienta
	RETURN @Klient
END

GO
CREATE FUNCTION RankingPracownikowMiesiaca(@id_miesiac INT,@id_rok INT) 
RETURNS @Ranking TABLE(
ID INT,
Imie NVARCHAR(32) NOT NULL,
Nazwisko NVARCHAR(32) NOT NULL,
Ilosc INT
)
AS
BEGIN
IF (@id_rok<YEAR(GETDATE()) AND @id_miesiac>=1 AND @id_miesiac<=12) OR (@id_rok=YEAR(GETDATE()) AND @id_miesiac<=MONTH(GETDATE()) AND @id_miesiac>=1 AND @id_miesiac<=12)
	BEGIN
	INSERT INTO @Ranking
	SELECT N.[ID pracownika],O.Imie, O.Nazwisko,N.[Il. Naprawionych] FROM
	(SELECT  Naprawy.[Id pracownika],COUNT(Naprawy.[Id pracownika]) AS [Il. Naprawionych] FROM Pracownicy JOIN Naprawy ON Pracownicy.Id=Naprawy.[Id pracownika] JOIN Zamowienia ON Naprawy.[ID zamowienia]=Zamowienia.ID
	WHERE Pracownicy.[Data zwolnienia] IS NULL AND Zamowienia.Stan='Zrealizowane' AND MONTH(CAST(Zamowienia.[Data realizacji] AS DATE)) = @id_miesiac AND YEAR(CAST(Zamowienia.[Data realizacji] AS DATE)) = @id_rok
	GROUP BY Naprawy.[Id pracownika]
	ORDER BY [Il. Naprawionych] DESC OFFSET 0 ROWS)
	AS N
	JOIN Osoby O ON O.ID=N.[ID pracownika]
	END
	RETURN
END 

GO
CREATE FUNCTION Faktura(@id_miesiac INT,@id_rok INT) 
RETURNS @FV TABLE(
[Nr Faktury] INT,
[ID odbiorcy] INT,
[Imie odbiorcy] NVARCHAR(32),
[Nazwisko odbiorcy] NVARCHAR(32),
Email NVARCHAR(320),
[Nr Telefonu] CHAR (9),
[Nr zamowienia] INT,
[Data wystawienia] Date,
[Cena] INT
)
AS
BEGIN
	IF (@id_rok<YEAR(GETDATE()) AND @id_miesiac>=1 AND @id_miesiac<=12) OR (@id_rok=YEAR(GETDATE()) AND @id_miesiac<=MONTH(GETDATE()) AND @id_miesiac>=1 AND @id_miesiac<=12)
	BEGIN
	INSERT INTO @FV
	SELECT Faktury.ID,K.ID,O.Imie,O.Nazwisko,O.Email,O.[Nr Telefonu],Faktury.[ID zamowienia],Faktury.[Data wystawienia],Faktury.Cena  FROM Faktury
	JOIN Klienci AS K ON K.ID=Faktury.[ID odbiorcy]
	JOIN Osoby AS O ON O.ID=K.ID
	WHERE YEAR(CAST(Faktury.[Data wystawienia] AS DATE)) = @id_rok AND MONTH(CAST(Faktury.[Data wystawienia] AS DATE))=@id_miesiac
	END
	RETURN
END 