locals {
  apim_health_api = {
    display_name          = "Health API"
    description           = "Health check API"
    path                  = "health"
    subscription_required = false
    service_url           = "https://${var.dns_zone_internal_entry}.${var.apim_dns_zone_prefix}.${var.external_domain}/arcbe/actuator/health/liveness"
  }
}

module "apim_api_health_v1" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                = "${local.project}-health-api"
  api_management_name = local.apim_name
  resource_group_name = local.apim_rg
  protocols           = ["https"]
  version_set_id      = azurerm_api_management_api_version_set.cittadini_ver_set.id
  api_version         = "v1"

  product_ids           = [module.apim_cittadini_product.product_id]
  subscription_required = local.apim_health_api.subscription_required
  description           = local.apim_health_api.description
  display_name          = local.apim_health_api.display_name
  path                  = local.apim_health_api.path
  service_url           = local.apim_health_api.service_url

  content_format = "openapi"
  content_value = templatefile("./api/cittadini/health/health_openapi.yml", {
    hostname = local.apim_hostname
  })

  xml_content = templatefile("./api/cittadini/health/health_base_policy.xml", {})
}
