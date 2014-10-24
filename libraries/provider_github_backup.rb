#
# Cookbook Name:: github_enterprise
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
        install_packages

        # Create directories
        [new_resource.parsed_data_dir, new_resource.parsed_log_dir].each do |d|
          directory "#{new_resource.parsed_name} create #{d}" do
            path d
            owner new_resource.parsed_user
            group new_resource.parsed_group
            mode '0755'
            action :create
          end
        end

        # Clone the backup utils repo
        remote = node['github_enterprise']['backup']['repository']
        git "#{new_resource.parsed_name} clone #{remote}" do
          destination new_resource.parsed_dir
          repository remote
          user new_resource.parsed_user
          group new_resource.parsed_group
          enable_submodules true
        end

        # Ensure bin/ files are executable
        # TODO

        # Create the configuration
        config_file = "#{new_resource.parsed_dir}/#{new_resource.parsed_name}.config"
        template "#{new_resource.parsed_name} create #{config_file}" do
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
      end

      #
      # Action: Delete
      #
      action :delete do
        remove_packages

        # TODO - Cleanup directories
        # TODO - Cleanup Cron
        # TODO - Cleanup data
      end

      action :run do
        backup
      end

      action :restore do
        # TODO
      end

      #
      # Package Dependencies
      #
      def packages
        %w[
          rsync
        ]
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

      #
      # Perform the backup
      #
      def backup
        # TODO - Perform the actual backup
      end
    end
  end
end
