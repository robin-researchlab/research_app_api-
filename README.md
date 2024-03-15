<div align="center">

[![Stemly](images/stemlyLogo.svg)](https://www.soptai.sg/)

## [About](#about) | [Contribute](#contribute) | [Quick Start](#quick-start) | [Migrations](#migrations) | [Testing](#testing) | [Static Code Analysis](#static-code-analysis)

</div>

## About

We are helping businesses to transform through AI powered forecasting and optimisation solutions.

**Autonomous Planning:** Empower executives to make fast and impactful decisions with data-driven recommendations.

**Accurate Predictions through AutoML:** Unique time series features and automatic model selection are our secret sauce to increase forecasting accuracy.

**Data-driven Scenario-based Modeling:** Optimise scenarios in minutes, not days, and debate implications and trade off to provide recommendations.

**Faster Response to Unexpected External Changes:** External data integration such as commodity prices, social media, external events, etc.

## Contribute

Check out [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute to this project.

**⚠️ Never upload _ANY_ passwords, tokens, or credentials to GitHub! ⚠️**

## Quick Start

The steps below will allow you to run Stemly API locally.

### Docker Setup

We use Docker to run Redis, Postgres, ClickHouse, and Azurite, so you will need Docker
to run this application locally.

The recommended method is to install Docker Desktop, which includes the Docker engine,
CLI, and Compose plugin. This step depends on your OS, so follow the instructions from
[the official docs](https://docs.docker.com/desktop/).

### Stemly RBAC Setup

We use [Casbin](https://casbin.org/) for our RBAC, through the Stemly RBAC service.

Follow the instructions in the [Stemly RBAC](https://github.com/soptai/stemly_rbac/)
repository to set up the RBAC service.

### Stemly API Setup

- Clone the repository:

  ```shell
  git clone https://github.com/soptai/stemly_api.git
  cd stemly_api
  ```

- Set up your Python environment, making sure to use Python 3.8, 3.9, or 3.10. All code
  must be compatible with Python 3.8. Use your choice of
  [pyenv](https://github.com/pyenv/pyenv),
  [Conda](https://docs.conda.io/en/latest/miniconda.html),
  or [venv](https://docs.python.org/3/library/venv.html).
  pyenv is recommended for development as it allows you to easily switch between Python
  versions without affecting your system Python installation.

  - Using pyenv:

    ```shell
    pyenv install 3.8
    pyenv local 3.8
    pyenv virtualenv stemly
    pyenv shell stemly
    ```

  - Using Conda:

    ```shell
    conda create -n "stemly" python=3.8
    conda activate stemly
    ```

  - Using venv (must already have Python 3.8 installed):

    ```shell
    python3 -m venv stemly
    source stemly/bin/activate
    ```

- Upgrade pip and install dependencies:

  ```shell
  pip install --upgrade pip
  pip install -e ".[test]"
  ```

- Create your `.env` file, using `.example.env` as a template and filling in the
  appropriate values:

  ```shell
  cp .example.env .env
  ```

- Start the Docker containers:

  ```shell
  make start
  ```

- Run the database migrations:

  ```shell
  stemlydb db upgrade
  ```

- Run the application:

  ```shell
  make start-api
  ```

- Make a test query to the API, using `Bearer root@localhost|test` for authorization:

  ```shell
    curl --location 'localhost:5000/api/profile' \
    --header 'Authorization: Bearer root@localhost|test'
  ```

## Migrations

We use [Flask-Migrate](https://flask-migrate.readthedocs.io/en/latest/) (a thin wrapper
around [Alembic](https://alembic.sqlalchemy.org/en/latest/)) for our database
migrations.

### During Development

- Ensure your working branch has the latest migrations according to the current release
  branch.
- Make the desired changes to the appropriate model file(s).
- Generate a new migration file (include a message describing the changes):

  ```shell
  stemlydb db migrate -m "Add new column to user model"
  ```

- Inspect the newly generated migration file to ensure the upgrade and downgrade
  functions are correct. Do not assume the generated migration file is correct, Alembic
  makes mistakes.
- Test the migration locally by running `stemlydb db upgrade` and `stemlydb db downgrade`
  to ensure the migration works as expected.
- Commit the migration file and push to your working branch.
- Create a pull request targeting the current release branch.

### During Review

- Review the migration file to ensure the upgrade and downgrade functions are correct.
- Test the migration locally by running `stemlydb db upgrade` and
  `stemlydb db downgrade` to ensure the migration works as expected.
- Ensure the `down_revision` in the migration file matches the `revision` of the
  previous migration file.
- If the migration file is correct, approve the pull request, otherwise request changes.

### Deployment

- Do not generate any migrations on deployed environments. All migrations should be
  generated during development and pushed to git.
- Pull the latest changes from git.
- Run `stemlydb db upgrade` to apply the latest migrations.

## Testing

### Unit Testing

We use [pytest](https://docs.pytest.org/en/stable/) for our unit testing. When creating
new tests please follow the steps below:

- Place new tests under `tests/unit`
- Prefix new test files with `test_`, e.g.: `test_user_model.py`
- Prefix test method names with `test_`, e.g.: `def test_create_new_user()`
- Place new test fixtures in `tests/conftest.py`

### Running Unit Tests

Run unit tests via the `make unit-tests` Makefile rule. This will run all tests under
the `tests/unit` directory, update the test reports under `tests/reports`, and generate
a coverage report.

### Integration Testing

We use a combination of [BATS](https://github.com/sstephenson/bats) and shell scripts
for our integration testing. Place new integration tests under `tests/integration`.

Before running integration tests, make sure you have the following installed:

- [BATS](https://github.com/sstephenson/bats#installing-bats-from-source)
- [jq](https://stedolan.github.io/jq/download/)

Also, make sure you have set up the git submodules:

```shell
git submodule init
git submodule update
```

### Running Integration Tests

- Follow the steps in the [Quick Start](#quick-start) section to set up the application
  locally, and have the application running.

#### Shell Scripts

- Select the integration test you want to run, e.g. `tests/integration/extract.sh` and
  open it in your editor.
- Open a new terminal and change your active directory to `tests/integration`.
- Run each line from the integration test file in the new terminal.

#### BATS Tests

- Open a new terminal and change your active directory to `tests/integration`.
- Run the desired BATS test file, e.g. `bats extract.bats`.

## Static Code Analysis

Install Trivy for your OS according to the [official instructions](https://aquasecurity.github.io/trivy/v0.35/getting-started/installation/).

Run with the `make static-scan` Makefile rule.
