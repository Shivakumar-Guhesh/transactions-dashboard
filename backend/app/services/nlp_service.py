import re
import sys
from typing import List, Set, Tuple

import spacy
from rapidfuzz import fuzz, process
from spacy.tokens import Doc


class NlpService:
    """Handles low-level NLP operations, fuzzy matching, and text normalization."""

    ALLOWED_POS = {"NOUN", "PROPN", "ADJ", "VERB"}
    SKIP_WORDS = {
        "a",
        "an",
        "by",
        "explain",
        "find",
        "for",
        "how",
        "in",
        "is",
        "list",
        "much",
        "of",
        "on",
        "provide",
        "select",
        "the",
        "to",
        "was",
        "what",
    }

    def __init__(self, candidate_words: List[str]):
        self.nlp = self._load_spacy_model()
        self.candidate_docs: List[Tuple[str, Doc]] = [
            (word, doc)
            for word, doc in zip(candidate_words, self.nlp.pipe(candidate_words))
            if doc.vector_norm
        ]

    def _load_spacy_model(self):
        try:
            return spacy.load("en_core_web_lg", disable=["ner", "textcat"])
        except OSError:
            print("Error: Spacy model 'en_core_web_lg' not found.")
            sys.exit(1)

    def get_lemma(self, text: str) -> List[str]:
        """Returns lemmas for tokens in the text."""
        doc = self.nlp(text)
        return [token.lemma_ for token in doc]

    def convert_question(self, question: str) -> str:
        """Corrects user question by matching tokens against known candidate values."""
        processed_question = question.lower()
        question_doc = self.nlp(processed_question)
        replacements = {}
        choices = [text for text, _ in self.candidate_docs]

        for token in question_doc:
            if (
                token.is_stop
                or not token.is_alpha
                or token.pos_ not in self.ALLOWED_POS
                or token.text in self.SKIP_WORDS
            ):
                continue

            best_match = None

            fuzzy_result = process.extractOne(token.text, choices, scorer=fuzz.WRatio)
            if fuzzy_result and fuzzy_result[1] > 90:
                best_match = fuzzy_result[0]

            if not best_match and token.has_vector:
                highest_sim = 0.6
                for val_text, val_doc in self.candidate_docs:
                    if (sim := token.similarity(val_doc)) > highest_sim:
                        highest_sim, best_match = sim, val_text

            if best_match:
                replacements[token.text] = best_match

        for old_word, new_val in replacements.items():
            processed_question = re.sub(
                rf"\b{re.escape(old_word)}\b", new_val, processed_question
            )

        return processed_question
