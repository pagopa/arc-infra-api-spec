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
                    "query": "let startTime = {timeRangeOverall:start};\nlet endTime = {timeRangeOverall:end};\nlet interval = totimespan({timeSpan:label});\nlet data = requests\n    | where timestamp between (startTime .. endTime) and operation_Name startswith \"arc\";\nlet operationData = data;\nlet totalOperationCount = operationData\n    | summarize Total = count() by operation_Name;\noperationData\n| join kind=inner totalOperationCount on operation_Name\n| summarize\n    Count = count(),\n    Users = dcount(tostring(customDimensions[\"Request-X-Forwarded-For\"])),\n    AvgResponseTime = round(avg(duration), 2)\n    by operation_Name, resultCode, Total\n| project\n    ['Request Name'] = operation_Name,\n    ['Result Code'] = resultCode,\n    ['Total Response'] = Count,\n    ['Rate %'] = (Count * 100) / Total,\n    ['Users Affected'] = Users,\n    ['Avg Response Time (ms)'] = AvgResponseTime\n| sort by ['Total Response'] desc\n\n",
                    "size": 0,
                    "showAnalytics": true,
                    "timeContextFromParameter": "timeRangeOverall",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-core-appinsights"
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
                            ],
                            "customColumnWidthSetting": "20ch"
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
                          "sortOrder": 2
                        }
                      ]
                    },
                    "sortBy": [
                      {
                        "itemKey": "$gen_heatmap_Total Response_2",
                        "sortOrder": 2
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
                    "query": "let startTime = {timeRangeOverall:start};\nlet endTime = {timeRangeOverall:end};\nlet interval = totimespan({timeSpan:label});\n\nlet dataset = requests\n    // additional filters can be applied here\n    | where timestamp between (startTime .. endTime) and operation_Name has \"arc\"\n;\ndataset\n| summarize percentile_95=percentile(duration, 95) by bin(timestamp, interval)\n| project timestamp, percentile_95, watermark=1000\n| render timechart",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Requests duration p95",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-core-appinsights"
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
                    "query": "let startTime = {timeRangeOverall:start};\nlet endTime = {timeRangeOverall:end};\nlet interval = totimespan({timeSpan:label});\n\nlet tot = AzureDiagnostics\n| where TimeGenerated between (startTime .. endTime) \n| where requestUri_s has 'cittadini'\n| summarize tot = todouble(count()) by bin(TimeGenerated, interval);\nlet errors = AzureDiagnostics\n| where requestUri_s has 'cittadini'\n| where strcmp(httpStatusCode_s, \"400\") == 0 or strcmp(httpStatusCode_s, \"412\") > 0 \n| summarize not_ok = count() by bin(TimeGenerated, interval);\ntot\n| join kind=leftouter errors on TimeGenerated\n| project TimeGenerated, availability = (tot - coalesce(not_ok, 0))/tot",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Availability @ AppGateway",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-core-law"
                    ],
                    "visualization": "timechart"
                  },
                  "customWidth": "50",
                  "name": "Availability @ AppGateway"
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\nlet interval = totimespan({timeSpan:label});\r\n\r\nlet data = requests\r\n| where timestamp between (startTime .. endTime) and operation_Name has \"arc\";\r\nlet unknowApi = data\r\n| join kind=inner exceptions on operation_Id\r\n| where type has \"OperationNotFound\";\r\nlet totalRequestCount = toscalar (data\r\n| count);\r\nlet joinedUnknowApi = unknowApi\r\n| summarize\r\n        Count = count(),\r\n        Users = dcount(tostring(customDimensions[\"Request-X-Forwarded-For\"]))\r\n        by operation_Name, resultCode, type\r\n| project \r\n        ['Request Name'] = operation_Name,\r\n        ['Result Code'] = resultCode,\r\n        ['Total Response'] = Count,\r\n        ['Rate (% of total requests)'] = (Count * 100) / totalRequestCount,\r\n        ['Users Affected'] = Users,\r\n        ['Type'] = type;\r\nunion joinedUnknowApi",
                    "size": 0,
                    "title": "Operation Not Found",
                    "timeContextFromParameter": "timeRangeOverall",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-core-appinsights"
                    ]
                  },
                  "conditionalVisibility": {
                    "parameterName": "selectedTab",
                    "comparison": "isEqualTo",
                    "value": "all"
                  },
                  "name": "Operation Not Found",
                  "styleSettings": {
                    "showBorder": true
                  }
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
                "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-${env}-aks-rg/providers/Microsoft.ContainerService/managedClusters/${prefix}-${env_short}-${location_short}-${env}-aks"
              ],
              "timeContextFromParameter": "timeRangeOverall",
              "timeContext": {
                "durationMs": 86400000
              },
              "metrics": [
                {
                  "namespace": "microsoft.containerservice/managedclusters",
                  "metric": "microsoft.containerservice/managedclusters-Nodes (PREVIEW)-node_cpu_usage_percentage",
                  "aggregation": 4
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
                "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-${env}-aks-rg/providers/Microsoft.ContainerService/managedClusters/${prefix}-${env_short}-${location_short}-${env}-aks"
              ],
              "timeContextFromParameter": "timeRangeOverall",
              "timeContext": {
                "durationMs": 86400000
              },
              "metrics": [
                {
                  "namespace": "microsoft.containerservice/managedclusters",
                  "metric": "microsoft.containerservice/managedclusters-Nodes (PREVIEW)-node_memory_working_set_percentage",
                  "aggregation": 4
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
                  "jsonData": "[\n    {\"label\":\"oneIdentity\",\"value\":\"dev.oneid.pagopa.it\",\"selected\": true},\n    {\"label\":\"bizEvents\",\"value\":\"bizevents\",\"selected\": true},\n    {\"label\":\"payments pull\",\"value\":\"pagopa-gpd-payments-pull\",\"selected\": true}\n]",
                  "timeContext": {
                    "durationMs": 86400000
                  },
                  "value": "bizevents"
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
              "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\n\r\ndependencies\r\n| where timestamp between (startTime .. endTime)\r\n| where cloud_RoleName startswith \"pagopaarcbe\"\r\n| where data has (\"{externalService}\")\r\n| summarize total=count() by bin(timestamp,1m), cloud_RoleName\r\n| render timechart",
              "size": 3,
              "showAnalytics": true,
              "title": "Number of calls to the external service \" {externalService:label} \" made by arc-be",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-core-appinsights"
              ]
            },
            "customWidth": "50",
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "externalService"
            },
            "name": "Number of calls to the external service made by arc-be"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\n\r\ndependencies\r\n| where timestamp between (startTime .. endTime)\r\n| where cloud_RoleName startswith \"pagopaarcbe\"\r\n| where data has (\"{externalService}\")\r\n| summarize total=count() by bin(timestamp,1m),resultCode\r\n| render timechart",
              "size": 3,
              "showAnalytics": true,
              "title": "Number of calls to the external service \" {externalService:label} \" divided by resultCode",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-core-appinsights"
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
              "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\n\r\ndependencies\r\n| where timestamp between (startTime .. endTime)\r\n| where cloud_RoleName startswith \"pagopaarcbe\"\r\n| where data has (\"{externalService}\")\r\n| summarize total=count() by bin(timestamp,1m), operation_Name\r\n| render timechart",
              "size": 0,
              "title": "Number of calls to the external service \" bizEvents \" divided by API",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-core-appinsights"
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "externalService"
            },
            "name": "Number of calls to the external service \" bizEvents \" divided by API"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\n\r\ndependencies\r\n| where timestamp between (startTime .. endTime)\r\n| where cloud_RoleName startswith \"pagopaarcbe\"\r\n| where data has (\"{externalService}\")\r\n| summarize total=count() by bin(timestamp,1m), duration, cloud_RoleName\r\n| render timechart",
              "size": 3,
              "showAnalytics": true,
              "title": "Duration of calls to the external service \" {externalService:label} \" made by arc-be",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-core-appinsights"
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
            "name": "Duration of calls to the external service made by arc-be"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbook539a8e8b-cead-4bf5-97c0-e793617b2805",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.insights/components",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-core-appinsights"
              ],
              "timeContextFromParameter": "timeRangeOverall",
              "timeContext": {
                "durationMs": 86400000
              },
              "metrics": [
                {
                  "namespace": "microsoft.insights/components/kusto",
                  "metric": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/processCpuPercentageTotal",
                  "aggregation": 4,
                  "splitBy": [
                    "cloud/roleInstance"
                  ]
                }
              ],
              "title": "Avg Process CPU by Cloud Role Instance",
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
            "name": "Avg Process CPU by Cloud Role Instance"
          },
          {
            "type": 10,
            "content": {
              "chartId": "workbookdc92903c-915e-4148-806b-c77000e98c0c",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.insights/components",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/e38f8c8c-3996-4e3c-976d-89cb22885543/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-core-appinsights"
              ],
              "timeContextFromParameter": "timeRangeOverall",
              "timeContext": {
                "durationMs": 86400000
              },
              "metrics": [
                {
                  "namespace": "microsoft.insights/components/kusto",
                  "metric": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/memoryAvailableBytes",
                  "aggregation": 4,
                  "splitBy": [
                    "cloud/roleInstance"
                  ]
                }
              ],
              "title": "Available Memory by Cloud Role Instance",
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
            "name": "Available Memory by Cloud Role Instance"
          }
        ]
      },
      "name": "wrapper"
    }
  ],
  "fallbackResourceIds": [
    "Azure Monitor"
  ],
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
}