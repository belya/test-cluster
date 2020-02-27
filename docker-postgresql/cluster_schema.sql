CREATE TABLE users (
    id       VARCHAR(100) NOT NULL PRIMARY KEY,
    version  INTEGER NOT NULL
);

CREATE OR REPLACE FUNCTION get_users(
    po_id       OUT VARCHAR,
    po_version  OUT INTEGER
) RETURNS SETOF RECORD
    language plpgsql
AS $$
DECLARE
/*
    Name       :  get_users
    Purpose    :  Get all users from table
    History    :
        <VERSION 1.0>
            Date    :  Feb 27, 2020
            Authors :  Anatoly Belchikov
            Notes   :  
*/
BEGIN
    RETURN QUERY SELECT id, version FROM users;
END;
$$;

CREATE OR REPLACE FUNCTION increase_version() RETURNS VOID
    language plpgsql
AS $$
DECLARE
/*
    Name       :  increase_version
    Purpose    :  Increase version field by 1 for all users
    History    :
        <VERSION 1.0>
            Date    :  Feb 27, 2020
            Authors :  Anatoly Belchikov
            Notes   :  
*/
BEGIN
    UPDATE users SET version = version + 1;
END;
$$;