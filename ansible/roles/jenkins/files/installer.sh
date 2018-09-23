#!/bin/bash

wget https://updates.jenkins.io/latest/script-security.hpi
wget http://ftp-nyc.osuosl.org/pub/jenkins/plugins/structs/1.14/structs.hpi
wget https://updates.jenkins.io/latest/cloudbees-folder.hpi
wget https://updates.jenkins.io/latest/ace-editor.hpi
wget https://updates.jenkins.io/latest/momentjs.hpi
wget https://updates.jenkins.io/latest/jackson2-api.hpi

java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 safe-restart
sleep 20s

wget https://updates.jenkins.io/latest/credentials.hpi
wget https://updates.jenkins.io/latest/command-launcher.hpi
wget https://updates.jenkins.io/latest/bouncycastle-api.hpi
wget https://updates.jenkins.io/latest/apache-httpcomponents-client-4-api.hpi
wget https://updates.jenkins.io/latest/scm-api.hpi
wget https://updates.jenkins.io/latest/workflow-step-api.hpi
wget https://updates.jenkins.io/latest/handlebars.hpi
wget https://updates.jenkins.io/latest/jquery-detached.hpi
wget https://updates.jenkins.io/latest/durable-task.hpi

java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 safe-restart
sleep 20s

wget https://updates.jenkins.io/latest/plain-credentials.hpi
wget https://updates.jenkins.io/latest/authentication-tokens.hpi
wget https://updates.jenkins.io/latest/junit.hpi
wget https://updates.jenkins.io/latest/workflow-api.hpi
wget https://updates.jenkins.io/latest/display-url-api.hpi
wget https://updates.jenkins.io/latest/ssh-credentials.hpi
wget https://updates.jenkins.io/latest/branch-api.hpi
wget https://updates.jenkins.io/latest/workflow-scm-step.hpi
wget https://updates.jenkins.io/latest/pipeline-stage-tags-metadata.hpi
wget https://updates.jenkins.io/latest/pipeline-model-api.hpi

java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 safe-restart
sleep 20s

wget https://updates.jenkins.io/latest/jsch.hpi
wget https://updates.jenkins.io/latest/docker-commons.hpi
wget https://updates.jenkins.io/latest/mailer.hpi
wget https://updates.jenkins.io/latest/junit.hpi
wget https://updates.jenkins.io/latest/pipeline-milestone-step.hpi
wget https://updates.jenkins.io/latest/workflow-support.hpi
wget https://updates.jenkins.io/latest/workflow-basic-steps.hpi
wget https://updates.jenkins.io/latest/pipeline-stage-step.hpi
wget https://updates.jenkins.io/latest/credentials-binding.hpi

java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 safe-restart
sleep 20s

wget https://updates.jenkins.io/latest/git-client.hpi
wget https://updates.jenkins.io/latest/matrix-project.hpi
wget https://updates.jenkins.io/latest/pipeline-build-step.hpi
wget https://updates.jenkins.io/latest/pipeline-input-step.hpi
wget https://updates.jenkins.io/latest/workflow-job.hpi
wget https://updates.jenkins.io/latest/workflow-cps.hpi
wget https://updates.jenkins.io/latest/workflow-durable-task-step.hpi
wget https://updates.jenkins.io/latest/docker-workflow.hpi
wget https://updates.jenkins.io/latest/workflow-multibranch.hpi

java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 safe-restart
sleep 20s

wget https://updates.jenkins.io/latest/pipeline-model-extensions.hpi
wget https://updates.jenkins.io/latest/pipeline-graph-analysis.hpi

java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 safe-restart
sleep 20s

wget https://updates.jenkins.io/latest/pipeline-rest-api.hpi

java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 safe-restart
sleep 20s

wget https://updates.jenkins.io/latest/pipeline-stage-view.hpi
wget https://updates.jenkins.io/latest/pipeline-model-declarative-agent.hpi
wget https://updates.jenkins.io/latest/git-server.hpi

java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 safe-restart
sleep 20s

wget wget https://updates.jenkins.io/latest/workflow-cps-global-lib.hpi

java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 safe-restart
sleep 20s

wget https://updates.jenkins.io/latest/workflow-aggregator.hpi

java -jar /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://127.0.0.1:8080 safe-restart
sleep 20s
