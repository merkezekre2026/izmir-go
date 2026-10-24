from fastapi.testclient import TestClient

from izmirgo.api.app import create_app


def test_health_ok() -> None:
    client = TestClient(create_app())
    res = client.get("/api/v1/health")
    assert res.status_code == 200
    assert res.json()["status"] == "ok"
    assert res.headers["cache-control"] == "no-store"
    assert "x-request-id" in res.headers


def test_unknown_route_is_problem_json() -> None:
    client = TestClient(create_app())
    res = client.get("/api/v1/nope")
    assert res.status_code == 404
    assert res.headers["content-type"].startswith("application/problem+json")
    assert res.json()["code"] == "NOT_FOUND"
