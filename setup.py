from setuptools import setup, find_packages

setup(
    name='oneclick_cli',
    version='0.1',
    packages= find_packages(),
    include_package_data=True,
    install_requires=[
        'Click'
    ],
    entry_points='''
        [console_scripts]
        oneclick=oneclick_cli.cli:main
    ''',
)