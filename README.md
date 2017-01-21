[![Build Status](https://travis-ci.org/GeoffWilliams/pe_info.svg?branch=master)](https://travis-ci.org/GeoffWilliams/pe_info)
# PeInfo

This is a simple library for figuring out things we need to know about Puppet
Enterprise, such as where to upload agent installers and what the agent version
number is.

This is done by either munging supplied version arguments or in the case of
agent versions, looking inside of an installation media tarball.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pe_info'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pe_info

## Usage

### Uploading agent installers

Lets say you have an agent installer tarball you previously downloaded:
```
...
38M /Users/geoff/agent_installers/2016.5.1/puppet-agent-sles-10-x86_64.tar.gz
25M /Users/geoff/agent_installers/2016.5.1/puppet-agent-sles-11-i386.tar.gz
33M /Users/geoff/agent_installers/2016.5.1/puppet-agent-sles-11-s390x.tar.gz
...
```

And you would like to know where it should be uploaded on a server you just
installed with PE 2016.5.1 from `/Users/geoff/Downloads/puppet-enterprise-2016.5.1-el-7-x86_64.tar.gz`:

```ruby
require 'pe_info'
tarball = '/Users/geoff/Downloads/puppet-enterprise-2016.5.1-el-7-x86_64.tar.gz'
pe_version, agent_version = PeInfo::Tarball::inspect(tarball)
if pe_version and agent_version
  upload_path = PeInfo::System::agent_installer_upload_path(
    pe_version,
    agent_version,
    repo_file
  )

  if upload_path
    # do something with upload_path
  else
    # unparsable agent_version
  end
else
  # install tarball missing or invalid
end
```

Now you know that the agent installers tarball belongs at `upload_path`.  If you upload the file to this location on a PE master, it will remove the need to head out to the internet and download the file manually.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/GeoffWilliams/pe_info.

### Creating mock PE tarballs
To create a PE tarball identical to a release but with every file truncated to zero bytes:

```shell
mkdir tmp
cd tmp
tar zxvf PE_UPSTREAM_TARBALL
cd puppet-enterprise-*
find . -type f -exec truncate -s 0 {} \;
cd ..
tar zcvf MOCK_PE_UPSTREAM_TARBALL puppet-enterprise-*
```

Once created, the tarball can be moved to spec/fixtures/tarballs and the tmp directory can be removed

## Support
* This is experimental software, use at own risk!
* This software is not supported by Puppet, Inc.
