from setuptools import find_packages, setup


setup(
    name='django-capital-framework',
    setup_requires=[
        'cfgov_setup==1.2',
    ],
    install_requires=[
        'Django==1.8.15',
        'Jinja2==2.7.3',
    ],
    frontend_build_script='setup.sh',
    include_package_data=True,
    packages=find_packages()
)
