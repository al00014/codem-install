name "codem-scheduler"
default_version "f9340d57450c04340e64d47f7c75335e45e80f08"

dependency "ruby"
dependency "rubygems"
dependency "bundler"
dependency "nokogiri"
dependency "sqlite"
dependency "sqlite-gem"
dependency "json-gem"
dependency "rsync"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "GEM_HOME" => "#{install_dir}/embedded/lib/ruby/gems/2.1.0",
  "GEM_PATH" => "#{install_dir}/embedded/lib/ruby/gems/2.1.0"
}

source :git => 'https://github.com/madebyhiro/codem-schedule.git'

build do
  scheduler_dir = "#{install_dir}/codem-scheduler"

  # sed -i works diffently on BSD and Linux, see
  # http://stackoverflow.com/questions/5694228/sed-in-place-flag-that-works-both-on-mac-bsd-and-linux
  #
  # Convert Gemfile to sqlite3
  command "sed -i.bak 's/mysql2/sqlite3/g' Gemfile"
  # Convert database.yml to sqlite3
  command "sed -i.bak 's/mysql2/sqlite3/g' config/database.yml"
  # Ensure Rails in production is serving static assets
  command "sed -i.bak 's/config.serve_static_assets = false/config.serve_static_assets = true/g' config/environments/production.rb"
  # Cleanup .bak
  command "rm Gemfile.bak config/database.yml.bak config/environments/production.rb.bak"

  # Install required gems, including a JS compiler for platforms that need it
  if platform != "mac_os_x"
    command "sed -i.bak 's/gem \"therubyracer\"//g' Gemfile"
    command "echo 'gem \"therubyracer\"' >> Gemfile"
    command "rm Gemfile.bak"
  end
  bundle "install --without development test", :env => env

  assets_env = {
    "RAILS_ENV" => "production",
    "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
  }.merge!(env)

  # Generate assets
  bundle "exec rake assets:precompile", :env => assets_env

  # Init database
  bundle "exec rake db:create",  :env => assets_env
  bundle "exec rake db:migrate", :env => assets_env

  # Init log file
  command "touch log/production.log && chmod 0666 log/production.log"

  # Generate destination and copy the actual code to the correct location
  command "mkdir -p #{scheduler_dir}"
  command "#{install_dir}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{scheduler_dir}"

  # Create a wrapper for the rake tasks of the Rails app
  erb :dest => "#{install_dir}/bin/codem-rake",
    :source => "bundle_exec_wrapper.erb",
    :mode => 0755,
    :vars => {:command => 'rake "$@"', :install_dir => install_dir}

  # Create a wrapper for the rails command, useful for e.g. `rails console`
  erb :dest => "#{install_dir}/bin/codem-rails",
    :source => "bundle_exec_wrapper.erb",
    :mode => 0755,
    :vars => {:command => 'rails "$@"', :install_dir => install_dir}

  # Create a start script
  erb :dest => "#{install_dir}/run.sh",
    :source => "run.sh.erb",
    :mode => 0755,
    :vars => {:install_dir => install_dir, :scheduler_dir => scheduler_dir}
end

