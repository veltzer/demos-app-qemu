config_requires = []
dev_requires = [
    "pydmt",
]
install_requires = []
make_requires = [
    "flask",
    "mysql-connector-python",
    "pyvardump",
    "requests",
    "types-requests",

    "pymakehelper",
    "pypitools",
    "pycmdtools",

    "black",

    "pylint",
    "pytest",
    "pytest-cov",
    "flake8",
    "pyflakes",
    "mypy",
]
test_requires = []
requires = config_requires + install_requires + make_requires + test_requires
