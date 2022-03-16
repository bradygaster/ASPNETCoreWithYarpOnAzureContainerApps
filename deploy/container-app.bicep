param name string
param location string = resourceGroup().location
param containerAppEnvironmentId string
param repositoryImage string
param envVars array = []
param allowExternalIngress bool = false
param allowInternalIngress bool = false
param targetIngressPort int = 80
param registry string
param registryUsername string
@secure()
param registryPassword string

// Handle whether to use an authenticated container registry
var secrets = empty(registryUsername) ? [] : array({
  name: 'container-registry-password'
  value: registryPassword
})

var registries = empty(registryUsername) ? [] : array({
  server: registry
  username: registryUsername
  passwordSecretRef: 'container-registry-password'
})


resource containerApp 'Microsoft.Web/containerApps@2021-03-01' = {
  name: name
  kind: 'containerapp'
  location: location
  properties: {
    kubeEnvironmentId: containerAppEnvironmentId
    configuration: {
      secrets: secrets
      registries: registries
      ingress: {
        internal: allowInternalIngress
        external: allowExternalIngress
        targetPort: targetIngressPort
      }
    }
    template: {
      containers: [
        {
          image: repositoryImage
          name: name
          env: envVars
        }
      ]
      scale: {
        minReplicas: 0
      }
    }
  }
}

output fqdn string = containerApp.properties.configuration.ingress.fqdn
