-- Seed data for local development
-- This file runs on `supabase db reset`

-- Sample clients
INSERT INTO clients (id, name, email, risk_level) VALUES
    ('c1', 'PT Maju Bersama', 'finance@majubersama.co.id', 'low'),
    ('c2', 'CV Karya Mandiri', 'ap@karyamandiri.co.id', 'medium'),
    ('c3', 'PT Sentosa Abadi', 'billing@sentosaabadi.co.id', 'high');

-- Sample invoices
INSERT INTO invoices (id, client_id, amount, currency, status, due_date) VALUES
    ('inv-001', 'c1', 15000000, 'IDR', 'paid', '2026-01-15'),
    ('inv-002', 'c2', 45000000, 'IDR', 'overdue', '2026-01-20'),
    ('inv-003', 'c3', 120000000, 'IDR', 'overdue', '2025-12-01'),
    ('inv-004', 'c1', 22000000, 'IDR', 'pending', '2026-03-01');
