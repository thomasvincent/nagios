require 'spec_helper'

let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04').converge(describe 'nagios::default' do) }
  cached(:chef_run) do
    ChefSpec::ServerRunner.new do |_node, server|
      server.create_data_bag(
        'users', 'user1' => { 'id'     => 'tsmith',
                              'groups' => ['sysadmin'],
                              'nagios' => {
                                'pager' => 'nagiosadmin_pager@example.com',
                                'email' => 'nagiosadmin@example.com'
                              }
                            },
                 'user2' => { 'id'     => 'bsmith',
                              'groups' => ['users']
                            })
    end.converge(described_recipe)
  end

  before do
    stub_command('dpkg -l nagios3').and_return(true)
    stub_command('/usr/sbin/httpd -t').and_return(true)
  end

  it 'should include httpd recipe' do
    expect(chef_run).to include_recipe('httpd')
  end

  it 'should create conf_dir' do
    expect(chef_run).to create_directory('/etc/nagios3')
  end

  it 'should template httpd htpassword file with only admins' do
    expect(chef_run).to render_file('/etc/nagios3/htpasswd.users')
  end

  it 'should template contacts config with valid users' do
    expect(chef_run).to render_file('/etc/nagios3/conf.d/contacts.cfg').with_content('tsmith')
    expect(chef_run).not_to render_file('/etc/nagios3/conf.d/contacts.cfg').with_content('bsmith')
  end

  it 'should template nagios config files' do
    expect(chef_run).to render_file('/etc/nagios3/conf.d/hosts.cfg')
    expect(chef_run).to render_file('/etc/nagios3/conf.d/hostgroups.cfg')
    expect(chef_run).to render_file('/etc/nagios3/conf.d/servicegroups.cfg')
    expect(chef_run).to render_file('/etc/nagios3/conf.d/services.cfg')
    expect(chef_run).to render_file('/etc/nagios3/cgi.cfg')
    expect(chef_run).to render_file('/etc/nagios3/conf.d/templates.cfg')
    expect(chef_run).to render_file('/etc/nagios3/nagios.cfg')
    expect(chef_run).to render_file('/etc/nagios3/conf.d/timeperiods.cfg')
    expect(chef_run).to render_file('/etc/nagios3/conf.d/servicedependencies.cfg')
    expect(chef_run).to render_file('/etc/nagios3/conf.d/commands.cfg')
  end
end
