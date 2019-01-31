+++
title = "Extracting part of files with sed"
date = 2012-01-10T14:34:00Z
updated = 2016-02-06T23:55:22Z
tags = ["Unix"]
blogimport = true 
[author]
	name = "Damien Lespiau"
	uri = "https://plus.google.com/114288295280403017038"
+++

For reference for my future self, a few handy sed commands. Let's consider this file:<pre class="brush: text; gutter: true">$ cat test-sed<br />First line<br />Second line<br />--<br />Another line<br />Last line</pre>We can extract the lines from the start of the file to the marker by deleting the rest:<pre class="brush: text; gutter: true">$ sed &#039;/--/,$d&#039; test-sed <br />First line<br />Second line</pre><code>a,b</code> is the range the command, here <code>d(elete)</code>, applies to. <code>a</code> and <code>b</code> can be, among others, line numbers, regular expressions or <code>$</code> for end of the file. We can also extract the lines from the marker to the end of the file with:<pre class="brush: text; gutter: true">$ sed -n &#039;/--/,$p&#039; test-sed <br />--<br />Another line<br />Last line</pre>This one is slightly more complicated. By default sed spits all the lines it receives as input, <code>'-n'</code> is there to tell sed not to do that. The rest of the expression is to <code>p(rint)</code> the lines between <code>--</code> and the end of the file.<br />That's all folks!
