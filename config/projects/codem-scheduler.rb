name 'codem-scheduler'
maintainer 'Hiro <hello@madebyhiro.com>'
homepage 'http://transcodem.com'

install_path    '/opt/codem-scheduler'
build_version   Omnibus::BuildVersion.semver
build_iteration 1

override :ruby,     :version => '2.1.1'
override :rubygems, :version => '2.2.1'

# creates required build directories
dependency 'preparation'

# codem dependencies/components
dependency 'codem-scheduler'

# version manifest file
dependency 'version-manifest'

exclude '\.git*'
exclude 'bundler\/git'
