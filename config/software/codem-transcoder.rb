name "codem-transcoder"
default_version "584ac526788f2e4f27ceb74fd5f8a997d8fd6e81"

dependency "nodejs"

source :git => 'https://github.com/madebyhiro/codem-transcode.git'

build do
  command "npm install"
end

