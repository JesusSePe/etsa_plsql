ALTER SESSION SET NLS_DATE_FORMAT='dd/mm/yyyy';
DROP TABLE Order2;
DROP TABLE Office;
DROP TABLE Supplier;
DROP TABLE Customer;
DROP TABLE Product;
DROP TABLE Users;

CREATE TABLE Supplier
  (Supplier_Code	NUMBER(5),
   Supplier_Name	VARCHAR2(50),
   HireDate   DATE,
   Sales_Objective  NUMBER(9,2),
   Real_Sales	NUMBER(9,2),
   Boss_code	NUMBER(5),
   Constraint Supplier_Pk PRIMARY KEY (Supplier_Code));
   
  INSERT INTO Supplier 
   VALUES(10,'MARTINEZ RODRIGUEZ, PEPE',TO_DATE('10/10/1950','dd/mm/yyyy'),20000,12000,null);
   
  INSERT INTO Supplier
   VALUES(20,'LOPEZ LOPEZ, MARIA',TO_DATE('14/07/1960','dd/mm/yyyy'),15000,10000,10);
   
  INSERT INTO Supplier
   VALUES(30,'MARIN LOPEZ, ROSA',TO_DATE('24/06/1970','dd/mm/yyyy'),12000,10000,10);
   
  INSERT INTO Supplier 
   VALUES(40,'ROSILLO ROSILLO, MARTOS',TO_DATE('24/06/1975','dd/mm/yyyy'),10000,8000,Null);
   
  INSERT INTO Supplier 
   VALUES(50,'NAVARRO GARCIA, ALBERTO',TO_DATE('04/03/1965','dd/mm/yyyy'),20000,12000,20);
   
  INSERT INTO Supplier
   VALUES(60,'PEREZ LA MATA, OSCAR',TO_DATE('01/06/1985','dd/mm/yyyy'),10000,8000,20);
   
  INSERT INTO Supplier
   VALUES(70,'RUIZ MORA,BEATRIZ',TO_DATE('11/12/1955','dd/mm/yyyy'),20000,12000,null);
 
  INSERT INTO Supplier
   VALUES(80,'MARTOS GARCIA, ORLANDO',TO_DATE('12/09/1958','dd/mm/yyyy'),20000,12000,null);


CREATE TABLE Office
 (Code_Office VARCHAR2(10),
  City VARCHAR2(30),
  Province VARCHAR2(20),
  Office_Objective NUMBER(9,2),
  Office_Sales NUMBER(9,2),
  Office_Director NUMBER(5),
  CONSTRAINT Office_Pk PRIMARY KEY (Code_Office),
  CONSTRAINT Office_Supplier_fk FOREIGN KEY (Office_Director) REFERENCES Supplier (Supplier_Code));

  INSERT INTO Office VALUES (Upper('Ofco1'),'CORNELLA DE LLOBREGAT','BARCELONA',300000,2000,10);
  INSERT INTO Office VALUES (Upper('Ofes1'),'ESPLUGUES DE LLOBREGAT','BARCELONA',2000,1000,40);
  INSERT INTO Office VALUES (Upper('Ofho1'),'HOSPITALET DE LLOBREGAT','BARCELONA',1900,100,40);
  INSERT INTO Office VALUES (Upper('Ofmo1'),'MOSTOLES','MADRID',40000,33200,40);
  INSERT INTO Office VALUES (UPPER('OFVI1'),'VILLACAÑAS','TOLEDO',20000,4000,null);

Create Table Customer
  (Customer_Code	NUMBER(9),
   Customer_Name	VARCHAR2(30),
   Customer_Address VARCHAR2(30),
   Customer_CP	VARCHAR2(5),
   Born_Date DATE,
   Email VARCHAR2(30),
   Constraint Customer_Pk PRIMARY KEY (Customer_Code));

  INSERT INTO Customer
    VALUES (10,UPPER('AA. Investigacion'),UPPER('AV. DEL SOL, 4'),'43221',TO_DATE('09/08/1970','dd/mm/yyyy'),'aainvest@gmail.com');

  INSERT INTO Customer
    VALUES (11,UPPER('Chen Associates'),UPPER('NEW YORK, 198'),'22321',TO_DATE('09/03/1960','dd/mm/yyyy'),'chen@hotmail.com');

  INSERT INTO Customer
    VALUES (12,UPPER('JPC Inc.'),UPPER('C/. MARIA DEL PI, 19'),'08940',TO_DATE('12/11/1965','dd/mm/yyyy'),'JPC@gmail.com');

  INSERT INTO Customer
    VALUES (13,UPPER('Todo Ordenadores'),UPPER('Polígono, nave 2'),'08940',null,null);

  INSERT INTO Customer
    VALUES (14,UPPER('System S.A.'),UPPER('Polígono, nave 24'),'08940',TO_DATE('17/04/1980','dd/mm/yyyy'),'SYSTEM@gmail.com');

CREATE TABLE Product	
  (Product_Code VARCHAR2(8),
   Description  	VARCHAR2(40),
   Prize		NUMBER(7,2),
   Stock	NUMBER(6),
   Minimum_Stock	NUMBER(6),
   CONSTRAINT Product_pk PRIMARY KEY (Product_Code));

  INSERT INTO Product VALUES('A0001','MESA AZUL 30x40cm',400,8,1);
  Insert Into Product VALUES('L8510','SILLA MADERA CEREZO',20,10,6);
  Insert Into Product VALUES('B8540','SILLA MADERA BLANCA',30,Null,5);
  Insert Into Product VALUES('C5409','CAMA 80x90',640,3,1);
  Insert Into Product VALUES('M8570','CAMA 135x140',900,14,3);
  Insert Into Product VALUES('L8543','MESA TV',259,6,2);
  Insert Into Product VALUES('A5803','CAFETERA',90,15,8);
  Insert Into Product VALUES('Z8231','PLATO HONDO',5.78,70,10);
  INSERT INTO Product VALUES('L1800','PLATO LLANO',3.54,50,10);
  INSERT INTO Product VALUES('L1812','REGLETA FLUORESCENTE 1CX40',3.60,1,1);
  INSERT INTO Product VALUES('CICP','BASE ESSCO BJC IBIZA BLANCO',65,1,1);
  INSERT INTO Product VALUES('T1009','MARCO TICINO TEKME 2 E GRIS',2.80,15,11);
  INSERT INTO Product VALUES('IM710','INTERRUPTOR NIESEN LISA BLANCO',8.90,1,1);
  Insert Into Product VALUES('ZN18B','BASE DE ENCHUFE PLASTIMETAL',1.90,4,3);
  INSERT INTO Product VALUES('ZN50B','BASE ENCHUFE TT PLASTIMETAL',2.79,1,1);
  INSERT INTO Product VALUES('ZN08B','BASE PLASTIMETAL TT LATERAL',2.65,12,7);
  
CREATE TABLE Order2
  (Order_Code	NUMBER(6),
   Order_Date	DATE,
   Customer_Code	NUMBER(9),
   Supplier_Code	NUMBER(5),
   Product_Code  VARCHAR2(8),
   Quantity NUMBER(4),
   Total_Amount	Number(7,2),
   Order_Drop VARCHAR2(1), 
   CONSTRAINT Order_pk PRIMARY KEY (Order_Code,Order_Date),
   CONSTRAINT Order_Customer_Fk FOREIGN KEY (Customer_Code) REFERENCES Customer (Customer_Code),
   CONSTRAINT Order_Product_fk FOREIGN KEY (Product_Code) REFERENCES Product (Product_Code),
   CONSTRAINT Order_Supplier_Fk FOREIGN KEY (Supplier_Code) REFERENCES Supplier (Supplier_Code));   

  INSERT INTO Order2 VALUES('001','10/10/1999',10,20,'ZN08B',1,2.65,'S');
  INSERT INTO Order2 VALUES('002','12/12/2000',11,20,'A0001',1,400,'S');
  INSERT INTO Order2 VALUES('003',SYSDATE,12,30,'A5803',2,180,'N');
  INSERT INTO Order2 VALUES('004',SYSDATE,10,10,'L8510',4,80,'N');
  INSERT INTO Order2 VALUES('005',SYSDATE,13,20,'M8570',1,900,'N');
  INSERT INTO Order2 VALUES('006',SYSDATE,10,50,'Z8231',10,57.8,'N');
  INSERT INTO Order2 VALUES('007',SYSDATE,14,60,'ZN08B',1,2.65,'N');
  INSERT INTO Order2 VALUES('008',SYSDATE,10,70,'ZN08B',1,2.65,'N');
  INSERT INTO Order2 VALUES('009',SYSDATE,11,80,'L8543',1,259,'N');
  
CREATE TABLE Users
  (User_Code VARCHAR2(5),
  Name VARCHAR2(20),
  FirsName VARCHAR2(30),
  LastName VARCHAR2(30), 
  Password VARCHAR2(10),
  CONSTRAINT Code_User_pk PRIMARY KEY (User_Code));

  INSERT INTO Users
  VALUES ('001MC','MC','MC','MC','1234');

  Commit;
  /
 
