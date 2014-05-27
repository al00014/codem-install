name "codem-scheduler"
default_version "f9340d57450c04340e64d47f7c75335e45e80f08"

dependency "ruby"
dependency "rubygems"
dependency "bundler"
dependency "nokogiri"
dependency "mysql-client"
dependency "mysql2-gem"
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

  # Install gems without dev and test
  gem "install bundler", :env => env
  bundle "install --binstubs --without development test", :env => env

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
end

