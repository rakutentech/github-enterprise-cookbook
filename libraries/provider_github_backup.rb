#
# Cookbook Name:: github-enterprise
# Library:: provider_github_backup
#
# Copyright (C) 2014 Rakuten, Inc.
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

class Chef
  class Provider
    class GithubBackup < Chef::Provider::LWRPBase
      use_inline_resources if defined?(use_inline_resources)

      #
      # Why Run Supported?
      #
      def whyrun_supported?
        true
      end

      #
      # Action: Create
      #
      action :create do
        @run_context.include_recipe 'git'
        install_packages

        name = new_resource.parsed_name
        log_dir = new_resource.parsed_log_dir
        remote = node['github-enterprise']['backup']['repository']
        dir = new_resource.parsed_dir
        data_dir = new_resource.parsed_data_dir
        config_file = "#{dir}/#{name}.config"

        # Create directories
        [data_dir, log_dir].each do |d|
          directory "#{name} create #{d}" do
            path d
            owner new_resource.parsed_user
            group new_resource.parsed_group
            mode '0755'
            recursive true
            action :create
          end
        end

        # Clone the backup utils repo
        git "#{name} clone #{remote}" do
          destination dir
          repository remote
          user new_resource.parsed_user
          group new_resource.parsed_group
          enable_submodules true
        end

        ["#{dir}/bin/ghe-backup", "#{dir}/bin/ghe-restore", "#{dir}/bin/ghe-host-check"].each do |f|
          file "#{name} set permissions on #{f}" do
            path f
            mode '0755'
          end
        end

        # Create the configuration
        template "#{name} create #{config_file}" do
          path config_file
          source 'backup.config.erb'
          owner new_resource.parsed_user
          group new_resource.parsed_group
          mode '0755'
          variables(
            :hostname => new_resource.parsed_hostname,
            :data_dir => new_resource.parsed_data_dir,
            :snapshots => new_resource.parsed_snapshots
          )
          cookbook 'github-enterprise'
          action :create
        end

        cron_d "github-backup-#{name}" do
          predefined_value new_resource.parsed_cron
          command "GHE_BACKUP_CONFIG=#{config_file} #{dir}/bin/ghe-backup 1>>#{log_dir}/#{name}.log"
          user new_resource.parsed_user
        end
      end

      #
      # Action: Delete
      #
      action :delete do
        remove_packages

        log_dir = new_resource.parsed_log_dir
        dir = new_resource.parsed_dir
        data_dir = new_resource.parsed_data_dir

        [data_dir, log_dir, dir].each do |d|
          directory "#{name} create #{d}" do
            recursive true
            action :delete
          end
        end

        cron_d "github-backup-#{name}" do
          action :delete
        end
      end

      #
      # Package Dependencies
      #
      def packages
        %w(
          rsync
        )
      end

      #
      # Install Packages
      #
      def install_packages
        packages.each do |p|
          package p do
            action :install
          end
        end
      end

      #
      # Remove Packages
      #
      def remove_packages
        packages.each do |p|
          package p do
            action :remove
          end
        end
      end
    end
  end
end
