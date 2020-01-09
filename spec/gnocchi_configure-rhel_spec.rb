# encoding: UTF-8

require_relative 'spec_helper'

describe 'openstack-telemetry::gnocchi_configure' do
  describe 'rhel' do
    let(:runner) { ChefSpec::SoloRunner.new(REDHAT_OPTS) }
    let(:node) { runner.node }
    cached(:chef_run) { runner.converge(described_recipe) }

    include_context 'telemetry-stubs'

    it do
      expect(chef_run).to_not create_cookbook_file('/etc/ceilometer/gnocchi_resources.yaml')
        .with(
          source: 'gnocchi_resources.yaml',
          owner: 'ceilometer',
          group: 'ceilometer',
          mode: 0o0640
        )
    end

    it do
      expect(chef_run).to nothing_execute('restore-selinux-context-gnocchi')
        .with(command: 'restorecon -Rv /etc/httpd /etc/pki || :')
    end
  end
end
