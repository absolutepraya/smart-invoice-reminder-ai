#!/bin/bash
set -e

echo "=== Seeding local database ==="

cd supabase
supabase db reset
echo "Database seeded successfully."
