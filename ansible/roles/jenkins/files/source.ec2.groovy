import com.amazonaws.services.ec2.model.InstanceType
import com.cloudbees.jenkins.plugins.awscredentials.AWSCredentialsImpl
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.Domain
import hudson.model.*
import hudson.plugins.ec2.AmazonEC2Cloud
import hudson.plugins.ec2.AMITypeData
import hudson.plugins.ec2.EC2Tag
import hudson.plugins.ec2.SlaveTemplate
import hudson.plugins.ec2.SpotConfiguration
import hudson.plugins.ec2.UnixData
import jenkins.model.Jenkins
 
// parameters
def SlaveTemplateUsEast1Parameters = [
  ami:                      'WORKERS_AMI',
  associatePublicIp:        false,
  connectBySSHProcess:      true,
  connectUsingPublicIp:     false,
  customDeviceMapping:      '',
  deleteRootOnTermination:  true,
  description:              'workers',
  ebsOptimized:             false,
  iamInstanceProfile:       '',
  idleTerminationMinutes:   '30',
  initScript:               '',
  instanceCapStr:           'AWS_DESIRE',
  jvmopts:                  '',
  labelString:              '',
  launchTimeoutStr:         '',
  numExecutors:             '5',
  remoteAdmin:              'ec2-user',
  remoteFS:                 '',
  securityGroups:           'AWS_SECURITYGROUPS',
  stopOnTerminate:          false,
  subnetId:                 'AWS_SUBNET',
  tags:                     new EC2Tag('Name', 'jenkins-distributed-workers'),
  tmpDir:                   '/var/lib/jenkins',
  type:                     'WORKERS_TYPE',
  useDedicatedTenancy:      false,
  useEphemeralDevices:      true,
  usePrivateDnsName:        true,
  userData:                 '',
  zone:                     'AWS_REGION'
]
 
def AmazonEC2CloudParameters = [
  cloudName:      'workers',
  credentialsId:  '',
  instanceCapStr: 'AWS_DESIRE',
  privateKey:     '''AWS_PEM''',
  region: 'AWS_REGION',
  useInstanceProfileForCredentials: true
]

def AWSCredentialsImplParameters = [
  id:           '',
  description:  '',
  accessKey:    '',
  secretKey:    ''
]
 
// https://github.com/jenkinsci/aws-credentials-plugin/blob/aws-credentials-1.23/src/main/java/com/cloudbees/jenkins/plugins/awscredentials/AWSCredentialsImpl.java
AWSCredentialsImpl aWSCredentialsImpl = new AWSCredentialsImpl(
  CredentialsScope.GLOBAL,
  AWSCredentialsImplParameters.id,
  AWSCredentialsImplParameters.accessKey,
  AWSCredentialsImplParameters.secretKey,
  AWSCredentialsImplParameters.description
)
 
// https://github.com/jenkinsci/ec2-plugin/blob/ec2-1.38/src/main/java/hudson/plugins/ec2/SlaveTemplate.java
SlaveTemplate slaveTemplateUsEast1 = new SlaveTemplate(
  SlaveTemplateUsEast1Parameters.ami,
  SlaveTemplateUsEast1Parameters.zone,
  null,
  SlaveTemplateUsEast1Parameters.securityGroups,
  SlaveTemplateUsEast1Parameters.remoteFS,
  InstanceType.fromValue(SlaveTemplateUsEast1Parameters.type),
  SlaveTemplateUsEast1Parameters.ebsOptimized,
  SlaveTemplateUsEast1Parameters.labelString,
  Node.Mode.NORMAL,
  SlaveTemplateUsEast1Parameters.description,
  SlaveTemplateUsEast1Parameters.initScript,
  SlaveTemplateUsEast1Parameters.tmpDir,
  SlaveTemplateUsEast1Parameters.userData,
  SlaveTemplateUsEast1Parameters.numExecutors,
  SlaveTemplateUsEast1Parameters.remoteAdmin,
  new UnixData(null, null, null),
  SlaveTemplateUsEast1Parameters.jvmopts,
  SlaveTemplateUsEast1Parameters.stopOnTerminate,
  SlaveTemplateUsEast1Parameters.subnetId,
  [SlaveTemplateUsEast1Parameters.tags],
  SlaveTemplateUsEast1Parameters.idleTerminationMinutes,
  SlaveTemplateUsEast1Parameters.usePrivateDnsName,
  SlaveTemplateUsEast1Parameters.instanceCapStr,
  SlaveTemplateUsEast1Parameters.iamInstanceProfile,
  SlaveTemplateUsEast1Parameters.deleteRootOnTermination,
  SlaveTemplateUsEast1Parameters.useEphemeralDevices,
  SlaveTemplateUsEast1Parameters.useDedicatedTenancy,
  SlaveTemplateUsEast1Parameters.launchTimeoutStr,
  SlaveTemplateUsEast1Parameters.associatePublicIp,
  SlaveTemplateUsEast1Parameters.customDeviceMapping,
  SlaveTemplateUsEast1Parameters.connectBySSHProcess,
  SlaveTemplateUsEast1Parameters.connectUsingPublicIp
)
 
// https://github.com/jenkinsci/ec2-plugin/blob/ec2-1.38/src/main/java/hudson/plugins/ec2/AmazonEC2Cloud.java
AmazonEC2Cloud amazonEC2Cloud = new AmazonEC2Cloud(
  AmazonEC2CloudParameters.cloudName,
  AmazonEC2CloudParameters.useInstanceProfileForCredentials,
  AmazonEC2CloudParameters.credentialsId,
  AmazonEC2CloudParameters.region,
  AmazonEC2CloudParameters.privateKey,
  AmazonEC2CloudParameters.instanceCapStr,
  [slaveTemplateUsEast1]
)
 
// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()
 
// get credentials domain
def domain = Domain.global()
 
// get credentials store
def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
 
// add credential to store
store.addCredentials(domain, aWSCredentialsImpl)
 
// add cloud configuration to Jenkins
jenkins.clouds.add(amazonEC2Cloud)
 
// save current Jenkins state to disk
jenkins.save()
