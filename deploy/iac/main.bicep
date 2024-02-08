@description('Name of the existing application insights to use as the scope for log queries.')
param appInsightsName string

@description('Name of the resource group that contains the application insights.')
param appInsightsResourceGroup string

@metadata({ Description: 'Resource name that Azure portal uses for the dashboard.' })
param dashboardName string = guid(appInsightsName, appInsightsResourceGroup, resourceGroup().name)

@description('Name of the dashboard to display in Azure portal')
param dashboardDisplayName string = 'FHIR Import'
param location string = resourceGroup().location

resource dashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: dashboardName
  location: location
  tags: {
    'hidden-title': dashboardDisplayName
  }
  properties: {
    lenses: [
      {
        order: 0
        parts: [
          {
            position: {
              x: 0
              y: 0
              rowSpan: 4
              colSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceTypeMode'
                  isOptional: true
                }
                {
                  name: 'ComponentId'
                  isOptional: true
                }
                {
                  name: 'Scope'
                  value: {
                    resourceIds: [
                      resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                    ]
                  }
                  isOptional: true
                }
                {
                  name: 'PartId'
                  value: '30d854f5-4b7b-43e7-ab0d-11ea0029c9c1'
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '2.0'
                  isOptional: true
                }
                {
                  name: 'TimeRange'
                  value: 'P30D'
                  isOptional: true
                }
                {
                  name: 'DashboardId'
                  isOptional: true
                }
                {
                  name: 'DraftRequestParameters'
                  isOptional: true
                }
                {
                  name: 'Query'
                  value: 'let completed = customEvents\n    | where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Success"\n    | distinct\n        timestamp,\n        importId = tostring(customDimensions.ImportId),\n        ImportStatus = tostring(customDimensions.ImportStatus)\n    | order by timestamp desc;\nlet failed = customEvents\n    | where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Failed"\n    | distinct\n        timestamp,\n        importId = tostring(customDimensions.ImportId),\n        ImportStatus = tostring(customDimensions.ImportStatus)\n    | order by timestamp desc;\nlet running = customEvents\n    | where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Running"\n    | distinct\n        timestamp,\n        importId = tostring(customDimensions.ImportId),\n        ImportStatus = tostring(customDimensions.ImportStatus)\n    | order by timestamp desc;\ncompleted\n| distinct importId, ImportStatus\n| extend Order=1\n| join kind=leftanti running on importId\n| join kind=leftanti failed on importId\n| union withsource=RunningTable kind=outer \n    (running\n    | distinct importId, ImportStatus\n    | join kind=leftanti completed on importId\n    | join kind=leftanti failed on importId\n    | distinct\n        importId,\n        ImportStatus\n    | extend Order=3\n    )\n| union withsource=FailedTable kind=outer \n    (failed\n    | distinct\n        importId,\n        ImportStatus\n    | extend Order=2\n    )\n| summarize TotalJobCount = count() by ImportStatus, Order\n| sort by Order asc \n| project ImportStatus, TotalJobCount\n| render piechart with(title="Job Counts by Status")\n'
                  isOptional: true
                }
                {
                  name: 'ControlType'
                  value: 'FrameControlChart'
                  isOptional: true
                }
                {
                  name: 'SpecificChart'
                  value: 'Pie'
                  isOptional: true
                }
                {
                  name: 'PartTitle'
                  value: 'Job Counts by Status'
                  isOptional: true
                }
                {
                  name: 'PartSubTitle'
                  value: 'appi-customevent-lra-poc'
                  isOptional: true
                }
                {
                  name: 'Dimensions'
                  value: {
                    xAxis: {
                      name: 'ImportStatus'
                      type: 'string'
                    }
                    yAxis: [
                      {
                        name: 'TotalJobCount'
                        type: 'long'
                      }
                    ]
                    splitBy: []
                    aggregation: 'Sum'
                  }
                  isOptional: true
                }
                {
                  name: 'LegendOptions'
                  value: {
                    isEnabled: true
                    position: 'Bottom'
                  }
                  isOptional: true
                }
                {
                  name: 'IsQueryContainTimeRange'
                  value: false
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart'
              settings: {}
            }
          }
          {
            position: {
              x: 5
              y: 0
              rowSpan: 1
              colSpan: 5
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  content: '## Running Jobs'
                  title: ''
                  subtitle: ''
                  markdownSource: 1
                  markdownUri: ''
                }
              }
            }
          }
          {
            position: {
              x: 10
              y: 0
              rowSpan: 1
              colSpan: 5
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  content: '## Completed Jobs'
                  title: ''
                  subtitle: ''
                  markdownSource: 1
                  markdownUri: ''
                }
              }
            }
          }
          {
            position: {
              x: 15
              y: 0
              rowSpan: 1
              colSpan: 5
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  content: '## Failed Jobs'
                  title: ''
                  subtitle: ''
                  markdownSource: 1
                  markdownUri: ''
                }
              }
            }
          }
          {
            position: {
              x: 20
              y: 0
              rowSpan: 1
              colSpan: 5
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  content: '## Application Status'
                  title: ''
                  subtitle: ''
                  markdownSource: 1
                  markdownUri: ''
                }
              }
            }
          }
          {
            position: {
              x: 5
              y: 1
              rowSpan: 2
              colSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceTypeMode'
                  isOptional: true
                }
                {
                  name: 'ComponentId'
                  isOptional: true
                }
                {
                  name: 'Scope'
                  value: {
                    resourceIds: [
                      resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                    ]
                  }
                  isOptional: true
                }
                {
                  name: 'PartId'
                  value: '8dfa7a4a-65a2-4d9c-870d-5e9ee1483e83'
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '2.0'
                  isOptional: true
                }
                {
                  name: 'TimeRange'
                  value: 'P30D'
                  isOptional: true
                }
                {
                  name: 'DashboardId'
                  isOptional: true
                }
                {
                  name: 'DraftRequestParameters'
                  isOptional: true
                }
                {
                  name: 'Query'
                  value: 'let completed = customEvents\n    | where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Success"\n    | distinct timestamp, importId = tostring(customDimensions.ImportId)\n    | order by timestamp desc;\nlet failed = customEvents\n    | where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Failed"\n    | distinct timestamp, importId = tostring(customDimensions.ImportId)\n    | order by timestamp desc;\nlet running = customEvents\n    | where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Running"\n    | distinct timestamp, importId = tostring(customDimensions.ImportId)\n    | order by timestamp desc;\nrunning\n| distinct importId\n| join kind=leftanti completed on importId\n| join kind=leftanti failed on importId\n| count as ImportRunning\n\n'
                  isOptional: true
                }
                {
                  name: 'ControlType'
                  value: 'AnalyticsGrid'
                  isOptional: true
                }
                {
                  name: 'SpecificChart'
                  isOptional: true
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                  isOptional: true
                }
                {
                  name: 'PartSubTitle'
                  value: 'appi-customevent-lra-poc'
                  isOptional: true
                }
                {
                  name: 'Dimensions'
                  isOptional: true
                }
                {
                  name: 'LegendOptions'
                  isOptional: true
                }
                {
                  name: 'IsQueryContainTimeRange'
                  value: false
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart'
              settings: {}
              partHeader: {
                title: 'Count of running import jobs'
                subtitle: ''
              }
            }
          }
          {
            position: {
              x: 10
              y: 1
              rowSpan: 2
              colSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceTypeMode'
                  isOptional: true
                }
                {
                  name: 'ComponentId'
                  isOptional: true
                }
                {
                  name: 'Scope'
                  value: {
                    resourceIds: [
                      resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                    ]
                  }
                  isOptional: true
                }
                {
                  name: 'PartId'
                  value: '8e94338b-4878-4169-a47c-d07417981589'
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '2.0'
                  isOptional: true
                }
                {
                  name: 'TimeRange'
                  value: 'P1D'
                  isOptional: true
                }
                {
                  name: 'DashboardId'
                  isOptional: true
                }
                {
                  name: 'DraftRequestParameters'
                  isOptional: true
                }
                {
                  name: 'Query'
                  value: 'let completed = customEvents\n    | where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Success"\n    | distinct timestamp, importId = tostring(customDimensions.ImportId)\n    | order by timestamp desc;\nlet failed = customEvents\n    | where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Failed"\n    | distinct timestamp, importId = tostring(customDimensions.ImportId)\n    | order by timestamp desc;\nlet running = customEvents\n    | where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Running"\n    | distinct timestamp, importId = tostring(customDimensions.ImportId)\n    | order by timestamp desc;\ncompleted\n| distinct importId\n| join kind=leftanti running on importId\n| join kind=leftanti failed on importId\n| count as ImportCompleted\n\n'
                  isOptional: true
                }
                {
                  name: 'ControlType'
                  value: 'AnalyticsGrid'
                  isOptional: true
                }
                {
                  name: 'SpecificChart'
                  isOptional: true
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                  isOptional: true
                }
                {
                  name: 'PartSubTitle'
                  value: 'appi-customevent-lra-poc'
                  isOptional: true
                }
                {
                  name: 'Dimensions'
                  isOptional: true
                }
                {
                  name: 'LegendOptions'
                  isOptional: true
                }
                {
                  name: 'IsQueryContainTimeRange'
                  value: false
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart'
              settings: {}
              partHeader: {
                title: 'Count of completed import jobs'
                subtitle: ''
              }
            }
          }
          {
            position: {
              x: 15
              y: 1
              rowSpan: 2
              colSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceTypeMode'
                  isOptional: true
                }
                {
                  name: 'ComponentId'
                  isOptional: true
                }
                {
                  name: 'Scope'
                  value: {
                    resourceIds: [
                      resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                    ]
                  }
                  isOptional: true
                }
                {
                  name: 'PartId'
                  value: '46c39a51-05f6-4d07-9911-96c23fc50ce9'
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '2.0'
                  isOptional: true
                }
                {
                  name: 'TimeRange'
                  value: 'P1D'
                  isOptional: true
                }
                {
                  name: 'DashboardId'
                  isOptional: true
                }
                {
                  name: 'DraftRequestParameters'
                  isOptional: true
                }
                {
                  name: 'Query'
                  value: 'let failed = customEvents\n    | where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Failed"\n    | distinct timestamp, importId = tostring(customDimensions.ImportId)\n    | order by timestamp desc;\nfailed\n| distinct importId\n| count as ImportFailed\n\n'
                  isOptional: true
                }
                {
                  name: 'ControlType'
                  value: 'AnalyticsGrid'
                  isOptional: true
                }
                {
                  name: 'SpecificChart'
                  isOptional: true
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                  isOptional: true
                }
                {
                  name: 'PartSubTitle'
                  value: 'appi-customevent-lra-poc'
                  isOptional: true
                }
                {
                  name: 'Dimensions'
                  isOptional: true
                }
                {
                  name: 'LegendOptions'
                  isOptional: true
                }
                {
                  name: 'IsQueryContainTimeRange'
                  value: false
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart'
              settings: {}
              partHeader: {
                title: 'Count of failed import jobs'
                subtitle: ''
              }
            }
          }
          {
            position: {
              x: 20
              y: 1
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                          }
                          name: 'requests/failed'
                          aggregationType: 7
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            resourceDisplayName: 'appi-customevent-lra-poc'
                            color: '#EC008C'
                          }
                        }
                      ]
                      title: 'Failed requests'
                      titleKind: 2
                      visualization: {
                        chartType: 3
                      }
                      openBladeOnClick: {
                        openBlade: true
                        destinationBlade: {
                          bladeName: 'ResourceMenuBlade'
                          parameters: {
                            id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                            menuid: 'failures'
                          }
                          extensionName: 'HubsExtension'
                          options: {
                            parameters: {
                              id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                              menuid: 'failures'
                            }
                          }
                        }
                      }
                    }
                  }
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {
                content: {
                  options: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                          }
                          name: 'requests/failed'
                          aggregationType: 7
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            resourceDisplayName: 'appi-customevent-lra-poc'
                            color: '#EC008C'
                          }
                        }
                      ]
                      title: 'Failed requests'
                      titleKind: 2
                      visualization: {
                        chartType: 3
                        disablePinning: true
                      }
                      openBladeOnClick: {
                        openBlade: true
                        destinationBlade: {
                          bladeName: 'ResourceMenuBlade'
                          parameters: {
                            id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                            menuid: 'failures'
                          }
                          extensionName: 'HubsExtension'
                          options: {
                            parameters: {
                              id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                              menuid: 'failures'
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
              filters: {
                MsPortalFx_TimeRange: {
                  model: {
                    format: 'local'
                    granularity: 'auto'
                    relative: '60m'
                  }
                }
              }
            }
          }
          {
            position: {
              x: 5
              y: 3
              rowSpan: 4
              colSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceTypeMode'
                  isOptional: true
                }
                {
                  name: 'ComponentId'
                  isOptional: true
                }
                {
                  name: 'Scope'
                  value: {
                    resourceIds: [
                      resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                    ]
                  }
                  isOptional: true
                }
                {
                  name: 'PartId'
                  value: '1da68496-1cb8-499e-be11-be6d3ad15398'
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '2.0'
                  isOptional: true
                }
                {
                  name: 'TimeRange'
                  value: 'P30D'
                  isOptional: true
                }
                {
                  name: 'DashboardId'
                  isOptional: true
                }
                {
                  name: 'DraftRequestParameters'
                  isOptional: true
                }
                {
                  name: 'Query'
                  value: 'customEvents\n| where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Running"\n| extend\n    ImportId=tostring(customDimensions.ImportId),\n    ImportStatus=tostring(customDimensions.ImportStatus),\n    StatusUrl=tostring(customDimensions.StatusUrl),\n    CorrelationId=tostring(customDimensions.CorrelationId),\n    ActualResourceCount=tostring(customDimensions.ActualResourceCount),\n    ExpectedResourceCount=tostring(customDimensions.ExpectedResourceCount),\n    ImportMode=tostring(customDimensions.ImportMode),\n    ResourceType=tostring(customDimensions.ResourceType),\n    InputUrl=tostring(customDimensions.InputUrl),\n    ErrorUrl=tostring(customDimensions.ErrorUrl)\n| project\n    timestamp,\n    ImportId,\n    ImportStatus,\n    CorrelationId,\n    ActualResourceCount,\n    ExpectedResourceCount,\n    ResourceType,\n    ImportMode,\n    InputUrl,\n    StatusUrl    \n\n'
                  isOptional: true
                }
                {
                  name: 'ControlType'
                  value: 'AnalyticsGrid'
                  isOptional: true
                }
                {
                  name: 'SpecificChart'
                  isOptional: true
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                  isOptional: true
                }
                {
                  name: 'PartSubTitle'
                  value: 'appi-customevent-lra-poc'
                  isOptional: true
                }
                {
                  name: 'Dimensions'
                  isOptional: true
                }
                {
                  name: 'LegendOptions'
                  isOptional: true
                }
                {
                  name: 'IsQueryContainTimeRange'
                  value: false
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart'
              settings: {}
              partHeader: {
                title: 'Running Import Job Details'
                subtitle: ''
              }
            }
          }
          {
            position: {
              x: 10
              y: 3
              rowSpan: 4
              colSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceTypeMode'
                  isOptional: true
                }
                {
                  name: 'ComponentId'
                  isOptional: true
                }
                {
                  name: 'Scope'
                  value: {
                    resourceIds: [
                      resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                    ]
                  }
                  isOptional: true
                }
                {
                  name: 'PartId'
                  value: '642a7e26-4059-4e6c-932d-c0e53344bdc2'
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '2.0'
                  isOptional: true
                }
                {
                  name: 'TimeRange'
                  value: 'P30D'
                  isOptional: true
                }
                {
                  name: 'DashboardId'
                  isOptional: true
                }
                {
                  name: 'DraftRequestParameters'
                  isOptional: true
                }
                {
                  name: 'Query'
                  value: 'customEvents\n| where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Success"\n| extend\n    ImportId=tostring(customDimensions.ImportId),\n    ImportStatus=tostring(customDimensions.ImportStatus),\n    StatusUrl=tostring(customDimensions.StatusUrl),\n    CorrelationId=tostring(customDimensions.CorrelationId),\n    ActualResourceCount=tostring(customDimensions.ActualResourceCount),\n    ExpectedResourceCount=tostring(customDimensions.ExpectedResourceCount),\n    ImportMode=tostring(customDimensions.ImportMode),\n    ResourceType=tostring(customDimensions.ResourceType),\n    InputUrl=tostring(customDimensions.InputUrl),\n    ErrorUrl=tostring(customDimensions.ErrorUrl)\n| project timestamp, ImportId, ImportStatus, CorrelationId, ActualResourceCount, ExpectedResourceCount, ResourceType, ImportMode, InputUrl, StatusUrl    \n\n'
                  isOptional: true
                }
                {
                  name: 'ControlType'
                  value: 'AnalyticsGrid'
                  isOptional: true
                }
                {
                  name: 'SpecificChart'
                  isOptional: true
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                  isOptional: true
                }
                {
                  name: 'PartSubTitle'
                  value: 'appi-customevent-lra-poc'
                  isOptional: true
                }
                {
                  name: 'Dimensions'
                  isOptional: true
                }
                {
                  name: 'LegendOptions'
                  isOptional: true
                }
                {
                  name: 'IsQueryContainTimeRange'
                  value: false
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart'
              settings: {}
              partHeader: {
                title: 'Completed Import Job Details'
                subtitle: ''
              }
            }
          }
          {
            position: {
              x: 15
              y: 3
              rowSpan: 4
              colSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceTypeMode'
                  isOptional: true
                }
                {
                  name: 'ComponentId'
                  isOptional: true
                }
                {
                  name: 'Scope'
                  value: {
                    resourceIds: [
                      resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                    ]
                  }
                  isOptional: true
                }
                {
                  name: 'PartId'
                  value: '11e7139f-4fda-4f5a-bb12-8ef3d3814278'
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '2.0'
                  isOptional: true
                }
                {
                  name: 'TimeRange'
                  value: 'P30D'
                  isOptional: true
                }
                {
                  name: 'DashboardId'
                  isOptional: true
                }
                {
                  name: 'DraftRequestParameters'
                  isOptional: true
                }
                {
                  name: 'Query'
                  value: 'customEvents\n| where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Failed"\n| extend\n    ImportId=tostring(customDimensions.ImportId),\n    ImportStatus=tostring(customDimensions.ImportStatus),\n    StatusUrl=tostring(customDimensions.StatusUrl),\n    CorrelationId=tostring(customDimensions.CorrelationId),\n    ActualResourceCount=tostring(customDimensions.ActualResourceCount),\n    ExpectedResourceCount=tostring(customDimensions.ExpectedResourceCount),\n    ImportMode=tostring(customDimensions.ImportMode),\n    ResourceType=tostring(customDimensions.ResourceType),\n    InputUrl=tostring(customDimensions.InputUrl),\n    ErrorUrl=tostring(customDimensions.ErrorUrl)\n| project\n    timestamp,\n    ImportId,\n    ImportStatus,\n    CorrelationId,\n    ActualResourceCount,\n    ExpectedResourceCount,\n    ResourceType,\n    ImportMode,\n    InputUrl,\n    StatusUrl,\n    ErrorUrl\n\n'
                  isOptional: true
                }
                {
                  name: 'ControlType'
                  value: 'AnalyticsGrid'
                  isOptional: true
                }
                {
                  name: 'SpecificChart'
                  isOptional: true
                }
                {
                  name: 'PartTitle'
                  value: 'Analytics'
                  isOptional: true
                }
                {
                  name: 'PartSubTitle'
                  value: 'appi-customevent-lra-poc'
                  isOptional: true
                }
                {
                  name: 'Dimensions'
                  isOptional: true
                }
                {
                  name: 'LegendOptions'
                  isOptional: true
                }
                {
                  name: 'IsQueryContainTimeRange'
                  value: false
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart'
              settings: {}
              partHeader: {
                title: 'Failed Import Job Details'
                subtitle: ''
              }
            }
          }
          {
            position: {
              x: 0
              y: 4
              rowSpan: 4
              colSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceTypeMode'
                  isOptional: true
                }
                {
                  name: 'ComponentId'
                  isOptional: true
                }
                {
                  name: 'Scope'
                  value: {
                    resourceIds: [
                      resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                    ]
                  }
                  isOptional: true
                }
                {
                  name: 'PartId'
                  value: '15ae8e10-149f-4b45-9922-8f7438b3247d'
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '2.0'
                  isOptional: true
                }
                {
                  name: 'TimeRange'
                  value: 'P30D'
                  isOptional: true
                }
                {
                  name: 'DashboardId'
                  isOptional: true
                }
                {
                  name: 'DraftRequestParameters'
                  isOptional: true
                }
                {
                  name: 'Query'
                  value: 'customEvents\n| where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Success"\n| project\n    ResourceCount=toint(tostring(customDimensions.ActualResourceCount)),\n    ImportId=tostring(customDimensions.ImportId),\n    ResourceType=tostring(customDimensions.ResourceType)\n| summarize sum(ResourceCount) by ResourceType\n| render piechart with(title="Total Resource Count by Type")\n\n'
                  isOptional: true
                }
                {
                  name: 'ControlType'
                  value: 'FrameControlChart'
                  isOptional: true
                }
                {
                  name: 'SpecificChart'
                  value: 'Pie'
                  isOptional: true
                }
                {
                  name: 'PartTitle'
                  value: 'Total Resource Count by Type'
                  isOptional: true
                }
                {
                  name: 'PartSubTitle'
                  value: 'appi-customevent-lra-poc'
                  isOptional: true
                }
                {
                  name: 'Dimensions'
                  value: {
                    xAxis: {
                      name: 'ResourceType'
                      type: 'string'
                    }
                    yAxis: [
                      {
                        name: 'sum_ResourceCount'
                        type: 'long'
                      }
                    ]
                    splitBy: []
                    aggregation: 'Sum'
                  }
                  isOptional: true
                }
                {
                  name: 'LegendOptions'
                  value: {
                    isEnabled: true
                    position: 'Bottom'
                  }
                  isOptional: true
                }
                {
                  name: 'IsQueryContainTimeRange'
                  value: false
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart'
              settings: {}
              partHeader: {
                title: 'Total Completed Resource Count By Type'
                subtitle: ''
              }
            }
          }
          {
            position: {
              x: 20
              y: 5
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                          }
                          name: 'requests/count'
                          aggregationType: 7
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Server requests'
                            resourceDisplayName: 'appi-customevent-lra-poc'
                            color: '#0078D4'
                          }
                        }
                      ]
                      title: 'Server requests'
                      titleKind: 2
                      visualization: {
                        chartType: 3
                      }
                      openBladeOnClick: {
                        openBlade: true
                        destinationBlade: {
                          bladeName: 'ResourceMenuBlade'
                          parameters: {
                            id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                            menuid: 'performance'
                          }
                          extensionName: 'HubsExtension'
                          options: {
                            parameters: {
                              id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                              menuid: 'performance'
                            }
                          }
                        }
                      }
                    }
                  }
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {
                content: {
                  options: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                          }
                          name: 'requests/count'
                          aggregationType: 7
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Server requests'
                            resourceDisplayName: 'appi-customevent-lra-poc'
                            color: '#0078D4'
                          }
                        }
                      ]
                      title: 'Server requests'
                      titleKind: 2
                      visualization: {
                        chartType: 3
                        disablePinning: true
                      }
                      openBladeOnClick: {
                        openBlade: true
                        destinationBlade: {
                          bladeName: 'ResourceMenuBlade'
                          parameters: {
                            id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                            menuid: 'performance'
                          }
                          extensionName: 'HubsExtension'
                          options: {
                            parameters: {
                              id: resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                              menuid: 'performance'
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
              filters: {
                MsPortalFx_TimeRange: {
                  model: {
                    format: 'local'
                    granularity: 'auto'
                    relative: '60m'
                  }
                }
              }
            }
          }
          {
            position: {
              x: 5
              y: 7
              rowSpan: 5
              colSpan: 7
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceTypeMode'
                  isOptional: true
                }
                {
                  name: 'ComponentId'
                  isOptional: true
                }
                {
                  name: 'Scope'
                  value: {
                    resourceIds: [
                      resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                    ]
                  }
                  isOptional: true
                }
                {
                  name: 'PartId'
                  value: '1259245a-15da-41ce-a758-29d6e9379e61'
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '2.0'
                  isOptional: true
                }
                {
                  name: 'TimeRange'
                  value: 'P30D'
                  isOptional: true
                }
                {
                  name: 'DashboardId'
                  isOptional: true
                }
                {
                  name: 'DraftRequestParameters'
                  isOptional: true
                }
                {
                  name: 'Query'
                  value: 'customEvents\n| where name == "FhirImport" and (tostring(customDimensions.ImportStatus) == "Success" or tostring(customDimensions.ImportStatus) == "Failed")\n| project    \n    ExpectedResourceCount=toint(tostring(customDimensions.ExpectedResourceCount)),\n    ActualResourceCount=toint(tostring(customDimensions.ActualResourceCount)),\n    ImportId=tostring(customDimensions.ImportId),\n    ResourceType=tostring(customDimensions.ResourceType)\n| summarize    \n    ExpectedResourceCount=sum(ExpectedResourceCount),\n    ActualResourceCount=sum(ActualResourceCount)\n    by ResourceType\n| render barchart\n    with(\n    kind=unstacked,\n    title="Total Resource Count by Type across Actuals and Expected",\n    ytitle="FHIR Resource Count",\n    xtitle="FHIR Resource Type")\n\n'
                  isOptional: true
                }
                {
                  name: 'ControlType'
                  value: 'FrameControlChart'
                  isOptional: true
                }
                {
                  name: 'SpecificChart'
                  value: 'UnstackedBar'
                  isOptional: true
                }
                {
                  name: 'PartTitle'
                  value: 'Total Resource Count by Type across Actuals and Expected'
                  isOptional: true
                }
                {
                  name: 'PartSubTitle'
                  value: 'appi-customevent-lra-poc'
                  isOptional: true
                }
                {
                  name: 'Dimensions'
                  value: {
                    xAxis: {
                      name: 'ResourceType'
                      type: 'string'
                    }
                    yAxis: [
                      {
                        name: 'ExpectedResourceCount'
                        type: 'long'
                      }
                      {
                        name: 'ActualResourceCount'
                        type: 'long'
                      }
                    ]
                    splitBy: []
                    aggregation: 'Sum'
                  }
                  isOptional: true
                }
                {
                  name: 'LegendOptions'
                  value: {
                    isEnabled: true
                    position: 'Bottom'
                  }
                  isOptional: true
                }
                {
                  name: 'IsQueryContainTimeRange'
                  value: false
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart'
              settings: {}
            }
          }
          {
            position: {
              x: 0
              y: 8
              rowSpan: 4
              colSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceTypeMode'
                  isOptional: true
                }
                {
                  name: 'ComponentId'
                  isOptional: true
                }
                {
                  name: 'Scope'
                  value: {
                    resourceIds: [
                      resourceId(appInsightsResourceGroup, 'Microsoft.insights/components', appInsightsName)
                    ]
                  }
                  isOptional: true
                }
                {
                  name: 'PartId'
                  value: '024eb85c-9c73-49d0-811a-e1c0c1002b40'
                  isOptional: true
                }
                {
                  name: 'Version'
                  value: '2.0'
                  isOptional: true
                }
                {
                  name: 'TimeRange'
                  value: 'P30D'
                  isOptional: true
                }
                {
                  name: 'DashboardId'
                  isOptional: true
                }
                {
                  name: 'DraftRequestParameters'
                  isOptional: true
                }
                {
                  name: 'Query'
                  value: 'customEvents\n| where name == "FhirImport" and tostring(customDimensions.ImportStatus) == "Failed"\n| project\n    ResourceCount=toint(tostring(customDimensions.ActualResourceCount)),\n    ImportId=tostring(customDimensions.ImportId),\n    ResourceType=tostring(customDimensions.ResourceType)\n| summarize sum(ResourceCount) by ResourceType\n| render barchart  with(title="Total Failed Resource Count by Type")\n\n'
                  isOptional: true
                }
                {
                  name: 'ControlType'
                  value: 'FrameControlChart'
                  isOptional: true
                }
                {
                  name: 'SpecificChart'
                  value: 'StackedBar'
                  isOptional: true
                }
                {
                  name: 'PartTitle'
                  value: 'Total Failed Resource Count by Type'
                  isOptional: true
                }
                {
                  name: 'PartSubTitle'
                  value: 'appi-customevent-lra-poc'
                  isOptional: true
                }
                {
                  name: 'Dimensions'
                  value: {
                    xAxis: {
                      name: 'ResourceType'
                      type: 'string'
                    }
                    yAxis: [
                      {
                        name: 'sum_ResourceCount'
                        type: 'long'
                      }
                    ]
                    splitBy: []
                    aggregation: 'Sum'
                  }
                  isOptional: true
                }
                {
                  name: 'LegendOptions'
                  value: {
                    isEnabled: true
                    position: 'Bottom'
                  }
                  isOptional: true
                }
                {
                  name: 'IsQueryContainTimeRange'
                  value: false
                  isOptional: true
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/LogsDashboardPart'
              settings: {}
            }
          }
        ]
      }
    ]
    metadata: {
      model: {
        timeRange: {
          value: {
            relative: {
              duration: 24
              timeUnit: 1
            }
          }
          type: 'MsPortalFx.Composition.Configuration.ValueTypes.TimeRange'
        }
        filterLocale: {
          value: 'en-us'
        }
        filters: {
          value: {
            MsPortalFx_TimeRange: {
              model: {
                format: 'utc'
                granularity: 'auto'
                relative: '30d'
              }
              displayCache: {
                name: 'UTC Time'
                value: 'Past 30 days'
              }
              filteredPartIds: [
                'StartboardPart-LogsDashboardPart-309bc8dd-b1c8-4fd9-b3df-0f61a1bf664b'
                'StartboardPart-LogsDashboardPart-3c87a8fe-768f-4e68-8719-e7d40297b157'
                'StartboardPart-LogsDashboardPart-0fca0d1b-546a-4d4a-8181-6d50398e4805'
                'StartboardPart-LogsDashboardPart-0fca0d1b-546a-4d4a-8181-6d50398e481e'
                'StartboardPart-MonitorChartPart-aad9033f-1f42-45aa-86f1-b27da2129105'
                'StartboardPart-LogsDashboardPart-309bc8dd-b1c8-4fd9-b3df-0f61a1bf62b6'
                'StartboardPart-LogsDashboardPart-f2cf3b33-b5cc-49d0-8c2b-1963f2f2f437'
                'StartboardPart-LogsDashboardPart-309bc8dd-b1c8-4fd9-b3df-0f61a1bf639f'
                'StartboardPart-LogsDashboardPart-309bc8dd-b1c8-4fd9-b3df-0f61a1bf66d9'
                'StartboardPart-MonitorChartPart-aad9033f-1f42-45aa-86f1-b27da21291f0'
                'StartboardPart-LogsDashboardPart-309bc8dd-b1c8-4fd9-b3df-0f61a1bf684a'
                'StartboardPart-LogsDashboardPart-309bc8dd-b1c8-4fd9-b3df-0f61a1bf6797'
              ]
            }
          }
        }
      }
    }
  }
}
