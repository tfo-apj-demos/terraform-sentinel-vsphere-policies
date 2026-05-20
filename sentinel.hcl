module "tfplan-functions" {
  source = "./common-functions/tfplan-functions/tfplan-functions.sentinel"
}

module "tfstate-functions" {
  source = "./common-functions/tfstate-functions/tfstate-functions.sentinel"
}

module "tfconfig-functions" {
  source = "./common-functions/tfconfig-functions/tfconfig-functions.sentinel"
}

# ---------- Resource-shape guardrails ----------

policy "restrict-vm-cpu-and-memory" {
  source            = "./restrict-vm-cpu-and-memory.sentinel"
  enforcement_level = "advisory"
}

policy "restrict-vm-disk-size" {
  source            = "./restrict-vm-disk-size.sentinel"
  enforcement_level = "advisory"
}

policy "restrict-virtual-disk-size-and-type" {
  source            = "./restrict-virtual-disk-size-and-type.sentinel"
  enforcement_level = "advisory"
}

# ---------- Storage tier guardrails ----------

policy "require-storage-drs" {
  source            = "./require-storage-drs.sentinel"
  enforcement_level = "advisory"
}

policy "require-nfs41-and-kerberos" {
  source            = "./require_nfs41_and_kerberos.sentinel"
  enforcement_level = "advisory"
}

# ---------- Enterprise hygiene ----------

policy "restrict-vm-naming-convention" {
  source            = "./restrict-vm-naming-convention.sentinel"
  enforcement_level = "advisory"

  params = {
    # <env>-<3-letter-site>-<role>-<2-digit-index>
    name_regex = "^(prd|stg|dev|tst)-[a-z]{3}-[a-z0-9-]+-[0-9]{2}$"
  }
}

policy "require-vm-annotation" {
  source            = "./require-vm-annotation.sentinel"
  enforcement_level = "advisory"
}

policy "restrict-network-portgroup-allowlist" {
  source            = "./restrict-network-portgroup-allowlist.sentinel"
  enforcement_level = "advisory"

  params = {
    # Replace with the real vsphere_network IDs from your environment.
    allowed_network_ids = [
      "network-prod-app",
      "network-prod-web",
      "network-nonprod",
    ]
  }
}
