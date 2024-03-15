import io
import json
import os
import subprocess

from setuptools import find_packages, setup

BASE_DIR = os.path.abspath(os.path.dirname(__file__))

PACKAGE_JSON = os.path.join(BASE_DIR, "stemly-frontend/package.json")
with open(PACKAGE_JSON, "r") as package_file:
    __version__ = json.load(package_file)["version"]


def get_git_sha():
    try:
        s = subprocess.check_output(["git", "rev-parse", "HEAD"])
        return s.decode().strip()
    except Exception:
        return ""


GIT_SHA = get_git_sha()
version_info = {"GIT_SHA": GIT_SHA, "version": __version__}
print("-==-" * 15)
print("VERSION: " + __version__)
print("GIT SHA: " + GIT_SHA)
print("-==-" * 15)

VERSION_INFO_FILE = os.path.join(BASE_DIR, "stemly", "static", "version_info.json")

with open(VERSION_INFO_FILE, "w") as version_file:
    json.dump(version_info, version_file)

with io.open("README.md", "r", encoding="utf-8") as f:
    long_description = f.read()

with open(os.path.join(BASE_DIR, "stemly/requirements.txt")) as f:
    requirements = [line for line in f if not line.startswith("#")]

with open(os.path.join(BASE_DIR, "stemly/requirements-test.txt")) as f:
    requirements_test = [line for line in f if not line.startswith("#")]


setup(
    name="stemly",
    version=__version__,
    long_description=long_description,
    long_description_content_type="text/markdown",
    packages=find_packages(exclude=["test"]),
    install_requires=requirements,
    extras_require={"test": requirements_test},
    entry_points={
        "console_scripts": ["stemly = stemly.cli:stemly", "stemlydb = stemly.cli:db"]
    },
    python_requires="~=3.8",
    classifiers=[
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
    ],
)
