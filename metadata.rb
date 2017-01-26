name              'nagios'
maintainer        'Tim Smith'
maintainer_email  'tsmith84@gmail.com'
license           'Apache 2.0'
description       'Installs and configures Nagios server'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '7.2.7'
issues_url       'https://github.com/schubergphilis/nagios/issues' if respond_to?(:issues_url)
source_url       'https://github.com/schubergphilis/nagios' if respond_to?(:source_url)
chef_version     '>= 11.0' if respond_to?(:chef_version)

recipe 'default', 'Installs Nagios server.'
recipe 'nagios::pagerduty', 'Integrates contacts w/ PagerDuty API'

depends 'httpd'
depends 'zap'
depends 'apache2'

%w( build-essential php nginx nginx_simplecgi yum-epel nrpe ).each do |cb|
  depends cb
end

%w( debian ubuntu redhat centos fedora scientific amazon oracle).each do |os|
  supports os
end
