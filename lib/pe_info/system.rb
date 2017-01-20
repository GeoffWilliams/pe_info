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
