java-install:
  pkg.installed:
    - pkgs:
      - default-jre
      - default-jdk

include:
  - ./pillar/jenkins