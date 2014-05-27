#
# Copyright:: Copyright (c) 2013 Robby Dyer
# Copyright:: Copyright (c) 2014 GitLab.com
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
name "mysql-client"
default_version "5.5.37"

dependency "openssl"
dependency "zlib"
dependency "ncurses"

source  :url => "http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.37.tar.gz",
        :md5 => "bf1d80c66d4822ec6036300399a33c03"

relative_path "mysql-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CXXFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CPPFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
  "LD_LIBRARY_PATH" => "#{install_dir}/embedded/lib",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
}

# Force CentOS-5 to use gcc/g++ v4.4
if Ohai.platform =~ /centos/ and Ohai.platform_version =~ /^5/
    env.merge!( {
        "CC" => "gcc44",
        "CXX" => "g++44"
    })
end

build do

  command [
            "cmake",
            "-DCMAKE_SKIP_RPATH=YES",
            "-DCMAKE_INSTALL_PREFIX=#{install_dir}/embedded",
            "-DWITH_SSL=system",
            "-DOPENSSL_INCLUDE_DIR:PATH=#{install_dir}/embedded/include",
            "-DOPENSSL_LIBRARIES:FILEPATH=#{install_dir}/embedded/lib/libssl.dylib",
            "-DWITH_ZLIB=system",
            "-DZLIB_INCLUDE_DIR:PATH=#{install_dir}/embedded/include",
            "-DZLIB_LIBRARY:FILEPATH=#{install_dir}/embedded/lib/libz.dylib",
            "-DCRYPTO_LIBRARY:FILEPATH=#{install_dir}/embedded/lib/libcrypto.dylib",
            ".",
           ].join(" "), :env => env

  %w{libmysql client include scripts}.each do |target|
    command "make -j #{max_build_jobs} install", :env => env, :cwd => "#{project_dir}/#{target}"
  end
end
