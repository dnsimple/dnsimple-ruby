# Releasing

This document describes the steps to release a new version of DNSimple/Ruby.

## Prerequisites

- You have commit access to the repository
- You have push access to the repository
- You have a GPG key configured for signing tags
- You have permission to publish to RubyGems

## Release process

1. **Determine the new version** using [Semantic Versioning](https://semver.org/)

   ```shell
   VERSION=X.Y.Z
   ```

   - **MAJOR** version for incompatible API changes
   - **MINOR** version for backwards-compatible functionality additions
   - **PATCH** version for backwards-compatible bug fixes

2. **Update the version file** with the new version

   Edit `version.rb` and update the `VERSION` constant:

   ```ruby
   VERSION = "$VERSION"
   ```

3. **Run tests** and confirm they pass

   ```shell
   rake
   ```

4. **Update the changelog** with the new version

   Finalize the `## main` section in `CHANGELOG.md` assigning the version.

5. **Commit the new version**

   ```shell
   git commit -a -m "Release $VERSION"
   ```

6. **Push the changes**

   ```shell
   git push origin main
   ```

7. **Wait for CI to complete**

8. **Create a signed tag**

   ```shell
   git tag -a v$VERSION -s -m "Release $VERSION"
   git push origin --tags
   ```

## Post-release

- Verify the new version appears on [RubyGems](https://rubygems.org/gems/dnsimple)
- Verify the GitHub release was created
- Announce the release if necessary
