CREATE EXTENSION dblink;


CREATE TABLE connections (
    connname VARCHAR(100) NOT NULL PRIMARY KEY,
    connstr VARCHAR(500) NOT NULL
);


INSERT INTO connections (connname, connstr) VALUES ('db1', 'host=db1 port=5432 user=root password=root dbname=db');
-- INSERT INTO connections (connname, connstr) VALUES ('broken_connection', 'host=db3 port=5432 user=root password=root dbname=db');
INSERT INTO connections (connname, connstr) VALUES ('db2', 'host=db2 port=5432 user=root password=root dbname=db');


-- TODO add errors processing
CREATE FUNCTION proxy_select_sql(sql VARCHAR, types VARCHAR) RETURNS VARCHAR
    language plpgsql
AS $$
DECLARE
    v_proxy_sql VARCHAR;
BEGIN
    SELECT
    string_agg(
        'SELECT * FROM dblink('
        || '''' || connstr || ''', '
        || '''' || sql || ''')' 
        || ' AS t_' || connname || '(' || types || ')'
        , ' UNION '
    )
    INTO v_proxy_sql
    FROM connections;

    RETURN v_proxy_sql;
END;
$$;


-- TODO return records instead of table with fixed types
CREATE FUNCTION proxy_users() RETURNS TABLE(id VARCHAR, version INTEGER)
    language plpgsql
AS $$
BEGIN
    RETURN QUERY EXECUTE proxy_select_sql(
        'SELECT * FROM users;', 
        'id VARCHAR, version INTEGER'
    );
END;
$$;


CREATE VIEW users AS (
    SELECT *
    FROM proxy_users()
);