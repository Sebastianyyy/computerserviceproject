
GO
CREATE VIEW ObecniPracownicy AS
	SELECT Osoby.*,Pracownicy.PESEL,Pracownicy.Stawka,Pracownicy.[Data zatrudnienia] FROM Osoby
	JOIN Pracownicy ON Osoby.Id = Pracownicy.Id
	WHERE [Data zwolnienia] IS NULL

GO
CREATE VIEW ZwolnieniPracownicy AS
	SELECT Osoby.*,Pracownicy.PESEL,Pracownicy.Stawka,Pracownicy.[Data zatrudnienia], Pracownicy.[Data zwolnienia] FROM Osoby
	JOIN Pracownicy ON Osoby.Id = Pracownicy.Id
	WHERE [Data zwolnienia] IS NOT NULL

GO
CREATE VIEW PrzyjeteZamowienia AS
	SELECT * FROM Zamowienia
	WHERE Stan LIKE('Przyjete')

GO
CREATE VIEW Zrealizowane AS
	SELECT * FROM Zamowienia
	WHERE Stan LIKE('Zrealizowane')
    
GO
CREATE VIEW DzisiejszeZamowienia AS
	SELECT * FROM Zamowienia
	WHERE CAST(Zamowienia.[Data przyjecia] AS DATE) = CAST(GETDATE() AS DATE)

GO
CREATE VIEW DzisiejszeRealizacje AS
	SELECT * FROM Zamowienia
	WHERE CAST(Zamowienia.[Data realizacji] AS DATE) = CAST(GETDATE() AS DATE)

GO
CREATE VIEW DzisiejszeZuzytePodzespoly AS
	SELECT M.ID,M.[ID podzespolu],M.Nazwa,M.Opis FROM Magazyn_Archiwalny AS M
	WHERE CAST(M.[Data zuzycia] AS DATE) = CAST(GETDATE() AS DATE)
    
GO
CREATE VIEW StanMagazynu AS
	SELECT * FROM Magazyn