-- ============================================================================
-- G&R AUTO PEÇAS — SCHEMA COMPLETO DO BANCO DE DADOS (SUPABASE POSTGRESQL)
-- ============================================================================

-- DICA: Se você quiser recriar a estrutura do zero limpando tabelas antigas,
-- descomente as 4 linhas abaixo:
-- DROP TABLE IF EXISTS order_items CASCADE;
-- DROP TABLE IF EXISTS orders CASCADE;
-- DROP TABLE IF EXISTS products CASCADE;
-- DROP TABLE IF EXISTS categories CASCADE;

-- 1. EXTENSÕES
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- 2. TABELA: categories
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    slug VARCHAR(150) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 3. TABELA: products
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    sku VARCHAR(255),
    description TEXT,
    application TEXT,
    price NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    promotional_price NUMERIC(10,2),
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    image_url TEXT,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 4. MIGRAÇÃO AUTOMÁTICA (caso a tabela products já existisse com estrutura anterior)
DO $$
BEGIN
    -- Ajusta tipo do SKU para comportar múltiplos códigos originais cruzados (OEM)
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='sku') THEN
        ALTER TABLE products ALTER COLUMN sku TYPE VARCHAR(255);
    ELSE
        ALTER TABLE products ADD COLUMN sku VARCHAR(255);
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='name') THEN
        ALTER TABLE products ADD COLUMN name VARCHAR(255);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='description') THEN
        ALTER TABLE products ADD COLUMN description TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='application') THEN
        ALTER TABLE products ADD COLUMN application TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='promotional_price') THEN
        ALTER TABLE products ADD COLUMN promotional_price NUMERIC(10,2);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='stock_quantity') THEN
        ALTER TABLE products ADD COLUMN stock_quantity INTEGER DEFAULT 0;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='category_id') THEN
        ALTER TABLE products ADD COLUMN category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='image_url') THEN
        ALTER TABLE products ADD COLUMN image_url TEXT;
    END IF;
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='is_active') THEN
        ALTER TABLE products ADD COLUMN is_active BOOLEAN DEFAULT TRUE;
    END IF;

    -- Se existiam colunas antigas (code, desc, app, img), migra os dados existentes
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='code') THEN
        EXECUTE 'UPDATE products SET sku = code WHERE (sku IS NULL OR sku = '''') AND code IS NOT NULL';
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='desc') THEN
        EXECUTE 'UPDATE products SET name = "desc" WHERE (name IS NULL OR name = '''') AND "desc" IS NOT NULL';
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='app') THEN
        EXECUTE 'UPDATE products SET application = app WHERE (application IS NULL OR application = '''') AND app IS NOT NULL';
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='img') THEN
        EXECUTE 'UPDATE products SET image_url = img WHERE (image_url IS NULL OR image_url = '''') AND img IS NOT NULL';
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='products' AND column_name='in_stock') THEN
        EXECUTE 'UPDATE products SET is_active = in_stock, stock_quantity = CASE WHEN in_stock = true THEN 5 ELSE 0 END WHERE is_active IS NULL';
    END IF;
END $$;

-- 5. TABELA: orders
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    customer_name VARCHAR(200) NOT NULL,
    customer_phone VARCHAR(50) NOT NULL,
    customer_address TEXT,
    payment_method VARCHAR(50) DEFAULT 'PIX',
    total_amount NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(50) NOT NULL DEFAULT 'pendente',
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 6. TABELA: order_items
CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    price NUMERIC(10,2) NOT NULL DEFAULT 0.00
);

-- 7. ÍNDICES DE PERFORMANCE E BUSCA FULL-TEXT
CREATE INDEX IF NOT EXISTS idx_products_sku ON products(sku);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_is_active ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_products_name_trgm ON products USING gin (name gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_products_app_trgm ON products USING gin (application gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at DESC);

-- 8. TRIGGER PARA ATUALIZAÇÃO AUTOMÁTICA DE updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_products_updated_at ON products;
CREATE TRIGGER trigger_products_updated_at
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- 9. POLÍTICAS DE SEGURANÇA (ROW LEVEL SECURITY - RLS)
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Leitura pública do catálogo
DROP POLICY IF EXISTS "Public can read categories" ON categories;
CREATE POLICY "Public can read categories" ON categories FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public can read products" ON products;
CREATE POLICY "Public can read products" ON products FOR SELECT USING (true);

-- Modificações de produtos e categorias (Chave anon / autenticado)
DROP POLICY IF EXISTS "Allow public full access categories" ON categories;
CREATE POLICY "Allow public full access categories" ON categories FOR ALL USING (true);

DROP POLICY IF EXISTS "Allow public full access products" ON products;
CREATE POLICY "Allow public full access products" ON products FOR ALL USING (true);

-- Criação e leitura de pedidos
DROP POLICY IF EXISTS "Public can create orders" ON orders;
CREATE POLICY "Public can create orders" ON orders FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Public can read orders" ON orders;
CREATE POLICY "Public can read orders" ON orders FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public can update orders" ON orders;
CREATE POLICY "Public can update orders" ON orders FOR UPDATE USING (true);

DROP POLICY IF EXISTS "Public can delete orders" ON orders;
CREATE POLICY "Public can delete orders" ON orders FOR DELETE USING (true);

DROP POLICY IF EXISTS "Public can delete order items" ON order_items;
CREATE POLICY "Public can delete order items" ON order_items FOR DELETE USING (true);

DROP POLICY IF EXISTS "Public can insert order items" ON order_items;
CREATE POLICY "Public can insert order items" ON order_items FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Public can read order items" ON order_items;
CREATE POLICY "Public can read order items" ON order_items FOR SELECT USING (true);

-- 10. HABILITAÇÃO DO REALTIME (POSTGRES CHANGES)
DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE products;
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE orders;
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

-- 11. STORAGE BUCKET: product-images
INSERT INTO storage.buckets (id, name, public)
VALUES ('product-images', 'product-images', true)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "Public Access product-images" ON storage.objects;
CREATE POLICY "Public Access product-images" ON storage.objects
FOR SELECT USING (bucket_id = 'product-images');

DROP POLICY IF EXISTS "Public Upload product-images" ON storage.objects;
CREATE POLICY "Public Upload product-images" ON storage.objects
FOR INSERT WITH CHECK (bucket_id = 'product-images');
