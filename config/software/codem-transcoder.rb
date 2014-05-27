name "codem-transcoder"
default_version "584ac526788f2e4f27ceb74fd5f8a997d8fd6e81"
always_build 1

dependency "rsync"
dependency "nodejs"
dependency "ffmpeg"
dependency "sqlite"

source :git => 'https://github.com/madebyhiro/codem-transcode.git'

build do
  transcoder_dir = "#{install_dir}/codem-transcoder"

  command "npm install"
  
  # Generate destination and copy the actual code to the correct location
  command "mkdir -p #{transcoder_dir}"
  command "#{install_dir}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{transcoder_dir}"

  command "mkdir #{install_dir}/log"
  command "mkdir #{install_dir}/db"
  command "mkdir #{install_dir}/config"

  erb :dest => "#{install_dir}/config/config.json",
    :source => "config.json.erb",
    :mode => 0755,
    :vars => { :log_dir => "#{install_dir}/log", 
               :db_dir => "#{install_dir}/db",
               :bin_dir => "#{install_dir}/embedded/bin" }
end

