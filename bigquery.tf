module "bigquery" {
  source = "terraform-google-modules/bigquery/google"
  version = "~> 7.0"

  dataset_id = "DS_${var.business_unit}_${upper(var.environment)}"
  project_id = var.project_id
  location = "EU"

  tables = [
    {
      table_id = "foo"
      schema = file("schemas/sample-schema.json"),
      time_partitioning = null,
      range_partitioning = null,
      clustering = [],
      expiration_time = 50000,
      labels = {
        env = "${var.environment}"
      }

    }
  ]

  views = [
    {
      view_id = "PMP",
      use_legacy_sql = false,
      expiration_time = 50000,
      query = <<EOF
      SELECT column_a, column_b,
      FROM `${var.project_id}."DS_${var.business_unit}_${upper(var.environment)}".foo`
      WHERE approved_user = SESSION_USER
EOF
      labels = {
        env = "devops"
        billable = "true"
        owner = "joedoe"
      }
    }
  ]
}