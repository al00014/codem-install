name "codem-scheduler"
default_version "f9340d57450c04340e64d47f7c75335e45e80f08"

dependency "ruby"
dependency "rubygems"
dependency "bundler"
dependency "rsync"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

source :git => 'https://github.com/madebyhiro/codem-schedule.git'

build do
  scheduler_dir = "#{install_dir}/codem-scheduler/"

  command "mkdir -p #{scheduler_dir}"
  command "#{install_dir}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{scheduler_dir}"

  bundle "install --binstubs --without development test --path vendor/bundle", :env => env
end

