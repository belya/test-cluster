CREATE EXTENSION dblink;

CREATE FUNCTION get_users(
    po_id OUT VARCHAR,
    po_version OUT INTEGER
) RETURNS SETOF RECORD
    language plpgsql
AS $$
BEGIN
    RETURN QUERY 
        SELECT * 
        FROM dblink(
            'host=proxydb user=root password=root dbname=db', 
            'SELECT * FROM get_users();'
        ) AS t(id VARCHAR, version INTEGER);
END;
$$;