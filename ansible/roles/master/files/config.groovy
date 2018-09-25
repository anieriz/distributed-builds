import jenkins.model.Jenkins
import jenkins.model.JenkinsLocationConfiguration
import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.security.s2m.AdminWhitelistRule

// enabled access control
println "--> enabling slave master access control"

Jenkins.instance.injector.getInstance(AdminWhitelistRule.class)
    .setMasterKillSwitch(false);

Jenkins.instance.save()

// enabled cli
jenkins.model.Jenkins.instance.getDescriptor("jenkins.CLI").get().setEnabled(false)

// set url and email
def jenkinsParameters = [
  email:  'Jenkins Admin <admin@orbis.pe>',
  url:    'http://builds.orbis.pe/'
]

def jenkinsLocationConfiguration = JenkinsLocationConfiguration.get()

jenkinsLocationConfiguration.setUrl(jenkinsParameters.url)
jenkinsLocationConfiguration.setAdminAddress(jenkinsParameters.email)
jenkinsLocationConfiguration.save()