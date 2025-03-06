#vault integration
provider "vault" {
  address = "https://vault.example.com:8200" # Vault server address
  token   = "s.YourVaultToken" # Vault authentication token
}

resource "vault_generic_secret" "example" {
  path = "secret/data/my-secret" # Path to the secret in Vault
  data_json = <<EOT
{
  "username": "example-user",
  "password": "example-password"
}
EOT
}

resource "vault_policy" "example" {
  name   = "example-policy" # Name of the policy
  policy = <<EOT
path "secret/data/my-secret" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOT
}
