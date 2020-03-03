CREATE EXTENSION dblink;

CREATE OR REPLACE FUNCTION dwh_get_users(
    po_id       OUT VARCHAR,
    po_version  OUT INTEGER
) RETURNS SETOF RECORD
    language plpgsql
AS $$
DECLARE
BEGIN
    RETURN QUERY 
        SELECT * 
        FROM dblink(
            'host=proxydb user=root password=root dbname=db', 
            'SELECT * FROM get_users();'
        ) AS t(id VARCHAR, version INTEGER);
END;
$$;
