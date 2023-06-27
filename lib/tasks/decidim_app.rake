# frozen_string_literal: true

namespace :decidim_app do
  desc "Setup Decidim-app"
  task setup: :environment do
    puts "Running bundler installation"
    system("bundle install")
    puts "[Decidim Awesome] Installing migrations..."
    system("bundle exec rails decidim_decidim_awesome:install:migrations")
    puts "[Decidim Awesome] Installing webpacker..."
    system("bundle exec rails decidim_decidim_awesome:webpacker:install")
    puts "[Homepage Interactive map] Installing migrations..."
    system("bundle exec rake decidim_homepage_interactive_map:install:migrations")
    puts "[Term customizer] Installing migrations"
    system("bundle exec rails decidim_term_customizer:install:migrations")
    puts "[Decidim Ludens] Installing migrations"
    system("bundle exec rails decidim_ludens:install:migrations")
    puts "Initializing decidim_ludens..."
    system("bundle exec rake decidim_ludens:initialize")
    puts "Checking for migrations to apply..."
    migrations = `bundle exec rake db:migrate:status | grep down`
    if migrations.present?
      puts "Missing migrations :
#{migrations}"
      puts "Applying missing migrations..."
      system("bundle exec rake db:migrate")
    else
      puts "All migrations are up"
    end

    puts "Setup successfully terminated"
  end

  desc "Create admin user with decidim_app:create_admin name='John Doe' nickname='johndoe' email='john@example.org', password='decidim123456' organization_id='1'"
  task create_admin: :environment do
    Decidim::AdminCreator.create!(ENV) ? puts("Admin created successfully") : puts("Admin creation failed")
  end

  desc "Create system user with decidim_app:create_system_admin email='john@example.org', password='decidim123456'"
  task create_system_admin: :environment do
    Decidim::SystemAdminCreator.create!(ENV) ? puts("System admin created successfully") : puts("System admin creation failed")
  end

  # This task is used to upgrade your decidim-app to the latest version
  # Meant to be used in a CI/CD pipeline or a k8s job/operator
  # You can add your own customizations here
  desc "Upgrade decidim-app"
  task upgrade: :environment do
    puts "Running db:migrate"
    Rake::Task["db:migrate"].invoke
  end
end
