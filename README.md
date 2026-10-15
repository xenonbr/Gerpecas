# G&R Auto Peças — E-commerce & Catálogo Digital com Supabase Realtime

Aplicação completa de e-commerce e catálogo digital para a **G&R Auto Peças**, desenvolvida com integração direta ao **Supabase (PostgreSQL + Realtime)**, design moderno esportivo (vermelho vibrante `#E52421`, preto `#111111` e branco), fluxo completo de compras, carrinho interativo, checkout automatizado com integração ao WhatsApp e painel administrativo com gestão de estoque e pedidos.

---

## 🚀 Principais Funcionalidades

1. **Catálogo Completo com 978 Peças**:
   - Fotos reais de todas as peças (`images/p_*.jpg`).
   - Busca instantânea e inteligente por nome da peça, código original/SKU e compatibilidade veicular (ex: Tucson, Tiggo, Celler, JAC J3, etc.).
   - 22 categorias automotivas com contadores dinâmicos e esteira de rolagem automática contínua (marquee infinito suave que pausa ao passar o mouse).
   - Alternância entre modo **Grid (Cards com fotos)** e modo **Tabela (Lista compacta para balconistas e oficinas)**.

2. **Integração Nativa com Supabase**:
   - Conexão direta via `@supabase/supabase-js` com chave pública (publishable).
   - **Sincronização em Tempo Real (Realtime)**: Alterações de preço, estoque e novos pedidos refletem instantaneamente no navegador sem recarregar a página.
   - Fallback de alta disponibilidade: Se o banco estiver em manutenção, a loja continua operando 100% com o catálogo local pré-carregado.

3. **Experiência de Compra (E-commerce)**:
   - **Carrinho Lateral (Drawer)**: Ajuste de quantidade (+ / -), remoção de itens e cálculo dinâmico de subtotal e total em R$.
   - **Modal de Detalhes da Peça**: Foto ampliada, especificações completas, aplicação e preço baseado no atacado com parcelamento sob consulta.
   - **Checkout Completo**: Nome, telefone, modalidade de entrega (Retirada no Balcão ou Envio) e método de pagamento (PIX, Cartão ou Balcão).
   - **Criação de Pedidos**: Gravação automática nas tabelas `orders` e `order_items` do Supabase.
   - **Notificação no WhatsApp**: Geração automática de link formatado para envio direto do comprovante e protocolo do pedido à equipe da loja.

4. **Painel de Gestão Administrativa**:
   - Acesso seguro protegido por senha (padrão: `isadora2016`).
   - Métricas: Total de peças, itens em estoque, valor total do catálogo e pedidos recebidos.
   - **Importação em Lote via Excel (.xlsx) e CSV**: Ferramenta integrada no Painel Admin para subir centenas de peças novas de uma só vez, com leitura automática de colunas, pré-visualização e gravação direta no Supabase com barra de progresso.
   - **Planilha Modelo Disponível (`modelo_importacao_pecas.xlsx`)**: Modelo pronto para preenchimento com colunas de SKU, Descrição, Aplicação, Categoria, Preço de Atacado e Estoque.
   - CRUD de Peças (Cadastrar nova peça, editar preço/estoque/aplicação e excluir).
   - **Visualização Completa do Pedido ao Tocar na Linha**: Ao tocar/clicar em qualquer pedido, abre modal detalhado exibindo dados do cliente, endereço/modalidade de entrega, tabela com fotos reais das peças solicitadas, códigos SKU, valores unitários, quantidades e soma total, com atalho direto para conversar no WhatsApp e impressão profissional do pedido em Página Única Exata (A4 sem repetições nem páginas em branco via container isolado #printable-order-receipt) (gera comprovante limpo em nova janela e PDF) e botão para copiar resumo completo em texto para WhatsApp/bloco de notas.
   - Monitoramento de pedidos em tempo real com alteração de status (`pendente`, `confirmado`, `pago`, `enviado`, `concluido`, `cancelado`).
   - **Carga Inicial em 1 Clique (Seed)**: Ferramenta integrada com barra de progresso que envia as 22 categorias e as 978 peças diretamente para o Supabase.

---

## 🛠️ Configuração do Supabase (Passo a Passo)

### 1. Criar as Tabelas e Políticas de Segurança
Acesse o **SQL Editor** no painel do seu projeto Supabase e execute o conteúdo do arquivo `schema.sql`:
- Criação das tabelas `categories`, `products`, `orders`, `order_items`.
- Índices trigram (`gin_trgm_ops`) para busca ultra-rápida.
- Políticas de RLS (Row Level Security) liberando leitura pública do catálogo e inserção pública de pedidos.
- Criação do bucket de storage `product-images`.
- Habilitação da publicação `supabase_realtime`.

### 2. Inserir os Dados Iniciais (Seed)
Você tem duas opções fáceis:
- **Opção A (Via SQL Editor)**: Execute o arquivo `seed_data.sql` no SQL Editor do Supabase para inserir todas as 22 categorias e 978 peças de uma só vez.
- **Opção B (Via Painel da Loja)**: Abra o site, clique em **Admin** (senha: `isadora2016`), acerte na aba **Supabase** e clique no botão **"Fazer Carga Inicial no Supabase (978 Peças)"**.

---

## 💻 Executando o Projeto

O pacote inclui duas formas de execução:

### Modo 1: Execução Imediata (Zero-Build / Static)
Abra diretamente o arquivo `index.html` em qualquer navegador web ou suba no Vercel/Netlify. Já está 100% pronto para uso com o CDN do Supabase.

### Modo 2: Projeto Next.js 14 / React com Tailwind CSS
1. Instale as dependências:
   ```bash
   npm install
   ```
2. Configure as variáveis de ambiente em um arquivo `.env.local`:
   ```env
   NEXT_PUBLIC_SUPABASE_URL="https://tuonthoakooumzfrwffz.supabase.co"
   NEXT_PUBLIC_SUPABASE_KEY="sb_publishable_Oe22oUdWPYCn1IWcA_PnzQ_CgBHe2mr"
   ```
3. Inicie o servidor de desenvolvimento:
   ```bash
   npm run dev
   ```
4. Acesse `http://localhost:3000`.

---

## 📁 Estrutura de Arquivos

```text
├── index.html                # Aplicação web SPA completa e responsiva
├── schema.sql                # Estrutura SQL, tabelas, RLS e Storage do Supabase
├── seed_data.sql             # Carga inicial das 22 categorias e 978 produtos
├── products.json             # Catálogo de dados brutos
├── package.json              # Dependências do Next.js e Tailwind
├── tailwind.config.js        # Configurações de cores e tema (#E52421)
├── src/
│   ├── app/                  # App Router do Next.js (page.tsx, layout.tsx)
│   ├── components/           # Componentes modulares (Header, Hero, ProductCard, etc.)
│   └── lib/                  # Cliente Supabase, tipos TypeScript e utilitários
└── images/
    ├── logo.png              # Logotipo oficial da G&R Auto Peças
    └── p_1.jpg ... p_978.jpg # Fotos reais das 978 peças automotivas
```
