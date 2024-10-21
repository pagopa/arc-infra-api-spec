locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  apim_name = "${local.project_core}-apim"
  apim_rg   = "${local.project_core}-api-rg"

  apim_hostname = "api.${var.apim_dns_zone_prefix}.${var.external_domain}"
  fe_hostname   = "${var.apim_dns_zone_prefix}.${var.external_domain}"

  apim_logger_id = "${data.azurerm_api_management.this.id}/loggers/${local.apim_name}-logger"
}
