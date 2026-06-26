from setuptools import setup, find_packages

setup(
    name="ph-naive-bayes",
    version="0.1.0",
    packages=find_packages(),
    include_package_data=True,
    package_data={"src": ["data/*.csv"]},
    install_requires=[
        "numpy>=1.24.0",
        "scipy>=1.10.0",
    ],
    python_requires=">=3.10",
    author="Paulo Henrique",
    description="Implementação didática de Naive Bayes para classificação",
    classifiers=[
        "Programming Language :: Python :: 3",
        "Topic :: Scientific/Engineering :: Artificial Intelligence",
    ],
)
