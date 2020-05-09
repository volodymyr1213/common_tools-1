resource "google_kms_key_ring" "key_ring" {
  project  = "${var.google_project_id}"
  name     = "${var.kms["key_ring"]}"
  location = "${var.kms["keyring_location"]}"
}

# Create a crypto key for the key ring 
resource "google_kms_crypto_key" "crypto_key" {
  name            = "${var.kms["crypto_key"]}"
  key_ring        = "${google_kms_key_ring.key_ring.self_link}"
  rotation_period = "100000s"
}

# Add the service account to the Keyring
resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  # key_ring_id = "google_kms_key_ring.key_ring.id"

  key_ring_id = "${var.google_project_id}/${var.kms["keyring_location"]}/${var.kms["key_ring"]}"
  role = "roles/owner"

  members = [
    "serviceAccount:fuchicorp-service-account-970@fuchiclass.iam.gserviceaccount.com",
  ]
}