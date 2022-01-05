param location string = resourceGroup().location

param catalog_api_image string
param orders_api_image string
param ui_image string
param yarp_image string
param registry string
param registryUsername string

@secure()
param registryPassword string

module logs 'logs.bicep' = {
  name: 'logAnalyticWorkspace'
  params: {
    location: location
  }
}

var workspace_resource_id = logs.outputs.workspace_resource_id

module ai 'application_insights.bicep' = {
  name: 'applicationInsights'
  params: {
    location: location
    workspace_id: workspace_resource_id
  }
}

module env 'environment.bicep' = {
  name: 'containerAppEnvironment'
  params: {
    location: location
    logsClientId: logs.outputs.clientId
    logsClientSecret: logs.outputs.clientSecret
  }
}

module catalog_api 'container-app.bicep' = {
  name: 'catalog-api'
  params: {
    name: 'catalog-api'
    containerAppEnvironmentId: env.outputs.id
    registry: registry
    registryPassword: registryPassword
    registryUsername: registryUsername
    repositoryImage: catalog_api_image
    allowExternalIngress: false
    allowInternalIngress: true
  }
}

var catalog_api_fqdn = 'https://${catalog_api.outputs.fqdn}'

module orders_api 'container-app.bicep' = {
  name: 'orders-api'
  params: {
    name: 'orders-api'
    containerAppEnvironmentId: env.outputs.id
    registry: registry
    registryPassword: registryPassword
    registryUsername: registryUsername
    repositoryImage: orders_api_image
    allowExternalIngress: false
    allowInternalIngress: true
  }
}

var orders_api_fqdn = 'https://${orders_api.outputs.fqdn}'

module ui 'container-app.bicep' = {
  name: 'ui'
  params: {
    name: 'ui'
    containerAppEnvironmentId: env.outputs.id
    registry: registry
    registryPassword: registryPassword
    registryUsername: registryUsername
    repositoryImage: ui_image
    allowExternalIngress: false
    allowInternalIngress: true
    envVars : [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
      {
        name: 'CATALOG_API'
        value: catalog_api_fqdn
      }
      {
        name: 'ORDERS_API'
        value: orders_api_fqdn
      }
    ]
  }
}

var ui_fqdn = 'https://${ui.outputs.fqdn}'

module yarp 'container-app.bicep' = {
  name: 'yarp'
  params: {
    name: 'yarp'
    containerAppEnvironmentId: env.outputs.id
    registry: registry
    registryPassword: registryPassword
    registryUsername: registryUsername
    repositoryImage: yarp_image
    allowExternalIngress: true
    allowInternalIngress: false
    envVars : [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
      {
        name: 'WEB_UI'
        value: ui_fqdn
      }
    ]
  }
}
