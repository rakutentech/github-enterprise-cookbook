#
# Cookbook Name:: github-enterprise
# Resource:: ghe_backup_cron
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

resource_name :ghe_backup_cron

property :name, kind_of: String, name_property: true
property :user, kind_of: String, default: 'root'
property :group, kind_of: String, default: 'root'
property :dir, kind_of: String, default: '/opt/github/backup-utils'
property :config_file, kind_of: String, default: 'backup.config'
property :log_dir, kind_of: String, default: '/opt/github/backup-logs'

action :create do
  file_config = ::File.join(new_resource.dir, new_resource.config_file)
  file_backup = ::File.join(new_resource.dir, 'bin', 'ghe-backup')
  file_log    = ::File.join(new_resource.log_dir, "#{cron_name(new_resource.name)}.log")

  cron_d cron_name(new_resource.name) do
    predefined_value '@hourly'
    command "GHE_BACKUP_CONFIG=#{file_config} #{file_backup} 1>>#{file_log}"
    user new_resource.user
    action :create
  end
end

action :delete do
  cron_d cron_name(new_resource.name) do
    action :delete
  end
end

def cron_name(resource_name)
  "github-backup-#{resource_name}"
end
