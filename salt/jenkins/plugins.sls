include:
  - jenkins
  - jenkins.cli

{% from "jenkins/map.jinja" import jenkins with context %}
{% from 'jenkins/macros.jinja' import jenkins_cli with context %}

{% set plugin_cache = "{0}/updates/default.json".format(jenkins.home) %}

jenkins_updates_file:
  file.directory:
    - name: {{ "{0}/updates".format(jenkins.home) }}
    - user: {{ jenkins.user }}
    - group: {{ jenkins.group }}
    - mode: 755

  pkg.installed:
    - name: curl

  cmd.run:
    - unless: test -f {{ plugin_cache }}
    - name: "curl -L {{ jenkins.plugins.updates_source }} | sed '1d;$d' > {{ plugin_cache }}"
    - require:
      - pkg: jenkins
      - pkg: jenkins_updates_file
      - file: jenkins_updates_file

{% for plugin in jenkins.plugins.installed %}
jenkins_install_plugin_{{ plugin }}:
  cmd.run:
    - unless: {{ jenkins_cli('list-plugins') }} | grep {{ plugin }}
    - name: {{ jenkins_cli('install-plugin', plugin) }}
    - timeout: {{ jenkins.plugins.timeout }}
    - require:
      - service: jenkins
      - cmd: jenkins_updates_file
    - watch_in:
      - cmd: restart_jenkins
{% endfor %}

{% for plugin in jenkins.plugins.disabled %}
jenkins_disable_plugin_{{ plugin }}:
  file.managed:
    - name: {{ jenkins.home }}/plugins/{{ plugin }}.jpi.disabled
    - user: {{ jenkins.user }}
    - group: {{ jenkins.group }}
    - contents: ''
    - watch_in:
      - cmd: restart_jenkins
{% endfor %}
