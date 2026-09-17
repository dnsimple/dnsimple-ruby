# Contributing to DNSimple/Ruby

## Getting started

Clone the repository and move into it:

```shell
git clone git@github.com:dnsimple/dnsimple-ruby.git
cd dnsimple-ruby
```

Install the dependencies using [Bundler](http://bundler.io/):

```shell
bundle
```

Run the test suite to check everything works as expected.

## Testing

To run the test suite:

```shell
rake
```

Submit unit tests for your changes. You can test your changes on your machine by running the test suite.

When you submit a PR, tests will also be run on the [continuous integration environment via GitHub Actions](https://github.com/dnsimple/dnsimple-ruby/actions).

## Changelog

We follow the [Common Changelog](https://common-changelog.org/) format for changelog entries.

Add new entries to the `## Unreleased` section at the top of `CHANGELOG.md`. When a change requires a major version, append `(requires major version)` to its entry, for example `- Drop support for Ruby < X.Y (requires major version)`. The release process uses this tag to select the next version.
