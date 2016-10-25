describe file('/usr/local/include/google/sparsehash') do
  it { should be_directory }
end

describe file('/usr/local/include/google/sparsehash/sparsehashtable.h') do
  it { should be_file }
end

describe file('/usr/local/include/jemalloc') do
  it { should be_directory }
end

describe file('/usr/local/include/jemalloc/jemalloc.h') do
  it { should be_file }
end

describe file('/usr/local/bamtools/bin') do
  it { should be_directory }
end

describe file('/usr/local/bamtools/bin/bamtools') do
  it { should be_file }
  it { should be_executable }
  it { should be_symlink }
end

describe command('. /etc/profile; which sga-align') do
  its('exit_status') { should eq 0 }
end

describe command('. /etc/profile; sga-align --help') do
  its('stdout') { should match(/align reads to contigs/) }
end
