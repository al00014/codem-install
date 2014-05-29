name "libfaac"
default_version "1.28"

source :url => "http://downloads.sourceforge.net/faac/faac-#{version}.tar.gz",
       :md5 => "80763728d392c7d789cde25614c878f6"

dependency "mp4v2"

relative_path "faac-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}


build do
  command "sudo apt-get -y install libfaac-dev" if platform == "ubuntu"

  if platform == "centos"
    command "sudo yum install -y libtool"
    command "./bootstrap", :env => env
  end

  command ["./configure",
           "--prefix=#{install_dir}/embedded",
           "--enable-static",
          ], :env => env

  command "sed -i -r '/^char \\*strcasestr/d' common/mp4v2/mpeg4ip.h"

  if platform == "debian"
    patch :source => "faac-1.28-external-libmp4v2.patch", :plevel => 1
  end

  command "make -j #{max_build_jobs}", :env => env
  command "make install", :env => env
end

