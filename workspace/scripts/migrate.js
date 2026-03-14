#!/usr/bin/env node
const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

const siteName = process.argv[2];
if (!siteName) {
  console.error('Usage: node migrate.js <site-name>');
  process.exit(1);
}

if (!/^[a-z0-9][a-z0-9-]*$/.test(siteName)) {
  console.error('Invalid site name: must be lowercase letters, numbers, and hyphens');
  process.exit(1);
}

const schema = 'site_' + siteName.replace(/-/g, '_');
const sitesBase = process.env.SITES_DIR || path.join(__dirname, '..', 'sites');
const migrationsDir = path.join(sitesBase, siteName, 'migrations');

async function migrate() {
  const client = new Client({ connectionString: process.env.DATABASE_URL });
  await client.connect();

  try {
    // Create schema with proper grants
    await client.query('SELECT public.create_site_schema($1)', [siteName]);
    console.log(`Schema "${schema}" ready.`);

    // Check for migrations directory
    if (!fs.existsSync(migrationsDir)) {
      console.log('No migrations/ directory found. Schema created, skipping migrations.');
      return;
    }

    // Get pending migration files
    const files = fs.readdirSync(migrationsDir)
      .filter(f => f.endsWith('.sql'))
      .sort();

    if (files.length === 0) {
      console.log('No migration files found.');
      return;
    }

    // Set search path to site schema
    await client.query(`SET search_path TO "${schema}", public`);

    for (const file of files) {
      // Check if already applied
      const { rows } = await client.query(
        'SELECT 1 FROM public.applied_migrations WHERE site_name = $1 AND migration_name = $2',
        [siteName, file]
      );

      if (rows.length > 0) {
        console.log(`  skip: ${file} (already applied)`);
        continue;
      }

      // Apply migration
      const sql = fs.readFileSync(path.join(migrationsDir, file), 'utf8');
      await client.query(sql);
      await client.query(
        'INSERT INTO public.applied_migrations (site_name, migration_name) VALUES ($1, $2)',
        [siteName, file]
      );
      console.log(`  applied: ${file}`);
    }

    // Notify PostgREST to reload schema cache
    await client.query("NOTIFY pgrst, 'reload config'");
    console.log('PostgREST notified to reload schemas.');
  } finally {
    await client.end();
  }
}

migrate().catch(err => {
  console.error('Migration failed:', err.message);
  process.exit(1);
});
