locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  apim_name            = "${local.project_core}-apim"
  apim_rg              = "${local.project_core}-api-rg"
  apim_hostname        = "api.${var.apim_dns_zone_prefix}.${var.external_domain}"
  cittadini_ingress_be = "citizen.internal.${var.apim_dns_zone_prefix}.${var.external_domain}"
}
