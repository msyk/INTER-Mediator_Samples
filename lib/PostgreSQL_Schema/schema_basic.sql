/*
 * INTER-Mediator
 * Copyright (c) INTER-Mediator Directive Committee (http://inter-mediator.org)
 * This project started at the end of 2009 by Masayuki Nii msyk@msyk.net.
 *
 * INTER-Mediator is supplied under MIT License.
 * Please see the full license for details:
 * https://github.com/INTER-Mediator/INTER-Mediator/blob/master/dist-docs/License.txt

This schema file is for the sample of INTER-Mediator using PostgreSQL, encoded by UTF-8.

Example:
$ psql -c 'create database test_db;' -h localhost postgres
$ psql -f sample_schema_pgsql.sql -h localhost test_db

*/

/***************************** ATTENTION *****************************
 * If you execute this schema twice or more, remove comment of the following lines.
 *********************************************************************/

-- DROP USER web;
CREATE
USER web PASSWORD 'password';
/*
DROP DATABASE IF EXISTS test_db;
CREATE DATABASE test_db ENCODING 'UTF8';
*/
VACUUM;

DROP SCHEMA IF EXISTS im_sample CASCADE;
CREATE SCHEMA im_sample;

SET
search_path TO im_sample,public;
ALTER
USER web SET search_path TO im_sample,public;

/*  The schema for the "Sample_form" and "Sample_Auth" sample set. */
CREATE SEQUENCE serial START 1000;
CREATE TABLE person
(
    id       SERIAL PRIMARY KEY,
    name     TEXT,
    address  TEXT,
    mail     TEXT,
    category INTEGER,
    checking BOOLEAN NOT NULL DEFAULT FALSE,
    location INTEGER,
    memo     TEXT
);
GRANT ALL PRIVILEGES ON im_sample.person_id_seq TO web;

CREATE TABLE contact
(
    id          SERIAL PRIMARY KEY,
    person_id   INTEGER,
    description TEXT,
    datetime    TIMESTAMP,
    summary     TEXT,
    important   INTEGER NOT NULL DEFAULT 0,
    way         INTEGER          default 4,
    kind        INTEGER
);
CREATE INDEX contact_person_id ON contact (person_id);
GRANT ALL PRIVILEGES ON im_sample.contact_id_seq TO web;

CREATE TABLE contact_way
(
    id   SERIAL PRIMARY KEY,
    name TEXT
);
GRANT ALL PRIVILEGES ON im_sample.contact_way_id_seq TO web;

CREATE TABLE contact_kind
(
    id   SERIAL PRIMARY KEY,
    name TEXT
);
GRANT ALL PRIVILEGES ON im_sample.contact_kind_id_seq TO web;


CREATE TABLE cor_way_kind
(
    id      SERIAL PRIMARY KEY,
    way_id  INTEGER,
    kind_id INTEGER
);
CREATE INDEX cor_way_id ON cor_way_kind (way_id);
CREATE INDEX cor_kind_id ON cor_way_kind (way_id);
GRANT ALL PRIVILEGES ON im_sample.cor_way_kind_id_seq TO web;

INSERT INTO cor_way_kind(way_id, kind_id)
VALUES (4, 4);
INSERT INTO cor_way_kind(way_id, kind_id)
VALUES (4, 5);
INSERT INTO cor_way_kind(way_id, kind_id)
VALUES (5, 6);
INSERT INTO cor_way_kind(way_id, kind_id)
VALUES (4, 7);
INSERT INTO cor_way_kind(way_id, kind_id)
VALUES (5, 8);
INSERT INTO cor_way_kind(way_id, kind_id)
VALUES (5, 9);
INSERT INTO cor_way_kind(way_id, kind_id)
VALUES (6, 10);
INSERT INTO cor_way_kind(way_id, kind_id)
VALUES (5, 11);
INSERT INTO cor_way_kind(way_id, kind_id)
VALUES (6, 12);
INSERT INTO cor_way_kind(way_id, kind_id)
VALUES (5, 12);
INSERT INTO cor_way_kind(way_id, kind_id)
VALUES (6, 13);

CREATE TABLE history
(
    id          SERIAL PRIMARY KEY,
    person_id   INTEGER,
    description TEXT,
    startdate   DATE,
    enddate     DATE,
    username    TEXT
);
CREATE INDEX history_person_id ON history (person_id);
GRANT ALL PRIVILEGES ON im_sample.history_id_seq TO web;

/* The schema for the "Sample_search" sample set. */

CREATE TABLE postalcode
(
    id   SERIAL PRIMARY KEY,
    f3   VARCHAR(20),
    f7   VARCHAR(40),
    f8   VARCHAR(15),
    f9   VARCHAR(40),
    memo VARCHAR(200)
);
CREATE INDEX postalcode_f3 ON postalcode (f3);
CREATE INDEX postalcode_f8 ON postalcode (f8);
GRANT ALL PRIVILEGES ON im_sample.postalcode_id_seq TO web;

/*
# The schema for the "Sample_products" sample set.                                                                REAL
#
# The sample data for these table, invoice, item and products is another part of this file.
# Please scroll down to check it.
*/
CREATE TABLE invoice
(
    id        SERIAL PRIMARY KEY,
    issued    DATE,
    title     VARCHAR(30),
    authuser  VARCHAR(30),
    authgroup VARCHAR(30),
    authpriv  VARCHAR(30)
);
GRANT ALL PRIVILEGES ON im_sample.invoice_id_seq TO web;

CREATE TABLE item
(
    id                SERIAL PRIMARY KEY,
    invoice_id        INTEGER,
    category_id       INTEGER,
    product_id        INTEGER,
    qty               INTEGER,
    product_unitprice FLOAT,
    product_name      TEXT,
    product_taxrate   FLOAT,
    user_id           INTEGER,
    group_id          INTEGER,
    priv_id           INTEGER
);
GRANT ALL PRIVILEGES ON im_sample.item_id_seq TO web;

CREATE TABLE product
(
    id              SERIAL PRIMARY KEY,
    category_id     INTEGER,
    unitprice       NUMERIC(10, 2),
    name            VARCHAR(20),
    photofile       VARCHAR(20),
    acknowledgement VARCHAR(100),
    ack_link        VARCHAR(100),
    memo            VARCHAR(120)
);
GRANT ALL PRIVILEGES ON im_sample.product_id_seq TO web;

/*  The schema for the "Sample_Asset" sample set. */

CREATE TABLE asset
(
    asset_id    SERIAL PRIMARY KEY,
    name        VARCHAR(20),
    category    VARCHAR(20),
    manifacture VARCHAR(20),
    productinfo VARCHAR(20),
    purchase    DATE,
    discard     DATE,
    memo        TEXT
);
CREATE INDEX asset_purchase ON asset (purchase);
CREATE INDEX asset_discard ON asset (discard);
GRANT ALL PRIVILEGES ON im_sample.asset_asset_id_seq TO web;

CREATE TABLE rent
(
    rent_id  SERIAL PRIMARY KEY,
    asset_id INT,
    staff_id INT,
    rentdate DATE,
    backdate DATE,
    memo     TEXT
);
CREATE INDEX rent_rentdate ON rent (rentdate);
CREATE INDEX rent_backdate ON rent (backdate);
CREATE INDEX rent_asset_id ON rent (asset_id);
CREATE INDEX rent_staff_id ON rent (staff_id);
GRANT ALL PRIVILEGES ON im_sample.rent_rent_id_seq TO web;

CREATE TABLE staff
(
    staff_id SERIAL PRIMARY KEY,
    name     VARCHAR(20),
    section  VARCHAR(20),
    memo     TEXT
);
GRANT ALL PRIVILEGES ON im_sample.staff_staff_id_seq TO web;

CREATE TABLE category
(
    category_id SERIAL PRIMARY KEY,
    name        VARCHAR(20)
);
GRANT ALL PRIVILEGES ON im_sample.category_category_id_seq TO web;

/*  The schema for the "Sample_Auth" sample set. */

CREATE TABLE chat
(
    id        SERIAL PRIMARY KEY,
    username  VARCHAR(64),
    groupname VARCHAR(64),
    postdt    TIMESTAMP,
    message   VARCHAR(800)
);
GRANT ALL PRIVILEGES ON im_sample.chat_id_seq TO web;

CREATE TABLE fileupload
(
    id   SERIAL PRIMARY KEY,
    f_id INTEGER,
    path TEXT
);
GRANT ALL PRIVILEGES ON im_sample.fileupload_id_seq TO web;

/* Observable */

CREATE TABLE registeredcontext
(
    id           SERIAL PRIMARY KEY,
    clientid     VARCHAR(64),
    entity       VARCHAR(100),
    conditions   VARCHAR(250),
    registereddt TIMESTAMP
);
GRANT ALL PRIVILEGES ON im_sample.registeredcontext_id_seq TO web;

CREATE TABLE registeredpks
(
    context_id INTEGER,
    pk         INTEGER,
    PRIMARY KEY (context_id, pk),
    FOREIGN KEY (context_id) REFERENCES registeredcontext (id) ON DELETE CASCADE
);
/* GRANT ALL PRIVILEGES ON im_sample.registeredpks_id_seq TO web; */

/* Authetication tables */
CREATE TABLE authuser
(
    id                    SERIAL PRIMARY KEY,
    username              VARCHAR(64),
    hashedpasswd          VARCHAR(72),
    email                 VARCHAR(100),
    realname              VARCHAR(100),
    address               VARCHAR(200),
    birthdate             CHAR(8),
    gender                CHAR(1),
    sub                   VARCHAR(255),
    limitdt               TIMESTAMP,
    publicKey             TEXT,
    publicKeyCredentialId TEXT,
    secret                TEXT,
    accessToken           VARCHAR(64),
    inactive              BOOLEAN
);
CREATE INDEX authuser_username ON authuser (username);
CREATE INDEX authuser_email ON authuser (email);
CREATE INDEX authuser_limitdt ON authuser (limitdt);
GRANT ALL PRIVILEGES ON im_sample.authuser_id_seq TO web;
/*
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
*/
CREATE TABLE authgroup
(
    id        SERIAL PRIMARY KEY,
    groupname VARCHAR(48)
);
GRANT ALL PRIVILEGES ON im_sample.authgroup_id_seq TO web;

INSERT INTO authgroup(id, groupname)
VALUES (1, 'group1');
INSERT INTO authgroup(id, groupname)
VALUES (2, 'group2');
INSERT INTO authgroup(id, groupname)
VALUES (3, 'group3');

CREATE TABLE authcor
(
    id            SERIAL PRIMARY KEY,
    user_id       INTEGER,
    group_id      INTEGER,
    dest_group_id INTEGER,
    privname      VARCHAR(48)
);
CREATE INDEX authcor_user_id ON authcor (user_id);
CREATE INDEX authcor_group_id ON authcor (group_id);
CREATE INDEX authcor_dest_group_id ON authcor (dest_group_id);
GRANT ALL PRIVILEGES ON im_sample.authcor_id_seq TO web;

CREATE TABLE issuedhash
(
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER,
    clienthost VARCHAR(64),
    hash       VARCHAR(100),
    expired    TIMESTAMP
);
CREATE INDEX issuedhash_user_id ON issuedhash (user_id);
CREATE INDEX issuedhash_expired ON issuedhash (expired);
CREATE INDEX issuedhash_clienthost ON issuedhash (clienthost);
CREATE INDEX issuedhash_user_id_clienthost ON issuedhash (user_id, clienthost);
GRANT ALL PRIVILEGES ON im_sample.issuedhash_id_seq TO web;

-- Collecting failed login information.
CREATE TABLE authfail
(
    id       SERIAL PRIMARY KEY ,
    dt       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip       TEXT,
    username TEXT,
    tw       INT
);

CREATE INDEX authfail_dt ON authfail (dt);
CREATE INDEX authfail_ip ON authfail (ip);
CREATE INDEX authfail_username ON authfail (username);
CREATE INDEX authfail_tw ON authfail (tw);
GRANT ALL PRIVILEGES ON im_sample.authfail_id_seq TO web;

/* Mail Template */
CREATE TABLE mailtemplate
(
    id         SERIAL PRIMARY KEY,
    to_field   TEXT,
    bcc_field  TEXT,
    cc_field   TEXT,
    from_field TEXT,
    subject    TEXT,
    body       TEXT
);

GRANT ALL PRIVILEGES ON im_sample.mailtemplate_id_seq TO web;

/* Storing Sent Mail */
CREATE TABLE maillog
(
    id         SERIAL PRIMARY KEY,
    to_field   TEXT,
    bcc_field  TEXT,
    cc_field   TEXT,
    from_field TEXT,
    subject    TEXT,
    body       TEXT,
    errors     TEXT,
    dt         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    foreign_id INT
);

GRANT ALL PRIVILEGES ON im_sample.maillog_id_seq TO web;

/* Operation Log Store */
CREATE TABLE operationlog
(
    id            SERIAL PRIMARY KEY,
    dt            TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "user"        VARCHAR(48),
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
    field9        TEXT
);
GRANT ALL PRIVILEGES ON im_sample.operationlog_id_seq TO web;

/* In case of real deployment, some indices are required for quick operations. */

CREATE TABLE testtable
(
    id      SERIAL PRIMARY KEY,
    num1    INTEGER          NOT NULL DEFAULT 0,
    num2    INTEGER,
    num3    INTEGER,
    dt1     Timestamp        NOT NULL DEFAULT '2001-01-01 00:00:00',
    dt2     Timestamp,
    dt3     Timestamp,
    date1   Date             NOT NULL DEFAULT '2001-01-01',
    date2   Date,
    time1   Time             NOT NULL DEFAULT '00:00:00',
    time2   Time,
    ts1     Timestamp        NOT NULL DEFAULT '2001-01-01 00:00:00',
    ts2     Timestamp,
    vc1     VARCHAR(100)     NOT NULL DEFAULT '',
    vc2     VARCHAR(100),
    vc3     VARCHAR(100),
    text1   TEXT             NOT NULL DEFAULT '',
    text2   TEXT,
    float1  REAL             NOT NULL DEFAULT 0,
    float2  REAL,
    bool1   BOOLEAN          NOT NULL DEFAULT FALSE,
    bool2   BOOLEAN,
    double1 DOUBLE PRECISION NOT NULL DEFAULT 0,
    double2 DOUBLE PRECISION
);
GRANT ALL PRIVILEGES ON im_sample.testtable_id_seq TO web;

/* Grant to All operations for all objects with web account */

GRANT ALL PRIVILEGES ON SCHEMA im_sample TO web;
GRANT ALL PRIVILEGES ON im_sample.authcor TO web;
GRANT ALL PRIVILEGES ON im_sample.authgroup TO web;
GRANT ALL PRIVILEGES ON im_sample.authuser TO web;
GRANT ALL PRIVILEGES ON im_sample.operationlog TO web;
GRANT ALL PRIVILEGES ON im_sample.chat TO web;
GRANT ALL PRIVILEGES ON im_sample.contact TO web;
GRANT ALL PRIVILEGES ON im_sample.contact_kind TO web;
GRANT ALL PRIVILEGES ON im_sample.contact_way TO web;
GRANT ALL PRIVILEGES ON im_sample.cor_way_kind TO web;
GRANT ALL PRIVILEGES ON im_sample.history TO web;
GRANT ALL PRIVILEGES ON im_sample.invoice TO web;
GRANT ALL PRIVILEGES ON im_sample.issuedhash TO web;
GRANT ALL PRIVILEGES ON im_sample.item TO web;
GRANT ALL PRIVILEGES ON im_sample.person TO web;
GRANT ALL PRIVILEGES ON im_sample.postalcode TO web;
GRANT ALL PRIVILEGES ON im_sample.product TO web;
GRANT ALL PRIVILEGES ON im_sample.serial TO web;
GRANT ALL PRIVILEGES ON im_sample.asset TO web;
GRANT ALL PRIVILEGES ON im_sample.rent TO web;
GRANT ALL PRIVILEGES ON im_sample.staff TO web;
GRANT ALL PRIVILEGES ON im_sample.category TO web;
GRANT ALL PRIVILEGES ON im_sample.testtable TO web;
GRANT ALL PRIVILEGES ON im_sample.fileupload TO web;
GRANT ALL PRIVILEGES ON im_sample.registeredcontext TO web;
GRANT ALL PRIVILEGES ON im_sample.registeredpks TO web;

