CREATE TABLE roles (
    id integer PRIMARY KEY,
    role varchar(15) UNIQUE
);

CREATE TABLE privileges (
    id integer PRIMARY KEY,
    role varchar(15) UNIQUE,
    privileges text[],
    FOREIGN KEY (id, role) REFERENCES roles (id, role)
);

CREATE TYPE employment_status AS ENUM ('active', 'suspended', 'inactive');

CREATE TABLE users (
    id integer PRIMARY KEY,
    name text,
    sex varchar(1),
    phone text,
    email text,
    role varchar(15) UNIQUE,
    registered_date date,
    deregistered_date date,
    employment_status employment_status,
    FOREIGN KEY (role) REFERENCES roles (role)
);

CREATE TABLE user_profiles (
    id integer PRIMARY KEY,
    profile_photo_src text,
    bio text,
    FOREIGN KEY (id) REFERENCES users (id)
);

CREATE TYPE message_status AS ENUM ('draft', 'read', 'unread', 'pending');

CREATE TABLE user_messages (
    id integer PRIMARY KEY,
    message text,
    sender text,
    recipient text,
    message_status message_status,
    sent timestamp,
    received timestamp
);

CREATE TYPE registration_status AS ENUM ('active', 'suspended', 'inactive');

CREATE TABLE customers (
    id integer PRIMARY KEY,
    name text,
    username text,
    phone text,
    email text,
    registered_date date,
    deregistered_date date,
    registration_status registration_status
);

CREATE TABLE customer_profiles (
    id integer PRIMARY KEY,
    profile_photo_src text,
    bio text,
    FOREIGN KEY (id) REFERENCES customers (id)
);

CREATE TABLE customer_messages (
    id integer PRIMARY KEY,
    message text,
    sender text,
    recipient text,
    message_status message_status,
    sent timestamp,
    received timestamp
);
