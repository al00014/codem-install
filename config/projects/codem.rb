name 'codem'
maintainer 'Hiro <hello@madebyhiro.com>'
homepage 'http://transcodem.com'

install_path    '/opt/codem'
build_version   Omnibus::BuildVersion.semver
build_iteration 1

# creates required build directories
dependency 'preparation'

# codem dependencies/components
dependency 'codem-scheduler'
dependency 'codem-transcoder'

# version manifest file
dependency 'version-manifest'

exclude '\.git*'
exclude 'bundler\/git'
