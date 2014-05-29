name "libxvid"
default_version "1.3.2"

source :url => "http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz",
       :md5 => "87c8cf7b69ebed93c2d82ea5709d098a"

relative_path "xvidcore/build/generic"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "PATH" => "#{install_dir}/embedded/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"
}

build do
  command "sudo apt-get -y install libxvidcore-dev" if platform == "ubuntu"

  command [ "./configure",
            "--disable-assembly",
            "--enable-shared",
            "--prefix=#{install_dir}/embedded" ], :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make -j #{max_build_jobs} install", :env => env
end
