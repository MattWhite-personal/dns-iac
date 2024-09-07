# Azure DNS Zone Management with Terraform

This repository contains Terraform code to manage DNS zones in Azure. The goal is to automate the creation, updating, and deletion of DNS records for specified domains using Infrastructure as Code (IaC) principles.

## Zones Under Management

The following DNS zones are managed by this repository:

- `benchspace.co`
- `benchspace.uk`
- `mattandjen.co.uk`
- `matthewjwhite.co.uk`
- `objectatelier.co.uk`
- `simonwhitedesign.co.uk`
- `theweaversmiths.co.uk`
- `tonyandlizwhite.co.uk`

## Prerequisites

Before you begin, ensure you have the following installed:

- Terraform v1.0.0 or later
- Azure CLI v2.0 or later
- An Azure account with the necessary permissions to manage DNS zones

## Getting Started

1. **Clone the repository:**
    ```sh
    git clone https://github.com/MattWhite-personal/dns-iac.git
    cd dns-iac
    ```

2. **Initialize Terraform:**
    ```sh
    terraform init
    ```

3. **Configure your Azure credentials:**
    ```sh
    az login
    ```

4. **Create a `terraform.tfvars` file:**
    ```sh
    touch terraform.tfvars
    ```

5. **Add your variables to `terraform.tfvars`:**
    ```hcl
    client_id = "your_azure_app_registration"
    client_secret = "your_azure_client_secret"
    tenant_id = "your_azure_tenant_id"
    subscription_id = "your_azure_subscription_id"
    permitted_ips = []
    ```

6. **Plan the Terraform configuration:**
    ```sh
    terraform plan -var-file="terraform.tfvars"
    ```

7. **Apply the Terraform configuration:**
    ```sh
    terraform apply -var-file="terraform.tfvars"
    ```

## Repository Structure

```
│   .gitignore
│   LICENSE
│
├───.github
│   │   dependabot.yml
│   │
│   └───workflows
│
└───terraform
    │   main.tf
    │   outputs.tf
    │   remote_state.tf
    │   terraform.tfstate
    │   terraform.tfstate.backup
    │   variables.tf
    │   zone_<zonename>.tf
    │
    └───module
        ├───dnsrecords
        │       main.tf
        │       outputs.tf
        │       variables.tf
        │
        └───mtasts
                main.tf
                variables.tf
```

## Contributing

Contributions are welcome! Please submit a pull request or open an issue to discuss any changes.

## License

This project is licensed under the GPL License - see the LICENSE file for details.

## Contact

For any questions or support, please open an issue.

