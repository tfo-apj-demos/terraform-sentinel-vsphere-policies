# terraform-sentinel-vsphere-policies

Sentinel policy set for on-prem vSphere environments managed by HCP Terraform.
Designed as a realistic starting point for enterprise platform teams running
vSphere via the `vmware/vsphere` provider and the
`tfo-apj-demos/single-virtual-machine/vsphere` private module.

## Layout

```
sentinel.hcl                    # HCP Terraform policy set config (read by the Sentinel runtime)
common-functions/               # Shared tfplan / tfstate / tfconfig helper modules
test/<policy>/                  # `sentinel test` mocks + assertions per policy
*.sentinel                      # Individual policies
```

## Policies

| Policy | Purpose | Enforcement |
| --- | --- | --- |
| `restrict-vm-cpu-and-memory` | Caps `num_cpus` and `memory` on VMs | advisory |
| `restrict-vm-disk-size` | Caps per-disk size on each VM | advisory |
| `restrict-virtual-disk-size-and-type` | Caps `vsphere_virtual_disk` size + requires `thin` | advisory |
| `require-storage-drs` | Requires `vsphere_datastore_cluster.sdrs_enabled` | advisory |
| `require-nfs41-and-kerberos` | Forces NFS41 + Kerberos on NAS datastores | advisory |
| `restrict-vm-naming-convention` | VM `name` must match `<env>-<site>-<role>-<NN>` regex | advisory |
| `require-vm-annotation` | Every VM must carry a non-empty annotation for ownership | advisory |
| `restrict-network-portgroup-allowlist` | VM NICs must attach to approved port-group IDs | advisory |

All policies start at `advisory` so they surface as warnings during a demo
run. Tighten individual policies to `soft-mandatory` (override-able by an
admin) or `hard-mandatory` (no override) in `sentinel.hcl` as your team
adopts each one.

## Configuration via params

`sentinel.hcl` passes parameters into each policy so the enforcement
thresholds and allowlists live in the policy-set config rather than in
the policy code itself. Override per environment:

```hcl
policy "restrict-vm-naming-convention" {
  source            = "./restrict-vm-naming-convention.sentinel"
  enforcement_level = "soft-mandatory"
  params = {
    name_regex = "^(prd|stg)-syd-[a-z]+-[0-9]{2}$"
  }
}

policy "restrict-network-portgroup-allowlist" {
  source            = "./restrict-network-portgroup-allowlist.sentinel"
  enforcement_level = "soft-mandatory"
  params = {
    allowed_network_ids = ["network-12", "network-34", "network-56"]
  }
}
```

## Running tests locally

```sh
sentinel test                                    # runs every policy's tests
sentinel test -run=restrict-vm-naming-convention # one policy only
sentinel test -verbose                           # show prints + rule trace
```

The local Sentinel CLI's `sentinel.hcl` format pre-dates HCP Terraform's;
`sentinel test` discovers policies from `.sentinel/policies/manifest.json`,
not `sentinel.hcl`. HCP Terraform parses `sentinel.hcl` when the policy
set is evaluated against a run.

## Reference files (not active in the policy set)

`check-cluster-capacity.sentinel` and `check-external-http-api.sentinel`
remain in the repo as reference for `http`/`json` import usage but are
intentionally **not** wired into `sentinel.hcl`:

- `check-cluster-capacity.sentinel` lacks a `main` rule, uses `base64`
  without importing it, and declares required params (`vcenter`,
  `username`, `password`) without sentinel.hcl supplying them. Treat as
  a sketch, not a runnable policy.
- `check-external-http-api.sentinel` calls `yesno.wtf/api` — a demo,
  not an enterprise control.
