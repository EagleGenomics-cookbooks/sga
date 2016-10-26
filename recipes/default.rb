#
# Cookbook Name:: sga
# Recipe:: default
#
# Copyright 2016 Eagle Genomics Ltd
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

# For description of dependencies see: https://github.com/jts/sga/tree/master/src#readme

include_recipe 'build-essential'
include_recipe 'apt'
include_recipe 'git'
include_recipe 'poise-python'

package ['cmake', 'zlib1g-dev'] do
  action :install
end

# bamtools dependency
git node['sga']['bamtools_install_path'] do
  repository 'https://github.com/pezmaster31/bamtools.git'
  revision 'master'
  action :sync
end
bash 'Install bamtools' do
  cwd node['sga']['bamtools_install_path']
  code <<-EOH
    mkdir build
    cd build
    cmake ..
    make
  EOH
  not_if { ::File.exist?('/usr/local/bamtools/bin/bamtools') }
end

# sparse_hash dependency
git node['sga']['sparse_hash_install_path'] do
  repository 'https://github.com/sparsehash/sparsehash.git'
  revision 'master'
  action :sync
end
bash 'Install sparse_hash header files' do
  cwd node['sga']['sparse_hash_install_path']
  code <<-EOH
    ./configure
    make
    make install
  EOH
  not_if { ::File.exist?('/usr/local/include/google/sparsehash/sparsehashtable.h') }
end

# jemalloc (optional) dependency
git node['sga']['jemalloc_install_path'] do
  repository 'https://github.com/jemalloc/jemalloc.git'
  revision 'master'
  action :sync
end
bash 'Install jemalloc header files' do
  cwd node['sga']['jemalloc_install_path']
  # This does not build the documentation (requires XSL)
  # See: https://github.com/jemalloc/jemalloc/issues/231
  code <<-EOH
    ./autogen.sh
    ./configure
    make
    make install_bin install_include install_lib
  EOH
  not_if { ::File.exist?('/usr/local/include/jemalloc/jemalloc.h') }
end

# python helper script dependencies
python_package 'pysam'
python_package 'ruffus'

# SGA
git node['sga']['install_path'] do
  repository 'https://github.com/jts/sga.git'
  revision 'master'
  action :sync
end
bash 'Install SGA' do
  cwd "#{node['sga']['install_path']}/src"
  code <<-EOH
    ./autogen.sh
    ./configure --with-bamtools=/usr/local/bamtools/ --with-sparsehash=/usr/local/include/google/sparsehash --with-jemalloc=/usr/local/include/jemalloc/
    make
    make install
  EOH
  # not_if { ::File.exist?('/usr/local/include/google/sparsehash/sparsehashtable.h') }
end

# this symlinks every executable in the install subdirectory to the top of the directory tree
# so that they are in the PATH
execute "find #{node['sga']['install_path']}/src/bin -maxdepth 1 -name '*' -executable -exec ln -s {} . \\;" do
  cwd 'usr/local/bin'
end
