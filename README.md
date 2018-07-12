killbill-docs
=============

Kill Bill documentation (user guides and tutorials).

To generate the documentation locally, run ```make.sh```. Generated html files are in the *build* directory (only selfcontained HTML files are generated today).

Pages are automatically built and pushed to http://killbill.github.io/killbill-docs by Travis.

Setup
-----

* Make sure to work off branch `v3`
* Install the gem dependencies: `gem install asciidoctor --version=1.5.7.1; gem install asciidoctor-diagram --version=1.3.2; gem install pygments.rb --version=0.6.3; gem install tilt --version=2.0.8; gem install haml --version=5.0.4; gem install thread_safe --version=0.3.6; gem install slim --version 2.1.0`
* Install Dot: `brew install graphviz`

Documentation on AsciiDoc can be found [here](http://asciidoctor.org/docs/). A quick reference is available [here](http://asciidoctor.org/docs/asciidoc-syntax-quick-reference/).
