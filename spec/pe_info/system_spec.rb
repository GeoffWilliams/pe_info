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

require "spec_helper"
require "pe_info/system"

describe PeInfo::System do
  PE_VERSION    = 'xxxx.xx.xx'
  AGENT_VERSION = 'y.y.y'

  AGENT_REPO_FILES_NORMAL = [
    "puppet-agent-aix-5.3-power.tar.gz",
    "puppet-agent-aix-6.1-power.tar.gz",
    "puppet-agent-aix-7.1-power.tar.gz",
    "puppet-agent-debian-7-amd64.tar.gz",
    "puppet-agent-debian-7-i386.tar.gz",
    "puppet-agent-debian-8-amd64.tar.gz",
    "puppet-agent-debian-8-i386.tar.gz",
    "puppet-agent-el-4-i386.tar.gz",
    "puppet-agent-el-4-x86_64.tar.gz",
    "puppet-agent-el-5-i386.tar.gz",
    "puppet-agent-el-5-x86_64.tar.gz",
    "puppet-agent-el-6-i386.tar.gz",
    "puppet-agent-el-6-s390x.tar.gz",
    "puppet-agent-el-6-x86_64.tar.gz",
    "puppet-agent-el-7-s390x.tar.gz",
    "puppet-agent-el-7-x86_64.tar.gz",
    "puppet-agent-fedora-22-i386.tar.gz",
    "puppet-agent-fedora-22-x86_64.tar.gz",
    "puppet-agent-fedora-23-i386.tar.gz",
    "puppet-agent-fedora-23-x86_64.tar.gz",
    "puppet-agent-fedora-24-i386.tar.gz",
    "puppet-agent-fedora-24-x86_64.tar.gz",
    "puppet-agent-sles-10-i386.tar.gz",
    "puppet-agent-sles-10-x86_64.tar.gz",
    "puppet-agent-sles-11-i386.tar.gz",
    "puppet-agent-sles-11-s390x.tar.gz",
    "puppet-agent-sles-11-x86_64.tar.gz",
    "puppet-agent-sles-12-s390x.tar.gz",
    "puppet-agent-sles-12-x86_64.tar.gz",
    "puppet-agent-solaris-10-i386.tar.gz",
    "puppet-agent-solaris-10-sparc.tar.gz",
    "puppet-agent-solaris-11-i386.tar.gz",
    "puppet-agent-solaris-11-sparc.tar.gz",
    "puppet-agent-ubuntu-10.04-amd64.tar.gz",
    "puppet-agent-ubuntu-10.04-i386.tar.gz",
    "puppet-agent-ubuntu-12.04-amd64.tar.gz",
    "puppet-agent-ubuntu-12.04-i386.tar.gz",
    "puppet-agent-ubuntu-14.04-amd64.tar.gz",
    "puppet-agent-ubuntu-14.04-i386.tar.gz",
    "puppet-agent-ubuntu-16.04-amd64.tar.gz",
    "puppet-agent-ubuntu-16.04-i386.tar.gz",
  ]

  AGENT_REPO_FILES_WINDOWS_X64 = "puppet-agent-x64.msi"
  AGENT_REPO_FILES_WINDOWS_X86 = "puppet-agent-x86.msi"

  it "agent_installer_upload_path generates correct installer upload path" do
    AGENT_REPO_FILES_NORMAL.each { |installer|
      upload_path = PeInfo::System::agent_installer_upload_path(
        PE_VERSION,
        AGENT_VERSION,
        installer
      )
      upload_path_correct = PeInfo::System::agent_installer_upload_path_normal(
        AGENT_VERSION
      )

      # check correct branch chosen
      expect(upload_path).to eq upload_path_correct
    }
  end

  it "agent_installer_upload_path works for win x64" do
    upload_path = PeInfo::System::agent_installer_upload_path(
      PE_VERSION,
      AGENT_VERSION,
      AGENT_REPO_FILES_WINDOWS_X64
    )
    upload_path_correct = PeInfo::System::agent_installer_upload_path_windows_x64(
      PE_VERSION,
      AGENT_VERSION
    )

    # check correct branch chosen
    expect(upload_path).to eq upload_path_correct
  end

  it "agent_installer_upload_path works for win x86" do
    upload_path = PeInfo::System::agent_installer_upload_path(
      PE_VERSION,
      AGENT_VERSION,
      AGENT_REPO_FILES_WINDOWS_X86
    )
    upload_path_correct = PeInfo::System::agent_installer_upload_path_windows_x86(
      PE_VERSION,
      AGENT_VERSION
    )

    # check correct branch chosen
    expect(upload_path).to eq upload_path_correct
  end
end
