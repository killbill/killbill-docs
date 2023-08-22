# Docs

Kill Bill documentation (user guides and tutorials).

The site is built using [Asciidoctor](http://asciidoctor.org/docs/).

## Edit and Syntax

The documentation is in the `userguide` directory.

AsciiDoc syntax: https://docs.asciidoctor.org/asciidoc/latest/syntax-quick-reference/

## Development

To generate the documentation locally:

```
make.sh
```

Generated html files are in the `build` directory.

To run the site locally:

```
ruby server.rb
```

Prerequisites:

* Install Ruby (use [RVM](https://rvm.io/) or [RubyInstaller](https://rubyinstaller.org/))
* Run `bundle install`

## Deployment

To deploy the docs:

```
make.sh
update_gh-pages.sh
```

Notes:

* The generated static pages under `build/selfcontained` are pushed to the `gh-pages` branch (not served by GitHub pages)
* The `gh-pages` branch is then deployed by Cloudflare (https://docs.killbill.io/)
* Minification of assets is handled by Cloudflare (check-in the unminified version)
