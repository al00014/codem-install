name               "ffmpeg"
default_version    "2.1.3"

source :url => "http://www.ffmpeg.org/releases/ffmpeg-#{version}.tar.gz",
       :md5 => "2b3bf6a2e1596e337f40bc545d3ef3e4"

dependency  "yasm"
dependency  "zlib"

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
                      "--enable-nonfree",
                      "--prefix=#{install_dir}/embedded",
                      "--yasmexe=#{install_dir}/embedded/bin/yasm"]
  make_binary = 'make'
  command configure_command.join(" ")
  command "#{make_binary} -j #{max_build_jobs}", :env => env
  command "#{make_binary} -j #{max_build_jobs} install", :env => env
end
