SHELL := /bin/bash
COMPOSE := docker compose -f infra/compose/compose.yaml
BACKEND := cd backend &&

.PHONY: help backend-install lint typecheck test test-db test-otp db-up db-down migrate api \
        seed-fixtures ingest contracts mobile-check

help:
	@grep -E '^[a-z-]+:' Makefile | cut -d: -f1

backend-install:
	$(BACKEND) uv sync

lint:
	$(BACKEND) uv run ruff check . && uv run ruff format --check .

typecheck:
	$(BACKEND) uv run mypy

test: lint typecheck
	$(BACKEND) uv run pytest

test-db:
	$(BACKEND) uv run pytest -m db

test-otp:
	$(BACKEND) uv run pytest -m otp -o addopts=""

db-up:
	$(COMPOSE) up -d db

db-down:
	$(COMPOSE) down

migrate:
	$(BACKEND) uv run alembic upgrade head

api:
	$(BACKEND) uv run uvicorn izmirgo.api.app:create_app --factory --reload --port 8000

seed-fixtures:
	$(BACKEND) uv run izmirgo-ingest seed-fixtures

ingest:
	$(BACKEND) uv run izmirgo-ingest run

contracts:
	$(BACKEND) uv run python -m izmirgo.api.export_openapi ../contracts/openapi.json

mobile-check:
	cd apps/mobile && dart format --set-exit-if-changed lib test && flutter analyze && flutter test
