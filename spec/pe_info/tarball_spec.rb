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
require "pe_info/tarball"

describe PeInfo::Tarball do
  MOCK_PE_MODULES_DIR         = File.join(Dir.pwd, 'spec', 'fixtures', 'pe-modules')
  MOCK_TARBALL_DIR            = File.join(Dir.pwd, 'spec', 'fixtures', 'tarballs')
  PE_2016_4_2_TARBALL         = File.join(MOCK_TARBALL_DIR, 'puppet-enterprise-2016.4.2-el-7-x86_64.tar.gz')
  PE_2016_5_1_TARBALL         = File.join(MOCK_TARBALL_DIR, 'puppet-enterprise-2016.5.1-el-7-x86_64.tar.gz')
  PE_2017_2_4_TARBALL         = File.join(MOCK_TARBALL_DIR, 'puppet-enterprise-2017.2.4-el-7-x86_64.tar.gz')
  MISSING_AGENT               = File.join(MOCK_TARBALL_DIR, 'missing_agent.tar.gz')
  CHANGED_VERSION_CONVENTION  = File.join(MOCK_TARBALL_DIR, 'changed_version_convention.tar.gz')
  MISSING_FILE                = File.join(MOCK_TARBALL_DIR, 'missing_file.tar.gz')
  PATH_ORIG                   = ENV['PATH']

  after do
    ENV['PATH'] = PATH_ORIG
  end


  it "correctly identifies PE tarballs" do
    [
      "./spec/fixtures/tarballs/puppet-enterprise-2016.4.2-el-7-x86_64.tar.gz",
      "./spec/fixtures/tarballs/puppet-enterprise-2016.5.1-el-7-x86_64.tar.gz",
      "./spec/fixtures/tarballs/puppet-enterprise-2017.2.4-el-7-x86_64.tar.gz",
    ].each { |tarball|
      expect(PeInfo::Tarball.is_pe_tarball(tarball)).to be true
    }
  end

  it "rejects miss-named PE tarballs" do
    [
      "./spec/fixtures/tarballs/changed_version_convention.tar.gz",
      "./spec/fixtures/tarballs/missing_agent.tar.gz",
    ].each { |tarball|
      expect(PeInfo::Tarball.is_pe_tarball(tarball)).to be false
    }
  end

  it "identifies correct PE version" do
    expect(PeInfo::Tarball.pe_version("puppet-enterprise-2015.3.2-el-7-x86_64.tar.gz")).to eq "2015.3.2"
    expect(PeInfo::Tarball.pe_version("puppet-enterprise-2016.2.1-el-7-x86_64.tar.gz")).to eq "2016.2.1"
    expect(PeInfo::Tarball.pe_version("puppet-enterprise-2015.3.2-el-7-x86_64.tar.gz")).to eq "2015.3.2"
    expect(PeInfo::Tarball.pe_version("puppet-enterprise-2020.5.1-el-8-x86_64.tar.gz")).to eq "2020.5.1"
  end

  it "fails gracefully with unparseble version number" do
    expect(PeInfo::Tarball.pe_version("puppet-enterprise-2020unlimited-el8-x86_64.tar.gz")).to be false
    expect(PeInfo::Tarball.pe_version("puppet-enterprise-4000.5-el-7-x86_64.tar.gz")).to be false
  end

  it "parses correct agent version from tarball" do
    expect(PeInfo::Tarball.agent_version(PE_2016_4_2_TARBALL)).to eq '1.7.1'
    expect(PeInfo::Tarball.agent_version(PE_2016_5_1_TARBALL)).to eq '1.8.2'
  end

  it "fails gracefully when agent version missing from tarball" do
    expect(PeInfo::Tarball.agent_version(MISSING_AGENT)).to be false
    expect(PeInfo::Tarball.agent_version(CHANGED_VERSION_CONVENTION)).to be false
    expect(PeInfo::Tarball.agent_version(MISSING_FILE)).to be false
  end

  it "returns correct inspection data" do
    pe_version, agent_version = PeInfo::Tarball.inspect(PE_2016_4_2_TARBALL, false)
    expect(pe_version).to eq "2016.4.2"
    expect(agent_version).to eq "1.7.1"

    pe_version, agent_version = PeInfo::Tarball.inspect(PE_2016_5_1_TARBALL, false)
    expect(pe_version).to eq "2016.5.1"
    expect(agent_version).to eq "1.8.2"

    pe_version, agent_version = PeInfo::Tarball.inspect(PE_2017_2_4_TARBALL, false)
    expect(pe_version).to eq "2017.2.4"
    expect(agent_version).to eq "1.10.8"
  end

  it "inspect call fails gracefully when tarball is bad" do
    pe_version, agent_version = PeInfo::Tarball.inspect(MISSING_AGENT, false)
    expect(pe_version).to be false
    expect(agent_version).to be false

    pe_version, agent_version = PeInfo::Tarball.inspect(CHANGED_VERSION_CONVENTION, false)
    expect(pe_version).to be false
    expect(agent_version).to be false

    pe_version, agent_version = PeInfo::Tarball.inspect(MISSING_FILE, false)
    expect(pe_version).to be false
    expect(agent_version).to be false
  end

  it "raises exception when tar is not found" do
    ENV['PATH'] = '/'

    # dont forget curly braces for expect - has to be lambda or the exception
    # 'escapes'!
    expect{PeInfo::Tarball::tar}.to raise_error(/install tar/)
  end

  it "uses --wildcards on gnu tar" do
    ENV['PATH'] = File.join('spec','fixtures','fake_bin', 'gnu')
    expect(PeInfo::Tarball::tar).to match(/wildcards/)
  end

  it "does not use --wildcards on non-GNU tar" do
    ENV['PATH'] = File.join('spec','fixtures','fake_bin', 'nongnu')
    expect(PeInfo::Tarball::tar).not_to match(/wildcards /)
  end

  it "finds correct platform tags from extracted pe_repo puppet code" do
    verified_platforms = [
      "aix-5.3-power",
      "aix-6.1-power",
      "aix-7.1-power",
      "debian-7-amd64",
      "debian-7-i386",
      "debian-8-amd64",
      "debian-8-i386",
      "debian-9-amd64",
      "debian-9-i386",
      "el-5-i386",
      "el-5-x86_64",
      "el-6-i386",
      "el-6-s390x",
      "el-6-x86_64",
      "el-7-ppc64le",
      "el-7-s390x",
      "el-7-x86_64",
      "fedora-24-i386",
      "fedora-24-x86_64",
      "fedora-25-i386",
      "fedora-25-x86_64",
      "osx-10.10",
      "osx-10.11",
      "osx-10.12",
      "sles-11-i386",
      "sles-11-s390x",
      "sles-11-x86_64",
      "sles-12-s390x",
      "sles-12-x86_64",
      "solaris-10-i386",
      "solaris-10-sparc",
      "solaris-11-i386",
      "solaris-11-sparc",
      "ubuntu-14.04-amd64",
      "ubuntu-14.04-i386",
      "ubuntu-16.04-amd64",
      "ubuntu-16.04-i386",
      "ubuntu-16.04-ppc64el",
    ]

    detected_platforms = PeInfo::Tarball.supported_platforms_from_dir(MOCK_PE_MODULES_DIR)

    # check same count and list members
    expect(detected_platforms.size).to eq verified_platforms.size
    verified_platforms.each { |platform|
      expect(detected_platforms.include?(platform)).to be true
    }
  end
end
