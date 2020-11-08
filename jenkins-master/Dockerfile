FROM jenkins/jenkins:lts

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

ADD plugins.yaml /usr/share/jenkins/ref/plugins.yaml
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.yaml --verbose

# Create three folders:
# /var/jenkins_home/mounted-configs/config - which should contain JCasC configuration files
# /var/jenkins_home/mounted-configs/init.groovy.d - which should contain groovy init scripts (this is particuarly used to create the SeedJob)
# /var/jenkins_home/mounted-configs/job-dsl - which should contain Job DSL scripts that will create the pipeline jobs
RUN mkdir -p /var/jenkins_home/mounted-configs \
    && rmdir /usr/share/jenkins/ref/init.groovy.d \
    && mkdir -p /usr/share/jenkins/ref/jobs/SeedJob \
    && ln -s /var/jenkins_home/mounted-configs/config /var/jenkins_home/config \
    && ln -s /var/jenkins_home/mounted-configs/init.groovy.d /usr/share/jenkins/ref/init.groovy.d \
    && ln -s /var/jenkins_home/mounted-configs/job-dsl /usr/share/jenkins/ref/jobs/SeedJob/workspace
