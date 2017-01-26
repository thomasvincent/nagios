#
# Author:: Tim Smith <tsmith@chef.io>
# Cookbook Name:: nagios
# Recipe:: apache
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

httpd_service 'nagios' do
  action [:create, :start]
end

httpd_config 'nagios' do
  source 'mysite.cnf.erb'
  notifies :restart, 'httpd_service[nagios]'
  action :create
end

httpd_module 'cgi' do
  action :create
end

httpd_module 'ssl' do
  action :create
end

httpd_module 'php' do
  action :create
end
