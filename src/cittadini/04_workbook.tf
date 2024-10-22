locals {
  workbooks = [
    {
      name     = "OPEX Workbook",
      filePath = "${path.module}/workbooks/OPEXWorkbook.json.tpl"
    }
  ]
}

resource "azurerm_application_insights_workbook" "cittadini_workbook" {
  for_each = {
    for index, workbook in local.workbooks :
    workbook.name => workbook
  }

  name                = uuidv5("oid", each.value.name)
  resource_group_name = data.azurerm_resource_group.workbook_rg.name
  location            = data.azurerm_resource_group.workbook_rg.location
  display_name        = each.value.name
  data_json = templatefile(each.value.filePath,
    {
      subscription_id = data.azurerm_subscription.current.subscription_id
      prefix          = "${var.prefix}-${var.env_short}"
      env             = var.env
      domain          = var.domain
      env_short       = var.env_short
      location_short  = var.location_short
    })

  tags = {
    ENV = var.env
  }

}