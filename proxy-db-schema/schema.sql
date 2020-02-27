-- PL/Proxy config START

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

-- PL/Proxy config END

CREATE OR REPLACE FUNCTION get_users(
    po_id       OUT VARCHAR,
    po_version  OUT INTEGER
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