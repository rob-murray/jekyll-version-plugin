## jekyll-version-plugin

### Description

A Liquid tag plugin for [Jekyll](http://jekyllrb.com/) that renders a version identifier for your Jekyll site, sourced from the `git` repository containing your code. Great if you want to display the version of your project on your site dynamically each time your site is built.

Identify and highlight the build of your project.

```html
<p class="small">Build: 3.0.0-5-ga189420</p>
```

### Features

Stand back, hold onto your hats... the **jekyll-version-plugin** has 1x feature.

* Render a version of your project via `git`.

### Requirements

* Your project is version controlled in `git`.

### Usage

Wherever you want to display the version, just add the snippet below in your content and the version will be rendered when the Jekyll project is built.

```
{% project_version %}
```

This will simply output the version number, you can then apply your own styling as necessary. Or just `html` comment it out if you don't want it visible.

Just follow Jekyll's instructions for getting a plugin into a project;

```bash
# Create the _plugins dir if needed and download project_version_tag plugin
$ mkdir _plugins && cd _plugins
$ wget https://raw.githubusercontent.com/rob-murray/jekyll-version-plugin/master/lib/project_version_tag.rb
```

### Output

Happy path is a `git` repo with releases that are tagged, if this is the case then the output will be something like this;

`3.0.0-5-ga189420`

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
