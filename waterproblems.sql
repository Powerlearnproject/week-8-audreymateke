CREATE TABLE Communities (
  CommunityID INT PRIMARY KEY,
  CommunityName VARCHAR(255),
  Location VARCHAR(255)
);

CREATE TABLE WaterSources (
  WaterSourceID INT PRIMARY KEY,
  WaterSourceName VARCHAR(255),
  Type VARCHAR(10),
  CommunityID INT,
  FOREIGN KEY (CommunityID) REFERENCES Communities(CommunityID)
);

CREATE TABLE WaterQuality (
  WaterQualityID INT PRIMARY KEY,
  WaterSourceID INT,
  Parameter VARCHAR(20),
  Value DECIMAL(5,2),
  FOREIGN KEY (WaterSourceID) REFERENCES WaterSources(WaterSourceID)
);

CREATE TABLE Households (
  HouseholdID INT PRIMARY KEY,
  CommunityID INT,
  NumberOfMembers INT,
  FOREIGN KEY (CommunityID) REFERENCES Communities(CommunityID)
);

CREATE TABLE WaterAccess (
  WaterAccessID INT PRIMARY KEY,
  HouseholdID INT,
  WaterSourceID INT,
  DistanceToWaterSource DECIMAL(5,2),
  FOREIGN KEY (HouseholdID) REFERENCES Households(HouseholdID),
  FOREIGN KEY (WaterSourceID) REFERENCES WaterSources(WaterSourceID)
);
INSERT INTO Communities (CommunityID, CommunityName, Location)
VALUES
(1, 'Ruralville', 'Rural'),
(2, 'Hilltop', 'Mountainous'),
(3, 'Lakeside', 'Coastal'),
(4, 'Desertview', 'Desert'),
(5, 'Forestedge', 'Forest');

INSERT INTO WaterSources (WaterSourceID, WaterSourceName, Type, CommunityID)
VALUES
(1, 'Well 1', 'Well', 1),
(2, 'River 1', 'River', 1),
(3, 'Well 2', 'Well', 2),
(4, 'Spring 1', 'Spring', 2),
(5, 'Lake 1', 'Lake', 3),
(6, 'Well 3', 'Well', 3),
(7, 'River 2', 'River', 4),
(8, 'Well 4', 'Well', 4),
(9, 'Spring 2', 'Spring', 5),
(10, 'Stream 1', 'Stream', 5);

INSERT INTO WaterQuality (WaterQualityID, WaterSourceID, Parameter, Value)
VALUES
(1, 1, 'pH', 7.2),
(2, 1, 'Turbidity', 1.5),
(3, 2, 'pH', 7.5),
(4, 2, 'Turbidity', 2.0),
(5, 3, 'pH', 7.0),
(6, 3, 'Turbidity', 1.0),
(7, 4, 'pH', 7.8),
(8, 4, 'Turbidity', 2.5),
(9, 5, 'pH', 7.3),
(10, 5, 'Turbidity', 1.8),
(11, 6, 'pH', 7.1),
(12, 6, 'Turbidity', 1.2),
(13, 7, 'pH', 7.6),
(14, 7, 'Turbidity', 2.2),
(15, 8, 'pH', 7.4),
(16, 8, 'Turbidity', 1.6),
(17, 9, 'pH', 7.9),
(18, 9, 'Turbidity', 2.8),
(19, 10, 'pH', 7.7),
(20, 10, 'Turbidity', 2.0);

INSERT INTO Households (HouseholdID, CommunityID, NumberOfMembers)
VALUES
(1, 1, 4),
(2, 1, 3),
(3, 1, 5),
(4, 2, 2),
(5, 2, 4),
(6, 2, 3),
(7, 3, 5),
(8, 3, 4),
(9, 3, 2),
(10, 4, 3),
(11, 4, 5),
(12, 4, 4),
(13, 5, 2),
(14, 5, 3),
(15, 5, 5),
(16, 1, 4),
(17, 1, 3),
(18, 2, 5),
(19, 2, 4),
(20, 3, 3),
(21, 3, 2),
(22, 4, 5),
(23, 4, 4),
(24, 5, 3),
(25, 5, 2),
(26, 1, 4),
(27, 1, 3),
(28, 2, 5),
(29, 2, 4),
(30, 3, 3),
(31, 3, 2),
(32, 4, 5),
(33, 4, 4),
(34, 5, 3),
(35, 5, 2),
(36, 1, 4),
(37, 1, 3),
(38, 2, 5),
(39, 2, 4),
(40, 3, 3),
(41, 3, 2),
(42, 4, 5),
(43, 4, 4),
(44, 5, 3),
(45, 5, 6);

SELECT c.CommunityName, COUNT(wa.HouseholdID) AS NumHouseholdsWithAccess
FROM WaterAccess wa
JOIN Households h ON wa.HouseholdID = h.HouseholdID
JOIN Communities c ON h.CommunityID = c.CommunityID
WHERE wa.DistanceToWaterSource < 1 AND wa.WaterSourceID IN (
  SELECT ws.WaterSourceID
  FROM WaterSources ws
  JOIN WaterQuality wq ON ws.WaterSourceID = wq.WaterSourceID
  WHERE wq.Parameter = 'pH' AND wq.Value BETWEEN 6.5 AND 8.5
)
GROUP BY c.CommunityName;

SELECT c.CommunityName, AVG(wa.DistanceToWaterSource) AS AvgDistance
FROM WaterAccess wa
JOIN Households h ON wa.HouseholdID = h.HouseholdID
JOIN Communities c ON h.CommunityID = c.CommunityID
GROUP BY c.CommunityName;

SELECT COUNT(h.HouseholdID) AS NumHouseholdsWithoutAccess
FROM Households h
LEFT JOIN WaterAccess wa ON h.HouseholdID = wa.HouseholdID
WHERE wa.HouseholdID IS NULL;