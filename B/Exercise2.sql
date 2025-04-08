CREATE DATABASE FamilyTreeDB;
USE FamilyTreeDB;

CREATE TABLE People (
    Person_Id INT PRIMARY KEY,
    Personal_Name VARCHAR(50),
    Family_Name VARCHAR(50),
    Gender VARCHAR(10) CHECK (Gender IN ('���', '����')),
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

-- �����:
INSERT INTO People (Person_Id, Personal_Name, Family_Name, Gender, Father_Id, Mother_Id, Spouse_Id)
VALUES
(1, '���', '�����', '���', NULL, NULL, 2),     -- ���� ������
(2, '�����', '�����', '����', NULL, NULL, NULL), -- ����� �����
(3, '��', '�����', '����', 1, 2, NULL),        -- �� �� ��� ������
(4, '�����', '�����', '���', 1, 2, NULL),       -- �� �� ��� ������
(5, '���', '���', '���', NULL, NULL, NULL);     -- ���� �����, ���� ���� �����

-- ����� 2 - ����� ��� ��� �����
UPDATE P2
SET P2.Spouse_Id = P1.Person_Id
FROM People P1
JOIN People P2 ON P1.Spouse_Id = P2.Person_Id
WHERE P2.Spouse_Id IS NULL;

-- ����� 1 - �� �����

-- ��
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT Person_Id, Father_Id, '��'
FROM People
WHERE Father_Id IS NOT NULL;

-- ��
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT Person_Id, Mother_Id, '��'
FROM People
WHERE Mother_Id IS NOT NULL;

-- �� ��� / �� ���
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT Person_Id, Spouse_Id,
       CASE WHEN Gender = '���' THEN '�� ���' ELSE '�� ���' END
FROM People
WHERE Spouse_Id IS NOT NULL;

-- ��/����
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT P1.Person_Id, P2.Person_Id,
       CASE WHEN P2.Gender = '���' THEN '��' ELSE '����' END
FROM People P1
JOIN People P2 ON (
    P1.Person_Id <> P2.Person_Id AND
    (
        (P1.Father_Id IS NOT NULL AND P1.Father_Id = P2.Father_Id)
        OR
        (P1.Mother_Id IS NOT NULL AND P1.Mother_Id = P2.Mother_Id)
    )
);

-- ��
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT Father_Id, Person_Id, '��'
FROM People
WHERE Father_Id IS NOT NULL AND Gender = '���'
UNION
SELECT Mother_Id, Person_Id, '��'
FROM People
WHERE Mother_Id IS NOT NULL AND Gender = '���';

-- ��
INSERT INTO FamilyTree (Person_Id, Relative_Id, Connection_Type)
SELECT Father_Id, Person_Id, '��'
FROM People
WHERE Father_Id IS NOT NULL AND Gender = '����'
UNION
SELECT Mother_Id, Person_Id, '��'
FROM People
WHERE Mother_Id IS NOT NULL AND Gender = '����';

-- ���� �������
SELECT * FROM People;
SELECT * FROM FamilyTree ORDER BY Person_Id;
