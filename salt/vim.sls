# formula
vim:
  pkg.installed: []

#copiar el archivo vimrc
/etc/vimrc:
  file.managed:
    - source: salt://vimrc
    - mode: 644
    - user: root
    - group: root