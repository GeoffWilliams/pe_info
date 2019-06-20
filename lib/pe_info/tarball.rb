#!/usr/bin/env ruby
#
# Copyright 2016 Geoff Williams for Puppet Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
require "pe_info/version"
require "tmpdir"

module PeInfo
  module Tarball
    def self.tar
      begin
        tar_version = %x(tar --version)
        if tar_version =~ /GNU/
          tar = 'tar --wildcards '
        else
          tar = 'tar'
        end
      rescue Errno::ENOENT
        raise "please install tar and make sure its in your PATH"
      end

      tar
    end

    def self.is_pe_tarball(tarball)
      # =~ returns nil if no matches or position of first match so we must
      # convert its result to a boolean for easy use
      tarball =~ /puppet-enterprise-\d{4}\.\d+\.\d+.*\.tar\.gz/ ? true : false
    end

    def self.pe_version(tarball)
      matches = tarball.match(/puppet-enterprise-(\d{4}\.\d+\.\d+)/)
      pe_version = matches ? matches.captures.first : false

      pe_version
    end

    def self.agent_version(tarball)
      agent_package = %x(#{tar} -ztf #{tarball} '*/puppet-agent*')
      matches = agent_package.match(/puppet-agent-(\d+\.\d+\.\d+)/)
      agent_version = matches ? matches.captures.first : false

      agent_version
    end

    def self.supported_platforms_from_dir(pe_modules_dir)
      platforms = []
      Dir.chdir(pe_modules_dir) do
        Dir.chdir("opt/puppetlabs/puppet/modules/pe_repo/manifests/platform") do
          # windows doesn't use the platform tag...
          manifests = Dir.glob("*.pp").reject {|e| e =~ /windows/ }
          manifests.each { |f|
            pe_repo_match = File.open(f).grep(/^\s+pe_repo::/).reject { |e|
              e =~ /deprecation/
            }
            if pe_repo_match.length > 0
              # need to read the call the manifest would have made to get the
              # platform tag, eg ubuntu-1604-i386 is really ubuntu-16.04-i386...
              platform_tag = pe_repo_match[0].scan(/[^']+'([^']+)':/)[0][0]
              if platform_tag =~ /osx/
                # must remove the arch from osx because reasons...
                platform_tag = platform_tag.gsub(/-x86_64/, '')
              end
              platforms << platform_tag
            else
              # some manifests dont have installers any more... (skipped)
            end
          }
        end
      end

      platforms.sort
    end

    def self.supported_platforms(tarball, fail_bad_tarball=true)
      platforms = false
      Dir.mktmpdir do |temp_dir|
        Dir.chdir(temp_dir) do
          if system("#{tar} --strip-components 3 -zxvf #{tarball} --wildcards puppet-enterprise*/packages/*/pe-modules*.rpm && rpm2cpio pe-modules*.rpm | cpio -idmv")
            platforms = supported_platforms_from_dir(temp_dir)
          elsif fail_bad_tarball
            raise "Tarball error - not found or missing .rpm"
          end

        end
      end
      platforms
    end

    # @param fail_bad_tarball False to ignore bad tarballs and proceed (for testing)
    def self.inspect(tarball, fail_bad_tarball=true)
      pe_version          = false
      agent_version       = false
      supported_platforms = []

      if is_pe_tarball(tarball)
        if File.exists?(tarball)

          # capture the main version
          pe_version = pe_version(tarball)

          # look for the agent version
          agent_version = agent_version(tarball)

          # Extract the pe-modules*rpm from the tarball and scan it supported
          # platforms in puppet code
          supported_platforms = supported_platforms(tarball, fail_bad_tarball)
        else
          PeInfo.logger.debug "File not found: #{tarball}"
        end
      else
        PeInfo.logger.debug "Not a puppet install tarball: #{tarball}"
      end
      return pe_version, agent_version, supported_platforms
    end
  end
end
