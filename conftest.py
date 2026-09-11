import os

import pytest
import requests


BASE_URL = os.getenv("BASE_URL", "http://livraison3.testacademy.fr")


@pytest.fixture(scope="session")
def base_url():
    return BASE_URL.rstrip("/")


@pytest.fixture(scope="session")
def http_session():
    session = requests.Session()
    session.headers.update({"User-Agent": "automated-api-tests/1.0"})
    yield session
    session.close()
