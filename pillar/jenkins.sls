jenkins:
  lookup:
    stable: True
    jenkins_port: 8080
    home: /var/jenkins
    user: jenkins
    group: jenkins
    master_url: http://0.0.0.0:8080
    pkgs:
      - jenkins: 2.150.3-1.1