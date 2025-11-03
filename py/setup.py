# py/setup.py
# Package your code in a .whl file
# Execute `python setup.py bdist_wheel` in 'py/' folder

from setuptools import setup, find_packages

setup(
    name="contoso_project",
    version="0.1.0",
    packages=find_packages(),
    description="Synapse Deep Dive using Contoso dataset."
)
