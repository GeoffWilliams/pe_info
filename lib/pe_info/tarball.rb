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

module PeInfo
  module Tarball
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
      agent_package = %x(tar ztf #{tarball} '**/puppet-agent*')
      matches = agent_package.match(/puppet-agent-(\d+\.\d+\.\d+)/)
      agent_version = matches ? matches.captures.first : false

      agent_version
    end

    def self.inspect(tarball)
      pe_version    = false
      agent_version = false

      if is_pe_tarball(tarball)
        if File.exists?(tarball)

          # capture the main version
          pe_version = pe_version(tarball)

          # look for the agent version
          agent_version = agent_version(tarball)
        else
          PeInfo.logger.debug "File not found: #{tarball}"
        end
      else
        PeInfo.logger.debug "Not a puppet install tarball: #{tarball}"
      end
      return pe_version, agent_version
    end
  end
end
