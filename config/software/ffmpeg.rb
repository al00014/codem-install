name               "ffmpeg"
default_version    "2.1.3"

source :url => "http://www.ffmpeg.org/releases/ffmpeg-#{version}.tar.gz",
       :md5 => "2b3bf6a2e1596e337f40bc545d3ef3e4"

dependency  "yasm"
dependency  "zlib"
dependency  "libx264"
dependency  "libfaac"
dependency  "libxvid"
dependency  "lame"

relative_path "#{name}-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include -fPIC",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command ["./configure",
           "--enable-static",
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
           "--enable-libxvid",
           "--prefix=#{install_dir}/embedded",
           "--yasmexe=#{install_dir}/embedded/bin/yasm"], :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make -j #{max_build_jobs} install", :env => env
end
