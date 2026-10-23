# Release

Manual release workflow. Requires `PYPI_API_TOKEN` with project upload scope.

1. Build sdist and wheel.
2. Run `twine check`.
3. Publish to PyPI.
4. Create and push the Git tag.
