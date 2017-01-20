require "pe_info/version"

module PeInfo
  module Tarball
    def self.is_pe_tarball(tarball)
      tarball =~ /puppet-enterprise-\d{4}\.\d+\.\d+.*\.tar\.gz/
    end

    def self.pe_version(tarball)
      pe_version = tarball.match(/puppet-enterprise-(\d{4}\.\d+\.\d+)/).captures.first

      pe_version
    end

    def self.agent_version(tarball)
      agent_package = %x(tar ztf #{tarball} '**/puppet-agent*')
      agent_version = agent_package.match(/puppet-agent-(\d+\.\d+\.\d+)/).captures.first

      agent_version
    end

    def self.inspect(tarball)
      if is_pe_tarball(tarball)
        if File.exists?(tarball)

          # capture the main version
          pe_version = pe_version(tarball)

          # look for the agent version
          agent_version = agent_version(tarball)
        else
          raise "File not found: #{tarball}"
        end
      else
        raise "Not a puppet install tarball: #{tarball}"
      end
      return pe_version, agent_version
    end
  end
end
