#
# Cookbook Name:: github-enterprise
# Resource:: ghe_backup_utils
#
# Copyright (C) 2016 Rakuten, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

resource_name :ghe_backup_utils

property :dir, kind_of: String, name_property: true
property :user, kind_of: String, default: 'ghe'
property :repo, kind_of: String, default: 'https://github.com/github/backup-utils.git'
property :branch, kind_of: String, default: 'master'
property :enable_cron, kind_of: [TrueClass, FalseClass], default: true

action :create do
  git dir do
    repository repo
    revision branch
    user user
    enable_submodules true
    action :sync
  end

  # Permissions
  [
    ::File.join(dir, 'bin/ghe-backup'),
    ::File.join(dir, 'bin/ghe-restore'),
    ::File.join(dir, 'bin/ghe-host-check')
  ].each do |f|
    file "#{name} set permissions on #{f}" do
      path f
      mode '0755'
    end
  end

  ghe_cron 'Github Enterprise Backup' do
    
    only_if { enable_cron }
  end
end

action :delete do
  directory dir do
    recursive true
    action :delete
  end
end
