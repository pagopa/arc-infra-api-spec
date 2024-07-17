resource "azurerm_api_management_api_version_set" "cittadini_ver_set" {

  name                = "${var.env_short}-cittadini-version-set"
  resource_group_name = local.apim_rg
  api_management_name = local.apim_name
  display_name        = "Cittadini API"
  versioning_scheme   = "Segment"
}

module "apim_api_cittadini_v1" {
  source = "./.terraform/modules/__v3__/api_management_api"

  name                  = "${local.project}-cittadini-api"
  api_management_name   = local.apim_name
  resource_group_name   = local.apim_rg
  product_ids           = [module.apim_cittadini_product.product_id]
  subscription_required = false
  version_set_id        = azurerm_api_management_api_version_set.cittadini_ver_set.id
  api_version           = "v1"

  description  = ""
  display_name = "Cittadini API"
  path         = ""
  protocols    = ["https"]
  service_url  = "https://${var.dns_zone_internal_entry}.${var.apim_dns_zone_prefix}.${var.external_domain}/pagopaarcbe/arc"

  content_format = "openapi"
  content_value = templatefile("./api/cittadini/v1/_openapi.yml", {
    hostname = local.apim_hostname
  })

  xml_content = templatefile("./api/cittadini/v1/_base_policy.xml", {})
}