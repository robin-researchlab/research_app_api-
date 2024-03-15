# Contribution Guidelines

**⚠️ Never upload _ANY_ passwords, tokens, or credentials to GitHub! ⚠️**

## 📃 Contents

- [🔑 Commit Signing](#-commit-signing)
- [🪝 Pre-commit Hooks](#-pre-commit-hooks)
- [📝 Issues](#-issues)
- [🧑‍💻 Pull Request Guidelines](#-pull-request-guidelines)
- [🔎 Code Review](#-code-review)
- [🔗 Useful Links](#-useful-links)
  - [API Libraries](#api-libraries)
  - [Database Libraries](#database-libraries)
  - [Testing Libraries](#testing-libraries)
  - [Data Science Libraries](#data-science-libraries)

## 🔑 Commit Signing

All commits must be signed with a valid GPG key before they can be merged into a
main/release branch.  
If you need help with this, follow the guides below:

- [Generating a new GPG key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)
- [Adding a GPG key to your GitHub account](https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-gpg-key-to-your-github-account)
- [Telling Git about your signing key](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)

After configuring the above, sign all your commits with the `-S` flag if using git from
a terminal, or look for an option to enable commit signing within your IDE or editor.

## 🪝 Pre-commit Hooks

It is **highly recommended** to make use of the configured
[pre-commit](https://pre-commit.com/) hooks in this repository.  
They will run each time you commit changes to ensure that your code is formatted
correctly, with no trailing whitespace, etc.  
There is also a check in place to avoid accidental commits to `main` or `release`
branches.

To set up pre-commit, activate your virtual environment (if used) and run:

```shell
make pre-commit
```

This will install the pre-commit git hook to run each time you run `git commit`. If you
want to run the checks manually, you can run:

```shell
pre-commit run
```

The pre-commit hooks are configured in the `.pre-commit-config.yaml` file.

## 📝 Issues

All issues are opened, tracked and resolved on
[Jira](https://stemly.atlassian.net/jira/projects).  
Please request permission to access it if you do not have access already.

## 🧑‍💻 Pull Request Guidelines

1. Check out the current release branch, following the `release_vMM_YY` naming
   convention (e.g., release_v03_21 for March 2021):

   ```shell
   git checkout release_vXX_XX
   ```

2. Pull the latest changes:

   ```shell
   git pull
   ```

3. Apply any new database migrations since last pull:

   ```shell
   stemlydb db upgrade
   ```

4. Check out your new working branch, prefixing the branch name with your ticket number
   and a short description:

   ```shell
   git checkout -b PRT-123-SomeNewFeature
   ```

5. Work on your changes, committing often and testing as necessary.
   [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) are
   encouraged:

   ```shell
   git commit -s -S -m "feat: add new feature"
   git commit -s -S -m "fix: fix bug"
   git commit -s -S -m "docs: update documentation"
   git commit -s -S -m "refactor: refactor code"
   git commit -s -S -m "test: add new test"
   ```

   You should provide a more descriptive commit message than the above examples.

6. If there are any database model changes, create a new migration script:

   ```shell
   stemlydb db migrate -m "Descriptive migration message"
   ```

   **⚠️ Test and review any new migration scripts before committing them! ⚠️**

7. Push your changes to GitHub:

   ```shell
   git push --set-upstream origin PRT-123-SomeNewFeature
   ```

8. Make a pull request and request a review! Check out these guides on writing a good
   pull request:

   - [How to write the perfect pull request](https://github.blog/2015-01-21-how-to-write-the-perfect-pull-request/)
   - [The (written) unwritten guide to pull requests](https://www.atlassian.com/blog/git/written-unwritten-guide-pull-requests)

## 🔎 Code Review

- When writing reviews, be helpful and constructive.
- If there are changes required, state exactly what changes need to be made before
  approval.
- If you are asked to update your pull request with some changes, there is no need to
  create a new one. Push your changes to the same branch.

## 🔗 Useful Links

Below are some useful links to documentation and API references for the libraries used
in this project.

### API Libraries

- [Flask documentation](https://flask.palletsprojects.com/en/2.3.x/)
- [Flask-RESTX documentation](https://flask-restx.readthedocs.io/en/latest/)
- [webargs documentation](https://webargs.readthedocs.io/en/latest/)
- [Marshmallow documentation](https://marshmallow.readthedocs.io/en/stable/)

### Database Libraries

- [SQLAlchemy documentation](https://docs.sqlalchemy.org/en/14/)
- [Flask-SQLAlchemy documentation](https://flask-sqlalchemy.palletsprojects.com/en/3.0.x/)
- [Alembic documentation](https://alembic.sqlalchemy.org/en/latest/)
- [Flask-Migrate documentation](https://flask-migrate.readthedocs.io/en/latest/)

### Testing Libraries

- [pytest documentation](https://docs.pytest.org/en/stable/)

### Data Science Libraries

- [pandas documentation](https://pandas.pydata.org/pandas-docs/version/1.5/index.html)
- [NumPy documentation](https://numpy.org/doc/stable/)
- [Polars API reference](https://pola-rs.github.io/polars/py-polars/html/reference/index.html)
