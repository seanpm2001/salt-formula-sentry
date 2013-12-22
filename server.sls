{%- if pillar.sentry.server.enabled %}

include:
- python
- supervisor

sentry_packages:
  pkg.installed:
  - names:
    - python-setuptools
    - python-memcache
    - python-psycopg2
    - python-imaging
    - python-docutils
    - python-simplejson
    - build-essential
    - gettext
  - require:
    - pkg: python_packages

/srv/sentry:
  virtualenv.manage:
  - system_site_packages: True
  - requirements: salt://sentry/conf/requirements.txt
  - require:
    - pkg: sentry_packages

sentry_user:
  user.present:
  - name: sentry
  - system: True
  - home: /srv/sentry
  - require:
    - virtualenv: /srv/sentry

/etc/sentry.conf.py:
  file:
  - managed
  - source: salt://sentry/conf/sentry.conf.py
  - mode: 644
  - template: jinja
  - require:
    - virtualenv: /srv/sentry
    - user: sentry_user
  - watch_in:
    - service: supervisor_service

{%- endif %}