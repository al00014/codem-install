name                "yasm"
default_version     "1.2.0"

source :url => "http://www.tortall.net/projects/yasm/releases/#{name}-#{version}.tar.gz",
       :md5 => "4cfc0686cf5350dd1305c4d905eb55a6"

relative_path "#{name}-#{version}"

prefix="#{install_dir}/embedded"
libdir="#{prefix}/lib"

env = {
  "LDFLAGS" => "-L#{libdir} -I#{prefix}/include",
  "CFLAGS" => "-L#{libdir} -I#{prefix}/include -fPIC",
  "LD_RUN_PATH" => libdir
}


build do
  configure_command = ["./configure",
                       "--prefix=#{install_dir}/embedded"]
  make_binary = 'make'
  command configure_command.join(" ")
  command "#{make_binary} -j #{max_build_jobs}", :env => env
  command "#{make_binary} -j #{max_build_jobs} install", :env => env
end
