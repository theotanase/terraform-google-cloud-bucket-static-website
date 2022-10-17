resource "google_storage_bucket" "website-frontend" {
  name     = "${var.project-name}-website-frontend"
  project  = var.project_id
  location = var.region

  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.website-frontend.name
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
}