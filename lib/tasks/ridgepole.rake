namespace :ridgepole do
  desc 'Apply a Schemafile file into the database'
  task :apply, :rails_env do
    sh [
      'ridgepole --apply -f db/Schemafile',
      '-c config/database.yml',
      "--ignore-tables '#{ignore_tables}'",
    ].join(' ')
  end

  def ignore_tables
    ActiveRecord::SchemaDumper.ignore_tables.map(&:source).join(',')
  end
end

Rake.application.lookup('db:migrate').clear
desc 'Migrate the database by Ridgepole'
task 'db:migrate' do
  Rake::Task['ridgepole:apply'].invoke

  if Rails.env.development?
    Annotate::Migration.update_annotations
  end
end
