CREATE SCHEMA test;

CREATE TABLE IF NOT EXISTS test.users
(
    username         varchar(255) PRIMARY KEY NOT NULL,
    age              integer,
    created_date     date,
    time_zone        varchar(255),
    city             varchar(255),
    country          varchar(255),
    address          varchar(255),
    current_position varchar(255),
    current_company  varchar(255),
    salary           numeric
);

CREATE TABLE IF NOT EXISTS test.prices (
    subscription_level        varchar(255) PRIMARY KEY,
    price           numeric,
    description     varchar(255)
);

CREATE TABLE IF NOT EXISTS test.subscription (
    username             varchar(255) PRIMARY KEY NOT NULL,
    subscription_level   varchar(255),
    FOREIGN KEY (username) REFERENCES test.users(username),
    FOREIGN KEY (subscription_level) REFERENCES test.prices(subscription_level)
);

INSERT INTO test.users (
username,
age,
created_date,
time_zone,
city,
country,
address,
current_position,
current_company,
salary
)
VALUES
    ('johndoe', 30, '2022-01-01', 'UTC-5', 'New York', 'USA', '123 Main St', 'Desarrollador', 'ACME Inc', 100000),
    ('janedoe', 25, '2022-02-01', 'UTC-6', 'Los Angeles', 'USA', '456 Sunset Blvd', 'Diseñador', 'XYZ Corp', 90000),
    ('johnsmith', 35, '2022-03-01', 'UTC-7', 'San Francisco', 'USA', '789 Market St', 'Gerente', 'ABC Inc', 110000),
    ('janesmith', 28, '2022-04-01', 'UTC-8', 'TBasicnto', 'Canada', '246 Queen St', 'Analista', 'DEF Ltd', 95000),
    ('bobjones', 40, '2022-05-01', 'UTC-5', 'Mexico City', 'Mexico', '369 Juarez Ave', 'Arquitecto', 'GHI SA', 105000),
    ('sarahjohnson', 32, '2022-06-01', 'UTC-6', 'Buenos Aires', 'Argentina', '159 Rivadavia St', 'Ingeniero', 'JKL Inc', 115000),
    ('mikebrown', 27, '2022-07-01', 'UTC-7', 'Santiago', 'Chile', '753 Alameda St', 'Técnico', 'MNO Ltd', 90000),
    ('jenniferwhite', 29, '2022-08-01', 'UTC-8', 'Rio de Janeiro', 'Brazil', '964 Copacabana St', 'Contador', 'PQR Corp', 85000),
    ('josegarcia', 36, '2022-09-01', 'UTC-5', 'Lima', 'Peru', '753 Arequipa St', 'Abogado', 'STU Inc', 105000),
    ('anaortiz', 33, '2022-10-01', 'UTC-6', 'Bogotá', 'Colombia', '369 Carrera St', 'Enfermero', 'VWX Ltd', 95000)
;

INSERT INTO test.prices (subscription_level, price, description)
VALUES
    ('Free', 0.00, 'Free plan with limited access to information'),
    ('Basic', 49.99, 'Limited access to certain Glassdoor features and tools'),
    ('Premium', 199.99, 'Full access to all Glassdoor features and tools')
;

INSERT INTO test.subscription (
    username, subscription_level
)
VALUES
    ('johndoe', 'Basic'),
    ('janedoe', 'Premium'),
    ('johnsmith', 'Basic'),
    ('janesmith', 'Premium'),
    ('bobjones', 'Basic'),
    ('sarahjohnson', 'Premium'),
    ('mikebrown', 'Premium'),
    ('jenniferwhite', 'Basic'),
    ('josegarcia', 'Basic'),
    ('anaortiz', 'Premium')
;