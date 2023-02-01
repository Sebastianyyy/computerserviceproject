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


CREATE TABLE Klienci(
ID INT,
PRIMARY KEY (ID),
[Data zalozenia] Date,
FOREIGN KEY (ID) REFERENCES Osoby(ID),
)

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

CREATE TABLE Urlopy(
ID INT,
[Od kiedy] DATE,
[Do kiedy] DATE NOT NULL,
CHECK ([Od kiedy]<=[Do kiedy]),
PRIMARY KEY (ID, [Od kiedy]),
FOREIGN KEY (ID) REFERENCES Pracownicy(ID)
)

CREATE TABLE Urzadzenia(
ID INT IDENTITY(1,1),
[ID klienta] INT,
[Typ] NVARCHAR(15),
[Marka] NVARCHAR(30),
Model NVARCHAR(50) ,
[Nr seryjny] NVARCHAR(50),
[Opis] NVARCHAR(190),
PRIMARY KEY(ID),
FOREIGN KEY ([ID klienta]) REFERENCES Klienci(ID)
)

CREATE TABLE Zamowienia(
ID INT IDENTITY(1,1),
[ID klienta] INT,
[ID urzadzenia] INT,
[Data przyjecia] DATE,
[Data realizacji] DATE,
[Opis] NVARCHAR(100),
[Stan] NVARCHAR(12) DEFAULT 'Przyjete',
PRIMARY KEY(ID),
FOREIGN KEY ([ID klienta]) REFERENCES Klienci(ID),
FOREIGN KEY ([ID urzadzenia]) REFERENCES Urzadzenia(ID)
)

CREATE TABLE Naprawy(
ID INT IDENTITY(1,1),
[ID zamowienia] INT,
[ID pracownika] INT,
[Data rozpoczecia] DATE,
[Data zakonczenia] DATE,
[Stan] NVARCHAR(10) DEFAULT 'Przyjete',--Przyjete, naprawiony
[Opis naprawy] NVARCHAR(200),
PRIMARY KEY (ID),
FOREIGN KEY ([ID pracownika]) REFERENCES Pracownicy(ID),
FOREIGN KEY ([ID zamowienia]) REFERENCES Zamowienia(ID),
)

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

CREATE TABLE Magazyn(
ID INT IDENTITY(1,1),
[Nazwa] NVARCHAR(50),
[Opis] NVARCHAR(50),
[Ilosc] INT,
PRIMARY KEY(ID),
)

CREATE TABLE Magazyn_Archiwalny(
ID INT IDENTITY(1,1),
[ID podzespolu] INT,
[Nazwa] NVARCHAR(50),
[Opis] NVARCHAR(50),
[Data zuzycia] DATE,
PRIMARY KEY(ID),
)
