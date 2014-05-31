
=====================

## jekyll-version-plugin

### Description

A [Jekyll](http://jekyllrb.com/) plugin that renders a version identifier to your project

Features:

Stand back, hold onto your hats... this plugin has 1x feature.

* Render a version of your project via `git`.

Requirements:

* Your project is stored in `git`.

## Usage

Wherever you want to display the version, just add the snippet below in your content and the version will be rendered when the Jekyll project is built.

```
{% project-version %}
```

This will simply output the version number, you can then apply your own styling as necessary. Or even just `html` comment it out if you don't want it visible.


## Technical wizardry

The plugin just calls;

```bash
$ git describe --tags
```


## Contributions

Please use the GitHub pull-request mechanism to submit contributions.

## License

This project is available for use under the MIT software license.
See LICENSE
