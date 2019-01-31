+++
title = "Testing for pending migrations in Django"
date = 2016-01-03T18:09:00Z
updated = 2017-01-29T17:15:22Z
blogimport = true 
[author]
	name = "Damien Lespiau"
	uri = "https://plus.google.com/114288295280403017038"
+++

<div dir="ltr" style="text-align: left;" trbidi="on"><div dir="ltr" style="text-align: left;" trbidi="on">DB migration support has been added in Django 1.7+, superseding <a href="http://django-south.readthedocs.io/en/latest/">South</a>. More specifically, it's possible to automatically generate migrations steps when one or more changes in the application models are detected. Definitely a nice feature!<br /><br />I've written a small generic unit-test that one should be able to drop into the tests directory of any Django project and that checks there's no pending migrations, ie. if the models are correctly in sync with the migrations declared in the application. Handy to check nobody has forgotten to <code class="command">git add</code> the migration file or that an innocent looking change in <code class="filename">models.py</code> doesn't need a migration step generated. Enjoy!<br /><br /><a href="https://djangosnippets.org/snippets/10567/">See the code on djangosnippets</a>&nbsp;or as a <a href="https://gist.github.com/dlespiau/a3fb10421d68be2a59daebf15f8b781e">github gist</a>!</div><script src="https://gist.github.com/dlespiau/a3fb10421d68be2a59daebf15f8b781e.js"></script><br /></div>
