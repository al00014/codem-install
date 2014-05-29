name "mp4v2"
default_version "2.0.0"

source :url => "https://mp4v2.googlecode.com/files/mp4v2-2.0.0.tar.bz2",
       :md5 => "c91f06711225b34b4c192c9114887b14"

relative_path "mp4v2-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command ["./configure",
           "--prefix=#{install_dir}/embedded",
          ], :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install", :env => env
end
