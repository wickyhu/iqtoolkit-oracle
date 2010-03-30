DROP TABLE categories CASCADE CONSTRAINTS
/

CREATE TABLE categories
    (categoryid                     NUMBER(*,0) NOT NULL,
    categoryname                   NVARCHAR2(15) NOT NULL,
    description                    NCLOB,
    picture                        BLOB) 
/

ALTER TABLE categories
ADD CONSTRAINT pk_categories PRIMARY KEY (categoryid)
USING INDEX
/

DROP TABLE customers CASCADE CONSTRAINTS
/

CREATE TABLE customers
    (customerid                     NVARCHAR2(5) NOT NULL,
    companyname                    NVARCHAR2(40) NOT NULL,
    contactname                    NVARCHAR2(30),
    contacttitle                   NVARCHAR2(30),
    address                        NVARCHAR2(60),
    city                           NVARCHAR2(15),
    region                         NVARCHAR2(15),
    postalcode                     NVARCHAR2(10),
    country                        NVARCHAR2(15),
    phone                          NVARCHAR2(24),
    fax                            NVARCHAR2(24))
/

ALTER TABLE customers
ADD CONSTRAINT pk_customers PRIMARY KEY (customerid)
USING INDEX
/

DROP TABLE employees CASCADE CONSTRAINTS
/

CREATE TABLE employees
    (employeeid                     NUMBER(*,0) NOT NULL,
    lastname                       NVARCHAR2(20) NOT NULL,
    firstname                      NVARCHAR2(10) NOT NULL,
    title                          NVARCHAR2(30),
    titleofcourtesy                NVARCHAR2(25),
    birthdate                      DATE,
    hiredate                       DATE,
    address                        NVARCHAR2(60),
    city                           NVARCHAR2(15),
    region                         NVARCHAR2(15),
    postalcode                     NVARCHAR2(10),
    country                        NVARCHAR2(15),
    homephone                      NVARCHAR2(24),
    extension                      NVARCHAR2(4),
    photo                          BLOB,
    notes                          NCLOB,
    reportsto                      NUMBER(*,0),
    photopath                      NVARCHAR2(255)) 
/

ALTER TABLE employees
ADD CONSTRAINT pk_employees PRIMARY KEY (employeeid)
USING INDEX
/

DROP TABLE orders CASCADE CONSTRAINTS
/

CREATE TABLE orders
    (orderid                        NUMBER(*,0) NOT NULL,
    customerid                     NVARCHAR2(5),
    employeeid                     NUMBER(*,0),
    orderdate                      TIMESTAMP (7),
    requireddate                   DATE,
    shippeddate                    DATE,
    shipvia                        NUMBER(*,0),
    freight                        NUMBER(19,4),
    shipname                       NVARCHAR2(40),
    shipaddress                    NVARCHAR2(60),
    shipcity                       NVARCHAR2(15),
    shipregion                     NVARCHAR2(15),
    shippostalcode                 NVARCHAR2(10),
    shipcountry                    NVARCHAR2(15))
/

ALTER TABLE orders
ADD CONSTRAINT pk_orders PRIMARY KEY (orderid)
USING INDEX
/


ALTER TABLE orders
ADD CONSTRAINT fk_customers FOREIGN KEY (customerid)
REFERENCES customers (customerid)
/


DROP TABLE products CASCADE CONSTRAINTS
/

CREATE TABLE products
    (productid                      NUMBER(*,0) NOT NULL,
    productname                    NVARCHAR2(40) NOT NULL,
    supplierid                     NUMBER(*,0),
    categoryid                     NUMBER(*,0),
    quantityperunit                NVARCHAR2(20),
    unitprice                      NUMBER(19,4),
    unitsinstock                   NUMBER(*,0),
    unitsonorder                   NUMBER(*,0),
    reorderlevel                   NUMBER(*,0),
    discontinued                   NUMBER(1,0) NOT NULL)
/

ALTER TABLE products
ADD CONSTRAINT pk_products PRIMARY KEY (productid)
USING INDEX
/

DROP TABLE "ORDER DETAILS" CASCADE CONSTRAINTS
/

CREATE TABLE "ORDER DETAILS"
    (orderid                        NUMBER(*,0) NOT NULL,
    productid                      NUMBER(*,0) NOT NULL,
    unitprice                      NUMBER(19,4) NOT NULL,
    quantity                       NUMBER(*,0) NOT NULL,
    discount                       FLOAT(126) NOT NULL)
/

ALTER TABLE "ORDER DETAILS"
ADD CONSTRAINT pk_order_details PRIMARY KEY (orderid, productid)
USING INDEX
/

ALTER TABLE "ORDER DETAILS"
ADD CONSTRAINT fk_orders FOREIGN KEY (orderid)
REFERENCES orders (orderid)
/
ALTER TABLE "ORDER DETAILS"
ADD CONSTRAINT fk_products FOREIGN KEY (productid)
REFERENCES products (productid)
/


DROP TABLE region CASCADE CONSTRAINTS
/

CREATE TABLE region
    (regionid                       NUMBER(*,0) NOT NULL,
    regiondescription              NCHAR(50) NOT NULL)
/

ALTER TABLE region
ADD CONSTRAINT pk_region PRIMARY KEY (regionid)
USING INDEX
/

DROP TABLE shippers CASCADE CONSTRAINTS
/

CREATE TABLE shippers
    (shipperid                      NUMBER(*,0) NOT NULL,
    companyname                    NVARCHAR2(40) NOT NULL,
    phone                          NVARCHAR2(24))
/

ALTER TABLE shippers
ADD CONSTRAINT pk_shippers PRIMARY KEY (shipperid)
USING INDEX
/

DROP TABLE suppliers CASCADE CONSTRAINTS
/

CREATE TABLE suppliers
    (supplierid                     NUMBER(*,0) NOT NULL,
    companyname                    NVARCHAR2(40) NOT NULL,
    contactname                    NVARCHAR2(30),
    contacttitle                   NVARCHAR2(30),
    address                        NVARCHAR2(60),
    city                           NVARCHAR2(15),
    region                         NVARCHAR2(15),
    postalcode                     NVARCHAR2(10),
    country                        NVARCHAR2(15),
    phone                          NVARCHAR2(24),
    fax                            NVARCHAR2(24),
    homepage                       NCLOB)
/

ALTER TABLE suppliers
ADD CONSTRAINT pk_suppliers PRIMARY KEY (supplierid)
USING INDEX
/

DROP TABLE testtable1 CASCADE CONSTRAINTS
/

CREATE TABLE testtable1
    (id                             NUMBER(*,0) NOT NULL,
    value1                         VARCHAR2(10))
/

ALTER TABLE testtable1
ADD PRIMARY KEY (id)
USING INDEX
/


DROP TABLE testtable2 CASCADE CONSTRAINTS
/

CREATE TABLE testtable2
    (id                             NUMBER(*,0) NOT NULL,
    value2                         VARCHAR2(10))
/

ALTER TABLE testtable2
ADD PRIMARY KEY (id)
USING INDEX
/


ALTER TABLE testtable2
ADD FOREIGN KEY (id)
REFERENCES testtable1 (id)
/
DROP TABLE testtable3 CASCADE CONSTRAINTS
/

CREATE TABLE testtable3
    (id                             NUMBER(*,0) NOT NULL,
    value3                         VARCHAR2(10))
/

ALTER TABLE testtable3
ADD PRIMARY KEY (id)
USING INDEX
/


ALTER TABLE testtable3
ADD FOREIGN KEY (id)
REFERENCES testtable1 (id)
/



