
provider "google" {
  credentials   = "${file("/Users/fsadykov/fuchicorp-service-account.json")}"   #GOOGLE_CREDENTIALS to the path of a file containing the credential JSON
  project       = "fuchicorp-project"
  region        = "us-central1"
}
