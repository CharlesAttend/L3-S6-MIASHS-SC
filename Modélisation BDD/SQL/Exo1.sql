CREATE TABLE Client (
    NumClient INTEGer PRIMARY KEY,
    Nom VARCHAR(100) NOTNULL,
    Prénom VARCHAR(100) NOTNULL,
    Adresse VARCHAR(100),
    CP INTEGER,
    Ville VARCHAR(100),
);

CREATE TABLE Photocopieur (
  NumSérie integer PRIMARY KEY,
    NumClient INTEGER REFERENCES Client,
    Marque varchar(200),
    Modèle VARCHAR(200),
    MiseEnService date,
);

CREATE TABLE DateIntervention (
  DateIntervention DATE PRIMARY KEY
);

CREATE table Technicien (
  Matricule INTEGER PRIMARY KEY,
    Nom VARCHAR(200) NOTNULL, 
    Prénom VARCHAR(200) NOTNULL,
);

create table Intervention (
    DateIntervention DATE REFERENCES DateIntervention
    Matricule integer references Technicien,
    NumSérie integer REFERENCES Photocopieur,
    Heure DATE,
    PRIMARY KEY (DateIntervention, Matricule, NumSérie)
);