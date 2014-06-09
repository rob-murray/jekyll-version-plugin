## jekyll-version-plugin

[![Build Status](https://travis-ci.org/rob-murray/jekyll-version-plugin.svg)](https://travis-ci.org/rob-murray/jekyll-version-plugin)
[![Gem Version](https://badge.fury.io/rb/jekyll_version_plugin.svg)](http://badge.fury.io/rb/jekyll_version_plugin)

### Description

A Liquid tag plugin for [Jekyll](http://jekyllrb.com/) that renders a version identifier for your Jekyll site sourced from the `git` repository containing your code. Great if you want to display the version of your project on your site dynamically each time your site is built.

Identify and highlight the build of your project by calling the tag from your Jekyll project.

```html
<p>Build: 3.0.0-5-ga189420</p>
```

```ruby
<p>Build: {% project_version %}</p>
```

### Features

Stand back, hold onto your hats... the **jekyll-version-plugin** has 1x feature.

* Render a version of your project via `git`.

### Requirements

* Your project is version controlled in `git`.

### Usage

As mentioned by [Jekyll's documentation](http://jekyllrb.com/docs/plugins/#installing-a-plugin) you have two options; manually import the source file or require the plugin as a `gem`.

#### Require gem

Add the `jekyll_version_plugin` to your site `_config.yml` file for Jekyll to import the plugin as a gem.

```ruby
gems: [jekyll_version_plugin]
```

#### Manual import

Just download the source file into your `_plugins` directory, e.g.

```bash
# Create the _plugins dir if needed and download project_version_tag plugin
$ mkdir -p _plugins && cd _plugins
$ wget https://raw.githubusercontent.com/rob-murray/jekyll-version-plugin/master/lib/project_version_tag.rb
```

#### Plugin tag usage

Wherever you want to display the version, just add the snippet below in your content and the version will be rendered when the Jekyll project is built.

```ruby
{% project_version %}
```

This will simply output the version number, you can then apply your own styling as necessary. Or just `html` comment it out if you don't want it visible.

### Output

Happy path is a `git` repo with releases that are tagged, if this is the case then the output will be something like this;

`3.0.0` or `3.0.0-5-ga189420`

If the repository does not have any `tags` then it will grab the short sha of the last commit, for example;

`a189420`

If for any reason this fails then the output will just be a *sorry* message. Sorry about that.

`Sorry, could not read project version at the moment`


### Technical wizardry

The plugin just calls `git describe` - For more information see [git documentation](http://git-scm.com/docs/git-describe).

```bash
$ git describe --tags --long
```

### Contributions

Please use the GitHub pull-request mechanism to submit contributions.

### License

This project is available for use under the MIT software license.
See LICENSE
