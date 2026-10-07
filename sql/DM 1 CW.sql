/* ============================================================
   SECTION 1: CREATE AND USE DATABASE
   ============================================================ */

CREATE DATABASE Serendib_Grand_Hotel;

USE Serendib_Grand_Hotel;

/* ============================================================
   SECTION 2: CREATE TABLES (in dependency order)
   ============================================================ */

   -- ---------- Strong entity: Room ----------
CREATE TABLE Room (
    Room_ID          VARCHAR(5)   NOT NULL PRIMARY KEY,
    Room_Number      VARCHAR(6)   NOT NULL,
    Floor            INT          NOT NULL,
    Price_Per_Night  DECIMAL(10,2) NOT NULL,
    Status           VARCHAR(15)  NOT NULL CHECK (Status IN ('Available','Occupied','Maintenance'))
);

-- ---------- ISA subtypes of Room (disjoint) ----------
CREATE TABLE Standard_Room (
    Room_ID        VARCHAR(5) NOT NULL PRIMARY KEY,
    Max_Occupancy  INT        NOT NULL,
    CONSTRAINT FK_StdRoom_Room FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);


CREATE TABLE Deluxe_Room (
    Room_ID      VARCHAR(5) NOT NULL PRIMARY KEY,
    Has_Balcony  VARCHAR(3) NOT NULL CHECK (Has_Balcony IN ('Yes','No')),
    CONSTRAINT FK_DlxRoom_Room FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);


CREATE TABLE Suite (
    Room_ID          VARCHAR(5) NOT NULL PRIMARY KEY,
    No_of_Bedrooms   INT        NOT NULL,
    CONSTRAINT FK_Suite_Room FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID)
);


-- ---------- Strong entity: Guest ----------
CREATE TABLE Guest (
    Guest_ID    VARCHAR(6)   NOT NULL PRIMARY KEY,
    Guest_Name  VARCHAR(50)  NOT NULL,
    NIC_No      VARCHAR(12)  NOT NULL UNIQUE,
    Address     VARCHAR(100) NOT NULL
);


-- ---------- Multivalued attribute table: Guest_Phone ----------
CREATE TABLE Guest_Phone (
    Guest_ID  VARCHAR(6) NOT NULL,
    Phone_No  VARCHAR(10) NOT NULL,
    CONSTRAINT PK_GuestPhone PRIMARY KEY (Guest_ID, Phone_No),
    CONSTRAINT FK_GuestPhone_Guest FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID)
);


-- ---------- Strong entity: Department ----------
CREATE TABLE Department (
    Department_ID    VARCHAR(4)  NOT NULL PRIMARY KEY,
    Department_Name  VARCHAR(50) NOT NULL
);


-- ---------- Multivalued attribute table: Department_Telephone ----------
CREATE TABLE Department_Telephone (
    Department_ID  VARCHAR(4) NOT NULL,
    Telephone_No   VARCHAR(10) NOT NULL,
    CONSTRAINT PK_DeptTel PRIMARY KEY (Department_ID, Telephone_No),
    CONSTRAINT FK_DeptTel_Dept FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
);


-- ---------- Strong entity: Staff ----------
CREATE TABLE Staff (
    Staff_ID       VARCHAR(6)   NOT NULL PRIMARY KEY,
    Staff_Name     VARCHAR(50)  NOT NULL,
    Age            INT          NOT NULL,
    Position       VARCHAR(30)  NOT NULL,
    Phone_No       VARCHAR(10)  NOT NULL,
    Salary         DECIMAL(10,2) NOT NULL,
    Department_ID  VARCHAR(4)   NOT NULL,
    CONSTRAINT FK_Staff_Dept FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
);


-- ---------- Weak entity: Manager ----------
CREATE TABLE Manager (
    Manager_ID     VARCHAR(6) NOT NULL PRIMARY KEY,
    Years_Worked   INT        NOT NULL,
    Staff_ID       VARCHAR(6) NOT NULL UNIQUE,
    Department_ID  VARCHAR(4) NOT NULL UNIQUE,
    CONSTRAINT FK_Manager_Staff FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
    CONSTRAINT FK_Manager_Dept FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
);


-- ---------- Strong entity: Booking ----------
CREATE TABLE Booking (
    Booking_ID       VARCHAR(6)   NOT NULL PRIMARY KEY,
    Check_in_Date    DATE         NOT NULL,
    Check_out_Date   DATE         NOT NULL,
    Total_Amount     DECIMAL(10,2) NOT NULL,
    Guest_ID         VARCHAR(6)   NOT NULL,
    Room_ID          VARCHAR(5)   NOT NULL,
    CONSTRAINT FK_Booking_Guest FOREIGN KEY (Guest_ID) REFERENCES Guest(Guest_ID),
    CONSTRAINT FK_Booking_Room FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID),
    CONSTRAINT CHK_Dates CHECK (Check_out_Date > Check_in_Date)
);


-- ---------- Strong entity: Service ----------
CREATE TABLE Service (
    Service_ID    VARCHAR(5)  NOT NULL PRIMARY KEY,
    Service_Name  VARCHAR(50) NOT NULL,
    Price         DECIMAL(8,2) NOT NULL
);


-- ---------- m:n relationship table: Booking_Service ----------
CREATE TABLE Booking_Service (
    Booking_ID  VARCHAR(6) NOT NULL,
    Service_ID  VARCHAR(5) NOT NULL,
    Quantity    INT        NOT NULL,
    CONSTRAINT PK_BookingService PRIMARY KEY (Booking_ID, Service_ID),
    CONSTRAINT FK_BS_Booking FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID),
    CONSTRAINT FK_BS_Service FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID)
);


-- ---------- Strong entity: Payment ----------
CREATE TABLE Payment (
    Payment_ID       VARCHAR(6)  NOT NULL PRIMARY KEY,
    Amount           DECIMAL(10,2) NOT NULL,
    Payment_Date     DATE        NOT NULL,
    Payment_Method   VARCHAR(20) NOT NULL CHECK (Payment_Method IN ('Cash','Card','Online')),
    Booking_ID       VARCHAR(6)  NOT NULL,
    CONSTRAINT FK_Payment_Booking FOREIGN KEY (Booking_ID) REFERENCES Booking(Booking_ID)
);


-- ---------- Strong entity: Housekeeping_Task ----------
CREATE TABLE Housekeeping_Task (
    Task_ID           VARCHAR(6)  NOT NULL PRIMARY KEY,
    Task_Description  VARCHAR(100) NOT NULL,
    Task_Date         DATE        NOT NULL,
    Status            VARCHAR(15) NOT NULL CHECK (Status IN ('Pending','Ongoing','Completed')),
    Room_ID           VARCHAR(5)  NOT NULL,
    Staff_ID          VARCHAR(6)  NOT NULL,
    CONSTRAINT FK_Task_Room FOREIGN KEY (Room_ID) REFERENCES Room(Room_ID),
    CONSTRAINT FK_Task_Staff FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID)
);


/* ============================================================
   SECTION 3: INSERT DATA (10+ records per table)
   ============================================================ */

-- ---------- Room (30 records: 10 Standard, 10 Deluxe, 10 Suite) ----------
INSERT INTO Room VALUES
('R001','101',1,8000.00,'Available'), ('R002','102',1,8000.00,'Available'),
('R003','103',1,8500.00,'Occupied'),  ('R004','104',1,8500.00,'Available'),
('R005','105',2,9000.00,'Available'), ('R006','106',2,9000.00,'Occupied'),
('R007','107',2,9200.00,'Available'), ('R008','108',2,9200.00,'Maintenance'),
('R009','109',2,9500.00,'Available'), ('R010','110',2,9500.00,'Available'),
('R011','201',3,12000.00,'Available'),('R012','202',3,12000.00,'Occupied'),
('R013','203',3,12500.00,'Available'),('R014','204',3,12500.00,'Available'),
('R015','205',3,13000.00,'Available'),('R016','206',4,13500.00,'Occupied'),
('R017','207',4,14000.00,'Available'),('R018','208',4,14000.00,'Available'),
('R019','209',4,14500.00,'Available'),('R020','210',4,15000.00,'Occupied'),
('R021','301',5,20000.00,'Available'),('R022','302',5,21000.00,'Occupied'),
('R023','303',5,22000.00,'Available'),('R024','304',5,23000.00,'Available'),
('R025','305',5,24000.00,'Available'),('R026','306',5,25000.00,'Available'),
('R027','401',6,26000.00,'Occupied'), ('R028','402',6,26000.00,'Available'),
('R029','403',6,27000.00,'Available'),('R030','404',6,28000.00,'Available');


INSERT INTO Standard_Room VALUES
('R001',2),('R002',2),('R003',3),('R004',2),('R005',2),
('R006',3),('R007',2),('R008',2),('R009',3),('R010',2);


INSERT INTO Deluxe_Room VALUES
('R011','Yes'),('R012','Yes'),('R013','No'),('R014','Yes'),('R015','Yes'),
('R016','No'),('R017','Yes'),('R018','Yes'),('R019','No'),('R020','Yes');


INSERT INTO Suite VALUES
('R021',1),('R022',2),('R023',1),('R024',2),('R025',1),
('R026',2),('R027',1),('R028',2),('R029',1),('R030',2);


-- ---------- Guest (12 records) ----------
INSERT INTO Guest VALUES
('G001','Ashan Perera','891234567V','Colombo'),
('G002','Nimali Fernando','925678901V','Kandy'),
('G003','Ruwantha Silva','887654321V','Galle'),
('G004','Dilrukshi Jayawardena','934567890V','Negombo'),
('G005','Chaminda Rathnayake','199012345678','Kurunegala'),
('G006','Sanduni Wickrama','200145678912','Matara'),
('G007','Ishara Gunasekara','913456789V','Jaffna'),
('G008','Buddhika Kariyawasam','856789012V','Anuradhapura'),
('G009','Tharaka Wijesundara','199845612378','Kalutara'),
('G010','Menaka Abeywardena','928765432V','Batticaloa'),
('G011','Sathya Ranasinghe','200098765432','Gampaha'),
('G012','Nadeeka Herath','887123456V','Ratnapura');


-- ---------- Guest_Phone (14 records) ----------
INSERT INTO Guest_Phone VALUES
('G001','0711234501'),('G001','0711234502'),('G002','0712234502'),
('G003','0713234503'),('G004','0714234504'),('G005','0715234505'),
('G005','0715234506'),('G006','0716234506'),('G007','0717234507'),
('G008','0718234508'),('G009','0719234509'),('G010','0710234510'),
('G011','0711234511'),('G012','0712234512');


-- ---------- Department (10 records) ----------
INSERT INTO Department VALUES
('D01','Front Office'),('D02','Housekeeping'),('D03','Food and Beverage'),
('D04','Kitchen'),('D05','Maintenance'),('D06','Security'),
('D07','Human Resources'),('D08','Finance'),('D09','Sales and Marketing'),
('D10','Information Technology');


-- ---------- Department_Telephone (12 records) ----------
INSERT INTO Department_Telephone VALUES
('D01','0112345001'),('D01','0112345002'),('D02','0112345010'),
('D03','0112345020'),('D04','0112345030'),('D05','0112345040'),
('D06','0112345050'),('D07','0112345060'),('D08','0112345070'),
('D09','0112345080'),('D09','0112345081'),('D10','0112345090');


-- ---------- Staff (20 records) ----------
INSERT INTO Staff VALUES
('S001','Kasun Perera',34,'Front Office Manager','0771111001',85000.00,'D01'),
('S002','Nadeesha Silva',28,'Receptionist','0771111002',55000.00,'D01'),
('S003','Ruwan Fernando',40,'Housekeeping Supervisor','0771111003',70000.00,'D02'),
('S004','Chamari Jayasinghe',30,'Room Attendant','0771111004',45000.00,'D02'),
('S005','Dinesh Wickramasinghe',45,'F and B Manager','0771111005',90000.00,'D03'),
('S006','Sanduni Rathnayake',26,'Waiter','0771111006',40000.00,'D03'),
('S007','Malinda Gunawardena',38,'Head Chef','0771111007',95000.00,'D04'),
('S008','Amaya Kumari',27,'Cook','0771111008',48000.00,'D04'),
('S009','Nuwan Bandara',42,'Maintenance Manager','0771111009',80000.00,'D05'),
('S010','Chathura De Silva',33,'Technician','0771111010',50000.00,'D05'),
('S011','Priyantha Kumara',46,'Security Manager','0771111011',75000.00,'D06'),
('S012','Lakshan Peris',29,'Security Guard','0771111012',42000.00,'D06'),
('S013','Harshani Wijesinghe',35,'HR Manager','0771111013',88000.00,'D07'),
('S014','Tharindu Madushanka',31,'HR Executive','0771111014',55000.00,'D07'),
('S015','Iresha Abeysekara',39,'Finance Manager','0771111015',92000.00,'D08'),
('S016','Roshan Dissanayake',30,'Accountant','0771111016',60000.00,'D08'),
('S017','Sachini Pathirana',32,'Sales Manager','0771111017',87000.00,'D09'),
('S018','Kavindu Rajapaksha',28,'Marketing Executive','0771111018',52000.00,'D09'),
('S019','Manoj Senanayake',41,'IT Manager','0771111019',95000.00,'D10'),
('S020','Yohan Fonseka',27,'IT Support','0771111020',50000.00,'D10');


-- ---------- Manager (10 records - one per department) ----------
INSERT INTO Manager VALUES
('M001',5,'S001','D01'), ('M002',7,'S003','D02'), ('M003',10,'S005','D03'),
('M004',8,'S007','D04'), ('M005',6,'S009','D05'), ('M006',9,'S011','D06'),
('M007',4,'S013','D07'), ('M008',11,'S015','D08'),('M009',3,'S017','D09'),
('M010',6,'S019','D10');


-- ---------- Booking (15 records) ----------
INSERT INTO Booking VALUES
('B001','2026-08-01','2026-08-03',16000.00,'G001','R001'),
('B002','2026-08-02','2026-08-05',36000.00,'G002','R012'),
('B003','2026-08-03','2026-08-06',63000.00,'G003','R022'),
('B004','2026-08-04','2026-08-05',8500.00,'G004','R003'),
('B005','2026-08-05','2026-08-08',40500.00,'G005','R016'),
('B006','2026-08-06','2026-08-07',9000.00,'G006','R006'),
('B007','2026-08-07','2026-08-10',45000.00,'G007','R020'),
('B008','2026-08-08','2026-08-11',78000.00,'G008','R027'),
('B009','2026-08-09','2026-08-10',9200.00,'G009','R008'),
('B010','2026-08-10','2026-08-12',24000.00,'G010','R011'),
('B011','2026-08-11','2026-08-14',66000.00,'G011','R023'),
('B012','2026-08-12','2026-08-13',8000.00,'G012','R002'),
('B013','2026-09-01','2026-09-04',42000.00,'G001','R017'),
('B014','2026-09-02','2026-09-03',9500.00,'G003','R009'),
('B015','2026-09-03','2026-09-06',81000.00,'G005','R029');


-- ---------- Service (10 records) ----------
INSERT INTO Service VALUES
('SV01','Room Service',2500.00),('SV02','Laundry',1500.00),
('SV03','Spa Treatment',6000.00),('SV04','Airport Pickup',4000.00),
('SV05','Gym Access',1000.00),('SV06','Mini Bar',2000.00),
('SV07','Extra Bed',3000.00),('SV08','Late Checkout',2500.00),
('SV09','Breakfast Buffet',1800.00),('SV10','Car Parking',500.00);


-- ---------- Booking_Service (14 records) ----------
INSERT INTO Booking_Service VALUES
('B001','SV01',2),('B001','SV09',2),('B002','SV02',1),('B002','SV06',1),
('B003','SV03',1),('B003','SV04',1),('B004','SV01',1),('B005','SV07',1),
('B005','SV09',3),('B006','SV06',2),('B007','SV03',2),('B008','SV04',1),
('B008','SV08',1),('B010','SV09',2);


-- ---------- Payment (19 records) ----------
INSERT INTO Payment VALUES
('P001','8000.00','2026-08-01','Cash','B001'),
('P002','8000.00','2026-08-03','Card','B001'),
('P003','36000.00','2026-08-02','Card','B002'),
('P004','30000.00','2026-08-03','Online','B003'),
('P005','33000.00','2026-08-06','Card','B003'),
('P006','8500.00','2026-08-04','Cash','B004'),
('P007','20000.00','2026-08-05','Card','B005'),
('P008','20500.00','2026-08-08','Cash','B005'),
('P009','9000.00','2026-08-06','Cash','B006'),
('P010','45000.00','2026-08-07','Online','B007'),
('P011','40000.00','2026-08-08','Card','B008'),
('P012','38000.00','2026-08-11','Cash','B008'),
('P013','9200.00','2026-08-09','Card','B009'),
('P014','24000.00','2026-08-10','Online','B010'),
('P015','66000.00','2026-08-11','Card','B011'),
('P016','8000.00','2026-08-12','Cash','B012'),
('P017','42000.00','2026-09-01','Card','B013'),
('P018','9500.00','2026-09-02','Cash','B014'),
('P019','81000.00','2026-09-03','Online','B015');


-- ---------- Housekeeping_Task (12 records) ----------
INSERT INTO Housekeeping_Task VALUES
('T001','Clean and prepare room','2026-08-01','Completed','R001','S004'),
('T002','Restock mini bar','2026-08-02','Completed','R012','S004'),
('T003','Deep clean bathroom','2026-08-03','Ongoing','R022','S003'),
('T004','Change bedsheets','2026-08-04','Completed','R003','S004'),
('T005','Fix air conditioning','2026-08-05','Completed','R016','S010'),
('T006','Clean carpet','2026-08-06','Pending','R006','S004'),
('T007','Repair shower','2026-08-07','Ongoing','R020','S010'),
('T008','General cleaning','2026-08-08','Completed','R027','S003'),
('T009','Replace light bulb','2026-08-09','Completed','R008','S010'),
('T010','Vacuum room','2026-08-10','Pending','R011','S004'),
('T011','Clean pool view suite','2026-08-11','Ongoing','R023','S003'),
('T012','Inspect minibar','2026-08-12','Completed','R002','S004');



SELECT * FROM Room;
SELECT * FROM Standard_Room;
SELECT * FROM Deluxe_Room;
SELECT * FROM Suite;
SELECT * FROM Guest;
SELECT * FROM Guest_Phone;
SELECT * FROM Department;
SELECT * FROM Department_Telephone;
SELECT * FROM Staff;
SELECT * FROM Manager;
SELECT * FROM Booking;
SELECT * FROM Service;
SELECT * FROM Booking_Service;
SELECT * FROM Payment;
SELECT * FROM Housekeeping_Task;


/* ============================================================
   SECTION 4: SQL SELECT QUERIES (5 frequently asked questions)
   ============================================================ */

-- Q1: Display all rooms that are currently Available
SELECT Room_ID, Room_Number, Floor, Price_Per_Night
FROM Room
WHERE Status = 'Available';


-- Q2: Display staff earning a salary greater than 80000
SELECT Staff_Name, Position, Salary
FROM Staff
WHERE Salary > 80000;


-- Q3: Display upcoming bookings (check-in date after 2026-08-31)
SELECT Booking_ID, Check_in_Date, Check_out_Date, Total_Amount
FROM Booking
WHERE Check_in_Date > '2026-08-31';


-- Q4: Display housekeeping tasks that are still Pending
SELECT Task_ID, Task_Description, Task_Date, Room_ID
FROM Housekeeping_Task
WHERE Status = 'Pending';


-- Q5: Display guest details combined with their phone numbers
SELECT Guest.Guest_ID, Guest.Guest_Name, Guest.Address, Guest_Phone.Phone_No
FROM Guest, Guest_Phone
WHERE Guest.Guest_ID = Guest_Phone.Guest_ID;


/* ============================================================
   SECTION 5: ADVANCED SQL QUERIES (GROUP BY / ORDER BY / HAVING)
   ============================================================ */

-- A1: Number of staff working in each department
SELECT Department.Department_Name, COUNT(Staff.Staff_ID) AS Number_Of_Staff
FROM Department, Staff
WHERE Department.Department_ID = Staff.Department_ID
GROUP BY Department.Department_Name;


-- A2: Total salary paid in each department
SELECT Department.Department_Name, SUM(Staff.Salary) AS Total_Salary
FROM Department, Staff
WHERE Department.Department_ID = Staff.Department_ID
GROUP BY Department.Department_Name;


-- A3: Departments with a total salary greater than 130000, ordered descending
SELECT Department.Department_Name, SUM(Staff.Salary) AS Total_Salary
FROM Department, Staff
WHERE Department.Department_ID = Staff.Department_ID
GROUP BY Department.Department_Name
HAVING SUM(Staff.Salary) > 130000
ORDER BY SUM(Staff.Salary) DESC;


-- A4: Total revenue generated by each room, ordered by revenue descending
SELECT Room_ID, SUM(Total_Amount) AS Total_Revenue
FROM Booking
GROUP BY Room_ID
ORDER BY Total_Revenue DESC;


-- A5: Guests who have made more than one booking
SELECT Guest_ID, COUNT(Booking_ID) AS Number_Of_Bookings
FROM Booking
GROUP BY Guest_ID
HAVING COUNT(Booking_ID) > 1;


/* ============================================================
   SECTION 6: JOIN QUERIES (3 table-joining scenarios)
   ============================================================ */

-- J1: Join Department, Manager and Staff to show each department's manager
SELECT Department.Department_Name, Staff.Staff_Name AS Manager_Name, Manager.Years_Worked
FROM (Department INNER JOIN Manager ON Department.Department_ID = Manager.Department_ID)
INNER JOIN Staff ON Manager.Staff_ID = Staff.Staff_ID
ORDER BY Department.Department_Name;


-- J2: Join Guest, Booking and Room to show who booked which room and when
SELECT Guest.Guest_Name, Room.Room_Number, Booking.Check_in_Date, Booking.Check_out_Date
FROM (Guest INNER JOIN Booking ON Guest.Guest_ID = Booking.Guest_ID)
INNER JOIN Room ON Booking.Room_ID = Room.Room_ID
ORDER BY Booking.Check_in_Date;


-- J3: Join Booking, Booking_Service and Service to show services used per booking
SELECT Booking.Booking_ID, Service.Service_Name, Booking_Service.Quantity
FROM (Booking INNER JOIN Booking_Service ON Booking.Booking_ID = Booking_Service.Booking_ID)
INNER JOIN Service ON Booking_Service.Service_ID = Service.Service_ID
ORDER BY Booking.Booking_ID;


/* ============================================================
   SECTION 7: USER LEVELS AND PERMISSIONS
   ============================================================ */

-- 1) Owner of the hotel - full control over the entire database
CREATE USER Vajira FOR LOGIN Owner;
GRANT CONTROL TO Vajira;


-- 2) IT Manager who created and maintains the database - full control
CREATE USER Manoj FOR LOGIN ITManager;
GRANT CONTROL TO Manoj;


-- 3) HR Manager - full access limited to HR-related tables only
CREATE USER Harshani FOR LOGIN HRManager;
GRANT ALL ON Staff TO Harshani;
GRANT ALL ON Department TO Harshani;
GRANT ALL ON Department_Telephone TO Harshani;
GRANT ALL ON Manager TO Harshani;


-- 4) Front Office Manager - full access to guest and booking related data
CREATE USER Kasun FOR LOGIN FrontOfficeManager;
GRANT ALL ON Guest TO Kasun;
GRANT ALL ON Guest_Phone TO Kasun;
GRANT ALL ON Booking TO Kasun;
GRANT ALL ON Payment TO Kasun;


-- 5) Housekeeping Supervisor - full access to room and task related data
CREATE USER Ruwan FOR LOGIN HousekeepingSupervisor;
GRANT ALL ON Room TO Ruwan;
GRANT ALL ON Standard_Room TO Ruwan;
GRANT ALL ON Deluxe_Room TO Ruwan;
GRANT ALL ON Suite TO Ruwan;
GRANT ALL ON Housekeeping_Task TO Ruwan;


-- 6) Finance Manager - full access to payment records for reporting
CREATE USER Iresha FOR LOGIN FinanceManager;
GRANT ALL ON Payment TO Iresha;
GRANT SELECT ON Booking TO Iresha;


-- 7) Receptionist - view-only access to check room availability
CREATE USER Nadeesha FOR LOGIN Receptionist;
GRANT SELECT ON Room TO Nadeesha;
GRANT SELECT ON Booking TO Nadeesha;

