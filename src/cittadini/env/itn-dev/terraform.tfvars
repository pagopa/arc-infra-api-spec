# general
prefix         = "arc"
env_short      = "d"
env            = "dev"
domain         = "cittadini"
location       = "italynorth"
location_short = "itn"


tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra-api-spec"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

external_domain         = "pagopa.it"
apim_dns_zone_prefix    = "dev.cittadini"
dns_zone_internal_entry = "citizen.internal"

apim_diagnostics_enabled = "true"

### azure application insights workbook

monitor_resource_group_name = "arc-d-itn-core-monitor-rg"