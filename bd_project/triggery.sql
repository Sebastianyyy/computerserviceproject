GO
CREATE TRIGGER Sprawdz_czy_naprawione ON Naprawy
AFTER UPDATE
AS
	DECLARE @TEMP_TABLE TABLE(NrZamowienia INT, Stan_ NVARCHAR(10))
	DECLARE @Nr_zamowienia INT
	DECLARE @flag INT
	SELECT @Nr_zamowienia=inserted.[ID zamowienia] FROM inserted

	INSERT INTO @TEMP_TABLE
	SELECT Naprawy.[ID zamowienia],Naprawy.Stan FROM Naprawy
	WHERE @Nr_zamowienia=Naprawy.[ID zamowienia];

	IF NOT EXISTS(SELECT * FROM   @TEMP_TABLE WHERE  Stan_ NOT LIKE('Naprawiony')) 
	BEGIN
		UPDATE Zamowienia
		SET Zamowienia.Stan='Zrealizowane', Zamowienia.[Data realizacji]=GETDATE()
		WHERE Zamowienia.ID=@Nr_zamowienia
	END
GO


CREATE TRIGGER Sprawdz_poprawnosc_faktury
ON Faktury
INSTEAD OF INSERT
AS 
BEGIN
	DECLARE
		@ID INT,
		@ID_zamowienia INT,	
		@Datawystawienia DATE,	
		@IDodbiorcy INT,
		@Cena Money

	SELECT @ID=inserted.ID, @ID_zamowienia=inserted.[ID zamowienia],@Datawystawienia=inserted.[Data wystawienia]
	,@IDodbiorcy=inserted.[ID odbiorcy],@Cena=inserted.Cena FROM inserted


	IF NOT EXISTS(SELECT Stan FROM Zamowienia WHERE Zamowienia.ID=@ID_zamowienia AND Stan='Zrealizowane')
	BEGIN
		PRINT('Zamowienie nie gotowe')
	END
	ELSE
	BEGIN
		INSERT INTO Faktury([ID zamowienia],[Data wystawienia],[ID odbiorcy],Cena)
		VALUES(@ID_zamowienia, @Datawystawienia,@IDodbiorcy,@Cena)
	END	
END



GO
CREATE TRIGGER Sprawdz_pracownika_dostepnosc
ON Naprawy
INSTEAD OF INSERT
AS
BEGIN
	DECLARE
		@ID INT,
		@ID_zamowienia INT,	
		@ID_pracownika INT,
		@Data_rozpoczecia DATE,	
		@Data_zakonczenia DATE,
		@Stan NVARCHAR(10),
		@Opis_naprawy NVARCHAR(200)

	SELECT @ID_zamowienia=inserted.[ID zamowienia], @id_pracownika=inserted.[ID pracownika],@Data_rozpoczecia=inserted.[Data rozpoczecia]
	,@Data_zakonczenia=inserted.[Data zakonczenia],@Stan=inserted.Stan,@Opis_naprawy=inserted.[Opis naprawy] FROM inserted
	IF EXISTS(SELECT * FROM Urlopy WHERE @ID_pracownika=Urlopy.ID AND (@Data_rozpoczecia BETWEEN Urlopy.[Od kiedy] AND Urlopy.[Do kiedy]))
	BEGIN
		PRINT('Pracownik jest na urlopie')
	END
	ELSE
	BEGIN
		INSERT INTO Naprawy([ID zamowienia],[ID pracownika],[Data rozpoczecia],[Data zakonczenia],[Stan],[Opis naprawy])
		VALUES(@ID_zamowienia, @ID_pracownika, @Data_rozpoczecia,@Data_zakonczenia,@Stan,@Opis_naprawy)
	END	
END;

GO

CREATE TRIGGER Aktualizacja_magazynu 
   ON Magazyn
   AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
    DELETE FROM Magazyn WHERE Ilosc <= 0 AND
	Magazyn.ID in (select Magazyn.ID from inserted);
END
