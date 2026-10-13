# G&R Peças — Catálogo Digital Automotivo & Gestão de Estoque

Aplicação web moderna, interativa e 100% responsiva contendo o catálogo de **978 peças automotivas** com fotos reais originais, busca avançada multi-termo, filtros por categoria/estoque, botão direto para orçamento via WhatsApp e Painel de Administração protegido por senha.

---

## 🚀 Como subir para o GitHub e Vercel (Passo a Passo)

### Opção 1: Via Interface Web do GitHub (Mais Fácil)
1. Crie um novo repositório no seu GitHub (exemplo: `catalogo-gr-pecas`).
2. Extraia o conteúdo deste arquivo zip no seu computador.
3. Faça o upload de todos os arquivos (`index.html`, `products.json`, pasta `images/`, `vercel.json`, etc.) diretamente pelo botão **"Add file" > "Upload files"** no GitHub.
4. Acesse [vercel.com](https://vercel.com) e faça login com seu GitHub.
5. Clique em **"Add New..." > "Project"** e selecione o repositório `catalogo-gr-pecas`.
6. Mantenha as configurações padrão (Framework Preset: **Other**) e clique em **Deploy**.
7. Em menos de 30 segundos seu site estará online com domínio próprio gratuito (ex: `catalogo-gr-pecas.vercel.app`) e certificado SSL (HTTPS).

### Opção 2: Via Linha de Comando (Git CLI)
```bash
# 1. Dentro da pasta extraída:
git init
git add .
git commit -m "feat: Catálogo G&R Peças completo com fotos e painel admin"

# 2. Conecte ao seu repositório no GitHub:
git branch -M main
git remote add origin https://github.com/SEU_USUARIO/catalogo-gr-pecas.git
git push -u origin main
```
Em seguida, conecte o repositório na Vercel para deploy automático a cada commit.

---

## 🔒 Acesso ao Painel Administrativo
- **Atalho Secreto**: Pressione `Ctrl + Alt + A` (ou `Cmd + Option + A` no Mac).
- **Link no Rodapé**: Clique em `🔒 Área Restrita` no rodapé da página.
- **Senha Padrão Inicial**: `grpecas2026`
- **Recursos**: Adicionar peças, editar preços, códigos, aplicações e substituir fotos (com redimensionamento automático). Você pode alterar a senha a qualquer momento dentro do painel.

---

## 📁 Estrutura de Arquivos do Projeto
```text
├── index.html          # Aplicação web completa (layout, filtros, catálogo e admin)
├── products.json       # Base de dados estruturada de todas as 978 peças
├── vercel.json         # Configuração de cache e headers HTTP para Vercel
├── README.md           # Guia de implantação e documentação
├── .gitignore          # Arquivos ignorados pelo Git
└── images/             # Pasta com 977 fotos originais otimizadas (.jpg)
```
