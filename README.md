## jekyll-version-plugin

[![Build Status](https://travis-ci.org/rob-murray/jekyll-version-plugin.svg)](https://travis-ci.org/rob-murray/jekyll-version-plugin)
[![Gem Version](https://badge.fury.io/rb/jekyll_version_plugin.svg)](http://badge.fury.io/rb/jekyll_version_plugin)

### Description

A Liquid tag plugin for [Jekyll](http://jekyllrb.com/) that renders a version identifier for your Jekyll site sourced from the `git` repository containing your code. Great if you want to display the version of your project on your site automatically each time your site is built.

Identify and highlight the build of your project by calling the tag from your Jekyll project.

##### This Jekyll view code will generate ...

Given a `git` repo with the latest tag of *3.0.0* and *5* commits since tagged, the commit `ga189420` being the latest.

```ruby
<p>Build: {% project_version %}</p>
```

##### This html

```html
<p>Build: 3.0.0-5-ga189420</p>
```


### Features

The **jekyll-version-plugin** has 1x feature with a few options;

* Render a version of your project via `git`.
  * Use the `git-describe` command with *long* or *short* option
  * Use the `git rev-parse` on **HEAD** with *long* or *short* option


### Requirements

* Your project is version controlled in `git`.


### Usage

As mentioned by [Jekyll's documentation](http://jekyllrb.com/docs/plugins/#installing-a-plugin) you have two options; manually import the source file or require the plugin as a `gem`.


#### Require gem

Add the `jekyll_version_plugin` to your site `_config.yml` file for Jekyll to import the plugin as a gem.

```ruby
gems: ['jekyll_version_plugin']
```


#### Manual import

Just download the source file into your `_plugins` directory, e.g.

```bash
# Create the _plugins dir if needed and download project_version_tag plugin
$ mkdir -p _plugins && cd _plugins
$ wget https://raw.githubusercontent.com/rob-murray/jekyll-version-plugin/master/lib/jekyll_version_plugin.rb
```


#### Plugin tag usage

The plugin can be called anywhere in your template with or without parameters;

```ruby
{% project_version *params %}
{% project_version type format %}
```

* **type** is what to use for versioning, either `tag` or `commit` - defaults to `tag`
* **format** is the format of the output, `short` or `long` - defaults to `short`

Wherever you want to display the version, just add one of the snippets below in your content and the version will be rendered when the Jekyll project is built.


```ruby
# Default options of `tag short`
{% project_version %} # => will run `git describe --tags --always`

# To render a short tag description like `3.0.0`
{% project_version tag short %} # => will run `git describe --tags --always`

# To render a more details tag description like `3.0.0-5-ga189420`
{% project_version tag long %} # => will run `git describe --tags --always --long`

# To render a short commitish like `151ebce`
{% project_version commit short %} # => will run `git rev-parse --short HEAD`

# To render a longer commitsh like `151ebce149c5886bcf2923db18d73742901eb976`
{% project_version commit long %} # => will run `git rev-parse HEAD`
```

This will simply output the version number, you can then apply your own styling as necessary. Or just `html` comment it out if you don't want it visible.


### Output

Happy path is a `git` repo with releases that are tagged, if this is the case then the output will be something like this;

`3.0.0` or `3.0.0-5-ga189420`

If you select the *commit* option then the output will be something like this;

`a189420`

If you have selected the *tags* option and the repository does not have any `tags` then it will grab the short sha of the last commit, see above;

If for any reason this fails then the output will just be a *sorry* message. Sorry about that.

`Sorry, could not read project version at the moment`


### Technical wizardry

The plugin just calls `git describe` or `git rev-parse HEAD` - For more information see [git-describe](http://git-scm.com/docs/git-describe) and [git rev-parse](https://git-scm.com/docs/git-rev-parse).

```bash
$ git describe --tags --long
$ git rev-parse --short HEAD
```


### Contributions

Please use the GitHub pull-request mechanism to submit contributions.


### License

This project is available for use under the MIT software license.
See LICENSE
