namespace :holt do
  desc 'Import Holt data'
  task import: :environment do
    # org = Organization.create_and_build_tenant(short_name: 'holt', full_name: "Holt International Cambodia", logo: File.open(Rails.root.join('app/assets/images/holt.jpg')), fcf_ngo: true)
    Organization.switch_to 'nepal'

    Rake::Task['db:seed'].invoke
    Rake::Task['agencies:import'].invoke
    Rake::Task['departments:import'].invoke
    Rake::Task['nepali_provinces:import'].invoke
    Rake::Task['referral_sources:import'].invoke
    Rake::Task['quantitative_types:import'].invoke
    Rake::Task['quantitative_cases:import'].invoke
    Setting.first.update(country_name: 'nepal')
    Rake::Task["field_settings:import"].invoke('nepal')
    # import = HoltImporter::Import.new('Family')
    # import.families

    # import = HoltImporter::Import.new('Users')
    # import.users

    # import = HoltImporter::Import.new('Client')
    # import.clients
  end
end
