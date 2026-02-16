-- Seed data for local development
-- This file runs on `supabase db reset`

-- =============================================================================
-- CLIENTS
-- =============================================================================
INSERT INTO clients (id, company_name, pic_email, pic_phone, current_risk_category) VALUES
    ('a1b2c3d4-0001-4000-8000-000000000001', 'PT Maju Bersama', 'finance@majubersama.co.id', '+6281234567001', 'LOW'),
    ('a1b2c3d4-0002-4000-8000-000000000002', 'CV Karya Mandiri', 'ap@karyamandiri.co.id', '+6281234567002', 'MEDIUM'),
    ('a1b2c3d4-0003-4000-8000-000000000003', 'PT Sentosa Abadi', 'billing@sentosaabadi.co.id', '+6281234567003', 'HIGH');

-- =============================================================================
-- INVOICES
-- =============================================================================
INSERT INTO invoices (id, client_id, invoice_number, amount, issued_date, due_date, status) VALUES
    -- PT Maju Bersama (LOW risk) — paid on time, one pending
    ('b2c3d4e5-0001-4000-8000-000000000001', 'a1b2c3d4-0001-4000-8000-000000000001', 'INV-2026-001', 15000000.00, '2025-12-15', '2026-01-15', 'PAID'),
    ('b2c3d4e5-0004-4000-8000-000000000004', 'a1b2c3d4-0001-4000-8000-000000000001', 'INV-2026-004', 22000000.00, '2026-02-01', '2026-03-01', 'UNPAID'),

    -- CV Karya Mandiri (MEDIUM risk) — one overdue, one partial
    ('b2c3d4e5-0002-4000-8000-000000000002', 'a1b2c3d4-0002-4000-8000-000000000002', 'INV-2026-002', 45000000.00, '2025-12-20', '2026-01-20', 'OVERDUE'),
    ('b2c3d4e5-0005-4000-8000-000000000005', 'a1b2c3d4-0002-4000-8000-000000000002', 'INV-2026-005', 30000000.00, '2026-01-10', '2026-02-10', 'PARTIAL'),

    -- PT Sentosa Abadi (HIGH risk) — overdue, long past due
    ('b2c3d4e5-0003-4000-8000-000000000003', 'a1b2c3d4-0003-4000-8000-000000000003', 'INV-2026-003', 120000000.00, '2025-11-01', '2025-12-01', 'OVERDUE'),
    ('b2c3d4e5-0006-4000-8000-000000000006', 'a1b2c3d4-0003-4000-8000-000000000003', 'INV-2026-006', 85000000.00, '2025-12-15', '2026-01-15', 'OVERDUE');

-- =============================================================================
-- PAYMENTS
-- days_late = payment_date - due_date (negative means early, positive means late)
-- =============================================================================
INSERT INTO payments (id, invoice_id, amount_paid, payment_date, days_late) VALUES
    -- PT Maju Bersama paid INV-001 on time (2 days early)
    ('c3d4e5f6-0001-4000-8000-000000000001', 'b2c3d4e5-0001-4000-8000-000000000001', 15000000.00, '2026-01-13', -2),

    -- CV Karya Mandiri partial payment on INV-005 (on time)
    ('c3d4e5f6-0002-4000-8000-000000000002', 'b2c3d4e5-0005-4000-8000-000000000005', 15000000.00, '2026-02-08', -2),

    -- PT Sentosa Abadi late partial on INV-003 (45 days late)
    ('c3d4e5f6-0003-4000-8000-000000000003', 'b2c3d4e5-0003-4000-8000-000000000003', 40000000.00, '2026-01-15', 45),

    -- PT Sentosa Abadi very late partial on INV-006 (20 days late)
    ('c3d4e5f6-0004-4000-8000-000000000004', 'b2c3d4e5-0006-4000-8000-000000000006', 25000000.00, '2026-02-04', 20);

-- =============================================================================
-- RISK SCORING LOGS
-- =============================================================================
INSERT INTO risk_scoring_logs (id, client_id, evaluation_date, probability_score, risk_label, model_version) VALUES
    ('d4e5f6a7-0001-4000-8000-000000000001', 'a1b2c3d4-0001-4000-8000-000000000001', '2026-02-01', 0.12, 'LOW', 'v0.1.0'),
    ('d4e5f6a7-0002-4000-8000-000000000002', 'a1b2c3d4-0002-4000-8000-000000000002', '2026-02-01', 0.55, 'MEDIUM', 'v0.1.0'),
    ('d4e5f6a7-0003-4000-8000-000000000003', 'a1b2c3d4-0003-4000-8000-000000000003', '2026-02-01', 0.89, 'HIGH', 'v0.1.0');

-- =============================================================================
-- REMINDER LOGS
-- =============================================================================
INSERT INTO reminder_logs (id, invoice_id, channel, message_type, message_content, delivery_status, sent_at) VALUES
    ('e5f6a7b8-0001-4000-8000-000000000001', 'b2c3d4e5-0002-4000-8000-000000000002', 'EMAIL', 'TEGAS',
        'Yth. CV Karya Mandiri, invoice INV-2026-002 senilai Rp45.000.000 telah melewati jatuh tempo. Mohon segera melakukan pembayaran.',
        'SENT', '2026-02-01 08:00:00+07'),
    ('e5f6a7b8-0002-4000-8000-000000000002', 'b2c3d4e5-0003-4000-8000-000000000003', 'EMAIL', 'PERINGATAN',
        'Yth. PT Sentosa Abadi, invoice INV-2026-003 senilai Rp120.000.000 telah melewati jatuh tempo selama 62 hari. Ini merupakan peringatan terakhir sebelum tindakan lebih lanjut.',
        'SENT', '2026-02-01 08:00:00+07'),
    ('e5f6a7b8-0003-4000-8000-000000000003', 'b2c3d4e5-0006-4000-8000-000000000006', 'WHATSAPP', 'PERINGATAN',
        'PT Sentosa Abadi: Invoice INV-2026-006 (Rp85.000.000) sudah lewat jatuh tempo 32 hari. Harap segera diselesaikan.',
        'FAILED', '2026-02-01 08:05:00+07');
