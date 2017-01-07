namespace :ridgepole do
  desc 'Apply a Schemafile file into the database'
  task :apply, :rails_env do
    sh [
      'ridgepole --apply -f db/Schemafile',
      '-c config/database.yml',
    ].join(' ')
  end
end

Rake.application.lookup('db:migrate').clear
desc 'Migrate the database by Ridgepole'
task 'db:migrate' do
  Rake::Task['ridgepole:apply'].invoke
end
