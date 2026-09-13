"""Tests de performance legers et reproductibles pour les routes HTTP critiques.

Chaque test est opt-in et verifie trois points: absence d'erreur HTTP,
temps de reponse mesure et respect du seuil correspondant au type de charge.
"""

import os
import statistics
import time
from concurrent.futures import ThreadPoolExecutor
from typing import List, Tuple

import pytest
import requests


pytestmark = pytest.mark.performance

REQUEST_TIMEOUT = float(os.getenv("PERFORMANCE_TIMEOUT", "15"))
MAX_AVERAGE_SECONDS = float(os.getenv("PERFORMANCE_MAX_AVERAGE", "3"))
MAX_P95_SECONDS = float(os.getenv("PERFORMANCE_MAX_P95", "5"))
MAX_CONCURRENT_SECONDS = float(os.getenv("PERFORMANCE_MAX_CONCURRENT", "10"))
MAX_STRESS_SECONDS = float(os.getenv("PERFORMANCE_MAX_STRESS", "20"))
MAX_SPIKE_SECONDS = float(os.getenv("PERFORMANCE_MAX_SPIKE", "20"))
CONCURRENT_REQUESTS = int(os.getenv("PERFORMANCE_CONCURRENCY", "10"))
STRESS_CONCURRENCY = int(os.getenv("PERFORMANCE_STRESS_CONCURRENCY", "20"))
SPIKE_CONCURRENCY = int(os.getenv("PERFORMANCE_SPIKE_CONCURRENCY", "30"))
ENDURANCE_ITERATIONS = int(os.getenv("PERFORMANCE_ENDURANCE_ITERATIONS", "20"))
BASE_URL = os.getenv("BASE_URL", "http://livraison3.testacademy.fr").rstrip("/")
HOME_PATH = "/"
LISTING_PATH = "/index.php/listing/beautiful-cove/"


def _performance_is_enabled() -> bool:
    return os.getenv("RUN_PERFORMANCE", "0").lower() in {"1", "true", "yes"}


def _request(path: str) -> Tuple[int, float]:
    started_at = time.perf_counter()
    response = requests.get(f"{BASE_URL}{path}", timeout=REQUEST_TIMEOUT)
    duration = time.perf_counter() - started_at
    return response.status_code, duration


def _collect_requests(path: str, count: int) -> Tuple[List[int], List[float]]:
    results = [_request(path) for _ in range(count)]
    statuses, durations = zip(*results)
    return list(statuses), list(durations)


def _assert_performance(path: str, count: int) -> None:
    statuses, durations = _collect_requests(path, count)
    successful_responses = sum(status == 200 for status in statuses)
    error_rate = 1 - (successful_responses / count)
    average = statistics.mean(durations)
    percentile_95 = sorted(durations)[max(0, int(count * 0.95) - 1)]

    print(
        f"Performance {path}: count={count}, average={average:.3f}s, "
        f"p95={percentile_95:.3f}s, error_rate={error_rate:.1%}"
    )
    assert error_rate == 0, f"Taux d'erreur trop eleve: {error_rate:.1%}"
    assert average <= MAX_AVERAGE_SECONDS
    assert percentile_95 <= MAX_P95_SECONDS


def _assert_concurrent_performance(
    path: str, concurrency: int, label: str, maximum_allowed: float
) -> None:
    with ThreadPoolExecutor(max_workers=concurrency) as executor:
        results = list(executor.map(_request, [path] * concurrency))

    statuses, durations = zip(*results)
    error_rate = sum(status != 200 for status in statuses) / concurrency
    maximum = max(durations)
    print(
        f"Performance {label} {path}: concurrency={concurrency}, "
        f"max={maximum:.3f}s, error_rate={error_rate:.1%}"
    )
    assert error_rate == 0
    assert maximum <= maximum_allowed


@pytest.fixture(autouse=True)
def require_performance_mode() -> None:
    if not _performance_is_enabled():
        pytest.skip("Definir RUN_PERFORMANCE=1 pour executer les tests de performance.")


def test_home_response_time_is_within_threshold() -> None:
    """Objectif: mesurer la reponse nominale de l'accueil.

    Mesure: cinq requetes sequentielles, moyenne et percentile 95.
    Attendu: statut HTTP 200, moyenne et p95 sous leurs seuils.
    """
    _assert_performance(HOME_PATH, count=5)


def test_listing_response_time_is_within_threshold() -> None:
    """Objectif: mesurer la reponse nominale d'une page annonce.

    Mesure: cinq requetes sequentielles sur une page dynamique.
    Attendu: statut HTTP 200, moyenne et p95 sous leurs seuils.
    """
    _assert_performance(LISTING_PATH, count=5)


def test_home_sequential_requests_are_stable() -> None:
    """Objectif: verifier la stabilite hors concurrence.

    Mesure: dix requetes successives sur l'accueil.
    Attendu: aucune erreur et aucune derive au-dela du p95 configure.
    """
    _assert_performance(HOME_PATH, count=10)


def test_home_concurrent_requests_support_expected_load() -> None:
    """Objectif: valider la charge nominale de l'accueil.

    Mesure: le nombre normal de requetes est lance simultanement.
    Attendu: toutes les reponses sont 200 et restent sous le seuil concurrent.
    """
    with ThreadPoolExecutor(max_workers=CONCURRENT_REQUESTS) as executor:
        results = list(executor.map(_request, [HOME_PATH] * CONCURRENT_REQUESTS))

    statuses, durations = zip(*results)
    assert all(status == 200 for status in statuses)
    assert max(durations) <= MAX_CONCURRENT_SECONDS


def test_listing_concurrent_requests_support_expected_load() -> None:
    """Objectif: valider la charge nominale d'une page annonce.

    Mesure: le nombre normal de visiteurs simultanes sur une page dynamique.
    Attendu: toutes les reponses sont 200 et restent sous le seuil concurrent.
    """
    with ThreadPoolExecutor(max_workers=CONCURRENT_REQUESTS) as executor:
        results = list(executor.map(_request, [LISTING_PATH] * CONCURRENT_REQUESTS))

    statuses, durations = zip(*results)
    assert all(status == 200 for status in statuses)
    assert max(durations) <= MAX_CONCURRENT_SECONDS


def test_charge_normale_sur_page_accueil() -> None:
    """Test de charge.

    Objectif: representer le trafic attendu en fonctionnement normal.
    Mesure: concurrence nominale configurable sur l'accueil.
    Attendu: aucune erreur et temps maximum sous PERFORMANCE_MAX_CONCURRENT.
    """
    _assert_concurrent_performance(
        HOME_PATH, CONCURRENT_REQUESTS, "charge", MAX_CONCURRENT_SECONDS
    )


def test_stress_progressif_sur_page_annonce() -> None:
    """Test de stress.

    Objectif: observer le comportement quand la charge depasse le nominal.
    Mesure: concurrence configuree par PERFORMANCE_STRESS_CONCURRENCY.
    Attendu: le service reste disponible sans erreur sous PERFORMANCE_MAX_STRESS.
    """
    _assert_concurrent_performance(
        LISTING_PATH, STRESS_CONCURRENCY, "stress", MAX_STRESS_SECONDS
    )


def test_pic_soudain_sur_page_accueil() -> None:
    """Test de pic.

    Objectif: simuler une arrivee simultanee de visiteurs.
    Mesure: concurrence instantanee configuree par PERFORMANCE_SPIKE_CONCURRENCY.
    Attendu: toutes les requetes obtiennent 200 sous PERFORMANCE_MAX_SPIKE.
    """
    _assert_concurrent_performance(
        HOME_PATH, SPIKE_CONCURRENCY, "pic", MAX_SPIKE_SECONDS
    )


def test_endurance_courte_sur_page_accueil() -> None:
    """Test d'endurance.

    Objectif: detecter une degradation lors de repetitions prolongees.
    Mesure: nombre d'iterations configure par PERFORMANCE_ENDURANCE_ITERATIONS.
    Attendu: moyenne, p95 et taux d'erreur restent dans les seuils nominaux.
    """
    _assert_performance(HOME_PATH, ENDURANCE_ITERATIONS)
