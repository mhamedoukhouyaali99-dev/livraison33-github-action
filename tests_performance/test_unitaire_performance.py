"""Mesure de performance des regles metier sans reseau ni navigateur."""

import os
import statistics
import sys
import time
from pathlib import Path

import pytest


sys.path.insert(0, str(Path(__file__).parents[1] / "tests_unitaire"))
from appl import HomeyManager  # noqa: E402


pytestmark = pytest.mark.performance
UNIT_ITERATIONS = int(os.getenv("PERFORMANCE_UNIT_ITERATIONS", "1000"))
MAX_UNIT_AVERAGE_SECONDS = float(os.getenv("PERFORMANCE_UNIT_MAX_AVERAGE", "0.01"))


def test_performance_unitaire_recherche_propriete() -> None:
    """Performance unitaire: rechercher une propriete reste rapide en memoire."""
    manager = HomeyManager()
    for propriete_id in range(100):
        manager.ajouter_propriete(propriete_id, f"Propriete {propriete_id}", 100)

    durations = []
    for _ in range(UNIT_ITERATIONS):
        started_at = time.perf_counter()
        resultats = manager.rechercher_par_nom("Propriete 50")
        durations.append(time.perf_counter() - started_at)
        assert resultats

    average = statistics.mean(durations)
    print(f"Performance unitaire: iterations={UNIT_ITERATIONS}, average={average:.8f}s")
    assert average <= MAX_UNIT_AVERAGE_SECONDS