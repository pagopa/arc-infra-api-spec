# general
prefix         = "arc"
env_short      = "u"
env            = "uat"
domain         = "cittadini"
location       = "italynorth"
location_short = "itn"


tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra-api-spec"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

external_domain         = "pagopa.it"
apim_dns_zone_prefix    = "uat.cittadini"
dns_zone_internal_entry = "citizen.internal"

apim_diagnostics_enabled = "true"