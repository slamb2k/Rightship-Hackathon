@description('Storage Account Privatelink Resource')
param storageAccountPrivateLinkResource string

@description('Storage Account name')
param storageAccountName string

@description('Keyvault Private Link resource.')
param keyvaultPrivateLinkResource string

@description('keyvault name.')
param keyvaultName string

@description('event hub name.')
param eventHubName string

@description('EventHub Private Link resource.')
param eventHubPrivateLinkResource string

var targetSubResourceDfs = 'dfs'
var targetSubResourceVault = 'vault'
var targetSubResourceEventHub = 'namespace'
// var targetSubResourceAml = 'amlworkspace'

@description('Vnet name for private link')
param vnetName string

@description('Privatelink subnet Id')
param privateLinkSubnetId string

@description('Privatelink subnet Id')
param privateLinkLocation string = resourceGroup().location

var privateDnsNameStorageString = 'privatelink.dfs.${environment().suffixes.storage}'
var storageAccountPrivateEndpointNameString = '${storageAccountName}privateendpoint'

var privateDnsNameVaultString = 'privatelink.vaultcore.azure.net'
var keyvaultPrivateEndpointNameString = '${keyvaultName}privateendpoint'

var privateDnsNameEventHubString = 'privatelink.servicebus.windows.net'
var eventHubPrivateEndpointNameString = '${eventHubName}privateendpoint'

resource storageAccountPrivateEndpointName 'Microsoft.Network/privateEndpoints@2021-02-01' = {
  name: storageAccountPrivateEndpointNameString
  location: privateLinkLocation
  properties: {
    privateLinkServiceConnections: [
      {
        name: storageAccountPrivateEndpointNameString
        properties: {
          privateLinkServiceId: storageAccountPrivateLinkResource
          groupIds: [
            targetSubResourceDfs
          ]
        }
      }
    ]
    subnet: {
      id: privateLinkSubnetId
    }
  }
}
resource privateDnsNameStorage 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsNameStorageString
  location: 'global'
  tags: {}
  properties: {}
  dependsOn: [
    storageAccountPrivateEndpointName
  ]
}
resource privateDnsNameStorage_vnetName 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsNameStorage
  name: vnetName
  location: 'global'
  properties: {
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetName)
    }
    registrationEnabled: false
  }
}
resource storageAccountPrivateEndpointName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-02-01' = {
  parent: storageAccountPrivateEndpointName
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-dfs-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsNameStorage.id
        }
      }
    ]
  }
}

resource keyvaultPrivateEndpointName 'Microsoft.Network/privateEndpoints@2021-02-01' = {
  name: keyvaultPrivateEndpointNameString
  location: privateLinkLocation
  properties: {
    privateLinkServiceConnections: [
      {
        name: keyvaultPrivateEndpointNameString
        properties: {
          privateLinkServiceId: keyvaultPrivateLinkResource
          groupIds: [
            targetSubResourceVault
          ]
        }
      }
    ]
    subnet: {
      id: privateLinkSubnetId
    }
  }
  tags: {}
}
resource privateDnsNameVault 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsNameVaultString
  location: 'global'
  tags: {}
  properties: {}
  dependsOn: [
    keyvaultPrivateEndpointName
  ]
}
resource privateDnsNameVault_vnetName 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsNameVault
  name: vnetName
  location: 'global'
  properties: {
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetName)
    }
    registrationEnabled: false
  }
}
resource keyvaultPrivateEndpointName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-02-01' = {
  parent: keyvaultPrivateEndpointName
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-vaultcore-azure-net'
        properties: {
          privateDnsZoneId: privateDnsNameVault.id
        }
      }
    ]
  }
}

resource eventHubPrivateEndpointName 'Microsoft.Network/privateEndpoints@2021-02-01' = {
  name: eventHubPrivateEndpointNameString
  location: privateLinkLocation
  properties: {
    privateLinkServiceConnections: [
      {
        name: eventHubPrivateEndpointNameString
        properties: {
          privateLinkServiceId: eventHubPrivateLinkResource
          groupIds: [
            targetSubResourceEventHub
          ]
        }
      }
    ]
    subnet: {
      id: privateLinkSubnetId
    }
  }
}
resource privateDnsNameEventHub 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsNameEventHubString
  location: 'global'
  tags: {}
  properties: {}
  dependsOn: [
    eventHubPrivateEndpointName
  ]
}
resource privateDnsNameEventHub_vnetName 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsNameEventHub
  name: vnetName
  location: 'global'
  properties: {
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetName)
    }
    registrationEnabled: false
  }
}
resource eventHubPrivateEndpointName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-02-01' = {
  parent: eventHubPrivateEndpointName
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-servicebus-windows-net'
        properties: {
          privateDnsZoneId: privateDnsNameEventHub.id
        }
      }
    ]
  }
}

// Configure Private Link to AML
// resource amlPrivateEndpointName 'Microsoft.Network/privateEndpoints@2021-02-01' = {
//   name: amlPrivateEndpointName_var
//   location: privateLinkLocation
//   properties: {
//     privateLinkServiceConnections: [
//       {
//         name: amlPrivateEndpointName_var
//         properties: {
//           privateLinkServiceId: amlPrivateLinkResource
//           groupIds: [
//             targetSubResourceAml
//           ]
//         }
//       }
//     ]
//     subnet: {
//       id: privateLinkSubnetId
//     }
//   }
// }
// resource privatelink_api_azureml_ms 'Microsoft.Network/privateDnsZones@2018-09-01' = {
//   name: privateDnsNameAmlApi_var
//   location: 'global'
//   properties: {}
// }
// resource privatelink_api_azureml_ms_resourceId_Microsoft_Network_virtualNetworks_parameters_vnetName 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
//   parent: privatelink_api_azureml_ms
//   name: 'privatelink_api_azureml_ms'
//   location: 'global'
//   properties: {
//     virtualNetwork: {
//       id: resourceId('Microsoft.Network/virtualNetworks', vnetName)
//     }
//     registrationEnabled: false
//   }
// }
// resource privatelink_notebooks_azure_net 'Microsoft.Network/privateDnsZones@2018-09-01' = {
//   name: privateDnsNameAmlNotebook_var
//   location: 'global'
//   properties: {}
// }
// resource privatelink_notebooks_azure_net_resourceId_Microsoft_Network_virtualNetworks_parameters_vnetName 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
//   parent: privatelink_notebooks_azure_net
//   name: 'privatelink_notebooks_azure_net'
//   location: 'global'
//   properties: {
//     virtualNetwork: {
//       id: resourceId('Microsoft.Network/virtualNetworks', vnetName)
//     }
//     registrationEnabled: false
//   }
// }
// resource privateEndpointName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-03-01' = {
//   parent: amlPrivateEndpointName
//   name: 'default'
//   properties: {
//     privateDnsZoneConfigs: [
//       {
//         name: 'privatelink-api-azureml-ms'
//         properties: {
//           privateDnsZoneId: privatelink_api_azureml_ms.id
//         }
//       }
//       {
//         name: 'privatelink-notebooks-azure-net'
//         properties: {
//           privateDnsZoneId: privatelink_notebooks_azure_net.id
//         }
//       }
//     ]
//   }
// }
