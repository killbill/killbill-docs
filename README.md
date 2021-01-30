killbill-docs
=============

Kill Bill documentation (user guides and tutorials).

To generate the documentation locally, run ```make.sh```. Generated html files are in the *build* directory (only selfcontained HTML files are generated today).

Pages are automatically built and pushed to https://docs.killbill.io/ by GitHub Actions.

Setup
-----

* Make sure to work off branch `v3`
* Install Ruby (use [RVM](https://rvm.io/) or [RubyInstaller](https://rubyinstaller.org/))
* Run `bundle install`
* [Optional] Install Dot (`brew install graphviz` on MacOS)
* Verify documentation can be built by running the `make.sh` script

Documentation on AsciiDoc can be found [here](http://asciidoctor.org/docs/). A quick reference is available [here](http://asciidoctor.org/docs/asciidoc-syntax-quick-reference/).
