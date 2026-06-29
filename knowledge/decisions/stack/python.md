---
type: architecture
title: Python Minimalist & Modern Stack
description: Minimalist stack for Python
  and dev tools for Python.
tags:
- python
- stack
- architecture
- minimalist
- tooling
timestamp: 2026-06-24
format_version: okf-v0.1
status: active
---


# Python Minimalist & Modern Stack

The definitive, modern toolchain and library stack for Python development, optimized for speed, developer ergonomics, and minimal maintenance overhead.

- **Runtime Environment:** Python 3.11+
  - *Chosen over older versions* for substantial performance enhancements (10–60% faster startup and execution via specializing adaptive interpreter PEP 659), fine-grained error tracebacks, `TaskGroup` in asyncio for structured concurrency, and modern syntax features.

- **Package & Project Manager:** [uv](https://docs.astral.sh/uv/)
  - *Chosen over pip:* `uv` (written in Rust) is 10–100x faster than `pip` at resolving and installing packages, caches aggressively, and provides a single, unified toolchain rather than needing multiple separate helper tools.
  - *Chosen over Poetry:* Poetry can have slow resolution times, complex dependency configuration, and high execution overhead since it is written in Python. `uv` replaces Poetry entirely by offering lightning-fast workspace support, lockfiles, and direct virtual environment management.
  - *Chosen over Pipenv:* Pipenv has historically suffered from slow lockfile generation, complex dependency resolver bugs, and high overhead. `uv` handles lockfiles instantly and is much more reliable.
  - *Chosen over conda:* Conda is heavy, slow, and designed primarily for data science with non-Python binary library requirements. For general Python applications, it introduces massive image sizes and slow environment resolution. `uv` is lightweight, fast, and builds minimal, precise virtual environments.

- **Linter & Formatter:** [Ruff](https://docs.astral.sh/ruff/)
  - *Chosen over Flake8, Black, isort, pylint:* Ruff is a single, unified Rust binary that replaces all of these tools. It is 10–100x faster than running each tool individually. It requires a single configuration block in `pyproject.toml`, eliminating the need to sync configuration between Black, Flake8, and isort (which frequently conflict on import order or trailing commas).

- **Test Runner:** [pytest](https://docs.pytest.org/)
  - *Chosen over unittest:* `pytest` provides a much simpler syntax using plain `assert` statements instead of verbose `self.assertEqual(...)` style assertions. It has a rich plugin ecosystem (e.g., `pytest-cov`, `pytest-asyncio`), supports fixture injection for clean setup/teardown, and runs standard `unittest` test suites out-of-the-box.

- **Web Framework:** [FastAPI](https://fastapi.tiangolo.com/)
  - *Chosen over Django:* Django is a heavy, "batteries-included" monolithic framework with high overhead, database coupling, and slow async performance. FastAPI is lightweight, modular, natively asynchronous, and designed specifically for modern APIs.
  - *Chosen over Flask:* Flask does not have native async support, lacks built-in request/response serialization/validation, and has no automatic OpenAPI/Swagger documentation generation. FastAPI provides all this out-of-the-box using standard Python type hints.

- **Data Validation & Serialization:** [Pydantic](https://docs.pydantic.dev/)
  - *Chosen over Marshmallow / Cerberus:* Pydantic has native integration with FastAPI, leverages Python type hints for runtime validation, features a fast validation engine (written in Rust in v2), and provides clean serialization/deserialization.

- **Database Client & ORM:** [SQLAlchemy](https://www.sqlalchemy.org/) / [SQLModel](https://sqlmodel.tiangolo.com/)
  - *Chosen over Django ORM:* Django ORM is tightly coupled to Django and cannot be easily used in standalone or microservice contexts. SQLAlchemy is highly flexible and works natively with any async driver.
  - *Chosen over raw database clients:* Writing raw SQL requires manual scanning of rows into structs, which is repetitive and lacks type safety. SQLModel combines Pydantic and SQLAlchemy, eliminating the need to write separate validation schemas (Pydantic models) and database models (SQLAlchemy models), avoiding code duplication and keeping type annotations unified and DRY.
