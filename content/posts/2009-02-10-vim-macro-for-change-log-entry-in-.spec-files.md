+++
title = "Vim macro for change log entry in .spec files"
date = 2009-02-10T12:38:00Z
updated = 2015-03-07T21:16:22Z
tags = ["misc"]
blogimport = true 
[author]
	name = "Damien Lespiau"
	uri = "https://plus.google.com/114288295280403017038"
+++

Tired of writing this kind of lines by hand ?<br/><br/><code>* Mon Feb 09 2009 Damien Lespiau &lt;damien.lespiau@xxxx.com&gt; 1.4.3</code><br/><br/>This vim macro does just this for you!<br/><br/><code>nmap ,mob-ts :r!date +'\%a \%b \%d \%Y'&lt;CR&gt;0i* &lt;ESC&gt;$a Damien Lespiau &lt;damien.lespiau@xxxx.com&gt; FIXME</code>
