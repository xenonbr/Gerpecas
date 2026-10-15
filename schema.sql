-- G&R Auto Peças — Supabase Database Schema
CREATE TABLE IF NOT EXISTS categories (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  sku TEXT,
  name TEXT NOT NULL,
  application TEXT,
  price NUMERIC(10,2) DEFAULT 0,
  stock_quantity INT DEFAULT 1,
  is_active BOOLEAN DEFAULT TRUE,
  category_id INT REFERENCES categories(id),
  description TEXT,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_name TEXT,
  customer_phone TEXT,
  customer_address TEXT,
  total_amount NUMERIC(10,2) DEFAULT 0,
  payment_method TEXT DEFAULT 'PIX',
  status TEXT DEFAULT 'pendente',
  notes TEXT,
  order_items JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
