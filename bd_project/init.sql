--tabele
IF OBJECT_ID('Naprawy','U') IS NOT NULL
DROP TABLE Naprawy
IF OBJECT_ID('Faktury','U') IS NOT NULL
DROP TABLE Faktury
IF OBJECT_ID('Zamowienia','U') IS NOT NULL
DROP TABLE Zamowienia
IF OBJECT_ID('Urlopy','U') IS NOT NULL
DROP TABLE Urlopy
IF OBJECT_ID('Urzadzenia','U') IS NOT NULL
DROP TABLE Urzadzenia
IF OBJECT_ID('Klienci','U') IS NOT NULL
DROP TABLE Klienci
IF OBJECT_ID('Pracownicy','U') IS NOT NULL
DROP TABLE Pracownicy
IF OBJECT_ID('Magazyn','U') IS NOT NULL
DROP TABLE Magazyn
IF OBJECT_ID('Magazyn_Archiwalny','U') IS NOT NULL
DROP TABLE Magazyn_Archiwalny
IF OBJECT_ID('Osoby','U') IS NOT NULL
DROP TABLE Osoby
--widoki
if object_id('ObecniPracownicy','v') is not null
drop view ObecniPracownicy;
if object_id('ZwolnieniPracownicy','v') is not null
drop view ZwolnieniPracownicy;
if object_id('PrzyjeteZamowienia','v') is not null
drop view PrzyjeteZamowienia;
if object_id('Zrealizowane','v') is not null
drop view Zrealizowane;
if object_id('DzisiejszeZamowienia','v') is not null
drop view DzisiejszeZamowienia;
if object_id('DzisiejszeRealizacje','v') is not null
drop view DzisiejszeRealizacje;
if object_id('DzisiejszeZuzytePodzespoly','v') is not null
drop view DzisiejszeZuzytePodzespoly;
if object_id('StanMagazynu','v') is not null
drop view StanMagazynu;
--funkcje
IF object_id(N'UrzadzeniaKlienta', N'TF') IS NOT NULL
    DROP FUNCTION UrzadzeniaKlienta
IF object_id(N'RankingPracownikowMiesiaca', N'TF') IS NOT NULL
    DROP FUNCTION RankingPracownikowMiesiaca
IF object_id(N'Faktura', N'TF') IS NOT NULL
    DROP FUNCTION Faktura
--procedury
IF OBJECT_ID('Dane_Osoby', 'P') IS NOT NULL
DROP PROC Dane_Osoby
IF OBJECT_ID('Osoba_Wyszukaj_Telefon', 'P') IS NOT NULL
DROP PROC Osoba_Wyszukaj_Telefon
IF OBJECT_ID('Osoba_Wyszukaj_Nazwisko', 'P') IS NOT NULL
DROP PROC Osoba_Wyszukaj_Nazwisko
IF OBJECT_ID('SprawdzStan', 'P') IS NOT NULL
DROP PROC SprawdzStan
IF OBJECT_ID('Napraw', 'P') IS NOT NULL
DROP PROC Napraw
IF OBJECT_ID('Zuzyj', 'P') IS NOT NULL
DROP PROC Zuzyj
IF OBJECT_ID('Dane_Klienta', 'P') IS NOT NULL
DROP PROC Dane_Klienta
IF OBJECT_ID('Zacznij_Naprawe', 'P') IS NOT NULL
DROP PROC Zacznij_Naprawe
IF OBJECT_ID('Zakoncz_Naprawe', 'P') IS NOT NULL
DROP PROC Zakoncz_Naprawe

--trigery

IF OBJECT_ID('Sprawdz_pracownika_dostepnosc','TR') IS NOT NULL
DROP TRIGGER Sprawdz_pracownika_dostepnosc
IF OBJECT_ID('Aktualizacja_magazynu','TR') IS NOT NULL
DROP TRIGGER Aktualizacja_magazynu
IF OBJECT_ID('Sprawdz_czy_naprawione','TR') IS NOT NULL
DROP TRIGGER Sprawdz_czy_naprawione
IF OBJECT_ID('Sprawdz_poprawnosc_faktury','TR') IS NOT NULL
DROP TRIGGER Sprawdz_poprawnosc_faktury