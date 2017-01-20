module PeInfo
  module System
    AGENT_UPLOAD_PATH_NORMAL  = '/opt/puppetlabs/server/data/staging'
    AGENT_UPLOAD_PATH_WINDOWS = '/opt/puppetlabs/server/data/packages/public'

    def self.agent_installer_upload_path_normal(agent_version)
      "#{AGENT_UPLOAD_PATH_NORMAL}/pe_repo-puppet-agent-#{agent_version}"

    end

    def self.agent_installer_upload_path_windows_x86(pe_version, agent_version)
      "/#{AGENT_UPLOAD_PATH_WINDOWS}/#{pe_version}/windows-i386-#{agent_version}"
    end

    def self.agent_installer_upload_path_windows_x64(pe_version, agent_version)
      "/#{AGENT_UPLOAD_PATH_WINDOWS}/#{pe_version}/windows-x86_64-#{agent_version}"
    end

    def self.upload_path(pe_version, agent_version, installer)
      if installer =~ /puppet-agent-x64.msi/
        path = agent_installer_upload_path_windows_x64(pe_version, agent_version)
      elsif installer =~ /puppet-agent-x86.msi/
        path = agent_installer_upload_path_windows_x86(pe_version, agent_version)
      else
        path = agent_installer_upload_path_normal(agent_version)
      end

      path
    end

  end
end
