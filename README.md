# PeInfo

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/pe_info`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

TODO: Write usage instructions here

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
