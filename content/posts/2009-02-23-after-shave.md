+++
title = "After-shave"
date = 2009-02-23T01:09:00Z
updated = 2016-02-07T14:06:35Z
tags = ["cool hacks"]
blogimport = true 
[author]
	name = "Damien Lespiau"
	uri = "https://plus.google.com/114288295280403017038"
+++

A few concerns have been raised by shave, namely not being able to debug build failure in an automated environment as easily as before, or users giving  useless bug reports of failed builds.<br /><br />One capital thing to realize is that, even when compiling with make V=1, everything that was not echoed was not showed (MAKEFLAGS=-s).<br /><br />Thus, I've made a few changes:<br /><ul><li>Add CXX support (yes, that's unrelated, but the question was raised, thanks to Tommi Komulainen for the initial patch),</li><li>add a --enable-shave option to the configure script,</li><li>make the Good Old Behaviour the default one,</li><li>as a side effect, the V and Q variables are now defined in the m4 macro, please remove them from your Makefile.am files.</li></ul><br />The rationale for the last point can be summarized as follow:<br /><ul><li>the default behaviour is as portable as before (for non GNU make that is), which is not the case is shave is activated by default,</li><li>you can still add --enable-shave to you autogen.sh script, bootstraping your project from a SCM will enable shave and that's cool!</li><li>don't break tools that were relying on automake's output.</li></ul><br />Grab the <a title="shave git repository" href="http://git.lespiau.name/cgit/shave/">latest version</a>! (git://git.lespiau.name/shave)
