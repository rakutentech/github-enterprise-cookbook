# Github Enterprise Cookbook

[![Build Status](https://secure.travis-ci.org/rakutentech/github-enterprise-cookbook.png)](http://travis-ci.org/rakutentech/github-enterprise-cookbook)

Facilities for automation around Github Enterprise.

Currently, just backup and restore.

## Supported Platforms

* Ubuntu 12.04
* Ubuntu 14.04
* CentOS 6.4
* CentOS 6.5

## Usage

### Backup

Define a resource block in the recipe you are constructing, passing appropriate values for your environment. Below is an example showing all the defaults.

```json
github_backup 'default' do
  hostname 'github.example.com'
  dir '/opt/github-backup-utils'
  data_dir '/opt/github-backup-data'
  user 'root'
  group 'root'
  snapshots 10
  cron 'hourly'
  log_dir '/var/log/github-backup'
  action :create
end
```

#### Parameters

* `hostname` - Hostname of the Github Enterprise server
* `dir` - Directory into which the Backup Tools will be installed
* `data_dir` - Directory into which data (backup data) will be stored (resource name will be appended to this path)
* `user` - User / owner of directories, and the user for scheduled tasks (if enabled)
* `group` - Group for directory permissions
* `snapshots` - Number of snapshots to retain
* `cron` - Either `'@hourly'` or `'@daily'` or `'@weekly'`.
* `log_dir` - Directory used for log output (resource name will be appended to this path)
* `action` - The following actions are supported: `create`, `delete`

Its important to note that the resource `name` (in this case: `'default'`) will be appended to the `data_dir` path, allowing you to define many Github Enterprise resources on a single backup host.

## License and Authors

- Author:: Graham Weldon <graham.weldon@mail.rakuten.com>

```text
Copyright:: 2016 Rakuten, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
