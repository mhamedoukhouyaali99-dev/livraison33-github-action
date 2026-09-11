HOME_PATH = "/"
LISTING_PATH = "/index.php/listing/beautiful-cove/"
MISSING_PATH = "/route-that-does-not-exist-for-api-tests/"


def test_get_home_returns_html(http_session, base_url):
    response = http_session.get(f"{base_url}{HOME_PATH}", timeout=30)

    assert response.status_code == 200
    assert "Accueil - Livraison 3" in response.text
    assert "<html" in response.text.lower()


def test_get_listing_returns_expected_page(http_session, base_url):
    response = http_session.get(f"{base_url}{LISTING_PATH}", timeout=30)

    assert response.status_code == 200
    assert "Beautiful Cove" in response.text
    assert "modal-contact-host" in response.text


def test_get_unknown_route_returns_not_found(http_session, base_url):
    response = http_session.get(f"{base_url}{MISSING_PATH}", timeout=30)

    assert response.status_code == 404
