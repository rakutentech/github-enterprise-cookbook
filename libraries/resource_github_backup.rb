#
# Cookbook Name:: github_enterprise
# Library:: resource_github_backup
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

require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class GithubBackup < Chef::Resource::LWRPBase
      self.resource_name = :github_backup
      actions :create, :delete, :run, :restore
      default_action :create

      attribute :hostname, :kind_of => String, :default => 'github.example.com'
      attribute :dir, :kind_of => String, :default => '/opt/github-backup-utils'
      attribute :data_dir, :kind_of => String, :default =>  '/opt/github-backup-data'
      attribute :user, :kind_of => String, :default =>  'root'
      attribute :group, :kind_of => String, :default =>  'root'
      attribute :snapshots, :kind_of => Integer, :default =>  10
      attribute :cron, :kind_of => [String, Array, TrueClass, FalseClass], :default =>  'hourly'
      attribute :log_dir, :kind_of => String, :default =>  '/var/log/github-backup'

      def parsed_hostname
        return hostname if hostname
      end

      def parsed_dir
        return dir if dir
      end

      def parsed_data_dir
        return data_dir if data_dir
      end

      def parsed_user
        return user if user
      end

      def parsed_group
        return group if group
      end

      def parsed_snapshots
        return snapshots if snapshots
      end

      def parsed_cron
        return cron if cron
        # TODO - Parse out the various options
        #return cron if cron.is_a? Array
        #return case cron ... 
      end

      def parsed_log_dir
        return log_dir if log_dir
      end

      def parsed_name
        return name if name
      end
    end
  end
end
