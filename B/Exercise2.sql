CREATE DATABASE FamilyTreeDB;
USE FamilyTreeDB;

CREATE TABLE People (
    Person_Id INT PRIMARY KEY,
    Personal_Name VARCHAR(50),
    Family_Name VARCHAR(50),
    Gender VARCHAR(10) CHECK (Gender IN ('זכר', 'נקבה')),
    Father_Id INT,
    Mother_Id INT,
    Spouse_Id INT,
    FOREIGN KEY (Father_Id) REFERENCES People(Person_Id),
    FOREIGN KEY (Mother_Id) REFERENCES People(Person_Id),
    FOREIGN KEY (Spouse_Id) REFERENCES People(Person_Id)
);

CREATE TABLE FamilyTree (
    Person_Id INT,
    Relative_Id INT,
    Connection_Type VARCHAR(20),
    PRIMARY KEY (Person_Id, Relative_Id, Connection_Type),
    FOREIGN KEY (Person_Id) REFERENCES People(Person_Id),
    FOREIGN KEY (Relative_Id) REFERENCES People(Person_Id)
);

-- אנשים:
INSERT INTO People (Person_Id, Personal_Name, Family_Name, Gender, Father_Id, Mother_Id, Spouse_Id)
VALUES
(1, 'אבי', 'סטארק', 'זכר', NULL, NULL, 2),     -- נשוי לרונית
(2, 'רונית', 'סטארק', 'נקבה', NULL, NULL, NULL), -- צריכה השלמה
(3, 'טל', 'סטארק', 'נקבה', 1, 2, NULL),        -- בת של אבי ורונית
(4, 'דניאל', 'סטארק', 'זכר', 1, 2, NULL),       -- בן של אבי ורונית
(5, 'גיל', 'כהן', 'זכר', NULL, NULL, NULL);     -- רווק חופשי, מחפש אהבה באקסל

-- תרגיל 2 - השלמת בני זוג חסרים
UPDATE P2
SET P2.Spouse_Id = P1.Person_Id
FROM People P1
JOIN People P2 ON P1.Spouse_Id = P2.Person_Id
WHERE P2.Spouse_Id IS NULL;

-- תרגיל 1 - עץ משפחה

-- אב
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT Person_Id, Father_Id, 'אב'
FROM People
WHERE Father_Id IS NOT NULL;

-- אם
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT Person_Id, Mother_Id, 'אם'
FROM People
WHERE Mother_Id IS NOT NULL;

-- בן זוג / בת זוג
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT Person_Id, Spouse_Id,
       CASE WHEN Gender = 'זכר' THEN 'בת זוג' ELSE 'בן זוג' END
FROM People
WHERE Spouse_Id IS NOT NULL;

-- אח/אחות
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT P1.Person_Id, P2.Person_Id,
       CASE WHEN P2.Gender = 'זכר' THEN 'אח' ELSE 'אחות' END
FROM People P1
JOIN People P2 ON (
    P1.Person_Id <> P2.Person_Id AND
    (
        (P1.Father_Id IS NOT NULL AND P1.Father_Id = P2.Father_Id)
        OR
        (P1.Mother_Id IS NOT NULL AND P1.Mother_Id = P2.Mother_Id)
    )
);

-- בן
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT Father_Id, Person_Id, 'בן'
FROM People
WHERE Father_Id IS NOT NULL AND Gender = 'זכר'
UNION
SELECT Mother_Id, Person_Id, 'בן'
FROM People
WHERE Mother_Id IS NOT NULL AND Gender = 'זכר';

-- בת
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT Father_Id, Person_Id, 'בת'
FROM People
WHERE Father_Id IS NOT NULL AND Gender = 'נקבה'
UNION
SELECT Mother_Id, Person_Id, 'בת'
FROM People
WHERE Mother_Id IS NOT NULL AND Gender = 'נקבה';

-- הצגת הטבלאות
SELECT * FROM People;
SELECT * FROM FamilyTree ORDER BY Person_Id;
