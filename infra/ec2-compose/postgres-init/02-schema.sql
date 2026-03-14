-- Migration tracking
CREATE TABLE IF NOT EXISTS public.applied_migrations (
    id SERIAL PRIMARY KEY,
    site_name TEXT NOT NULL,
    migration_name TEXT NOT NULL,
    applied_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(site_name, migration_name)
);

-- PostgREST dynamic schema discovery
-- Called on each schema cache reload to register all site_* schemas
CREATE SCHEMA IF NOT EXISTS pgrst;
GRANT USAGE ON SCHEMA pgrst TO authenticator;

CREATE OR REPLACE FUNCTION pgrst.pre_config()
RETURNS void AS $$
DECLARE
    schemas TEXT;
BEGIN
    SELECT string_agg(schema_name, ', ' ORDER BY schema_name)
    INTO schemas
    FROM information_schema.schemata
    WHERE schema_name LIKE 'site\_%' ESCAPE '\';

    IF schemas IS NOT NULL THEN
        PERFORM set_config('pgrst.db_schemas', 'public, ' || schemas, true);
    ELSE
        PERFORM set_config('pgrst.db_schemas', 'public', true);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Helper: create a new site schema with proper grants
-- Usage: SELECT public.create_site_schema('mystore');
-- Creates schema site_mystore with read access for web_anon
CREATE OR REPLACE FUNCTION public.create_site_schema(p_site_name TEXT) RETURNS void AS $$
DECLARE
    s TEXT := 'site_' || replace(p_site_name, '-', '_');
BEGIN
    EXECUTE format('CREATE SCHEMA IF NOT EXISTS %I', s);
    EXECUTE format('GRANT USAGE ON SCHEMA %I TO web_anon', s);
    EXECUTE format('GRANT USAGE ON SCHEMA %I TO authenticator', s);

    -- Auto-grant read access on all future tables/views created by postgres
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA %I GRANT SELECT ON TABLES TO web_anon', s);
    EXECUTE format('ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA %I GRANT USAGE, SELECT ON SEQUENCES TO web_anon', s);
END;
$$ LANGUAGE plpgsql;
