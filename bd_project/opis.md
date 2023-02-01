<h1>Uproszczona Baza Danych Serwisu Komputerowego </h1>

<h2>Wstęp</h2>
Projekt uproszczonej bazy danych serwisu komputerowego, której celem jest symulowanie rzeczywistej bazy danych.
Przechowuje informacje o klientach zarejestrowanych w naszym systemie, pracownikach naszej firmy ,informacje o zamówieniach naprawczych, informacje o przebiegu napraw, urządzeniach oraz o stanie częsci naprawczych w naszym magazynie.

<h2>Ograniczenia</h2>
Jednym z podstawowych ograniczeń naszej bazy, to brak aplikacji klienckiej.
Mimo, że baza danych skupia się na serwisowaniu komputerów może być w prosty sposób rozszerzona do serwisowania urządzeń AGD, RTV, ale o tym więcej w akapicie dotyczącym rozwoju.

<h2>Zaplanowany Rozwój</h2>
Głownymi celami rozwoju, jakie zostały ustalone to, między innymi, skupienie się na utworzeniu aplikacji. Baza danych nie ma się ograniczać jedynie do serwisowania komputerów, ale ma się skupiać na wszelkiego rodzaju sprzętach elektronicznych takie jak komputery, monitory, drukarki, RTV typu: telefony, zasilacze, radia, aż po sprzęty AGD, typu lodówki, piekarniki, pralki.
Najbliższym celem, jakie zostało postawione zespołowi developerskiemu odpowiadającemu za rozwój bazy jest dodanie notyfikacji typu SMS oraz Mail, odnośnie przyjęcia zamówienia oraz gotowości w celu odberania naprawionego sprzętu

Głownym celem, jakim się kierowałem podczas tworzenia bazy to przejrzystość, prostota oraz łatwość w posługiwaniu się nią.


<h2>Pielęgnacja</h2>
Nasza baza danych jest dosyć często aktualizowana, ze względu na dodawanie zamówień oraz ich aktualizacji. Zatem, bedzięmy wykonywać codziennie kopie różnicową, a raz na tydzień zalecane jest wykonanie kopii zapasowej pełnej. Wykonywanie kopii zapasowych powinno odbywać się poza godzianami pracy serwisu.


<h2>Inne</h2>
Baza danych zawiera, atrybuty, które zmieniają się w czasie. 
W tabeli "Zamówienia" wartość atrybutu "Stan" przyjmuje dwie wartości:
-Przyjęty (informacja o tym, że zamówienie zostało przyjęte przez serwis)
-Zrealizowany (informacja o tym, że zamówienie zostało zrealizowane i jest gotowe do odbioru przez klienta)
W tabeli "Naprawy" wartość atrybutu "Stan" przyjmuje dwie wartości:
-Przyjęty (informacja, o tym, że zlecenie naprawy danego komponentu zostało rozpoczęte)
-Naprawiony (informacja, o tym, że zlecenie naprawy danego komponentu zostało zrealizowane)

<h1>Tabele</h1>

<h3>Osoby</h3>
Tabel ma na celu przechowywać dane osób takich jak pracownicy czy klienci. Zawiera podstawowe zabezpieczenia przed wpisywaniem nieprawidłowych danych. Tabela Osoby realizuje, wraz z tabelami Klienci oraz Pracownicy model dziedziczenia Table Per Type(TPT)

    CREATE TABLE Osoby(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Imie NVARCHAR (32) NOT NULL,
    Nazwisko CHAR(32) NOT NULL,
    [Nr Telefonu] CHAR (9) UNIQUE NOT NULL,
    Miejscowosc NVARCHAR(50),
    Ulica NVARCHAR(50),
    [Nr domu] INT,
    [Nr Mieszkania] INT,
    Email NVARCHAR(320) UNIQUE NOT NULL,
    Plec CHAR(1) CHECK(Plec LIKE('M') OR Plec LIKE('F')),
    CHECK ([Nr Telefonu] NOT LIKE '%[^0-9]%'),
    CHECK (Email LIKE '%_@__%.__%')
    )

<h3>Klienci</h3>
Tabela przechowuje klientów naszego serwisu.

    CREATE TABLE Klienci(
    ID INT,
    PRIMARY KEY (ID),
    [Data zalozenia] Date,
    FOREIGN KEY (ID) REFERENCES Osoby(ID),
    )

<h3>Pracownicy</h3>
Tabela przechowuje pracowników naszego serwisu. W przyszłości planowana jest rozbudowa tej tabeli, w sposób taki, aby rozróżniać pracowników biurowych, zarządu, warsztatu itp.

    CREATE TABLE Pracownicy(
    ID INT,
    Stawka Money NOT NULL,
    PESEL CHAR(11) UNIQUE NOT NULL,
    [Data zatrudnienia] DATE NOT NULL,
    [Data zwolnienia] DATE,
    CHECK ([Data zatrudnienia]<=[Data zwolnienia]),
    CHECK(LEN(PESEL)=11),
    CHECK(PESEL NOT LIKE '%[^0-9]%'),
    PRIMARY KEY (ID),
    FOREIGN KEY (ID) REFERENCES Osoby(ID)
    )

<h3>Urlopy</h3>
Tabela przechowuje informacje o urlopach pracowników.

    CREATE TABLE Urlopy(
    ID INT,
    [Od kiedy] DATE,
    [Do kiedy] DATE NOT NULL,
    CHECK ([Od kiedy]<=[Do kiedy]),
    PRIMARY KEY (ID, [Od kiedy]),
    FOREIGN KEY (ID) REFERENCES Pracownicy(ID)
    )

<h3>Urzadzenia</h3>
Tabela przechowuje informacje o urządzeniach klientów, które zostały zarejestrowane w naszym systemie do naprawy.

    CREATE TABLE Urzadzenia(
    ID INT IDENTITY(1,1),
    [ID klienta] INT,
    [Typ] NVARCHAR(30),
    [Marka] NVARCHAR(30),
    Model NVARCHAR(50) ,
    [Nr seryjny] NVARCHAR(50),
    [Opis] NVARCHAR(190),
    PRIMARY KEY(ID),
    FOREIGN KEY ([ID klienta]) REFERENCES Klienci(ID)
    )

<h3>Zamowienia</h3>
Table przechowuje zlecenia klientów na naprawe urządzeń w naszym serwisie. Wartość atrybuty Stan się zmienia. Rejestrując zamówienie w naszym serwisie Stan, początkowo jest wartościowany na "Przyjęty". Gdy wszystkie naprawy zostaną dokonane w związku z danym zamówieniem, wartość Stan zmienia się na "Gotowy", oznaczający jak sama nazwa wskazuję na gotowy do odbioru przez klienta. Mamy również date złożenia zamówienia, czyli data przyjęcia oraz datę zakończenia wszystkich napraw oraz gotowości do odbioru.

    CREATE TABLE Zamowienia(
    ID INT IDENTITY(1,1),
    [ID klienta] INT,
    [ID urzadzenia] INT,
    [Data przyjecia] DATE,
    [Data realizacji] DATE,
    [Opis] NVARCHAR(100),
    [Stan] NVARCHAR(12) DEFAULT 'Przyjety',
    PRIMARY KEY(ID),
    FOREIGN KEY ([ID klienta]) REFERENCES Klienci(ID),
    FOREIGN KEY ([ID urzadzenia]) REFERENCES Urzadzenia(ID)
    )

<h3>Naprawy</h3>
Tabela zawiera informacje o naprawach urządzeń. Dane zamówienie na naprawe urządzenia może obejmować kilka napraw. Czyli przypisujemy danego pracownika do naprawy i jest on odpowiedzialny za naprawe/wymiane danych komponentów. Inny pracownik, może być odpowiedzilany za np. instalacje. Działają oni razem w związku z danym zamówieniem, lecz ich naprawy są osobne i niezależą od siebie. Atrybut zmieniający wartość to Stan przyjmuję on wartości "Przyjęty" oraz "Naprawiony".

    CREATE TABLE Naprawy(
    ID INT IDENTITY(1,1),
    [ID zamowienia] INT,
    [ID pracownika] INT,
    [Data rozpoczecia] DATE,
    [Data zakonczenia] DATE,
    [Stan] NVARCHAR(10) ,
    [Opis naprawy] NVARCHAR(200),
    PRIMARY KEY (ID),
    FOREIGN KEY ([ID pracownika]) REFERENCES Pracownicy(ID),
    FOREIGN KEY ([ID zamowienia]) REFERENCES Zamowienia(ID),
    )

<h3>Faktury</h3>
Tabela przechowująca faktury klientów, za naprawe urządzenia.

    CREATE TABLE Faktury(
    ID INT IDENTITY(1,1),
    [ID zamowienia] INT,
    [Data wystawienia] DATE NOT NULL,
    [ID odbiorcy] INT,
    [Cena] Money NOT NULL,
    PRIMARY KEY (ID),
    FOREIGN KEY ([ID odbiorcy]) REFERENCES Klienci(ID),
    FOREIGN KEY ([ID zamowienia]) REFERENCES Zamowienia(ID),
    )

<h3>Magazyn</h3>
Tabela przechowuje aktualne komponenty/podzespoły w magazynie.

    CREATE TABLE Magazyn(
    ID INT IDENTITY(1,1),
    [Nazwa] NVARCHAR(50),
    [Opis] NVARCHAR(50),
    [Ilosc] INT,
    PRIMARY KEY(ID),
    )

<h3>Magazyn_Archiwalny</h3>
Tabela przechowuje zużyte komponenty/podzespoły, których nie ma już w magazynie.

    CREATE TABLE Magazyn_Archiwalny(
    ID INT IDENTITY(1,1),
    [ID podzespolu] INT,
    [Nazwa] NVARCHAR(50),
    [Opis] NVARCHAR(50),
    [Data zuzycia] DATE,
    PRIMARY KEY(ID),
    )

# Procedury

### Dane_Osoby
Procedura odpowiadająca za wyświetleniu danych osoby o zadanym id

    CREATE PROCEDURE Dane_Osoby (@id_klienta INT )
    AS
    BEGIN
        SELECT Osoby.ID,Osoby.Imie,Osoby.Nazwisko,Osoby.Email,Osoby.Miejscowosc,Osoby.Ulica,Osoby.[Nr domu],Osoby.[Nr Mieszkania],Osoby.[Nr Telefonu],Osoby.Plec,Klienci.[Data zalozenia],Pracownicy.PESEL,Pracownicy.[Data zatrudnienia],Pracownicy.[Data zwolnienia],Pracownicy.Stawka
        FROM Osoby LEFT JOIN Klienci 
        ON Osoby.Id=Klienci.Id 
        LEFT JOIN Pracownicy ON Pracownicy.ID=Osoby.ID
        WHERE Osoby.Id = @id_klienta
    END;


### Osoba_Wyszukaj_Nazwisko
Procedura ma za zadanie wyświetlenie podstawowych danych o osobie o zadanym nazwisku.

    CREATE PROCEDURE Osoba_Wyszukaj_Nazwisko (@nazwisko_osoby NVARCHAR(32))
    AS
    BEGIN
        SELECT Osoby.* 
        FROM Osoby
        WHERE Osoby.Nazwisko = @nazwisko_osoby
    END;

### Osoba_Wyszukaj_Telefon
Procedura ma za zadanie wyświetlenie podstawowych danych posiadający zadany numer telefonu. Jest on unikalny przypisany do danego klienta.

    CREATE PROCEDURE Osoba_Wyszukaj_Telefon (@telefon CHAR(9))
    AS
    BEGIN
        SELECT Osoby.* 
        FROM Osoby
        WHERE Osoby.Nazwisko = @telefon
    END;

### Sprawdz_Stan
Procedura ma za zadanie wyświetlenie informacji o stanie danego zamówienia. 

    CREATE PROCEDURE Sprawdz_Stan (@nr_zamowienia int)
    AS
    BEGIN
        SELECT Stan FROM Zamowienia
        WHERE @nr_zamowienia=ID
    END;

### Sprawdz_Zamowienia_Klienta
Procedura ma za zadanie wyświetlenie informacji o zleceniach naszego klienta w serwisie.

    CREATE PROCEDURE Sprawdz_Zamowienia_Klienta(@nr_klienta int)
    AS
    BEGIN
        SELECT * FROM Zamowienia
        WHERE @nr_klienta=Zamowienia.[ID klienta]
    END;

### Zacznij_Naprawe
Procedura ma za zadanie przekazaniu informacji do systemu, że dana naprawa została rozpoczęta. Procedura zmienia stan naszej naprawy oraz zmienia data rozpoczęcia naprawy.

    CREATE PROCEDURE Zacznij_Naprawe (@nr_naprawy int)
    AS
    BEGIN
        UPDATE Naprawy
        SET [Data rozpoczecia]=(CAST(GETDATE() AS DATE))
        ,[Stan]='Przyjete'
        WHERE ID=@nr_naprawy
    END;

### Zakoncz_Naprawe
Procedura ma za zadanie przekazaniu informacji do systemu, że dana naprawa została zakończona. Procedura zmienia stan naszej naprawy oraz zmienia data zakonczenia naprawy.

    CREATE PROCEDURE Zakoncz_Naprawe (@nr_naprawy int,@opis NVARCHAR(200))
    AS
    BEGIN
        UPDATE Naprawy
        SET [Data zakonczenia]=(CAST(GETDATE() AS DATE))
        ,[Stan]='Naprawiony',[Opis naprawy]=@opis
        WHERE ID=@nr_naprawy
    END;

### Zuzyj
Procedura ma za zadanie przekazaniu informacji do systemu, że dany komponent/podzespół został wykorzystany oraz, już się nie znajduje w naszym magazynie. Zostaje on zapisany w naszym magazynie archiwalnym.

    CREATE PROCEDURE Zuzyj (@nr_podzespolu int)
    AS
    BEGIN
        UPDATE Magazyn
        SET Ilosc=Ilosc-1
        WHERE Magazyn.ID=@nr_podzespolu
        INSERT INTO Magazyn_Archiwalny
        SELECT Magazyn.ID, Magazyn.Nazwa,Magazyn.Opis,(CAST(GETDATE() AS DATE)) FROM Magazyn

    END; 

# Widoki

### Obecni_Pracownicy
Widok wyświetla pracowników, którzy na daną chwile pracują w serwisie.

    CREATE VIEW Obecni_Pracownicy AS
        SELECT Osoby.*,Pracownicy.PESEL,Pracownicy.Stawka,Pracownicy.[Data zatrudnienia] FROM Osoby
        JOIN Pracownicy ON Osoby.Id = Pracownicy.Id
        WHERE [Data zwolnienia] IS NULL

### Zwolnieni_Pracownicy
Widok wyświetla pracowników, którzy już nie pracują w serwisie.

    CREATE VIEW Zwolnieni_Pracownicy AS
        SELECT Osoby.*,Pracownicy.PESEL,Pracownicy.Stawka,Pracownicy.[Data zatrudnienia], Pracownicy.[Data zwolnienia] FROM Osoby
        JOIN Pracownicy ON Osoby.Id = Pracownicy.Id
        WHERE [Data zwolnienia] IS NOT NULL

### Przyjete_Zamowienia
Widok wyświetla wszystkie zamówienia/realizacje, które zostały złożone w naszym serwisie, a nie zostały jeszcze zrealizowane.

    CREATE VIEW Przyjete_Zamowienia AS
        SELECT * FROM Zamowienia
        WHERE Stan LIKE('Przyjete')

### Zrealizowane_Zamowienia
Widok wyświetla wszystkie zamówienia/realizacje, które zostały już zrealizowane, i są gotowe do odbioru, lub zostały odebrane przez klienta.
 
    CREATE VIEW Zrealizowane_Zamowienia AS
        SELECT * FROM Zamowienia
        WHERE Stan LIKE('Zrealizowane')

### Dzisiejsze_Zamowienia
Widok wyświetla wszystkie zamówienia/realizacje, które zostały złożone w dniu dzisiejszym w naszym serwisie, a nie zostały jeszcze zrealizowane.
 
    CREATE VIEW Dzisiejsze_Zamowienia 
        AS 
        SELECT * FROM Zamowienia WHERE 
        CAST (Zamowienia.[Data przyjecia] AS DATE) = CAST(GETDATE() AS DATE)

### Dzisiejsze_Realizacje
Widok wyświetla wszystkie zamówienia/realizacje, których realizacja została zakończona w dniu dzisiejszym, i są gotowe do odbioru, lub zostały odebrane przez klienta.

    CREATE VIEW Dzisiejsze_Realizacje AS
        SELECT * FROM Zamowienia
        WHERE CAST(Zamowienia.[Data realizacji] AS DATE) = CAST(GETDATE() AS DATE)
 
### Dzisiejsze_Zuzyte_Podzespoly
Widok wyświetla wszystkie wszystkie podzespoły, które zostały zużyte dzisiaj.

    CREATE VIEW Dzisiejsze_Zuzyte_Podzespoly AS
        SELECT M.ID,M.[ID podzespolu],M.Nazwa,M.Opis FROM Magazyn_Archiwalny AS M
        WHERE CAST(M.[Data zuzycia] AS DATE) = CAST(GETDATE() AS DATE)
    

### Stan_Magazynu
Widok wyświetla obecny stan magazynu, czyt. wszystkie podzespoły gotowe do użycia.

    CREATE VIEW Stan_Magazynu AS
        SELECT * FROM Magazyn

# Funkcje

### Urzadzenia_Klienta
Funkcja zwracająca tabele urządzeń należących do klienta, zarejestrowanych w serwisie.

    CREATE FUNCTION UrzadzeniaKlienta(@id_klienta INT) 
    RETURNS @Klient TABLE(
    ID INT,
    Imie NVARCHAR(32) ,
    Nazwisko NVARCHAR(32) ,
    Email NVARCHAR(320),
    [Nr Telefonu] CHAR (9),
    Miejscowosc NVARCHAR(50),
    [ID Urzadzenia] INT,
    [Typ] NVARCHAR(15),
    [Marka] NVARCHAR(15),
    Model NVARCHAR(50) ,
    [Nr seryjny] NVARCHAR(50)
    )
    AS
    BEGIN
        IF EXISTS (SELECT * FROM Urzadzenia WHERE Urzadzenia.[ID klienta]=@id_klienta)
        BEGIN
        INSERT INTO @Klient(ID,Imie,Nazwisko,Email,[Nr Telefonu],Miejscowosc,[ID Urzadzenia],Typ,Marka,Model,[Nr seryjny])
        SELECT  Osoby.ID,Osoby.Imie,Osoby.Nazwisko,Osoby.Email,Osoby.[Nr Telefonu],Osoby.Miejscowosc,Urzadzenia.ID,Urzadzenia.Typ,Urzadzenia.Marka,Urzadzenia.Model,Urzadzenia.[Nr seryjny] 
        FROM Osoby JOIN Urzadzenia ON Urzadzenia.[ID klienta]=Osoby.ID
        WHERE [ID klienta]=@id_klienta

        END;
        RETURN 
    END

### Ranking_Pracownikow_Miesiaca
Funkcja zwracająca tabele pracowników, wraz z ilościa napraw przeprowadzonych w danym miesiącu i roku. Liczą się naprawy, w których realizacja została zakończona.

    CREATE FUNCTION Ranking_Pracownikow_Miesiaca(@id_miesiac INT,@id_rok INT) 
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


### Faktura
Funkcja zwracająca wszystkie faktury, które zostały wystawione w danym miesiącu i roku.

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

# Wyzwalacze

### Sprawdz_Czy_Naprawione
Wyzwalacz, po każdej naprawie sprawdza czy wszystkie kompenenty danego urządzenia zostały naprawione, jeśli tak to stan w tabeli zamówienia zostaje zmieniona na Zrealizowy z dzisiejszą datą.

    CREATE TRIGGER Sprawdz_Czy_Naprawione ON Naprawy
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

### Sprawdz_Poprawnosc_Faktury
Wyzwalacz, sprawdza przy dodaniu danego zamówienia do faktury zostało zrealizowane.

    CREATE TRIGGER Sprawdz_Poprawnosc_Faktury
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

### Sprawdz_Pracownika_Dostepnosc
Wyzwalacz, sprawdza czy nasz pracownik może zostać przypisany do danego zamówienia.

    CREATE TRIGGER Sprawdz_Pracownika_Dostepnosc
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

### Aktualizacja_Magazynu
Wyzwalacz, aktualizuje magazyn, jeżeli podzespołow nie bedzię już dostępnych to usuwa go z naszego magazynu.

    CREATE TRIGGER Aktualizacja_Magazynu 
    ON Magazyn
    AFTER INSERT, UPDATE, DELETE
    AS 
    BEGIN
        DELETE FROM Magazyn WHERE Ilosc <= 0 AND
        Magazyn.ID in (select Magazyn.ID from inserted);
    END
