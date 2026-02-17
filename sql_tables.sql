DROP TABLE IF EXISTS GroupsStudents;
DROP TABLE IF EXISTS GroupsCurators;
DROP TABLE IF EXISTS Curators;
DROP TABLE IF EXISTS GroupsLectures;
DROP TABLE IF EXISTS Lectures;
DROP TABLE IF EXISTS Subjects;
DROP TABLE IF EXISTS Teachers;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Groups;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Faculties;


CREATE TABLE Faculties (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE CHECK (Name <> '')
);

CREATE TABLE Departments (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Building INTEGER NOT NULL CHECK(Building BETWEEN 1 AND 5),
    Financing REAL NOT NULL DEFAULT 0 CHECK (Financing >= 0),
    Name TEXT NOT NULL UNIQUE CHECK (Name <> ''),
    FacultyId INTEGER NOT NULL,
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
);

CREATE TABLE Groups (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE CHECK (Name <> ''),
    DepartmentId INTEGER NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1 AND 5),
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

CREATE TABLE Students(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL CHECK (Name <> ''),
    Surname TEXT NOT NULL CHECK (Surname <> ''),
    Rating INTEGER NOT NULL CHECK (Rating BETWEEN 0 AND 5)
);

CREATE TABLE Teachers (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    IsProfessor INTEGER NOT NULL DEFAULT 0,
    Name TEXT NOT NULL CHECK (Name <> ''),
    Salary REAL NOT NULL CHECK (Salary > 0),
    Surname TEXT NOT NULL CHECK (Surname <> '')
);

CREATE TABLE Subjects(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL UNIQUE CHECK (Name <> '')
);

CREATE TABLE Lectures(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Date TEXT NOT NULL,
    SubjectId INTEGER NOT NULL,
    TeacherId INTEGER NOT NULL,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

CREATE TABLE GroupsLectures(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    GroupId INTEGER NOT NULL,
    LectureId INTEGER NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);

CREATE TABLE Curators(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL CHECK (Name <> ''),
    Surname TEXT NOT NULL CHECK (Surname <> '')
);

CREATE TABLE GroupsCurators(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    CuratorId INTEGER NOT NULL,
    GroupId INTEGER NOT NULL,
    FOREIGN KEY (CuratorId) REFERENCES Curators(Id),
    FOREIGN KEY (GroupId) REFERENCES Groups(Id)
);

CREATE TABLE GroupsStudents(
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    GroupId INTEGER NOT NULL,
    StudentId INTEGER NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (StudentId) REFERENCES Students(Id)
);


INSERT INTO Faculties (Name) VALUES 
('Engineering'),
('Humanities');

INSERT INTO Departments (Building, Financing, Name, FacultyId) VALUES
(1, 750000, 'Mechanical Engineering', 1),
(2, 650000, 'Electrical Engineering', 1),
(3, 400000, 'Philosophy', 2),
(3, 350000, 'History', 2),
(4, 200000, 'Linguistics', 2);

INSERT INTO Groups (Name, DepartmentId, Year) VALUES
('M301', 1, 4),
('M302', 1, 4),
('E201', 2, 5),
('P101', 3, 3),
('H105', 4, 5);

INSERT INTO Students (Name, Surname, Rating) VALUES
('Olivia', 'Brown', 5),
('Ethan', 'White', 3),
('Sophia', 'Green', 4),
('Liam', 'Black', 5),
('Mason', 'Gray', 2),
('Emma', 'Davis', 5),
('Noah', 'Wilson', 4),
('Isabella', 'Martinez', 3),
('Lucas', 'Garcia', 4),
('Mia', 'Rodriguez', 5),
('Amelia', 'Hernandez', 3),
('Logan', 'Lopez', 4);

INSERT INTO GroupsStudents (GroupId,StudentId) VALUES
(1,1),(1,2),(1,3),(1,4),
(2,5),(2,6),(2,7),
(3,8),(3,9),
(4,10),
(5,11),(5,12);

INSERT INTO Teachers (Name, Surname, Salary, IsProfessor) VALUES
('Robert', 'Johnson', 1800, 1),
('Linda', 'Smith', 1300, 0),
('David', 'Williams', 2100, 1),
('Karen', 'Jones', 1100, 0);

INSERT INTO Subjects (Name) VALUES 
('Thermodynamics'),
('Circuit Analysis'),
('Ethics'),
('World History');

INSERT INTO Lectures (Date, SubjectId, TeacherId) VALUES
('2026-03-01',1,1),
('2026-03-01',2,2),
('2026-03-02',1,1),
('2026-03-02',2,2),
('2026-03-03',1,3),
('2026-03-03',2,4),
('2026-03-04',1,1),
('2026-03-04',3,3),
('2026-03-04',4,4),
('2026-03-05',3,1),
('2026-03-06',4,2);

INSERT INTO GroupsLectures (GroupId, LectureId) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
(2,1),(2,2),(2,3),
(3,7),(3,8),(3,9),
(4,10),
(5,11);

INSERT INTO Curators (Name, Surname) VALUES
('Anna', 'Peterson'),
('Mark', 'Evans'),
('Laura', 'Stevens');

INSERT INTO GroupsCurators (GroupId, CuratorId) VALUES
(1,1),(1,2),
(3,3);


-- TASK1
SELECT Building
FROM Departments
GROUP BY Building
HAVING SUM(Financing) > 100000;



-- TASK2
SELECT g.Name
FROM Groups g
JOIN Departments d ON g.DepartmentId = d.Id
JOIN GroupsLectures gl ON g.Id = gl.GroupId
JOIN Lectures l ON gl.LectureId = l.Id
WHERE g.Year = 5
  AND d.Name = 'Software Development'
  AND l.Date BETWEEN '2026-02-10' AND '2026-02-16'
GROUP BY g.Id, g.Name
HAVING COUNT(l.Id) > 10;



-- TASK3
SELECT g.Name
FROM Groups g
JOIN GroupsStudents gs ON g.Id = gs.GroupId
JOIN Students s ON gs.StudentId = s.Id
GROUP BY g.Id, g.Name
HAVING AVG(s.Rating) >
(
    SELECT AVG(s2.Rating)
    FROM GroupsStudents gs2
    JOIN Students s2 ON gs2.StudentId = s2.Id
    JOIN Groups g2 ON gs2.GroupId = g2.Id
    WHERE g2.Name = 'D221'
);



-- TASK4
SELECT Surname, Name
FROM Teachers
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Teachers
    WHERE IsProfessor = 1
);



-- TASK5
SELECT g.Name
FROM Groups g
JOIN GroupsCurators gc ON g.Id = gc.GroupId
GROUP BY g.Id, g.Name
HAVING COUNT(gc.CuratorId) > 1;



-- TASK6
SELECT g.Name
FROM Groups g
JOIN GroupsStudents gs ON g.Id = gs.GroupId
JOIN Students s ON gs.StudentId = s.Id
GROUP BY g.Id, g.Name
HAVING AVG(s.Rating) <
(
    SELECT MIN(avgRating)
    FROM
    (
        SELECT AVG(s2.Rating) AS avgRating
        FROM Groups g2
        JOIN GroupsStudents gs2 ON g2.Id = gs2.GroupId
        JOIN Students s2 ON gs2.StudentId = s2.Id
        WHERE g2.Year = 5
        GROUP BY g2.Id
    ) AS Sub
);



-- TASK7
SELECT f.Name
FROM Faculties f
JOIN Departments d ON f.Id = d.FacultyId
GROUP BY f.Id, f.Name
HAVING SUM(d.Financing) >
(
    SELECT SUM(d2.Financing)
    FROM Departments d2
    JOIN Faculties f2 ON d2.FacultyId = f2.Id
    WHERE f2.Name = 'Computer Science'
);



-- TASK8
WITH LectureCount AS
(
    SELECT
        sub.Id,
        sub.Name AS SubjectName,
        t.Name,
        t.Surname,
        COUNT(*) AS LectureTotal,
        RANK() OVER (PARTITION BY sub.Id ORDER BY COUNT(*) DESC) AS rnk
    FROM Lectures l
    JOIN Subjects sub ON l.SubjectId = sub.Id
    JOIN Teachers t ON l.TeacherId = t.Id
    GROUP BY sub.Id, sub.Name, t.Id, t.Name, t.Surname
)
SELECT SubjectName, Name, Surname, LectureTotal
FROM LectureCount
WHERE rnk = 1;



-- TASK9
SELECT sub.Name
FROM Subjects sub
LEFT JOIN Lectures l ON sub.Id = l.SubjectId
GROUP BY sub.Id, sub.Name
HAVING COUNT(l.Id) =
(
    SELECT MIN(cnt)
    FROM
    (
        SELECT COUNT(*) AS cnt
        FROM Subjects s2
        LEFT JOIN Lectures l2 ON s2.Id = l2.SubjectId
        GROUP BY s2.Id
    ) AS Sub
);



-- TASK10
SELECT 
    COUNT(DISTINCT gs.StudentId) AS StudentCount,
    COUNT(DISTINCT l.SubjectId) AS SubjectCount
FROM Groups g
JOIN Departments d ON g.DepartmentId = d.Id
LEFT JOIN GroupsStudents gs ON g.Id = gs.GroupId
LEFT JOIN GroupsLectures gl ON g.Id = gl.GroupId
LEFT JOIN Lectures l ON gl.LectureId = l.Id
WHERE d.Name = 'Software Development';
