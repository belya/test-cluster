CREATE TABLE users (
    id VARCHAR(100) NOT NULL PRIMARY KEY,
    version INTEGER NOT NULL
);

CREATE FUNCTION get_users(
    po_id OUT VARCHAR,
    po_version OUT INTEGER
) RETURNS SETOF RECORD
    language plpgsql
AS $$
BEGIN
    RETURN QUERY SELECT id, version FROM users;
END;
$$;

CREATE FUNCTION increase_version() RETURNS VOID
    language plpgsql
AS $$
BEGIN
    UPDATE users SET version = version + 1;
END;
$$;