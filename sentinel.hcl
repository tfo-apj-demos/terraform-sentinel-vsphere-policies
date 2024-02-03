module "tfplan-functions" {
  source = "./common-functions/tfplan-functions/tfplan-functions.sentinel"
}

module "tfstate-functions" {
  source = "./common-functions/tfstate-functions/tfstate-functions.sentinel"
}

module "tfconfig-functions" {
  source = "./common-functions/tfconfig-functions/tfconfig-functions.sentinel"
}

/*policy "restrict-vm-cpu-and-memory" {
    source = "./restrict-vm-cpu-and-memory.sentinel"
    enforcement_level = "advisory"
}

policy "require-storage-drs" {
    source = "./require-storage-drs.sentinel"
    enforcement_level = "advisory"
}

policy "require_nfs41_and_kerberos" {
    source = "./require_nfs41_and_kerberos.sentinel"
    enforcement_level = "advisory"
}

policy "restrict-virtual-disk-size-and-type" {
    source = "./restrict-virtual-disk-size-and-type.sentinel"
    enforcement_level = "advisory"
}

policy "restrict-vm-disk-size" {
    source = "./restrict-vm-disk-size.sentinel"
    enforcement_level = "advisory"
}*/

policy "check-external-http-api" {
    source = "./check-external-http-api.sentinel"
    enforcement_level = "advisory"
}

policy "check-external-http-api" {
    source = "./check-cluster-capacity.sentinel"
    enforcement_level = "advisory"
}