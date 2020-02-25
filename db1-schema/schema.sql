CREATE TABLE users (
    id VARCHAR(100) NOT NULL PRIMARY KEY,
    version INTEGER NOT NULL
);

INSERT INTO users (id, version) VALUES ('user1', 0);
INSERT INTO users (id, version) VALUES ('user2', 0);