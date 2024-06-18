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
  Source      = "https://github.com/pagopa/pagopa-arc-api-spec.git"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

external_domain         = "pagopa.it"
apim_dns_zone_prefix    = "dev.cittadini-p4pa"
dns_zone_internal_entry = "citizen.internal"
### Aks
ingress_load_balancer_hostname = "${var.dns_zone_internal_entry}.${var.apim_dns_zone_prefix}.${var.external_domain}"