from __future__ import absolute_import

from jinja2.ext import Extension

from capitalframework.templatetags.capitalframework import cf_icon


class CFExtension(Extension):
    def __init__(self, environment):
        super(CFExtension, self).__init__(environment)
        self.environment.globals.update({
            'cf_icon': cf_icon,
        })


filters = CFExtension
