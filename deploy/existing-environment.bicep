param envName string


resource existingEnv 'Microsoft.Web/kubeEnvironments@2021-02-01' existing = {
  name: envName
}

output id string = existingEnv.id
