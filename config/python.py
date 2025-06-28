""" python deps for this project """

build_requires: list[str] = [
    "pydmt",
    "pymakehelper",

    "pylint",
    "pytest",
    "pytest-cov",
    "mypy",

    # types
    "types-requests",
]
requires = build_requires
