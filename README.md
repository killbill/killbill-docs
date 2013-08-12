killbill-docs
=============

Kill Bill documentation.

To generate the documentation locally, run ```make.sh``` (generated html files are in the *build* directory, you can open them with your browser).

To update the GitHub site, run ```release.sh``` (the script will take care of switching branches).

To update the JavaDocs, run ```update_javadocs.sh``` (the script will take care of switching branches).

Setup
-----

The scripts assume:

* the branch gh-pages has been checked-out locally at least once: ```git checkout -b gh-pages origin/gh-pages```
* the asciidoctor gem is installed: ```gem install asciidoctor```

Documentation on AsciiDoc can be found here: http://asciidoctor.org/docs/. A quick reference is available here: http://asciidoctor.org/docs/asciidoc-syntax-quick-reference/.
