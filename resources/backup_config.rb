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

property :config_file, kind_of: String, name_property: true
property :hostname, kind_of: String
property :ssh_user, kind_of: String, default: 'admin'
property :ssh_opts, kind_of: Hash, default: {}
property :owner, kind_of: String, default: 'root'
property :group, kind_of: String, default: 'root'
property :config_template, kind_of: String, default: 'backup.config.erb'
property :template_cookbook, kind_of: String, default: 'github-enterprise'
property :data_dir, kind_of: String, default: '/opt/github/backup-data'
property :log_dir, kind_of: String, default: '/opt/github/backup-logs'
property :num_snapshots, kind_of: Fixnum, default: 10

action :create do
  template new_resource.config_file do
    cookbook new_resource.template_cookbook
    source new_resource.config_template
    owner new_resource.owner
    group new_resource.group
    variables({
      :hostname => new_resource.hostname,
      :num_snapshots => new_resource.num_snapshots,
      :data_dir => new_resource.data_dir,
      :ssh_opts => new_resource.ssh_opts
    })
    action :create
  end
end

action :delete do
  template new_resource.config_file do
    action :delete
  end
end
