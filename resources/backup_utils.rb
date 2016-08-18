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
property :user, kind_of: String, default: 'root'
property :repo_url, kind_of: String, default: 'https://github.com/github/backup-utils.git'
property :branch, kind_of: String, default: 'stable'
property :data_dir, kind_of: String, default: '/opt/github/backup-data'
property :log_dir, kind_of: String, default: '/opt/github/backup-logs'

default_action :create

# TODO Load existing values to prevent re-converge incorrectly
# load_current_value do
#   if (::File.exist?(dir))
#     user ::Etc.getpwuid(::File.stat(dir).uid).name
#     repo 
#     branch
#     data_dir
#     log_dir
#   end
# end

action :create do
  include_recipe 'git'

  directory ::File.dirname(new_resource.dir) do
    owner new_resource.user
    action :create
  end

  git new_resource.dir do
    repository new_resource.repo_url
    revision new_resource.branch
    user new_resource.user
    enable_submodules true
    action :sync
  end

  # Permissions
  %w(
    ghe-backup
    ghe-restore
    ghe-host-check
  ).each do |f|
    f_path = ::File.join(new_resource.dir, 'bin', f)
    file "#{name} set permissions on #{f_path}" do
      path f_path
      mode '0755'
    end
  end

  [new_resource.data_dir, new_resource.log_dir].each do |d|
    directory "#{name} create #{d}" do
      path d
      owner new_resource.user
      mode '0755'
      recursive true
      action :create
    end
  end
end

action :delete do
  [
    new_resource.data_dir,
    new_resource.log_dir,
    new_resource.dir
  ].each do |d|
    directory d do
      action :delete
    end
  end
end
