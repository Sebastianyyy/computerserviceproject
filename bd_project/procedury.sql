GO
CREATE PROCEDURE Dane_Osoby (@id_klienta INT )
AS
BEGIN
	SELECT Osoby.ID,Osoby.Imie,Osoby.Nazwisko,Osoby.Email,Osoby.Miejscowosc,Osoby.Ulica,Osoby.[Nr domu],Osoby.[Nr Mieszkania],Osoby.[Nr Telefonu],Osoby.Plec,Klienci.[Data zalozenia],Pracownicy.PESEL,Pracownicy.[Data zatrudnienia],Pracownicy.[Data zwolnienia],Pracownicy.Stawka
	FROM Osoby LEFT JOIN Klienci 
	ON Osoby.Id=Klienci.Id 
	LEFT JOIN Pracownicy ON Pracownicy.ID=Osoby.ID
	WHERE Osoby.Id = @id_klienta
END;
GO
CREATE PROCEDURE Osoba_Wyszukaj_Nazwisko (@nazwisko_osoby NVARCHAR(32))
AS
BEGIN
	SELECT Osoby.* 
	FROM Osoby
    WHERE Osoby.Nazwisko = @nazwisko_osoby
END;
GO

CREATE PROCEDURE Osoba_Wyszukaj_Telefon (@telefon CHAR(9))
AS
BEGIN
	SELECT Osoby.* 
	FROM Osoby
    WHERE Osoby.Nazwisko = @telefon
END;
GO
CREATE PROCEDURE SprawdzStan (@nr_zamowienia int)
AS
BEGIN
	SELECT Stan FROM Zamowienia
	WHERE @nr_zamowienia=ID
END;
GO
CREATE PROCEDURE Zacznij_Naprawe (@nr_naprawy int)
AS
BEGIN
	UPDATE Naprawy
	SET [Data rozpoczecia]=(CAST(GETDATE() AS DATE))
	,[Stan]='Przyjete'
	WHERE ID=@nr_naprawy
END;

GO
CREATE PROCEDURE Zakoncz_Naprawe (@nr_naprawy int,@opis NVARCHAR(200))
AS
BEGIN
	UPDATE Naprawy
	SET [Data zakonczenia]=(CAST(GETDATE() AS DATE))
	,[Stan]='Naprawiony',[Opis naprawy]=@opis
	WHERE ID=@nr_naprawy
END;


GO
CREATE PROCEDURE Zuzyj (@nr_podzespolu int)
AS
BEGIN
	UPDATE Magazyn
	SET Ilosc=Ilosc-1
	WHERE Magazyn.ID=@nr_podzespolu
	INSERT INTO Magazyn_Archiwalny
	SELECT Magazyn.ID, Magazyn.Nazwa,Magazyn.Opis,(CAST(GETDATE() AS DATE)) FROM Magazyn

END; 
