// This file is compiled inside Decidim core pack. Code can be added here and will be executed
// as part of that pack

// Load images
require.context("../../images", true)

if (process.env.NODE_ENV === "development") {
  require("./sjma_development_service_worker_cleanup")
}
