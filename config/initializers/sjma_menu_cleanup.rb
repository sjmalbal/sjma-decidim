# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim.menu :mobile_menu do |menu|
    menu.remove_item :help
  end
end
