name 'json-gem'
default_version '1.8.1'

dependency "ruby"
dependency "rubygems"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "LD_LIBRARY_PATH" => "#{install_dir}/embedded/lib",
  "GEM_HOME" => "#{install_dir}/embedded/lib/ruby/gems/2.1.0",
  "GEM_PATH" => "#{install_dir}/embedded/lib/ruby/gems/2.1.0",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
}

build do
  gem ["install",
       "json",
       "-v #{version}"].join(' '), :env => env
end
