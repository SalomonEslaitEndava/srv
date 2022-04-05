java-install:
  pkg.installed:
    - pkgs:
      - default-jre
      # - java-1.8.0-openjdk

include:
  - ./pillar/jenkins