killbill-docs
=============

Kill Bill documentation (user guides and tutorials).

To generate the documentation locally, run ```make.sh```. Generated html files are in the *build* directory (only selfcontained HTML files are generated today).

Pages are automatically built and pushed to http://killbill.github.io/killbill-docs by Travis.

Setup
-----

* Make sure to work off branch `v3`
* Install the gem dependencies: `gem install asciidoctor --version=1.5.2; gem install asciidoctor-diagram --version=1.3.2; gem install pygments.rb --version=0.6.3`
* Install Dot: `brew install graphviz`

Documentation on AsciiDoc can be found [here](http://asciidoctor.org/docs/). A quick reference is available [here](http://asciidoctor.org/docs/asciidoc-syntax-quick-reference/).
