CREATE TABLE orders (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_email TEXT NOT NULL,
  amount_cents   INTEGER NOT NULL CHECK (amount_cents > 0),
  status         TEXT NOT NULL DEFAULT 'pending'
                 CHECK (status IN ('pending', 'paid', 'canceled')),
  created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE payments (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id       UUID NOT NULL REFERENCES orders(id),
    gateway        TEXT NOT NULL CHECK (gateway IN ('fakepay', 'mockbank')),
    gateway_payment_id TEXT UNIQUE,
    amount_cents   INTEGER NOT NULL CHECK (amount_cents > 0),               
    status         TEXT NOT NULL DEFAULT 'pending'
                    CHECK (status IN ('pending', 'processing', 'paid', 'failed', 'refunded', 'chargeback')),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_payments_order_id ON payments(order_id);

CREATE TABLE idempotency_keys (
  key           TEXT PRIMARY KEY,         -- o PRIMARY KEY já é UNIQUE: segura a "corrida" de 2 cliques
  request_hash  TEXT NOT NULL,            -- detecta mesma chave com conteúdo diferente
  status        TEXT NOT NULL CHECK (status IN ('processing', 'completed')),
  response_code INTEGER,
  response_body JSONB,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE webhook_events (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  gateway      TEXT NOT NULL,
  event_id     TEXT NOT NULL,
  payload      JSONB NOT NULL,
  processed_at TIMESTAMPTZ,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (gateway, event_id)              -- o mesmo evento do mesmo gateway só entra uma vez
);