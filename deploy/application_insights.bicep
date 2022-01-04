param location string
param baseName string = resourceGroup().name
param workspace_id string 

resource appInsightsComponents 'Microsoft.Insights/components@2020-02-02' = {
  name: '${baseName}ai'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspace_id
  }
}
