#describe file('/usr/local/bwa-0.7.15') do
#  it { should be_directory }
#end

#describe file('/usr/local/bwa-0.7.15/bwa') do
#  it { should be_executable }
#end

#describe file('/usr/local/bin/bwa') do
#  it { should be_symlink }
#end

#describe command('. /etc/profile; which bwa') do
#  its('exit_status') { should eq 0 }
#end

#describe command('. /etc/profile; bwa') do
#  its('stderr') { should match(/Version: 0.7.15-r1140/) }
#end
