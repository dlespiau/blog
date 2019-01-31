+++
title = "Per project .vimrc"
date = 2009-03-18T22:52:00Z
updated = 2016-02-07T14:05:35Z
tags = ["misc"]
blogimport = true 
[author]
	name = "Damien Lespiau"
	uri = "https://plus.google.com/114288295280403017038"
+++

<div dir="ltr" style="text-align: left;" trbidi="on">My natural C indentation style is basically kernel-like and my <code class="filename">~/.vimrc</code> reflects that. Unfortunately I have to hack on GNUish-style projects and I really don't want to edit my <code class="filename">~/.vimrc</code> every single time I switch between different indentation styles.<br /><br />Modelines are evil.<br /><br />To solve that terrible issue, <code class="command">vim</code> can use per directory configuration files. To enable that neat feature only two little lines are needed in your <code class="filename">~/.vimrc</code>:<br /><pre class="brush: text; gutter: true">set exrc   " enable per-directory .vimrc files<br />set secure   " disable unsafe commands in local .vimrc files</pre>Then it's just a matter of writing a per project <code class="filename">.vimrc</code> like this one:<br /><pre class="brush: text; gutter: true">set tabstop=8<br />set softtabstop=2<br />set shiftwidth=2<br />set expandtab<br />set cinoptions=&gt;4,n-2,{2,^-2,:0,=2,g0,h2,t0,+2,(0,u0,w1,m1</pre>You can find help with the wonderful <code>cinoptions</code> variable in the <a href="http://vimdoc.sourceforge.net/htmldoc/indent.html#cinoptions-values" title="cinoptions documentation">Vim documentation</a>. As sane persons open files from the project's root directory, this works like a charm. As for the Makefiles, they are special anyway, you really should add an autocmd in your <code class="filename">~/.vimrc</code>.<br /><pre class="brush: text; gutter: true">" add list lcs=tab:&gt;-,trail:x for tab/trailing space visuals<br />autocmd BufEnter ?akefile* set noet ts=8 sw=8 nocindent</pre></div>
