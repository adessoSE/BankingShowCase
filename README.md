# BankingShowCase

## Beschreibung des Projektes
Im Rahmen des Projekts "Banking UseCase" sollen Lösungsansätze aus dem Bereich "Big Data" und Methoden aus dem Bereich "Machine Learning"(ML) und "Deep Learning" (DL) anhand zwei konkreter Anwendungsfälle umgesetzt werden. Bei den Anwendungsfällen handelt es sich um reale Probleme aus dem Bankensektor, welche mit Hilfe von "BigData"- und "ML/DL"-Technologien effizienter gelöst werden können.

## Installation und Quick Start (Lokal)

Das ist eine Angular 7 Application zur Eingabe von Credit Scoring Daten und zum Speichern in eine MySQL Datenbank.

Das [downloaden und installieren von Node.js](https://nodejs.org/en/download/) ist zum Starten der Application erforderlich.

  Git Repository Klonen:

```bash
$ git clone https://github.com/adessoAG/BankingShowCase
```  

  Dependencies Installieren:

```bash
$ npm install
```

  MySQL DB Config anpassen unter ./src/app.js. Lokale Datenbank siehe hier: 

```js
  const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'bankingshowcase'
});  
```

  Für das Aufsetzen einer lokalen MySQL Datenbank empfehle ich xampp.

  Server Starten:

```bash
$ cd src/
```

```bash
$ node app.js
```

  Angular App starten (im root Verzeichnis):

```bash
$ ng serve
```

  Die App ist anschließend unter http://localhost:4200/ erreichbar.

## Features

  * Credit Scoring
