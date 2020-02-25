CREATE TABLE users (
    id VARCHAR(100) NOT NULL PRIMARY KEY,
    version INTEGER NOT NULL
);

INSERT INTO users (id, version) VALUES ('user3', 0);
INSERT INTO users (id, version) VALUES ('user4', 0);