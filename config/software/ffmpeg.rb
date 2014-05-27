name               "ffmpeg"
default_version    "2.1.3"

source :url => "http://www.ffmpeg.org/releases/ffmpeg-#{version}.tar.gz",
       :md5 => "2b3bf6a2e1596e337f40bc545d3ef3e4"

dependency  "yasm"
dependency  "zlib"
dependency  "libx264"
dependency  "libfaac"
dependency  "lame"

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
                      "--enable-pthreads",
                      "--enable-gpl",
                      "--enable-version3",
                      "--enable-hardcoded-tables",
                      "--enable-avresample",
                      "--enable-vda",
                      "--enable-libx264",
                      "--enable-libfaac",
                      "--enable-libmp3lame",
                      "--prefix=#{install_dir}/embedded",
                      "--yasmexe=#{install_dir}/embedded/bin/yasm"]
  command configure_command.join(" ")
  command "make -j #{max_build_jobs}", :env => env
  command "make -j #{max_build_jobs} install", :env => env
end
