name 'mysql2-gem'
default_version '0.3.6'

dependency "ruby"
dependency "rubygems"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "GEM_HOME" => "#{install_dir}/embedded/lib/ruby/gems/2.1.0",
  "GEM_PATH" => "#{install_dir}/embedded/lib/ruby/gems/2.1.0",
}

build do
  gem ["install",
       "mysql2",
       "-v #{version}",
       "--",
       "--with-mysql-config=#{install_dir}/embedded/bin/mysql_config"].join(' '), :env => env
end
