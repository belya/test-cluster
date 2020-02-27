-- PL/proxy START

CREATE FOREIGN DATA WRAPPER plproxy;

CREATE SERVER cluster FOREIGN DATA WRAPPER plproxy
OPTIONS (
    connection_lifetime '1800',
    p0 'host=db1 port=5432 user=root password=root dbname=db',
    p1 'host=db2 port=5432 user=root password=root dbname=db'
);

CREATE USER MAPPING
FOR PUBLIC
SERVER cluster;

-- handler function
CREATE OR REPLACE FUNCTION plproxy_call_handler ()
RETURNS language_handler AS 'plproxy' LANGUAGE C;

-- validator function
CREATE OR REPLACE FUNCTION plproxy_validator (oid)
RETURNS void AS 'plproxy' LANGUAGE C;

-- language
CREATE OR REPLACE LANGUAGE plproxy HANDLER plproxy_call_handler VALIDATOR plproxy_validator;

-- PL/proxy END

CREATE OR REPLACE FUNCTION get_users(
    po_id OUT VARCHAR,
    po_version OUT INTEGER
) RETURNS SETOF RECORD
LANGUAGE plproxy AS $$
    CLUSTER 'cluster';
    RUN ON ALL;
$$;

CREATE OR REPLACE FUNCTION increase_version() RETURNS SETOF VOID
LANGUAGE plproxy AS $$
    CLUSTER 'cluster';
    RUN ON ALL;
$$;

-- CREATE FUNCTION proxy_sql(sql VARCHAR, types VARCHAR) RETURNS VARCHAR
--     language plpgsql
-- AS $$
-- DECLARE
--     v_proxy_sql VARCHAR;
-- BEGIN
--     SELECT
--     string_agg(
--         'SELECT * FROM dblink('
--         || '''' || connstr || ''', '
--         || '''' || sql || ''')' 
--         || ' AS t_' || connname || '(' || types || ')', 
--         ' UNION '
--     )
--     INTO v_proxy_sql
--     FROM connections;

--     RETURN v_proxy_sql;
-- END;
-- $$;


-- -- TODO return records instead of table with fixed types
-- -- TODO add errors processing
-- CREATE FUNCTION select_proxy_users() RETURNS TABLE(id VARCHAR, version INTEGER)
--     language plpgsql
-- AS $$
-- BEGIN
--     RETURN QUERY EXECUTE proxy_sql(
--         'SELECT * FROM users;', 
--         'id VARCHAR, version INTEGER'
--     );
-- END;
-- $$;