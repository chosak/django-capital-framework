import os

from django.template import engines
from django.template.backends.jinja2 import Template
from django.test import TestCase, override_settings

from capitalframework.tests.test_templatetags import VALID_SVG


@override_settings(
    STATICFILES_DIRS=[
        os.path.join(os.path.dirname(__file__), 'staticfiles'),
    ],
    TEMPLATES=[
        {
            'NAME': 'test',
            'BACKEND': 'django.template.backends.jinja2.Jinja2',
            'OPTIONS': {
                'extensions': [
                    'capitalframework.jinja2tags.filters',
                ],
            },
        },
    ]
)
class SvgIconTests(TestCase):
    def setUp(self):
        self.jinja_engine = engines['test']

    def test_jinja_tag(self):
        template = self.jinja_engine.from_string('{{ cf_icon("test") }}')
        self.assertEqual(template.render(), VALID_SVG)

    def test_jinja_tag_invalid(self):
        template = self.jinja_engine.from_string('{{ cf_icon("invalid") }}')
        with self.assertRaises(ValueError):
            template.render()
