-- Question 1 
    SELECT G.pseudo AS "Nom_du_groupe", A.pseudo, A.nom, A.prenom
        FROM Artiste AS A
        JOIN Etre_membre_de ON A1.numArtiste = Etre_membre_de.numArtiste 
        JOIN Artiste AS G ON G.numArtiste = Etre_membre_de.numGroupe
    -- Autre méthode 
    FROM Artiste AS A, Artiste AS G, Etre_membrede as EMD 
        WHERE A.numAr = EMD.mumA
        AND G.numAR = EMD.numGr

-- Question 2 
    CREATE OR REPLACE VIEW vue_artiste AS (
        SELECT A.nom, A.prenom, A.pseudo 
        FROM Artiste AS A
        WHERE A.nom IS NOT NULL)

    -- Correction
    CREATE VIEW vue_artiste (numAr, nom, prénom, pseudo) AS
        SELECT A.pseudo, A.nom, A.prenom, A.numar
        FROM Artiste AS A, Etre_membre_de AS EMD
        WHERE A.numAr = EMD.numAR

-- Question 3 
    CREATE OR REPLACE VIEW vue_groupe AS (
        SELECT A.nom, A.prenom, A.pseudo 
        FROM Artiste AS A
        WHERE A.nom IS  NULL)
    
    -- Correction
    CREATE VIEW vue_groupe (numGroup, nomGroup) AS
        SELECT  EMD.numAr, EMD.pseudo
        FROM Artiste AS A, Etre_membre_de AS EMD
        WHERE A.numAr = EMD.numGr


-- Question 4
    SELECT G.pseudo AS "Nom_du_groupe", A.pseudo, A.nom, A.prenom
        FROM vue_artiste AS A, vue_groupe AS G, etre_membre_de AS EMD
        WHERE A.numAr = EMD.numAr
        AND G.numGR = EMD.numGr
    -- C'est bon 

-- Question 5
    SELECT titre 
        FROM Chanson
        JOIN Contribuer_a AS C ON C.numCh = Chanson.numCh
        JOIN vue_artiste ON vue_artiste.numAr = C.numAr
        JOIN Etre_membre_DE AS EMD ON EMD.numAr = vue_artiste.numAR
        JOIN vue_groupe ON vue.groupe = EMD.numGr
        WHERE vue_groupe.pseudo = "Beatles"
            AND C.role = "Interprete"
    -- Correction 
        SELECT Titre FROM Chanson as C
            JOIN contribuer_à AS CA ON CA.numCh = C.numCH
            JOIN vue_groupe AS VG ON VG.numGroupe = CA.numAR
            WHERE nomgroupe = "Les Beatles"
                AND role = "interprete"
    
-- Question 6
    SELECT Album.titre FROM Album
        JOIN Se_Compose_de AS SCD ON SCD.numAl = Album.numAl
        JOIN Chanson ON Chanson.NumCh = SCD.NumCh
        JOIN Contribuer_a AS C ON C.numCh = Chanson.numCh
        JOIN vue_artiste ON vue_artiste.numAr = C.numAr
        JOIN Etre_membre_DE AS EMD ON EMD.numAr = vue_artiste.numAR
        JOIN vue_groupe ON vue.groupe = EMD.numGr
        WHERE vue_groupe.pseudo != "Beatles"
            AND vue_artiste.nom = "Lennon"
            AND vue_artiste.prenom = "John"

    -- Correction 
    SELECT count(Al.title) FROM Album AS Al
    JOIN se composer de AS SCD ON Al.numAl = SCD.numAl
    JOIN Chanson AS C ON C.numCh=SCD.Ch
    JOIN Contribuer a AS CB ON CB.numCh = C.numCH
    JOIN vue_artiste AS VA ON VA.numAr = CB.numAr
    WHERE nom="Lennon" AND prenom="John"

-- Question 7

    -- Correction 
    il faudrait creer une vue qui relie les album au artiste 
    CREATE VIEW chanson_album AS 
        SELECT numAlbum, Al.titre AS "Titre album",
            date sortie, C.numChansom, C.titre AS "titre chanson", durée
        FROM Album as Al, Chanson AS C, se composer de AS SCD
        WHERE C.numCh = SCD.NumCh
        AND Al.numAl = SCD.numAl

    -- La request devient
    SELECT count(titre album)
    FROM vue_chanson_album AS VACUUM
    JOIN Contribue a AS CA ON CA.numC = VCA.numCh
    JOIN Vue_artiste AS VA ON VA.numAr = VAC.NumAr
    WHERE nom="Lennon" AND "prenom="john"