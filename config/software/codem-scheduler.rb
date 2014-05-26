name "codem-scheduler"
default_version "f9340d57450c04340e64d47f7c75335e45e80f08"

dependency "ruby"
dependency "bundler"
dependency "rsync"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
}

source :git => 'https://github.com/madebyhiro/codem-schedule.git'

build do
  command "bundle install --without development test --path=#{install_dir}/embedded/service ", :env => env

  command "mkdir -p #{install_dir}/codem-scheduler"
  command "#{install_dir}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{install_dir}/codem-scheduler/"
end

