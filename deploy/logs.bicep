param location string
param baseName string = resourceGroup().name

resource logs 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: '${baseName}logs'
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  })
}

output clientId string = logs.properties.customerId
output clientSecret string = logs.listKeys().primarySharedKey
output workspace_resource_id string = logs.id
