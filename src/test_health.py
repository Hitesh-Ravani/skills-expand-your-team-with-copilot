"""
Tests for the health check endpoint
"""

import pytest
from unittest.mock import patch, MagicMock
from fastapi.testclient import TestClient


@pytest.fixture
def client():
    """Create a test client with a mocked database"""
    with patch("src.backend.database.MongoClient") as mock_mongo:
        mock_db = MagicMock()
        mock_mongo.return_value = mock_db
        mock_db.__getitem__.return_value = MagicMock()

        from src.app import app
        return TestClient(app)


class TestHealthEndpoint:
    """Tests for GET /health"""

    def test_health_returns_200_when_db_is_up(self, client):
        """Health check returns 200 and ok status when database is reachable"""
        with patch("src.backend.routers.health.client") as mock_client:
            mock_client.admin.command.return_value = {"ok": 1}

            response = client.get("/health")

        assert response.status_code == 200
        body = response.json()
        assert body["status"] == "ok"
        assert body["database"] == "ok"

    def test_health_returns_503_when_db_is_down(self, client):
        """Health check returns 503 and degraded status when database is unreachable"""
        with patch("src.backend.routers.health.client") as mock_client:
            mock_client.admin.command.side_effect = Exception("Connection refused")

            response = client.get("/health")

        assert response.status_code == 503
        body = response.json()
        assert body["status"] == "degraded"
        assert body["database"] == "unreachable"

    def test_health_trailing_slash_also_works(self, client):
        """Health check responds to both /health and /health/"""
        with patch("src.backend.routers.health.client") as mock_client:
            mock_client.admin.command.return_value = {"ok": 1}

            response = client.get("/health/")

        assert response.status_code == 200

    def test_health_response_shape(self, client):
        """Health response always contains status and database keys"""
        with patch("src.backend.routers.health.client") as mock_client:
            mock_client.admin.command.return_value = {"ok": 1}

            response = client.get("/health")

        body = response.json()
        assert "status" in body
        assert "database" in body
