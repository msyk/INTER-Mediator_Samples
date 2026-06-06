/*
 * INTER-Mediator
 * Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
 *
 * INTER-Mediator is supplied under MIT License.
 * Please see the full license for details:
 * https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt

This schema file is for the sample of INTER-Mediator using MySQL, encoded by UTF-8.

Example:
$ mysql -u root -p < sample_schema_mysql.sql
Enter password:

*/
SET NAMES 'utf8mb4';
#Create db user.
DROP USER IF EXISTS 'web'@'localhost';
CREATE USER IF NOT EXISTS 'web'@'localhost' IDENTIFIED BY 'password';
#Grant to All operations for all objects with web account.
GRANT SELECT, INSERT, DELETE, UPDATE ON TABLE test_db.* TO 'web'@'localhost';
GRANT SHOW VIEW ON TABLE test_db.* TO 'web'@'localhost';
# For mysqldump, the SHOW VIEW privilege is just required, and use options --single-transaction and --no-tablespaces.
# GRANT RELOAD, PROCESS ON *.* TO 'webuser'@'localhost'; # For mysqldump

DROP DATABASE IF EXISTS test_db;
CREATE DATABASE test_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE test_db;

# The schema for the "Sample_form" and "Sample_Auth" sample set.

CREATE TABLE person
(
    id       INT AUTO_INCREMENT,
    name     VARCHAR(20),
    address  VARCHAR(40),
    mail     VARCHAR(40),
    category INT,
    checking BOOLEAN,
    location INT,
    memo     TEXT,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE contact
(
    id          INT AUTO_INCREMENT,
    person_id   INT,
    description TEXT,
    datetime    DATETIME,
    summary     VARCHAR(50),
    important   INT,
    way         INT default 4,
    kind        INT,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;
CREATE INDEX contact_person_id ON contact (person_id);


CREATE TABLE contact_way
(
    id   INT AUTO_INCREMENT,
    name VARCHAR(50),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE contact_kind
(
    id   INT AUTO_INCREMENT,
    name VARCHAR(50),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE cor_way_kind
(
    id      INT AUTO_INCREMENT,
    way_id  INT,
    kind_id INT,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;
CREATE INDEX cor_way_id ON cor_way_kind (way_id);
CREATE INDEX cor_kind_id ON cor_way_kind (way_id);

CREATE TABLE history
(
    id          INT AUTO_INCREMENT,
    person_id   INT,
    description VARCHAR(50),
    startdate   DATE,
    enddate     DATE,
    username    VARCHAR(20),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;
CREATE INDEX history_person_id ON history (person_id);

# The schema for the "Sample_search" sample set.

CREATE TABLE postalcode
(
    id   INT AUTO_INCREMENT,
    f3   VARCHAR(20),
    f7   VARCHAR(40),
    f8   VARCHAR(15),
    f9   VARCHAR(40),
    memo VARCHAR(200),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;
CREATE INDEX postalcode_f3 ON postalcode (f3);
CREATE INDEX postalcode_f8 ON postalcode (f8);

# The schema for the "Sample_products" sample set.
#
# The sample data for these table, invoice, item and products is another part of this file.
# Please scroll down to check it.

CREATE TABLE invoice
(
    id        INT AUTO_INCREMENT,
    issued    DATE,
    title     VARCHAR(30),
    authuser  VARCHAR(30),
    authgroup VARCHAR(30),
    authpriv  VARCHAR(30),
    PRIMARY KEY (id)
) CHARACTER
      SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE item
(
    id                INT AUTO_INCREMENT,
    invoice_id        INT,
    category_id       INT,
    product_id        INT,
    qty               INT,
    product_unitprice FLOAT,
    product_name      TEXT,
    product_taxrate   FLOAT,
    user_id           INT,
    group_id          INT,
    priv_id           INT,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE product
(
    id              INT AUTO_INCREMENT,
    category_id     INT,
    unitprice       FLOAT,
    name            VARCHAR(20),
    taxrate         FLOAT(4, 2),
    photofile       VARCHAR(20),
    acknowledgement VARCHAR(100),
    ack_link        VARCHAR(100),
    memo            VARCHAR(120),
    user            VARCHAR(16),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

# The schema for the "Sample_Asset" sample set.


DROP TABLE IF EXISTS asset;
CREATE TABLE asset
(
    asset_id    INT AUTO_INCREMENT,
    name        VARCHAR(20),
    category    VARCHAR(20),
    manifacture VARCHAR(20),
    productinfo VARCHAR(20),
    purchase    DATE,
    discard     DATE,
    memo        TEXT,
    PRIMARY KEY (asset_id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;
CREATE INDEX asset_purchase ON asset (purchase);
CREATE INDEX asset_discard ON asset (discard);

DROP TABLE IF EXISTS rent;
CREATE TABLE rent
(
    rent_id  INT AUTO_INCREMENT,
    asset_id INT,
    staff_id INT,
    rentdate DATE,
    backdate DATE,
    memo     TEXT,
    PRIMARY KEY (rent_id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;
CREATE INDEX rent_rentdate ON rent (rentdate);
CREATE INDEX rent_backdate ON rent (backdate);
CREATE INDEX rent_asset_id ON rent (asset_id);
CREATE INDEX rent_staff_id ON rent (staff_id);

DROP TABLE IF EXISTS staff;
CREATE TABLE staff
(
    staff_id INT AUTO_INCREMENT,
    name     VARCHAR(20),
    section  VARCHAR(20),
    memo     TEXT,
    PRIMARY KEY (staff_id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

DROP TABLE IF EXISTS category;
CREATE TABLE category
(
    category_id INT AUTO_INCREMENT,
    name        VARCHAR(20),
    PRIMARY KEY (category_id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

# The schema for the "Sample_Auth" sample set.

CREATE TABLE chat
(
    id        INT AUTO_INCREMENT,
    user      VARCHAR(64),
    groupname VARCHAR(64),
    postdt    DATETIME,
    message   VARCHAR(800),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;


CREATE TABLE fileupload
(
    id   INT AUTO_INCREMENT,
    f_id INT,
    path VARCHAR(1000),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

# This 'survey' table is for a demonstration.

CREATE TABLE survey
(
    id INT AUTO_INCREMENT,
    Q1 TEXT,
    Q2 TEXT,
    Q3 TEXT,
    Q4 TEXT,
    Q5 TEXT,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE registeredcontext
(
    id           INT AUTO_INCREMENT,
    clientid     TEXT,
    entity       TEXT,
    conditions   TEXT,
    registereddt DATETIME,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;


CREATE TABLE registeredpks
(
    context_id INT,
    pk         INT,
    PRIMARY KEY (context_id, pk),
    FOREIGN KEY (context_id) REFERENCES registeredcontext (id) ON DELETE CASCADE
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE authuser
(
    id                    INT AUTO_INCREMENT, # Primary key field for this table
    username              VARCHAR(100),       # The username that user enters, This should be unique
    hashedpasswd          VARCHAR(72),        # The hash of password
    realname              VARCHAR(100),       # The real name
    email                 VARCHAR(100),       # The email address
    address               VARCHAR(200),       # The real address
    birthdate             CHAR(8),            # My Number Card
    gender                CHAR(1),            # My Number Card
    sub                   VARCHAR(255),       # For OAuth2, My Number Card
    limitdt               DATETIME,           # The limit for continuing authentication on SAML/OAuth2
    initialPassword       VARCHAR(30),        # Storing for the initial password
    publicKey             TEXT,               # For Passkey Authentication
    publicKeyCredentialId TEXT,               # For Passkey Authentication
    secret                TEXT,               # For Google Authenticator
    accessToken           VARCHAR(64),        # For API, the length depends on your implementation.
    inactive              BOOLEAN,            # Inhibit to log in.
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE UNIQUE INDEX authuser_username
    ON authuser (username);
CREATE INDEX authuser_email
    ON authuser (email);
CREATE INDEX authuser_limitdt
    ON authuser (limitdt);

# The user1 has the password 'user1'. It's salted with the string 'TEXT'.
# All users have the password the same as user name. All are salted with 'TEXT'
# The following command lines are used to generate above hashed-hexed-password.
#
#  $ echo -n 'user1TEST' | openssl sha1 -sha1
#  d83eefa0a9bd7190c94e7911688503737a99db01
#  echo -n 'TEST' | xxd -ps
#  54455354
#  - combine above two results:
#  d83eefa0a9bd7190c94e7911688503737a99db0154455354

# The user mig2 has SHA-256 hashed password with 5000 times. There is no way to simple hash generating commands.
# The script dist-docs/passwdgen.sh can generate longer hash. The below shows how to calculate it from a password.
#
# % dist-docs/passwdgen.sh '--password=mig2'
# '','mig2','b7d863d29021fc96de261da6a5dfb6c4c28d3d43c75ad5ddddea4ec8716bdaf074675473'
#
# The dist-docs/passwdgen2.sh is quite faster than above and shows 3 kinds of hashes.
#
# % dist-docs/passwdgen2.sh 123456
# Input Values: password = 123456 , salt = ^N_* (5e4e5f2a) -- random salt generated
# Version 1 Hash Value = bc3bcf676e96ea16e888e31829e4920d2c079b2d5e4e5f2a
# Version 2m Hash Value = 9191796213a1e16448e1e43ef17340e73a5738c55ac5abf0c2d60c10b7d4ad2d5e4e5f2a
# Version 2 Hash Value = 013c325a6fddd183146d3acf6a490012f2de8609ea73f94d2ad7df9d9918913a5e4e5f2a


# The user mig2m is originally SHA-1 hashed password with password 'mig2m' and salt 'HASH' as like first line.
# The SHA-1 hash value converted with the same salt and re-hashed with SHA-256 as like third line.
# This means SHA-1 based hash value can change to the SHA-256 based one, and INTER-Mediator supports this style
# hash too to migrate SHA-256 from an SHA-1 account in the authuser table.

CREATE TABLE authgroup
(
    id        INT AUTO_INCREMENT,
    groupname VARCHAR(48),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE authcor
(
    id            INT AUTO_INCREMENT,
    user_id       INT,
    group_id      INT,
    dest_group_id INT,
    privname      VARCHAR(48),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE INDEX authcor_user_id
    ON authcor (user_id);
CREATE INDEX authcor_group_id
    ON authcor (group_id);
CREATE INDEX authcor_dest_group_id
    ON authcor (dest_group_id);

CREATE TABLE issuedhash
(
    id         INT AUTO_INCREMENT,
    user_id    INT,
    clienthost VARCHAR(64),
    hash       VARCHAR(100),
    expired    DateTime,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE INDEX issuedhash_user_id
    ON issuedhash (user_id);
CREATE INDEX issuedhash_expired
    ON issuedhash (expired);
CREATE INDEX issuedhash_clienthost
    ON issuedhash (clienthost);
CREATE INDEX issuedhash_user_id_clienthost
    ON issuedhash (user_id, clienthost);

# Collecting failed login information.
CREATE TABLE authfail
(
    id       INT AUTO_INCREMENT,
    dt       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip       VARCHAR(39),
    username VARCHAR(64),
    tw       INT,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE INDEX authfail_dt ON authfail (dt);
CREATE INDEX authfail_ip ON authfail (ip);
CREATE INDEX authfail_tw ON authfail (tw);
CREATE INDEX authfail_username ON authfail (username);

# Mail Template

CREATE TABLE mailtemplate
(
    id         INT AUTO_INCREMENT,
    to_field   TEXT,
    bcc_field  TEXT,
    cc_field   TEXT,
    from_field TEXT,
    subject    TEXT,
    body       TEXT,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

# Storing Sent Mail

CREATE TABLE maillog
(
    id         INT AUTO_INCREMENT,
    to_field   TEXT,
    bcc_field  TEXT,
    cc_field   TEXT,
    from_field TEXT,
    subject    TEXT,
    body       TEXT,
    errors     TEXT,
    dt         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    foreign_id INT,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

# Operation Log Store

CREATE TABLE operationlog
(
    id            INT AUTO_INCREMENT,
    dt            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user          VARCHAR(48),
    client_id_in  VARCHAR(48),
    client_id_out VARCHAR(48),
    require_auth  BIT(1),
    set_auth      BIT(1),
    client_ip     VARCHAR(60),
    path          VARCHAR(256),
    access        VARCHAR(20),
    context       VARCHAR(50),
    get_data      TEXT,
    post_data     TEXT,
    result        TEXT,
    error         TEXT,
    condition0    VARCHAR(50),
    condition1    VARCHAR(50),
    condition2    VARCHAR(50),
    condition3    VARCHAR(50),
    condition4    VARCHAR(50),
    field0        TEXT,
    field1        TEXT,
    field2        TEXT,
    field3        TEXT,
    field4        TEXT,
    field5        TEXT,
    field6        TEXT,
    field7        TEXT,
    field8        TEXT,
    field9        TEXT,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

# In case of real deployment, some indices are required for quick operations.

CREATE TABLE testtable
(
    id      INT AUTO_INCREMENT,
    num1    INT          NOT NULL DEFAULT 0,
    num2    INT,
    num3    INT,
    dt1     DateTime     NOT NULL DEFAULT '2001-01-01 00:00:00',
    dt2     DateTime,
    dt3     DateTime,
    date1   Date         NOT NULL DEFAULT '2001-01-01',
    date2   Date,
    time1   Time         NOT NULL DEFAULT '00:00:00',
    time2   Time,
    ts1     Timestamp    NOT NULL DEFAULT '2001-01-01 00:00:00',
    ts2     Timestamp             DEFAULT '2001-01-01 00:00:00', # Required default value
    vc1     VARCHAR(100) NOT NULL DEFAULT '',
    vc2     VARCHAR(100),
    vc3     VARCHAR(100),
    text1   TEXT,
    text2   TEXT,
    float1  FLOAT        NOT NULL DEFAULT 0,
    float2  FLOAT,
    double1 DOUBLE       NOT NULL DEFAULT 0,
    double2 DOUBLE,
    bool1   BOOLEAN      NOT NULL DEFAULT FALSE,
    bool2   BOOLEAN,
    PRIMARY KEY (id)
) CHARACTER
      SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE information
(
    id          INT AUTO_INCREMENT,
    lastupdated DATE,
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

#The schema for the "Sample_Extensible" sample set.

DROP TABLE IF EXISTS saleslog;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS item_master;

CREATE TABLE saleslog
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    dt          DATETIME,
    item        VARCHAR(20),
    customer    VARCHAR(70),
    qty         INT,
    item_id     INT,
    customer_id INT,
    unitprice   INT,
    total       INT
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE item_master
(
    id        INT PRIMARY KEY,
    name      VARCHAR(20),
    unitprice INT
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE customer
(
    id   INT PRIMARY KEY,
    name VARCHAR(70)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

CREATE TABLE alphabet
(
    id INT AUTO_INCREMENT,
    c  VARCHAR(1),
    PRIMARY KEY (id)
) CHARACTER SET utf8mb4,
  COLLATE utf8mb4_unicode_ci
  ENGINE = InnoDB;

