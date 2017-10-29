# Infrastructure

Navit's web infrastructure

## Terraform

### Requirement

Install latest version of Terraform

### Usage

Run Terraform plan :

```
make plan service=<service_name>

# example : make plan service=fdroid
```

Apply your change :

```
make apply service=<service_name>

# example : make apply service=fdroid
```
