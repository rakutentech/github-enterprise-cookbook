require 'serverspec'

set :backend, :exec

describe file('/opt/github-backup-utils') do
  it { should be_directory }
end

describe command('cd /opt/github-backup-utils && git branch') do
  its(:stdout) { should match 'stable' }
end

describe file('/opt/github-backup-utils/bin/ghe-backup') do
  it { should be_executable }
end

describe file('/etc/cron.d/github-backup-default') do
  it { should be_file }
  it { should contain '@hourly root ' }
  it { should contain 'GHE_BACKUP_CONFIG=' }
end
