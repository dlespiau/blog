+++
title = "A git pre-commit hook to check the year of copyright notices"
date = 2013-01-13T21:39:00Z
updated = 2016-02-06T18:35:31Z
blogimport = true 
[author]
	name = "Damien Lespiau"
	uri = "https://plus.google.com/114288295280403017038"
+++

Like every year, touching a source file means you also need to update the year of the copyright notice you should have at the top of the file. I always end up forgetting about them, this is where a git pre-commit hook would be ultra-useful, so I wrote one:<pre class="brush: bash; gutter: true; first-line: 1; highlight: []; html-script: false">#<br /># Check if copyright statements include the current year<br />#<br />files=`git diff --cached --name-only`<br />year=`date +&quot;%Y&quot;`<br /><br />for f in $files; do<br />    head -10 $f | grep -i copyright 2&gt;&amp;1 1&gt;/dev/null || continue<br /><br />    if ! grep -i -e &quot;copyright.*$year&quot; $f 2&gt;&amp;1 1&gt;/dev/null; then<br />        missing_copyright_files=&quot;$missing_copyright_files $f&quot;<br />    fi<br />done<br /><br />if [ -n &quot;$missing_copyright_files&quot; ]; then<br />    echo &quot;$year is missing in the copyright notice of the following files:&quot;<br />    for f in $missing_copyright_files; do<br />        echo &quot;    $f&quot;<br />    done <br />    exit 1<br />fi</pre>Hope this helps!
