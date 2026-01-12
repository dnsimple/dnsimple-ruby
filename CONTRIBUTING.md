# Contributing to DNSimple/Ruby

## Getting started

### 1. Clone the repository

Clone the repository and move into it:

```shell
git clone git@github.com:dnsimple/dnsimple-ruby.git
cd dnsimple-ruby
```

### 2. Install the dependencies

Install the dependencies using [Bundler](http://bundler.io/):

```shell
bundle
```

### 3. Build and test

[Run the test suite](#testing) to check everything works as expected.

## Changelog

We follow the [Common Changelog](https://common-changelog.org/) format for changelog entries.

## Testing

To run the test suite:

```shell
rake
```

## Tests

Submit unit tests for your changes. You can test your changes on your machine by [running the test suite](#testing).

When you submit a PR, tests will also be run on the [continuous integration environment via GitHub Actions](https://github.com/dnsimple/dnsimple-ruby/actions).
