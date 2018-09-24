import jenkins.model.Jenkins
import jenkins.model.JenkinsLocationConfiguration

def jenkinsParameters = [
  email:  'Jenkins Admin <admin@orbis.pe>',
  url:    'http://builds.orbis.pe/'
]

def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

jenkinsLocationConfiguration.setUrl(jenkinsParameters.url)
jenkinsLocationConfiguration.setAdminAddress(jenkinsParameters.email)
jenkinsLocationConfiguration.save()