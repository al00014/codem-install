name "codem-transcoder"
default_version "584ac526788f2e4f27ceb74fd5f8a997d8fd6e81"

dependency "rsync"
dependency "nodejs"
dependency "ffmpeg"
dependency "sqlite"

source :git => 'https://github.com/madebyhiro/codem-transcode.git'

build do
  transcoder_dir = "#{install_dir}/codem-transcoder"

  # npm provided by Ubuntu is outdated, we need npm > 1.1.4
  if platform == "ubuntu"
    command "sudo apt-get update"
    command "sudo apt-get install -y python-software-properties python g++ make"
    command "sudo add-apt-repository ppa:chris-lea/node.js"
    command "sudo apt-get update"
    command "sudo apt-get install nodejs"
  end

  # Cent OS doesn't have npm at all
  if platform == "centos"
    command "sudo rpm --import https://fedoraproject.org/static/0608B895.txt"
    command "sudo rpm -Uvh http://download-i2.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm ; /bin/true"
    command "sudo yum install -y npm --enablerepo=epel"
  end

  command "npm install"

  # Create directories needed for the provided config file
  command "mkdir #{install_dir}/log"
  command "mkdir #{install_dir}/db"
  command "mkdir #{install_dir}/config"

  # Create a config file for localhost:8080
  erb :dest => "#{install_dir}/config/localhost_8080.json",
    :source => "config.json.erb",
    :mode => 0755,
    :vars => { :log_dir => "#{install_dir}/log", 
               :db_dir => "#{install_dir}/db",
               :bin_dir => "#{install_dir}/embedded/bin",
               :port => '8080' }

  # Create a start script
  erb :dest => "#{install_dir}/run.sh",
    :source => "run.sh.erb",
    :mode => 0755,
    :vars => {:install_dir => install_dir,
              :transcoder_dir => transcoder_dir,
              :config_file => "config/localhost_8080.json"}

  # Generate destination and copy the actual code to the correct location
  command "mkdir -p #{transcoder_dir}"
  command "#{install_dir}/embedded/bin/rsync -a --delete --exclude=.git/*** --exclude=.gitignore ./ #{transcoder_dir}"
end

