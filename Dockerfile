FROM jenkins/jenkins:lts

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

ADD plugins.yaml /usr/share/jenkins/ref/plugins.yaml
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yaml --verbose

# Groovy script to create the "SeedJob" (the standard way, not with DSL)
COPY init.groovy.d/* /usr/share/jenkins/ref/init.groovy.d/

# The place where to put the DSL files for the Seed Job to run
RUN mkdir -p /usr/share/jenkins/ref/jobs/SeedJob

ADD casc.yaml /var/jenkins_home/casc.yaml

COPY job-dsl /usr/share/jenkins/ref/jobs/SeedJob/workspace
