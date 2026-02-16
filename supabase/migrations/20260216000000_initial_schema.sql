-- Initial schema: 5 tables matching the official ERD
-- Tables: clients, invoices, payments, risk_scoring_logs, reminder_logs

-- =============================================================================
-- CLIENTS (ERD: KLIEN)
-- =============================================================================
CREATE TABLE clients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name TEXT NOT NULL,
    pic_email TEXT NOT NULL,                -- TODO: encrypt AES-256 at app layer (NFR-01)
    pic_phone TEXT,                         -- TODO: encrypt AES-256 at app layer
    current_risk_category TEXT NOT NULL DEFAULT 'LOW'
        CHECK (current_risk_category IN ('LOW', 'MEDIUM', 'HIGH')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- =============================================================================
-- INVOICES (ERD: INVOICE)
-- =============================================================================
CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL REFERENCES clients(id),
    invoice_number TEXT NOT NULL UNIQUE,
    amount DECIMAL(15, 2) NOT NULL,
    issued_date DATE NOT NULL,
    due_date DATE NOT NULL,
    status TEXT NOT NULL DEFAULT 'UNPAID'
        CHECK (status IN ('UNPAID', 'PARTIAL', 'PAID', 'OVERDUE'))
);

-- =============================================================================
-- PAYMENTS (ERD: PEMBAYARAN)
-- Records each payment against an invoice.
-- `days_late` is the key ML feature: payment_date - due_date (negative = early).
-- =============================================================================
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID NOT NULL REFERENCES invoices(id),
    amount_paid DECIMAL(15, 2) NOT NULL,
    payment_date DATE NOT NULL,
    days_late INT NOT NULL DEFAULT 0
);

-- =============================================================================
-- RISK_SCORING_LOGS (ERD: RISK_SCORING_LOG)
-- Historical log of ML risk evaluations per client.
-- Never overwrite — always append. Use model_version to track drift.
-- =============================================================================
CREATE TABLE risk_scoring_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID NOT NULL REFERENCES clients(id),
    evaluation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    probability_score FLOAT NOT NULL,
    risk_label TEXT NOT NULL
        CHECK (risk_label IN ('LOW', 'MEDIUM', 'HIGH')),
    model_version TEXT NOT NULL
);

-- =============================================================================
-- REMINDER_LOGS (ERD: REMINDER_LOG)
-- Tracks every reminder sent. Check before sending to prevent same-day duplicates.
-- =============================================================================
CREATE TABLE reminder_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID NOT NULL REFERENCES invoices(id),
    channel TEXT NOT NULL
        CHECK (channel IN ('EMAIL', 'WHATSAPP', 'SMS')),
    message_type TEXT NOT NULL
        CHECK (message_type IN ('SOPAN', 'TEGAS', 'PERINGATAN')),
    message_content TEXT NOT NULL,
    delivery_status TEXT NOT NULL DEFAULT 'PENDING'
        CHECK (delivery_status IN ('PENDING', 'SENT', 'FAILED')),
    sent_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
