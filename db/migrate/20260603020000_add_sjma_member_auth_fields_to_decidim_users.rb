# frozen_string_literal: true

class AddSjmaMemberAuthFieldsToDecidimUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :decidim_users, :sjma_dni_digest, :string
    add_column :decidim_users, :sjma_dni_last4, :string
    add_column :decidim_users, :sjma_member_number, :string
    add_column :decidim_users, :sjma_member_active, :boolean, null: false, default: false
    add_column :decidim_users, :sjma_must_change_password, :boolean, null: false, default: false
    add_column :decidim_users, :sjma_synced_from_supabase_at, :datetime

    add_index :decidim_users,
              [:decidim_organization_id, :sjma_dni_digest],
              unique: true,
              where: "sjma_dni_digest IS NOT NULL AND deleted_at IS NULL",
              name: "index_decidim_users_on_org_and_sjma_dni_digest"
    add_index :decidim_users, :sjma_member_number
    add_index :decidim_users, :sjma_member_active
  end
end
