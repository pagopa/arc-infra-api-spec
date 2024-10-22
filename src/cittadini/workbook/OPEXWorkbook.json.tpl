{
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "75b945d9-1f77-40e6-a8f6-2356759b8c3b",
            "version": "KqlParameterItem/1.0",
            "name": "timeRangeOverall",
            "type": 4,
            "isRequired": true,
            "typeSettings": {
              "selectableValues": [
                {
                  "durationMs": 300000
                },
                {
                  "durationMs": 900000
                },
                {
                  "durationMs": 1800000
                },
                {
                  "durationMs": 86400000
                }
              ],
              "allowCustom": true
            },
            "timeContext": {
              "durationMs": 86400000
            },
            "value": {
              "durationMs": 86400000
            }
          },
          {
            "id": "4a7b6e18-8b58-4227-86a9-c6ac65cd7bb8",
            "version": "KqlParameterItem/1.0",
            "name": "timeSpan",
            "type": 10,
            "isRequired": true,
            "typeSettings": {
              "additionalResourceOptions": [],
              "showDefault": false
            },
            "jsonData": "[\r\n{\"label\": \"30s\", \"value\": 30000, \"selected\": false},\r\n{\"label\": \"1m\", \"value\": 60000, \"selected\": true},\r\n{\"label\": \"2m\", \"value\": 120000, \"selected\": false},\r\n{\"label\": \"10m\", \"value\": 600000, \"selected\": false},\r\n{\"label\": \"30m\", \"value\": 3600000, \"selected\": false}\r\n]",
            "timeContext": {
              "durationMs": 86400000
            }
          }
        ],
        "style": "pills",
        "queryType": 0,
        "resourceType": "microsoft.insights/components"
      },
      "name": "parameters - 2"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "items": [
          {
            "type": 11,
            "content": {
              "version": "LinkItem/1.0",
              "style": "tabs",
              "links": [
                {
                  "id": "af5a3000-400d-4b80-92a2-7454bfefbdaa",
                  "cellValue": "selectedTab",
                  "linkTarget": "parameter",
                  "linkLabel": "OPEX - OVERALL",
                  "subTarget": "all",
                  "style": "link",
                  "linkIsContextBlade": true
                },
                {
                  "id": "5a3e244e-a412-4f57-912f-0e0cc4e4abd1",
                  "cellValue": "selectedTab",
                  "linkTarget": "parameter",
                  "linkLabel": "CLUSTER METRICS",
                  "subTarget": "clusterMetrics",
                  "style": "link"
                },
                {
                  "id": "71a6e41d-5cb9-4ee1-b71b-d3011168e8e9",
                  "cellValue": "selectedTab",
                  "linkTarget": "parameter",
                  "linkLabel": "SERVIZI ESTERNI",
                  "subTarget": "externalService",
                  "style": "link"
                }
              ]
            },
            "name": "links - 0"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "items": [
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeOverall:start};\nlet endTime = {timeRangeOverall:end};\nlet interval = totimespan({timeSpan:label});\nlet data = requests\n    | where timestamp between (startTime .. endTime) and operation_Name has \"p4pa\";\nlet operationData = data;\nlet totalOperationCount = operationData\n    | summarize Total = count() by operation_Name;\noperationData\n    | join kind=inner totalOperationCount on operation_Name\n    | summarize\n        Count = count(),\n        Users = dcount(tostring(customDimensions[\"Request-X-Forwarded-For\"])),\n        AvgResponseTime = round(avg(duration), 2)\n        by operation_Name, resultCode, Total\n    | project\n        ['Request Name'] = operation_Name,\n        ['Result Code'] = resultCode,\n        ['Total Response'] = Count,\n        ['Rate %'] = (Count * 100) / Total,\n        ['Users Affected'] = Users,\n        ['Avg Response Time (ms)'] = AvgResponseTime\n    | sort by ['Request Name']",
                    "size": 0,
                    "showAnalytics": true,
                    "timeContextFromParameter": "timeRangeOverall",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
                    ],
                    "gridSettings": {
                      "formatters": [
                        {
                          "columnMatch": "Result Code",
                          "formatter": 18,
                          "formatOptions": {
                            "thresholdsOptions": "icons",
                            "thresholdsGrid": [
                              {
                                "operator": "==",
                                "thresholdValue": "429",
                                "representation": "4",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "==",
                                "thresholdValue": "404",
                                "representation": "success",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "startsWith",
                                "thresholdValue": "5",
                                "representation": "4",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "startsWith",
                                "thresholdValue": "2",
                                "representation": "success",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "Default",
                                "thresholdValue": null,
                                "representation": "warning",
                                "text": "{0}{1}"
                              }
                            ]
                          }
                        },
                        {
                          "columnMatch": "Total Response",
                          "formatter": 8,
                          "formatOptions": {
                            "min": 1,
                            "palette": "blue"
                          }
                        },
                        {
                          "columnMatch": "Rate %",
                          "formatter": 8,
                          "formatOptions": {
                            "min": 0,
                            "max": 100,
                            "palette": "yellowGreenBlue"
                          },
                          "numberFormat": {
                            "unit": 1,
                            "options": {
                              "style": "decimal",
                              "useGrouping": false
                            }
                          }
                        },
                        {
                          "columnMatch": "Users Affected",
                          "formatter": 8,
                          "formatOptions": {
                            "min": 0,
                            "palette": "blueDark"
                          }
                        },
                        {
                          "columnMatch": "Group",
                          "formatter": 1
                        },
                        {
                          "columnMatch": "Failed with Result Code",
                          "formatter": 18,
                          "formatOptions": {
                            "thresholdsOptions": "icons",
                            "thresholdsGrid": [
                              {
                                "operator": "startsWith",
                                "thresholdValue": "5",
                                "representation": "4",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "==",
                                "thresholdValue": "429",
                                "representation": "4",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "startsWith",
                                "thresholdValue": "2",
                                "representation": "success",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "==",
                                "thresholdValue": "404",
                                "representation": "success",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "Default",
                                "thresholdValue": null,
                                "representation": "2",
                                "text": "{0}{1}"
                              }
                            ],
                            "compositeBarSettings": {
                              "labelText": "",
                              "columnSettings": [
                                {
                                  "columnName": "Failed with Result Code",
                                  "color": "blue"
                                }
                              ]
                            }
                          },
                          "numberFormat": {
                            "unit": 0,
                            "options": {
                              "style": "decimal"
                            }
                          }
                        },
                        {
                          "columnMatch": "Total Failures",
                          "formatter": 8,
                          "formatOptions": {
                            "min": 1,
                            "palette": "blue"
                          }
                        },
                        {
                          "columnMatch": "Failure rate %",
                          "formatter": 8,
                          "formatOptions": {
                            "min": 0,
                            "max": 100,
                            "palette": "redGreen"
                          }
                        }
                      ],
                      "sortBy": [
                        {
                          "itemKey": "$gen_heatmap_Total Response_2",
                          "sortOrder": 1
                        }
                      ]
                    },
                    "sortBy": [
                      {
                        "itemKey": "$gen_heatmap_Total Response_2",
                        "sortOrder": 1
                      }
                    ],
                    "tileSettings": {
                      "showBorder": false,
                      "titleContent": {
                        "columnMatch": "Request Name",
                        "formatter": 1
                      },
                      "leftContent": {
                        "columnMatch": "Total Failures",
                        "formatter": 12,
                        "formatOptions": {
                          "palette": "auto"
                        },
                        "numberFormat": {
                          "unit": 17,
                          "options": {
                            "maximumSignificantDigits": 3,
                            "maximumFractionDigits": 2
                          }
                        }
                      }
                    },
                    "graphSettings": {
                      "type": 0,
                      "topContent": {
                        "columnMatch": "Request Name",
                        "formatter": 1
                      },
                      "leftContent": {
                        "columnMatch": "Failed with Result Code"
                      },
                      "centerContent": {
                        "columnMatch": "Total Failures",
                        "formatter": 1,
                        "numberFormat": {
                          "unit": 17,
                          "options": {
                            "maximumSignificantDigits": 3,
                            "maximumFractionDigits": 2
                          }
                        }
                      },
                      "rightContent": {
                        "columnMatch": "Failure rate %"
                      },
                      "bottomContent": {
                        "columnMatch": "Users Affected"
                      },
                      "nodeIdField": "Request Name",
                      "sourceIdField": "Failed with Result Code",
                      "targetIdField": "Total Failures",
                      "graphOrientation": 3,
                      "showOrientationToggles": false,
                      "nodeSize": null,
                      "staticNodeSize": 100,
                      "colorSettings": null,
                      "hivesMargin": 5
                    },
                    "chartSettings": {
                      "showLegend": true,
                      "showDataPoints": true
                    },
                    "mapSettings": {
                      "locInfo": "LatLong",
                      "sizeSettings": "Total Failures",
                      "sizeAggregation": "Sum",
                      "legendMetric": "Total Failures",
                      "legendAggregation": "Sum",
                      "itemColorSettings": {
                        "type": "heatmap",
                        "colorAggregation": "Sum",
                        "nodeColorField": "Total Failures",
                        "heatmapPalette": "greenRed"
                      }
                    }
                  },
                  "name": "query - 14"
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeOverall:start};\nlet endTime = {timeRangeOverall:end};\nlet interval = totimespan({timeSpan:label});\n\nlet dataset = requests\n    // additional filters can be applied here\n    | where timestamp between (startTime .. endTime)\n;\ndataset\n| summarize percentile_95=percentile(duration, 95) by bin(timestamp, interval)\n| project timestamp, percentile_95, watermark=1000\n| render timechart",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Requests duration p95",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
                    ],
                    "visualization": "timechart"
                  },
                  "customWidth": "50",
                  "name": "Requests duration p95"
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeOverall:start};\nlet endTime = {timeRangeOverall:end};\nlet interval = totimespan({timeSpan:label});\n\nlet tot = AzureDiagnostics\n| where TimeGenerated between (startTime .. endTime) \n| where requestUri_s has 'p4pa'\n| summarize tot = todouble(count()) by bin(TimeGenerated, interval);\nlet y = AzureDiagnostics\n| where requestUri_s has 'p4pa'\n| where httpStatus_d < 400 or httpStatus_d == 404\n| summarize n_ok=count() by bin(TimeGenerated, interval);\ny\n| join kind=inner tot  on TimeGenerated | project TimeGenerated, availability = n_ok/tot\n",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Availability @ AppGateway",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${location_short}-core-law"
                    ],
                    "visualization": "timechart"
                  },
                  "customWidth": "50",
                  "name": "Availability @ AppGateway"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "all"
            },
            "name": "all"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook4ff901ba-f592-405c-b520-5b7c8f17bc06",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.containerservice/managedclusters",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${env}-aks-rg/providers/Microsoft.ContainerService/managedClusters/${prefix}-${location_short}-${env}-aks"
              ],
              "timeContextFromParameter": "timeRangeOverall",
              "timeContext": {
                "durationMs": 86400000
              },
              "metrics": [
                {
                  "namespace": "microsoft.containerservice/managedclusters",
                  "metric": "microsoft.containerservice/managedclusters-Nodes (PREVIEW)-node_cpu_usage_percentage",
                  "aggregation": 4,
                  "splitBy": null
                }
              ],
              "title": "Cluster CPU Usage",
              "showOpenInMe": true,
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "clusterMetrics"
            },
            "name": "Cluster CPU Usage ",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook3fc01a1c-c9b3-4135-9a95-cfa0513d9af6",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.containerservice/managedclusters",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${env}-aks-rg/providers/Microsoft.ContainerService/managedClusters/${prefix}-${location_short}-${env}-aks"
              ],
              "timeContextFromParameter": "timeRangeOverall",
              "timeContext": {
                "durationMs": 86400000
              },
              "metrics": [
                {
                  "namespace": "microsoft.containerservice/managedclusters",
                  "metric": "microsoft.containerservice/managedclusters-Nodes (PREVIEW)-node_memory_working_set_percentage",
                  "aggregation": 4,
                  "splitBy": null
                }
              ],
              "title": "Cluster Memory Usage",
              "showOpenInMe": true,
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "customWidth": "50",
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "clusterMetrics"
            },
            "name": "Cluster Memory Usage",
            "styleSettings": {
              "maxWidth": "50"
            }
          },
          {
            "type": 9,
            "content": {
              "version": "KqlParameterItem/1.0",
              "parameters": [
                {
                  "id": "2c27e0f6-1f79-4352-a6cb-2194f39415b8",
                  "version": "KqlParameterItem/1.0",
                  "name": "externalService",
                  "type": 2,
                  "description": "Select the external service you want to monitor",
                  "isRequired": true,
                  "typeSettings": {
                    "additionalResourceOptions": [],
                    "showDefault": false
                  },
                  "jsonData": "[\n    {\"label\":\"selfcare\",\"value\":\"selfcare.pagopa.it\",\"selected\": true},\n    {\"label\":\"nodopagopa\",\"value\":\"platform.pagopa.it\",\"selected\": true},\n    {\"label\":\"io\",\"value\":\"api.io.pagopa.it\",\"selected\": true}\n]",
                  "timeContext": {
                    "durationMs": 86400000
                  },
                  "value": "selfcare.pagopa.it"
                }
              ],
              "style": "pills",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces"
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "externalService"
            },
            "name": "parameters - 9"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\n\r\ndependencies\r\n| where timestamp between (startTime .. endTime)\r\n| where cloud_RoleName startswith \"p4pa\"\r\n| where data has (\"{externalService}\")\r\n| summarize total=count() by bin(timestamp,1m), cloud_RoleName\r\n| render timechart",
              "size": 3,
              "showAnalytics": true,
              "title": "Number of calls to the external service \" {externalService:label} \" divided  by microservices",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
              ]
            },
            "customWidth": "50",
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "externalService"
            },
            "name": "Number of calls to the external service divided by microservices"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\n\r\ndependencies\r\n| where timestamp between (startTime .. endTime)\r\n| where cloud_RoleName startswith \"p4pa\"\r\n| where data has (\"{externalService}\")\r\n| summarize total=count() by bin(timestamp,1m),resultCode\r\n| render timechart",
              "size": 3,
              "showAnalytics": true,
              "title": "Number of calls to the external service \" {externalService:label} \" divided by resultCode",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
              ]
            },
            "customWidth": "50",
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "externalService"
            },
            "name": "Number of calls to the external service divided by resultCode"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\n\r\ndependencies\r\n| where timestamp between (startTime .. endTime)\r\n| where cloud_RoleName startswith \"p4pa\"\r\n| where data has (\"{externalService}\")\r\n| summarize total=count() by bin(timestamp,1m), duration, cloud_RoleName\r\n| render timechart",
              "size": 3,
              "showAnalytics": true,
              "title": "Duration of calls to the external service \" {externalService:label} \" divided by microservices",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
              ],
              "visualization": "timechart",
              "chartSettings": {
                "xAxis": "timestamp",
                "yAxis": [
                  "duration"
                ],
                "customThresholdLine": "800",
                "customThresholdLineStyle": 0
              }
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "externalService"
            },
            "name": "Duration of calls to the external service divided by microservices"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "Cosmos DB",
              "items": [
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbookc40881cd-42b1-4a91-a095-0aba2bfbca5f",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.documentdb/databaseaccounts",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${domain}-mongodb-account"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 780000,
                      "endTime": "2023-04-12T10:30:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.documentdb/databaseaccounts",
                        "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequestUnits",
                        "aggregation": 1,
                        "splitBy": "CollectionName"
                      }
                    ],
                    "title": "Cosmos DB Requests Units",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "2",
                        "key": "CollectionName",
                        "operator": 0,
                        "valueParam": "dbCollections"
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Cosmos DB Requests Units"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbookdfee1d78-8786-42b2-8ed5-ebe31e2ba523",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.documentdb/databaseaccounts",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${domain}-mongodb-account"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 780000,
                      "endTime": "2023-04-12T10:30:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.documentdb/databaseaccounts",
                        "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequestUnits",
                        "aggregation": 1,
                        "splitBy": "StatusCode"
                      }
                    ],
                    "title": "Cosmos Errors",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "1",
                        "key": "StatusCode",
                        "operator": 1,
                        "values": [
                          "200",
                          "201",
                          "204",
                          "404",
                          "412",
                          "449",
                          "409"
                        ]
                      },
                      {
                        "id": "2",
                        "key": "CollectionName",
                        "operator": 0,
                        "valueParam": "dbCollections"
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Cosmos Errors"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook694b2aec-e7b0-440e-82b1-de66fce0b7ac",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.documentdb/databaseaccounts",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${domain}-mongodb-account"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 780000,
                      "endTime": "2023-04-12T10:30:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.documentdb/databaseaccounts",
                        "metric": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption",
                        "aggregation": 3,
                        "splitBy": null
                      }
                    ],
                    "title": "Normalized RU Consumption",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "2",
                        "key": "CollectionName",
                        "operator": 0,
                        "valueParam": "dbCollections"
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Normalized RU Consumption"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook8c1c4726-5a2d-4261-ae75-c019aef53bf3",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.documentdb/databaseaccounts",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${domain}-mongodb-account"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 780000,
                      "endTime": "2023-04-12T10:30:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.documentdb/databaseaccounts",
                        "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
                        "aggregation": 7,
                        "splitBy": "CommandName"
                      }
                    ],
                    "title": "Mongo DB Operations",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "1",
                        "key": "CollectionName",
                        "operator": 0,
                        "valueParam": "dbCollections"
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Mongo DB Operations"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook026603f3-d8cc-46de-9ef1-456243f40556",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.documentdb/databaseaccounts",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${domain}-mongodb-account"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 780000,
                      "endTime": "2023-04-12T10:30:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.documentdb/databaseaccounts",
                        "metric": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
                        "aggregation": 1,
                        "splitBy": "CollectionName"
                      }
                    ],
                    "title": "Data Usage",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "1",
                        "key": "CollectionName",
                        "operator": 0,
                        "valueParam": "dbCollections"
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Data Usage"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbooka6bbd238-c717-4839-b457-3f07c4e7ebd4",
                    "version": "MetricsItem/2.0",
                    "size": 1,
                    "chartType": 2,
                    "resourceType": "microsoft.documentdb/databaseaccounts",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${domain}-mongodb-account"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 780000,
                      "endTime": "2023-04-12T10:30:00.000Z"
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.documentdb/databaseaccounts",
                        "metric": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount",
                        "aggregation": 1,
                        "splitBy": "CollectionName"
                      }
                    ],
                    "title": " Document Count",
                    "showOpenInMe": true,
                    "filters": [
                      {
                        "id": "1",
                        "key": "CollectionName",
                        "operator": 0,
                        "valueParam": "dbCollections"
                      }
                    ],
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": " Document Count"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "all"
            },
            "name": "Cosmos DB",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "PostgreSQL",
              "items": [
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook4adf9bbe-2173-453c-b76c-97c116c8c016",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.dbforpostgresql/flexibleservers",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/${prefix}-${location_short}-${domain}-flexible-postgresql"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 0
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.dbforpostgresql/flexibleservers",
                        "metric": "microsoft.dbforpostgresql/flexibleservers-Availability-is_db_alive",
                        "aggregation": 3,
                        "splitBy": null
                      }
                    ],
                    "title": "Database is Alive",
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Database is Alive"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook3c76bec2-8f2c-4065-a3da-e8d9baf18d01",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.dbforpostgresql/flexibleservers",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/${prefix}-${location_short}-${domain}-flexible-postgresql"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 0
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.dbforpostgresql/flexibleservers",
                        "metric": "microsoft.dbforpostgresql/flexibleservers-Errors-connections_failed",
                        "aggregation": 1,
                        "splitBy": null
                      }
                    ],
                    "title": "Failed Connections",
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Failed Connections"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook9db56c20-7292-4903-9265-2b499d045367",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.dbforpostgresql/flexibleservers",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/${prefix}-${location_short}-${domain}-flexible-postgresql"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 0
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.dbforpostgresql/flexibleservers",
                        "metric": "microsoft.dbforpostgresql/flexibleservers-Saturation-cpu_percent",
                        "aggregation": 4,
                        "splitBy": null
                      }
                    ],
                    "title": "CPU Percent",
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "CPU Percent"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbooka48f848b-a70a-4cd3-9168-be5e3aa0b111",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.dbforpostgresql/flexibleservers",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/${prefix}-${location_short}-${domain}-flexible-postgresql"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 0
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.dbforpostgresql/flexibleservers",
                        "metric": "microsoft.dbforpostgresql/flexibleservers-Saturation-disk_iops_consumed_percentage",
                        "aggregation": 4,
                        "splitBy": null
                      }
                    ],
                    "title": "Disk IOPS",
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Disk IOPS"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook3d5b2b4e-d489-497e-bc6f-096b2ca4e888",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.dbforpostgresql/flexibleservers",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/${prefix}-${location_short}-${domain}-flexible-postgresql"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 0
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.dbforpostgresql/flexibleservers",
                        "metric": "microsoft.dbforpostgresql/flexibleservers-Saturation-memory_percent",
                        "aggregation": 4,
                        "splitBy": null
                      }
                    ],
                    "title": "Memory Percent",
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Memory Percent"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbooke3c0bee3-2726-4c1c-9170-c99810c2e54e",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.dbforpostgresql/flexibleservers",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/${prefix}-${location_short}-${domain}-flexible-postgresql"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 0
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.dbforpostgresql/flexibleservers",
                        "metric": "microsoft.dbforpostgresql/flexibleservers-Saturation-storage_used",
                        "aggregation": 4,
                        "splitBy": null
                      }
                    ],
                    "title": "Storage Used",
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Storage Used"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook0135176c-be3b-46a0-99ce-2b4b7a283a63",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.dbforpostgresql/flexibleservers",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/${prefix}-${location_short}-${domain}-flexible-postgresql"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 0
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.dbforpostgresql/flexibleservers",
                        "metric": "microsoft.dbforpostgresql/flexibleservers-Database-tps",
                        "aggregation": 3,
                        "splitBy": null
                      }
                    ],
                    "title": "Transactions per Second",
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Transactions per Second"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbookdb5fe42b-1ee1-4117-a134-bb76c22be927",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.dbforpostgresql/flexibleservers",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${domain}-db-rg/providers/Microsoft.DBforPostgreSQL/flexibleServers/${prefix}-${location_short}-${domain}-flexible-postgresql"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 0
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.dbforpostgresql/flexibleservers",
                        "metric": "microsoft.dbforpostgresql/flexibleservers-Database-deadlocks",
                        "aggregation": 1,
                        "splitBy": null
                      }
                    ],
                    "title": "Deadlocks",
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Deadlocks"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "all"
            },
            "name": "Postgre",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRangeOverall:start};\nlet endTime = {timeRangeOverall:end};\nlet interval = totimespan({timeSpan:label});\nlet data = requests\n    | where timestamp between (startTime .. endTime) and operation_Name has \"p4pa\";\nlet unknowApi = data\n    | join kind=inner exceptions on operation_Id\n    | where type has \"OperationNotFound\";\nlet totalRequestCount = toscalar (data\n    | count);\nlet joinedUnknowApi = unknowApi\n    | summarize\n        Count = count(),\n        Users = dcount(tostring(customDimensions[\"Request-X-Forwarded-For\"]))\n        by operation_Name, resultCode, type\n    | project \n        ['Request Name'] = operation_Name,\n        ['Result Code'] = resultCode,\n        ['Total Response'] = Count,\n        ['Rate (% of total requests)'] = (Count * 100) / totalRequestCount,\n        ['Users Affected'] = Users,\n        ['Type'] = type;\nunion joinedUnknowApi",
              "size": 0,
              "showAnalytics": true,
              "title": "Requests not mapped in apim that give an \"OperationNotFound\" error",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
              ],
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Result Code",
                    "formatter": 18,
                    "formatOptions": {
                      "thresholdsOptions": "icons",
                      "thresholdsGrid": [
                        {
                          "operator": "==",
                          "thresholdValue": "429",
                          "representation": "4",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "==",
                          "thresholdValue": "404",
                          "representation": "failed",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "startsWith",
                          "thresholdValue": "5",
                          "representation": "4",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "startsWith",
                          "thresholdValue": "2",
                          "representation": "success",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "Default",
                          "thresholdValue": null,
                          "representation": "warning",
                          "text": "{0}{1}"
                        }
                      ]
                    }
                  },
                  {
                    "columnMatch": "Total Response",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 1,
                      "palette": "blue"
                    }
                  },
                  {
                    "columnMatch": "Rate %",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "max": 100,
                      "palette": "yellowGreenBlue"
                    },
                    "numberFormat": {
                      "unit": 1,
                      "options": {
                        "style": "decimal",
                        "useGrouping": false
                      }
                    }
                  },
                  {
                    "columnMatch": "Users Affected",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "palette": "blueDark"
                    }
                  },
                  {
                    "columnMatch": "Group",
                    "formatter": 1
                  },
                  {
                    "columnMatch": "Failed with Result Code",
                    "formatter": 18,
                    "formatOptions": {
                      "thresholdsOptions": "icons",
                      "thresholdsGrid": [
                        {
                          "operator": "startsWith",
                          "thresholdValue": "5",
                          "representation": "4",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "==",
                          "thresholdValue": "429",
                          "representation": "4",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "startsWith",
                          "thresholdValue": "2",
                          "representation": "success",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "==",
                          "thresholdValue": "404",
                          "representation": "success",
                          "text": "{0}{1}"
                        },
                        {
                          "operator": "Default",
                          "thresholdValue": null,
                          "representation": "2",
                          "text": "{0}{1}"
                        }
                      ],
                      "compositeBarSettings": {
                        "labelText": "",
                        "columnSettings": [
                          {
                            "columnName": "Failed with Result Code",
                            "color": "blue"
                          }
                        ]
                      }
                    },
                    "numberFormat": {
                      "unit": 0,
                      "options": {
                        "style": "decimal"
                      }
                    }
                  },
                  {
                    "columnMatch": "Total Failures",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 1,
                      "palette": "blue"
                    }
                  },
                  {
                    "columnMatch": "Failure rate %",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "max": 100,
                      "palette": "redGreen"
                    }
                  }
                ],
                "sortBy": [
                  {
                    "itemKey": "$gen_heatmap_Total Response_2",
                    "sortOrder": 1
                  }
                ]
              },
              "sortBy": [
                {
                  "itemKey": "$gen_heatmap_Total Response_2",
                  "sortOrder": 1
                }
              ],
              "tileSettings": {
                "showBorder": false,
                "titleContent": {
                  "columnMatch": "Request Name",
                  "formatter": 1
                },
                "leftContent": {
                  "columnMatch": "Total Failures",
                  "formatter": 12,
                  "formatOptions": {
                    "palette": "auto"
                  },
                  "numberFormat": {
                    "unit": 17,
                    "options": {
                      "maximumSignificantDigits": 3,
                      "maximumFractionDigits": 2
                    }
                  }
                }
              },
              "graphSettings": {
                "type": 0,
                "topContent": {
                  "columnMatch": "Request Name",
                  "formatter": 1
                },
                "leftContent": {
                  "columnMatch": "Failed with Result Code"
                },
                "centerContent": {
                  "columnMatch": "Total Failures",
                  "formatter": 1,
                  "numberFormat": {
                    "unit": 17,
                    "options": {
                      "maximumSignificantDigits": 3,
                      "maximumFractionDigits": 2
                    }
                  }
                },
                "rightContent": {
                  "columnMatch": "Failure rate %"
                },
                "bottomContent": {
                  "columnMatch": "Users Affected"
                },
                "nodeIdField": "Request Name",
                "sourceIdField": "Failed with Result Code",
                "targetIdField": "Total Failures",
                "graphOrientation": 3,
                "showOrientationToggles": false,
                "nodeSize": null,
                "staticNodeSize": 100,
                "colorSettings": null,
                "hivesMargin": 5
              },
              "chartSettings": {
                "showLegend": true,
                "showDataPoints": true
              },
              "mapSettings": {
                "locInfo": "LatLong",
                "sizeSettings": "Total Failures",
                "sizeAggregation": "Sum",
                "legendMetric": "Total Failures",
                "legendAggregation": "Sum",
                "itemColorSettings": {
                  "type": "heatmap",
                  "colorAggregation": "Sum",
                  "nodeColorField": "Total Failures",
                  "heatmapPalette": "greenRed"
                }
              }
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "all"
            },
            "name": "query - 14 - Copy"
          }
        ]
      },
      "name": "wrapper"
    }
  ],
  "fallbackResourceIds": [
    "azure monitor"
  ],
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
}