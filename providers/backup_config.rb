#
# Cookbook Name:: github-enterprise
# Resource:: ghe_backup_config
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

resource_name :ghe_backup_config

property :config_file, String, name_property: true
property :user, String, default: 'ghe'
property :group, String, default: 'ghe'
property :template, String, default: 'backup.config.erb'
property :data_dir, String, default: '/opt/github/backup-data'
property :num_snapshots, 

action :create do
  template config_file do
    source template
    owner user
    group group
    variables({
      :hostname => hostname,
      :num_snapshots => num_snapshots,
      :data_dir => data_dir,
      :ssh_opts => ssh_opts
    })
    action :create
  end
end

action :delete do
  template config_file do
    action :delete
  end
end
