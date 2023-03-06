// Create a Jenkins user for Swarm agents
// The user will have a long, randomized password that is not used for anything
// The user will also be given an API token
// Swarm agents will use username + API token to authenticate against the controller

// This is done via an init script instead of via CasC because CasC does not allow us to both
//   declare that we use the googleOAuth2 login provider and also inject additional users into
//   the private security realm

import hudson.model.*
import hudson.security.HudsonPrivateSecurityRealm
import jenkins.model.*
import jenkins.security.*
import jenkins.security.apitoken.*

// Fetch parameters from jenkins' Credential store

def jenkinsCredentials = com.cloudbees.plugins.credentials.CredentialsProvider.lookupCredentials(
        com.cloudbees.plugins.credentials.Credentials.class,
        Jenkins.instance,
        null,
        null
);

def userName = (jenkinsCredentials.find { it.id == "swarm_agent_username" }).getSecret().getPlainText()
def userPassword = (jenkinsCredentials.find { it.id == "swarm_agent_password" }).getSecret().getPlainText()
def tokenName = (jenkinsCredentials.find { it.id == "swarm_agent_api_token_key" }).getSecret().getPlainText()
def tokenValue = (jenkinsCredentials.find { it.id == "swarm_agent_api_token" }).getSecret().getPlainText()

// Create swarm agent Jenkins user, in case it does not yet exist

HudsonPrivateSecurityRealm securityRealm = new HudsonPrivateSecurityRealm(true, false, null)
def users = securityRealm.getAllUsers()
if (!users.any{ it.getId() == userName }) {
  securityRealm.createAccount(userName, userPassword)
}

// Add API token to swarm agent Jenkins user if it does not yet exist

def user = User.get(userName, false)
def apiTokenProperty = user.getProperty(ApiTokenProperty.class)
def existingTokens = apiTokenProperty.getTokenList()
if (!existingTokens.any{ it.name == tokenName }) {
	apiTokenProperty.tokenStore.addFixedNewToken(tokenName, tokenValue)
	user.save()
}
