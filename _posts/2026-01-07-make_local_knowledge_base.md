---
layout: post
title:  "构建自己的本地知识库"
categories: experience
tags: knowledge base
author: David
---

* content
{:toc}

在“仅用于自己查询、不上传任何信息到云端”的前提下，构建本地知识库的核心目标是：**完全离线、数据安全、高效检索**。下面是一个系统化的构建方案，涵盖工具选择、数据处理、检索方式等关键环节：

### 一、整体架构（完全本地化）

```
[本地文档/数据源]  
       ↓  
[文档解析 & 向量化] → [本地向量数据库]  
       ↓  
[本地大模型（LLM）] ←→ [本地检索系统]  
       ↓  
[用户界面 / 查询入口]
```

所有组件均运行在你的个人电脑或局域网服务器上，无需联网。

---

### 二、关键组件与工具推荐（开源 + 本地运行）

#### 1. **文档解析与预处理**
- 支持格式：PDF、Word、TXT、Markdown、网页快照、笔记（如 Obsidian/Logseq 导出）等。
- 工具：
  - `Unstructured`（Python 库）：智能解析多种文档。
  - `PyPDF2` / `pdfplumber`：处理 PDF。
  - `BeautifulSoup`：解析 HTML。
  - 对于 Obsidian 等笔记系统，可直接读取 Markdown 文件。

#### 2. **文本分块（Chunking）**
- 将长文档切分为适合检索的片段（如 300–500 字）。
- 可使用重叠分块（overlap）保留上下文。
- 工具：LangChain 的 `RecursiveCharacterTextSplitter` 或自定义逻辑。

#### 3. **文本向量化（Embedding）**
- 将文本转换为向量（用于语义搜索）。
- **推荐本地嵌入模型**（无需联网）：
  - `BAAI/bge-small-zh-v1.5`（中文优化，轻量高效）
  - `m3e-small`（中文社区常用）
  - `all-MiniLM-L6-v2`（英文/多语言，极小）
- 使用 `sentence-transformers` 库本地加载模型。

#### 4. **本地向量数据库**
- 存储和检索向量，支持相似性搜索。
- **推荐**：
  - **ChromaDB**：轻量、嵌入式、Python 友好，支持持久化。
  - **FAISS**（Facebook）：高效，适合静态知识库。
  - **Qdrant**（可本地运行）：功能更强，支持过滤、多向量等。
  - **SQLite + Vector 扩展**（如 sqlite-vss）：极简方案。

> ✅ 所有数据库均可配置为仅保存在本地磁盘，不联网。

#### 5. **本地大语言模型（用于生成答案）**
- 可选：如果你希望模型基于检索到的内容“总结”或“回答”，而非仅返回原文。
- **推荐本地 LLM**（7B 以下可在消费级 GPU 或 CPU 运行）：
  - **中文**：`Qwen1.5-4B-Chat`、`Yi-1.5-6B-Chat`、`DeepSeek-Coder`（若含代码）
  - **多语言/英文**：`Mistral-7B`、`Phi-3-mini`（微软，性能强且小）
- **运行框架**：
  - `Ollama`（最简单，一键运行模型）
  - `LM Studio`（图形界面，支持聊天和 API）
  - `llama.cpp`（CPU 友好，量化后可在普通笔记本运行）

#### 6. **检索增强生成（RAG）本地实现**
- 流程：
  1. 用户提问 → 用本地嵌入模型转为向量。
  2. 在本地向量库中搜索最相关的 3–5 个文本块。
  3. 将问题 + 检索结果拼接为提示（prompt），送入本地 LLM 生成答案。
- 可用 `LangChain` 或 `LlamaIndex` 构建本地 RAG 流程（设置 `offline=True`，禁用网络）。

#### 7. **用户界面（可选）**
- 命令行（最简单）
- Web 界面（如用 `Gradio` 或 `Streamlit` 快速搭建本地 UI）
- Obsidian 插件（如 `Smart Connections` + `Local LLM` 集成）

---

### 三、数据安全与隐私保障

- 所有数据存储在本地磁盘（如 `~/my_knowledge_base/`）。
- 向量数据库文件（如 Chroma 的 persist directory）也保存在本地。
- 使用 `ollama serve` 或 `lmstudio` 时，确保禁用远程访问（默认仅 `localhost`）。
- 可对敏感数据加密（如使用 VeraCrypt 创建加密卷存放知识库）。

---

### 四、简易搭建流程（示例）

1. 安装 Python 和必要库：
   ```bash
   pip install langchain chromadb sentence-transformers unstructured
   ```

2. 下载中文嵌入模型（首次运行自动下载到本地）：
   ```python
   from sentence_transformers import SentenceTransformer
   model = SentenceTransformer('BAAI/bge-small-zh-v1.5')
   ```

3. 构建向量库（以 Chroma 为例）：
   ```python
   from langchain_chroma import Chroma
   from langchain_community.embeddings import HuggingFaceBgeEmbeddings

   embeddings = HuggingFaceBgeEmbeddings(model_name="BAAI/bge-small-zh-v1.5")
   vectorstore = Chroma.from_documents(
       documents=your_docs,
       embedding=embeddings,
       persist_directory="./chroma_db"
   )
   ```

4. 本地查询（无需 LLM 也可直接返回相关段落）：
   ```python
   results = vectorstore.similarity_search("你的问题", k=3)
   print(results)
   ```

5. 若需 LLM 生成答案，用 Ollama 启动模型：
   ```bash
   ollama pull qwen:4b
   ollama run qwen:4b
   ```
   再通过 API 或 LangChain 调用。

---

### 五、进阶建议

- **定期备份**：知识库文件（向量库 + 原始文档）定期加密备份。
- **增量更新**：支持新增/删除文档后更新向量库。
- **多模态扩展**：未来可加入图片 OCR（Tesseract + PaddleOCR 本地运行）。

---

### 总结

✅ 完全本地  
✅ 无数据上传  
✅ 中文友好  
✅ 开源免费  
✅ 可在普通电脑运行（尤其使用 4B 以下模型 + Chroma/FAISS）

只要你有一台个人电脑（最好是 16GB+ 内存，如有独立 GPU 更佳），就可以搭建一个**私密、安全、高效**的个人知识库系统。

---

以下是一个**完全本地化、无需联网、不上传任何数据到云端**的中文个人知识库构建教程，使用开源工具和模型。我们将使用：

- **文档格式**：本地 Markdown / TXT / PDF（以 Markdown 为例）
- **嵌入模型**：`BAAI/bge-small-zh-v1.5`（中文优化，本地运行）
- **向量数据库**：ChromaDB（轻量、支持持久化）
- **大模型（可选）**：Qwen 4B（通过 Ollama 本地运行）
- **框架**：Python + LangChain（仅用于流程编排，不联网）
- **运行环境**：Windows / macOS / Linux 均可（推荐 Python 3.10+）

---

## 🧰 第一步：准备工作

### 1.1 安装 Python（建议 3.10 或 3.11）
从 [python.org](https://www.python.org/downloads/) 下载并安装。

### 1.2 创建项目目录
```bash
mkdir ~/local_knowledge_base
cd ~/local_knowledge_base
```

### 1.3 创建虚拟环境（推荐）
```bash
python -m venv venv
source venv/bin/activate      # macOS/Linux
# 或
venv\Scripts\activate         # Windows
```

### 1.4 安装依赖包
```bash
pip install langchain \
            langchain-community \
            langchain-chroma \
            chromadb \
            sentence-transformers \
            unstructured \
            unstructured[local-inference] \
            pdf2image \
            PyPDF2 \
            ollama \
            python-dotenv
```

> ⚠️ 如果你**不需要 PDF 解析**，可跳过 `pdf2image` 和 `PyPDF2`。
>
> ⚠️ 首次运行 `sentence-transformers` 会**自动下载模型到本地缓存**（约 130MB），但**不需要联网之后也能用**。如果你完全不能联网，请提前在有网环境下载好模型（见附录）。

---

## 📁 第二步：准备你的知识文档

在项目目录下创建一个 `docs/` 文件夹，放入你的文档，例如：

```
local_knowledge_base/
├── docs/
│   ├── note1.md
│   ├── note2.md
│   └── my_book_summary.txt
```

> 支持格式：`.txt`, `.md`, `.pdf`（后续可扩展）

---

## 🧩 第三步：编写文档加载与分块脚本

创建文件：`ingest.py`

```python
# ingest.py
import os
from langchain_community.document_loaders import (
    DirectoryLoader,
    TextLoader,
    UnstructuredMarkdownLoader,
    PyPDFLoader
)
from langchain_text_splitters import RecursiveCharacterTextSplitter

# 配置路径
DOCS_DIR = "./docs"
PERSIST_DIR = "./chroma_db"

def load_documents():
    """加载所有支持的文档"""
    documents = []

    # 加载 .txt 文件
    txt_loader = DirectoryLoader(DOCS_DIR, glob="*.txt", loader_cls=TextLoader, loader_kwargs={"encoding": "utf-8"})
    documents.extend(txt_loader.load())

    # 加载 .md 文件
    md_loader = DirectoryLoader(DOCS_DIR, glob="*.md", loader_cls=UnstructuredMarkdownLoader)
    documents.extend(md_loader.load())

    # 加载 .pdf 文件（可选）
    # pdf_loader = DirectoryLoader(DOCS_DIR, glob="*.pdf", loader_cls=PyPDFLoader)
    # documents.extend(pdf_loader.load())

    print(f"✅ 共加载 {len(documents)} 个文档片段")
    return documents

def split_documents(documents):
    """将文档切分为小块"""
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=500,
        chunk_overlap=50,
        length_function=len,
        is_separator_regex=False,
    )
    chunks = text_splitter.split_documents(documents)
    print(f"✅ 切分为 {len(chunks)} 个文本块")
    return chunks

if __name__ == "__main__":
    docs = load_documents()
    chunks = split_documents(docs)

    # 保存到临时文件（用于下一步嵌入）
    os.makedirs(PERSIST_DIR, exist_ok=True)
    with open(os.path.join(PERSIST_DIR, "chunks.txt"), "w", encoding="utf-8") as f:
        for i, chunk in enumerate(chunks):
            f.write(f"--- Chunk {i} ---\n")
            f.write(chunk.page_content + "\n\n")
    print("✅ 文本块已保存（供调试）")
```

运行：
```bash
python ingest.py
```

> ✅ 此时会在 `chroma_db/chunks.txt` 中看到切分后的文本（可选，仅调试用）

---

## 🧠 第四步：构建本地向量数据库（使用 BGE 中文嵌入模型）

创建文件：`build_vector_db.py`

```python
# build_vector_db.py
from langchain_chroma import Chroma
from langchain_community.embeddings import HuggingFaceBgeEmbeddings
from ingest import load_documents, split_documents
import os

# 嵌入模型配置（完全本地）
embedding_model_name = "BAAI/bge-small-zh-v1.5"
model_kwargs = {'device': 'cpu'}          # 若有 GPU 可改为 'cuda'
encode_kwargs = {'normalize_embeddings': True}  # BGE 推荐设置

embeddings = HuggingFaceBgeEmbeddings(
    model_name=embedding_model_name,
    model_kwargs=model_kwargs,
    encode_kwargs=encode_kwargs,
    query_instruction="为这个句子生成表示以用于检索相关文章："  # BGE 中文模型推荐 query 指令
)

PERSIST_DIR = "./chroma_db"

def build_vector_db():
    print("🔍 正在加载文档...")
    docs = load_documents()
    chunks = split_documents(docs)

    print("🧠 正在生成向量并构建数据库（首次运行会下载模型到本地缓存）...")
    vectorstore = Chroma.from_documents(
        documents=chunks,
        embedding=embeddings,
        persist_directory=PERSIST_DIR,
        collection_name="my_knowledge"
    )
    print(f"✅ 向量数据库已保存到 {PERSIST_DIR}")

if __name__ == "__main__":
    build_vector_db()
```

运行：
```bash
python build_vector_db.py
```

> ⏳ 首次运行会自动下载 `BAAI/bge-small-zh-v1.5` 模型（约 130MB）到 `~/.cache/huggingface/`，**之后完全离线可用**。
>
> ✅ 数据库文件将保存在 `./chroma_db/`，**仅在本地磁盘**。

---

## 🔍 第五步：本地语义检索（不依赖大模型，直接返回相关段落）

创建文件：`query.py`

```python
# query.py
from langchain_chroma import Chroma
from langchain_community.embeddings import HuggingFaceBgeEmbeddings

embedding_model_name = "BAAI/bge-small-zh-v1.5"
model_kwargs = {'device': 'cpu'}
encode_kwargs = {'normalize_embeddings': True}

embeddings = HuggingFaceBgeEmbeddings(
    model_name=embedding_model_name,
    model_kwargs=model_kwargs,
    encode_kwargs=encode_kwargs,
    query_instruction="为这个句子生成表示以用于检索相关文章："
)

vectorstore = Chroma(
    persist_directory="./chroma_db",
    embedding_function=embeddings,
    collection_name="my_knowledge"
)

def search(query: str, k: int = 3):
    docs = vectorstore.similarity_search(query, k=k)
    print(f"\n🔍 问题：{query}\n")
    for i, doc in enumerate(docs):
        print(f"【结果 {i+1}】（来源: {doc.metadata.get('source', '未知')}）")
        print(doc.page_content[:500] + "...\n")
    return docs

if __name__ == "__main__":
    while True:
        question = input("\n请输入你的问题（输入 'quit' 退出）：")
        if question.lower() == 'quit':
            break
        search(question)
```

运行：
```bash
python query.py
```

> ✅ 此时你可以直接提问，系统会返回最相关的原文片段，**完全本地、无网络请求**。

---

## 🤖 第六步（可选）：使用本地大模型生成答案（RAG）

### 6.1 安装 Ollama（https://ollama.com/）
- 下载并安装 Ollama（支持 Windows/macOS/Linux）
- 安装后，**默认只监听 localhost，不联网**

### 6.2 拉取本地中文模型（首次需要联网，之后离线可用）
```bash
ollama pull qwen:4b
```

> 模型大小约 2.5GB（4-bit 量化版），可在 16GB 内存笔记本 CPU 运行（稍慢）。

### 6.3 创建 RAG 查询脚本：`rag_query.py`

```python
# rag_query.py
from langchain_chroma import Chroma
from langchain_community.embeddings import HuggingFaceBgeEmbeddings
from langchain_ollama import OllamaLLM
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser

# === 配置 ===
embedding_model_name = "BAAI/bge-small-zh-v1.5"
llm_model = "qwen:4b"  # Ollama 中的模型名

# === 嵌入与向量库 ===
embeddings = HuggingFaceBgeEmbeddings(
    model_name=embedding_model_name,
    model_kwargs={'device': 'cpu'},
    encode_kwargs={'normalize_embeddings': True},
    query_instruction="为这个句子生成表示以用于检索相关文章："
)

vectorstore = Chroma(
    persist_directory="./chroma_db",
    embedding_function=embeddings,
    collection_name="my_knowledge"
)
retriever = vectorstore.as_retriever(search_kwargs={"k": 3})

# === LLM 与 Prompt ===
llm = OllamaLLM(model=llm_model, temperature=0.3)

template = """
你是一个知识助手，请根据以下提供的上下文信息回答问题。
只使用上下文中的内容，不要编造。如果上下文没有相关信息，请回答“根据现有资料无法回答”。

上下文：
{context}

问题：{question}
答案：
"""

prompt = ChatPromptTemplate.from_template(template)

# === RAG 链 ===
rag_chain = (
    {"context": retriever, "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)

# === 查询 ===
if __name__ == "__main__":
    while True:
        question = input("\n🧠 请输入你的问题（'quit' 退出）：")
        if question.lower() == 'quit':
            break
        print("\n🤔 正在思考...\n")
        answer = rag_chain.invoke(question)
        print(f"✅ 答案：{answer}\n")
```

> ⚠️ 确保 Ollama 正在运行（终端输入 `ollama serve`，或后台已启动）

运行：
```bash
python rag_query.py
```

> ✅ 此时系统会：
> 1. 用本地嵌入模型检索相关段落
> 2. 将段落 + 问题交给本地 Qwen 模型
> 3. 生成自然语言答案
> **全程无任何数据上传到网络**

---

## 🔒 隐私与安全说明

- 所有数据（原始文档、向量库、模型缓存）均保存在你的电脑。
- ChromaDB 默认保存在 `./chroma_db/`
- Hugging Face 模型缓存路径：`~/.cache/huggingface/hub/`
- Ollama 模型路径：
  - macOS: `~/.ollama/models/`
  - Windows: `C:\Users\<user>\.ollama\models\`
  - Linux: `~/.ollama/models/`
- 可将整个 `local_knowledge_base` 文件夹放入加密磁盘（如 VeraCrypt）进一步保护。

---

## 📌 附录：完全离线使用（提前下载模型）

如果你**完全不能联网**，请在有网络的机器上提前下载：

### A. 下载嵌入模型
```python
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('BAAI/bge-small-zh-v1.5')
model.save('./bge-small-zh')  # 保存到本地
```

然后修改代码中 `model_name='./bge-small-zh'`

### B. 下载 Ollama 模型后复制到目标机器
Ollama 模型可直接复制 `~/.ollama/models/` 到另一台机器（需相同架构）。

---

## ✅ 总结

你现在已经拥有一个：

- ✅ **100% 本地运行**
- ✅ **支持中文**
- ✅ **无需上传任何数据**
- ✅ **可扩展（PDF/Word/笔记）**
- ✅ **支持语义检索 + 智能问答**

的私人知识库系统！


# 需要图形界面以及自动监控文档更新

在已有**完全本地、离线、隐私安全**的知识库基础上，我们可以进一步：

1. **添加图形界面（GUI）**：使用 Streamlit 快速搭建 Web 界面（仅本地访问）  
2. **实现自动监控文档更新**：使用 `watchdog` 监听 `docs/` 目录变化，自动增量更新向量库  

> ✅ 依然 **不联网、不上传任何数据**，所有组件运行在本地。

---

## ✅ 最终目标架构

```
[docs/ 目录] ←─(watchdog 监控)─┐
                              ↓
[用户通过浏览器访问 http://localhost:8501]  
                              ↓  
[Streamlit GUI] → [检索/问答逻辑] → [ChromaDB + 本地 LLM]
                              ↑  
（文档变更时自动触发 rebuild 向量库）
```

---

## 第一步：安装额外依赖

```bash
pip install streamlit watchdog
```

---

## 第二步：实现“自动监控文档更新 + 增量更新向量库”

> 注意：ChromaDB 本身**不支持高效增量删除**，但我们可以：
> - **简单方案**：监控到变化 → 重新构建整个向量库（适合 <1000 文档）
> - **进阶方案**：记录文档 hash，只更新变更/新增的 chunk（本文采用简单方案，清晰可靠）

### 创建 `auto_updater.py`

```python
# auto_updater.py
import os
import time
import hashlib
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
from build_vector_db import build_vector_db  # 复用之前写的构建函数

DOCS_DIR = "./docs"
STATE_FILE = "./chroma_db/update_state.txt"

def compute_docs_hash():
    """计算 docs/ 目录下所有文件的 hash，用于判断是否变化"""
    hash_md5 = hashlib.md5()
    paths = sorted(Path(DOCS_DIR).rglob("*"))
    for path in paths:
        if path.is_file():
            stat = path.stat()
            hash_md5.update(str(stat.st_mtime).encode())
            hash_md5.update(str(stat.st_size).encode())
    return hash_md5.hexdigest()

def load_last_hash():
    if os.path.exists(STATE_FILE):
        with open(STATE_FILE, "r") as f:
            return f.read().strip()
    return None

def save_current_hash():
    current_hash = compute_docs_hash()
    os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)
    with open(STATE_FILE, "w") as f:
        f.write(current_hash)

class DocUpdateHandler(FileSystemEventHandler):
    def __init__(self, callback):
        self.callback = callback
        self.last_trigger = 0

    def on_any_event(self, event):
        # 防抖：5 秒内只触发一次
        if time.time() - self.last_trigger > 5:
            if event.src_path.endswith(('.txt', '.md', '.pdf')):
                print(f"\n📁 检测到文档变更: {event.src_path}")
                self.last_trigger = time.time()
                self.callback()

def start_watcher():
    """启动文件监控"""
    observer = Observer()
    event_handler = DocUpdateHandler(on_docs_changed)
    observer.schedule(event_handler, DOCS_DIR, recursive=True)
    observer.start()
    print(f"👀 正在监控 {os.path.abspath(DOCS_DIR)} 目录...")

    # 初始检查是否需要首次构建
    if not os.path.exists("./chroma_db/chroma.sqlite3"):  # ChromaDB 默认文件
        print("🆕 首次运行：正在构建向量库...")
        build_vector_db()
        save_current_hash()
    else:
        current_hash = compute_docs_hash()
        last_hash = load_last_hash()
        if current_hash != last_hash:
            print("🔄 检测到历史变更：正在重建向量库...")
            build_vector_db()
            save_current_hash()

    return observer

def on_docs_changed():
    """文档变更时的回调"""
    build_vector_db()
    save_current_hash()
    print("✅ 向量库已更新！")
```

---

## 第三步：改造 `build_vector_db.py`（支持被调用）

修改 `build_vector_db.py`，使其可被其他模块调用而不重复初始化模型：

```python
# build_vector_db.py（修改版）
from langchain_chroma import Chroma
from langchain_community.embeddings import HuggingFaceBgeEmbeddings
from ingest import load_documents, split_documents
import os
import shutil

PERSIST_DIR = "./chroma_db"
embedding_model_name = "BAAI/bge-small-zh-v1.5"
model_kwargs = {'device': 'cpu'}
encode_kwargs = {'normalize_embeddings': True}
query_instruction = "为这个句子生成表示以用于检索相关文章："

# 全局嵌入模型（避免重复加载）
_EMBEDDING_MODEL = None

def get_embedding_model():
    global _EMBEDDING_MODEL
    if _EMBEDDING_MODEL is None:
        _EMBEDDING_MODEL = HuggingFaceBgeEmbeddings(
            model_name=embedding_model_name,
            model_kwargs=model_kwargs,
            encode_kwargs=encode_kwargs,
            query_instruction=query_instruction
        )
    return _EMBEDDING_MODEL

def build_vector_db():
    """构建向量数据库（覆盖写入）"""
    # 删除旧数据库（Chroma 不支持高效更新）
    if os.path.exists(PERSIST_DIR):
        shutil.rmtree(PERSIST_DIR)
        os.makedirs(PERSIST_DIR)

    docs = load_documents()
    chunks = split_documents(docs)

    embeddings = get_embedding_model()
    print("🧠 正在生成向量...")
    Chroma.from_documents(
        documents=chunks,
        embedding=embeddings,
        persist_directory=PERSIST_DIR,
        collection_name="my_knowledge"
    )
    print("✅ 向量库重建完成")
```

---

## 第四步：创建图形界面（Streamlit）

### 创建 `app.py`

```python
# app.py
import streamlit as st
from langchain_chroma import Chroma
from build_vector_db import get_embedding_model
from langchain_ollama import OllamaLLM
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.runnables import RunnablePassthrough
from langchain_core.output_parsers import StrOutputParser
import os

# === 配置 ===
PERSIST_DIR = "./chroma_db"
USE_RAG = True  # 设为 False 则只返回检索结果

# === 初始化 ===
@st.cache_resource
def get_retriever():
    embeddings = get_embedding_model()
    vectorstore = Chroma(
        persist_directory=PERSIST_DIR,
        embedding_function=embeddings,
        collection_name="my_knowledge"
    )
    return vectorstore.as_retriever(search_kwargs={"k": 3})

@st.cache_resource
def get_rag_chain():
    retriever = get_retriever()
    llm = OllamaLLM(model="qwen:4b", temperature=0.3)
    template = """
你是一个知识助手，请根据以下提供的上下文信息回答问题。
只使用上下文中的内容，不要编造。如果上下文没有相关信息，请回答“根据现有资料无法回答”。

上下文：
{context}

问题：{question}
答案：
"""
    prompt = ChatPromptTemplate.from_template(template)
    return (
        {"context": retriever, "question": RunnablePassthrough()}
        | prompt
        | llm
        | StrOutputParser()
    )

# === Streamlit UI ===
st.set_page_config(page_title="我的本地知识库", layout="wide")
st.title("🧠 我的本地知识库（完全离线）")

# 输入框
query = st.text_input("请输入你的问题：", placeholder="例如：项目的关键时间节点是什么？")

if query:
    with st.spinner("正在检索和思考..."):
        if USE_RAG:
            try:
                answer = get_rag_chain().invoke(query)
                st.subheader("✅ 答案")
                st.write(answer)
            except Exception as e:
                st.error(f"模型调用失败（请确认 Ollama 正在运行）：{str(e)}")
                USE_RAG = False  # 回退到仅检索
        
        # 显示检索到的原文（始终显示）
        retriever = get_retriever()
        docs = retriever.invoke(query)
        st.subheader("📚 相关原文片段")
        for i, doc in enumerate(docs):
            source = doc.metadata.get("source", "未知")
            st.markdown(f"**来源 {i+1}:** `{os.path.basename(source)}`")
            st.text_area("", doc.page_content, height=150, key=f"doc_{i}")

# 侧边栏
with st.sidebar:
    st.header("⚙️ 系统状态")
    db_exists = os.path.exists(os.path.join(PERSIST_DIR, "chroma.sqlite3"))
    st.success("🟢 向量库已加载") if db_exists else st.warning("🔴 向量库未构建")
    
    ollama_status = "🟢 Ollama 可用（若启用 RAG）" if USE_RAG else "⚪ 仅检索模式"
    st.write(ollama_status)
    
    st.info("📁 文档目录: `./docs`")
    st.info("🔒 所有数据仅保存在本地")
```

---

## 第五步：启动完整系统

### 创建启动脚本 `start.sh`（Linux/macOS）或 `start.bat`（Windows）

#### `start.sh`
```bash
#!/bin/bash
source venv/bin/activate

# 启动监控
python -c "
from auto_updater import start_watcher
import time
observer = start_watcher()
try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    observer.stop()
    observer.join()
" &
WATCHER_PID=$!

# 启动 Streamlit
streamlit run app.py --server.port=8501 --server.address=127.0.0.1

# 停止监控
kill $WATCHER_PID
```

#### Windows (`start.bat`)
```bat
@echo off
call venv\Scripts\activate

start /B python -c "from auto_updater import start_watcher; import time; o=start_watcher(); time.sleep(100000)" ^

streamlit run app.py --server.port=8501 --server.address=127.0.0.1
```

> 💡 **更简单的做法**：开两个终端分别运行：
> ```bash
> # 终端 1：启动监控
> python -c "from auto_updater import start_watcher; start_watcher(); import time; time.sleep(100000)"
> 
> # 终端 2：启动 Web 界面
> streamlit run app.py
> ```

---

## 第六步：使用说明

1. **启动系统**：
   ```bash
   chmod +x start.sh  # Linux/macOS
   ./start.sh
   ```
   浏览器会自动打开 `http://localhost:8501`

2. **添加/修改文档**：
   - 直接编辑 `./docs/` 下的 `.md` / `.txt` 文件
   - 保存后，**5 秒内自动重建向量库**
   - 刷新网页或重新提问即可看到新内容

3. **隐私保障**：
   - Streamlit 默认只监听 `127.0.0.1`（仅本机访问）
   - 无任何外网连接

---

## 🔧 可选增强

| 功能 | 实现方式 |
|------|--------|
| **支持 PDF/Word** | 在 `ingest.py` 中启用 `Unstructured` 的 PDF/DOCX loader |
| **显示文档修改时间** | 在 `auto_updater.py` 中记录变更日志 |
| **多用户（局域网）** | 修改 Streamlit 启动参数 `--server.address=0.0.0.0`（⚠️ 仅限可信内网） |
| **加密存储** | 将整个项目目录放入 VeraCrypt 加密卷 |

---

## ✅ 总结

你现在拥有一个：

- ✅ **图形化界面**（通过浏览器访问）
- ✅ **自动监控文档更新并重建知识库**
- ✅ **支持检索 + 智能问答（RAG）**
- ✅ **100% 本地运行，零数据上传**
- ✅ **中文优化，隐私安全**

的完整个人知识库系统！

> 💡 **提示**：首次运行会较慢（下载模型 + 构建向量库），之后所有操作均在本地快速完成。


# 在 ingest.py 中启用 Unstructured 的 PDF/DOCX loader

要在 `ingest.py` 中**启用 Unstructured 的 PDF 和 DOCX（Word）文档加载功能**，你需要：

1. 安装额外的依赖（支持 PDF/DOCX 解析）  
2. 在 `ingest.py` 中添加对应的加载器  
3. 确保 `Unstructured` 使用本地模型（避免联网）

由于你要求**完全本地、不上传任何信息到云端**，我们将配置 `Unstructured` 使用 **本地 OCR（如 Tesseract）** 和 **本地解析器**，禁用其默认可能调用的远程 API（如 `unstructured-api`）。

---

## ✅ 第一步：安装必要的本地依赖

### 1.1 安装 Python 依赖
```bash
# 已有基础
pip install unstructured[local-inference]

# 新增：PDF 和 DOCX 支持
pip install unstructured[pdf]      # 包含 pdf2image, PyPDF2
pip install unstructured[docx]     # 包含 python-docx

# 可选但推荐（提高 PDF 表格/图文解析质量）
pip install pymupdf          # 更快的 PDF 解析（替代 pdf2image）
pip install poppler-utils     # 用于 pdf2image（需系统安装）
```

> ⚠️ 注意：`unstructured[pdf]` 默认会尝试使用 `pdf2image`，它依赖系统级的 **Poppler**。

---

### 1.2 安装系统级依赖（Windows）

#### （1）安装 **Tesseract OCR**（用于 PDF 中扫描图像的文字识别）
- 下载地址：https://github.com/UB-Mannheim/tesseract/wiki
- 安装时勾选 **“Additional language data (e.g. Chinese)”** → 选择 `chi_sim`（简体中文）和 `chi_tra`（繁体）
- 安装完成后，将 Tesseract 路径（如 `C:\Program Files\Tesseract-OCR`）加入系统 `PATH` 环境变量

#### （2）安装 **Poppler**（用于 `pdf2image`）
- 下载预编译版：https://github.com/oschwartz10612/poppler-windows/releases/
- 解压到 `C:\poppler`
- 将 `C:\poppler\Library\bin` 加入系统 `PATH`

> ✅ 验证安装：
> ```cmd
> tesseract --version
> pdftoppm -h
> ```

---

## ✅ 第二步：修改 `ingest.py` 启用 PDF/DOCX 加载器

更新你的 `ingest.py` 文件如下（关键：**禁用远程 API，强制本地解析**）：

```python
# ingest.py （更新版：支持 PDF / DOCX / TXT / MD，完全本地）

import os
from langchain_community.document_loaders import (
    DirectoryLoader,
    TextLoader,
    UnstructuredMarkdownLoader,
)
from langchain_community.document_loaders.unstructured import UnstructuredFileLoader
from typing import List
import warnings
warnings.filterwarnings("ignore", category=UserWarning, module="unstructured")

DOCS_DIR = "./docs"
PERSIST_DIR = "./chroma_db"

def load_documents() -> List:
    """加载所有支持的文档（TXT, MD, PDF, DOCX），完全本地解析"""
    documents = []

    # === .txt 文件 ===
    txt_loader = DirectoryLoader(
        DOCS_DIR,
        glob="*.txt",
        loader_cls=TextLoader,
        loader_kwargs={"encoding": "utf-8"}
    )
    documents.extend(txt_loader.load())

    # === .md 文件 ===
    md_loader = DirectoryLoader(
        DOCS_DIR,
        glob="*.md",
        loader_cls=UnstructuredMarkdownLoader,
        loader_kwargs={"encoding": "utf-8"}
    )
    documents.extend(md_loader.load())

    # === .pdf 文件 ===
    pdf_files = [str(f) for f in Path(DOCS_DIR).glob("*.pdf")]
    for pdf_file in pdf_files:
        print(f"📄 正在解析 PDF: {os.path.basename(pdf_file)}")
        loader = UnstructuredFileLoader(
            pdf_file,
            mode="single",  # 或 "elements"（更细粒度）
            strategy="fast",  # "hi_res" 更准但慢，需 OCR
            # 关键：强制本地，不调用 API
            api_url=None,   # 禁用远程 API
            # 启用本地 OCR（如果 PDF 是扫描件）
            ocr_languages=["chi_sim", "eng"],  # 中英混合
        )
        documents.extend(loader.load())

    # === .docx 文件 ===
    docx_files = [str(f) for f in Path(DOCS_DIR).glob("*.docx")]
    for docx_file in docx_files:
        print(f"📝 正在解析 DOCX: {os.path.basename(docx_file)}")
        loader = UnstructuredFileLoader(
            docx_file,
            mode="single",
            strategy="fast",
            api_url=None,  # 禁用远程 API
        )
        documents.extend(loader.load())

    print(f"✅ 共加载 {len(documents)} 个文档片段")
    return documents

# --- 保留原有的 split_documents 函数 ---
from langchain_text_splitters import RecursiveCharacterTextSplitter
from pathlib import Path

def split_documents(documents):
    text_splitter = RecursiveCharacterTextSplitter(
        chunk_size=500,
        chunk_overlap=50,
        length_function=len,
        is_separator_regex=False,
    )
    chunks = text_splitter.split_documents(documents)
    print(f"✅ 切分为 {len(chunks)} 个文本块")
    return chunks

if __name__ == "__main__":
    docs = load_documents()
    chunks = split_documents(docs)

    os.makedirs(PERSIST_DIR, exist_ok=True)
    with open(os.path.join(PERSIST_DIR, "chunks.txt"), "w", encoding="utf-8") as f:
        for i, chunk in enumerate(chunks):
            f.write(f"--- Chunk {i} ---\n")
            f.write(chunk.page_content + "\n\n")
    print("✅ 文本块已保存（供调试）")
```

---

## ✅ 第三步：验证配置（确保无网络请求）

`UnstructuredFileLoader` 默认在 `api_url=None` 时会使用 **本地解析**（`partition` 函数），不会连接任何远程服务。

你可以通过以下方式确认：
- 禁用网络（拔网线 / 关 WiFi）
- 运行 `python ingest.py`
- 如果能正常解析 PDF/DOCX → 说明完全本地

> 🔒 安全提示：`Unstructured` 的 `UnstructuredAPIFileLoader` 才会联网，我们用的是 `UnstructuredFileLoader`（本地版）。

---

## ✅ 第四步（可选）：提高 PDF 解析质量

如果你的 PDF 是**扫描件（图片型）**，确保 Tesseract 已正确安装并支持中文：

```python
# 在 UnstructuredFileLoader 中显式指定 OCR 选项
loader = UnstructuredFileLoader(
    pdf_file,
    strategy="hi_res",          # 启用高级布局分析
    ocr_languages="chi_sim+eng", # 中英混合
    include_page_breaks=False,
    api_url=None,
)
```

> 💡 `strategy="hi_res"` 会调用 `layoutparser` 和 `Tesseract`，需要额外安装：
> ```bash
> pip install unstructured[local-inference]
> # 已包含 layoutparser, detectron2（但 detectron2 在 Windows 安装复杂）
> ```
> 如果安装失败，可降级使用 `strategy="ocr_only"` 或 `"fast"`。

---

## ✅ 文件目录示例

```
local_knowledge_base/
└── docs/
    ├── notes.md
    ├── summary.txt
    ├── report.pdf        ← 支持！
    └── meeting.docx      ← 支持！
```

放入这些文件后，运行：
```bash
python ingest.py
python build_vector_db.py
```
即可将 PDF/DOCX 内容纳入知识库。

---

## ⚠️ 常见问题解决

| 问题 | 解决方案 |
|------|--------|
| `TesseractNotFoundError` | 安装 Tesseract 并加入 `PATH` |
| `poppler not installed` | 安装 Poppler 并加入 `PATH` |
| 中文 OCR 识别乱码 | 安装 `chi_sim` 语言包（Tesseract 安装时勾选） |
| DOCX 表格丢失 | `unstructured` 对复杂表格支持有限，可考虑转为 PDF 或 Markdown 预处理 |

---

## ✅ 总结

你现在已经成功在 `ingest.py` 中启用了：

- ✅ **PDF 解析**（文本型 + 扫描型 OCR）
- ✅ **DOCX 解析**（文字、标题、列表）
- ✅ **完全本地运行**
- ✅ **不上传任何数据到云端**

所有文档（包括 PDF/DOCX）都会被切块、向量化，并纳入你的本地知识库，可通过图形界面查询。
