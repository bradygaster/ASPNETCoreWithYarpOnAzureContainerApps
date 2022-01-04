param baseName string = resourceGroup().name
param location string = resourceGroup().location
param logsClientId string
param logsClientSecret string

resource env 'Microsoft.Web/kubeEnvironments@2021-02-01' = {
  name: '${baseName}env'
  location: location
  properties: {
    type: 'managed'
    internalLoadBalancerEnabled: false
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: logsClientId
        sharedKey: logsClientSecret
      }
    }
  }
}

output id string = env.id
