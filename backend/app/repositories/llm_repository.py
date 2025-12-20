from typing import Any, Dict, List, Optional

import chromadb
from langchain_ollama import OllamaEmbeddings


class LlmRepository:
    """Handles vector database operations using ChromaDB."""

    def __init__(self, db_path: str, collection_name: str) -> None:
        self.client = chromadb.PersistentClient(path=db_path)
        self.collection_name = collection_name

        self._collection = None

    @property
    def collection(self):
        if self._collection is None:
            self._collection = self.client.get_or_create_collection(
                name=self.collection_name
            )
        return self._collection

    def semantic_search(
        self,
        question,
        filters: Optional[Dict[str, Any]] = None,
        n_results: int = 50,
    ):
        """
        Executes a vector search with optional metadata filtering.
        """
        EMBED_LLM_MODEL = "nomic-embed-text"
        embedding_llm = OllamaEmbeddings(model=EMBED_LLM_MODEL)
        question_vector = embedding_llm.embed_query(question)
        try:
            results = self.collection.query(
                query_embeddings=question_vector,
                where=filters if filters else None,
                n_results=n_results,
            )
            return results
        except Exception as e:
            # In a production app, log this properly
            print(f"ChromaDB Query Error: {e}")
            return {"ids": [], "documents": [], "metadatas": []}
