# frozen_string_literal: true

ASSET_ROOT = Rails.root.join("app/assets/images/sjma")
PROCESS_SLUG = "modificacio-estatutaria-2022-2026"

def asset_path(filename)
  path = ASSET_ROOT.join(filename)
  raise "Missing SJMA asset: #{path}" unless File.exist?(path)

  path
end

def attach_direct!(record, name, filename, content_type)
  path = asset_path(filename)

  ActiveStorage::Attachment
    .where(record_type: record.class.name, record_id: record.id, name: name.to_s)
    .find_each(&:purge)

  blob = ActiveStorage::Blob.create_and_upload!(
    io: File.open(path, "rb"),
    filename: filename,
    content_type: content_type
  )

  ActiveStorage::Attachment.create!(
    name: name.to_s,
    record_type: record.class.name,
    record_id: record.id,
    blob: blob
  )
end

def attach_content_block_image!(content_block, name, filename, content_type)
  path = asset_path(filename)
  attachment = content_block.images_container.public_send(name)
  attachment.purge if attachment.attached?

  attachment.attach(
    io: File.open(path, "rb"),
    filename: filename,
    content_type: content_type
  )
end

org = Decidim::Organization.first!
process = Decidim::ParticipatoryProcess.find_by!(
  organization: org,
  slug: PROCESS_SLUG
)

home_hero = Decidim::ContentBlock.find_by!(
  organization: org,
  scope_name: "homepage",
  manifest_name: "hero"
)

process_hero = Decidim::ContentBlock.find_by!(
  organization: org,
  scope_name: "participatory_process_homepage",
  scoped_resource_id: process.id,
  manifest_name: "hero"
)

attach_direct!(org, :logo, "logo-horizontal-marro.png", "image/png")
attach_direct!(org, :favicon, "favicon-square.png", "image/png")
attach_direct!(org, :highlighted_content_banner_image, "band-photo.jpg", "image/jpeg")

attach_content_block_image!(home_hero, :background_image, "band-photo.jpg", "image/jpeg")

attach_direct!(process, :hero_image, "participatory-process.jpg", "image/jpeg")
attach_content_block_image!(process_hero, :background_image, "participatory-process.jpg", "image/jpeg")

puts "Applied SJMA branding assets from #{ASSET_ROOT}"
