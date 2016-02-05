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
property :user, kind_of: String, default: 'ghe'
property :dir, kind_of: String, default: '/opt/github/backup-utils'
property :config_file, kind_of: String, default: 'backup.config'
property :log_dir, kind_of: String, default: '/opt/github/backup-logs'

action :create do
  cron_d "github-backup-#{name}" do
    predefined_value '@hourly'
    command "GHE_BACKUP_CONFIG=#{::File.join(dir, config_file)} #{dir}/bin/ghe-backup 1>>#{log_dir}/#{name}.log"
    user user
    action :create
  end
end

action :delete do
  cron_d "github-backup-#{name}" do
    action :delete
  end
end