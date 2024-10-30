# general
prefix         = "arc"
env_short      = "p"
env            = "prod"
domain         = "cittadini"
location       = "italynorth"
location_short = "itn"


tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra-api-spec"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

external_domain         = "pagopa.it"
apim_dns_zone_prefix    = "cittadini"
dns_zone_internal_entry = "citizen.internal"

apim_diagnostics_enabled = "true"
