+++
title = "Blending two RGBA 5551 layers"
date = 2009-01-06T18:59:00Z
updated = 2016-02-07T14:04:51Z
tags = ["cool hacks"]
blogimport = true 
[author]
	name = "Damien Lespiau"
	uri = "https://plus.google.com/114288295280403017038"
+++

<div dir="ltr" style="text-align: left;" trbidi="on">I've just stumbled accross a small piece of code, written one year and a half ago, that blends two 512x512 RGBA 5551 images. It was originally written for a (good!) GIS, so the piece of code blends roads with rivers (and displays the result in a GdkPixbuf). The only thing interesting is that it uses some MMX, SSE2 and <code>rdtsc</code> instructions. You can have a look at the code in <a href="http://git.lespiau.name/cgit/blend-5551-sse2/tree/main.c">its git repository</a>.<br /><div class="separator" style="clear: both; text-align: center;"><a href="https://4.bp.blogspot.com/-zoARUkF4-Iw/VrdO7QiZFjI/AAAAAAAAAbI/BJErKuv7x08/s1600/screenshot-layer-fusion.png" imageanchor="1" style="margin-left: 1em; margin-right: 1em;"><img border="0" height="320" src="https://4.bp.blogspot.com/-zoARUkF4-Iw/VrdO7QiZFjI/AAAAAAAAAbI/BJErKuv7x08/s320/screenshot-layer-fusion.png" width="307" /></a></div><br /></div>
