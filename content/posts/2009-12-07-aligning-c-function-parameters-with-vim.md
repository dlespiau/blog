+++
title = "Aligning C function parameters with vim"
date = 2009-12-07T12:56:00Z
updated = 2015-03-07T21:16:22Z
tags = ["GNOME"]
blogimport = true 
[author]
	name = "Damien Lespiau"
	uri = "https://plus.google.com/114288295280403017038"
+++

<span style="color: #ff0000;">updated:</span> now saves/retores the paste register<br/><br/>It has bothered me for a while, some coding styles, most notably in the GNOME world try to enforce good looking alignment of functions parameters such as:<br/><pre class="brush: c; gutter: true">static UniqueResponse<br/>on_unique_message_received (UniqueApp         *unique_app,<br/>                            gint               command,<br/>                            UniqueMessageData *message_data,<br/>                            guint              time_,<br/>                            gpointer           user_data)<br/>{<br/>}</pre><br/>Until now, I aligned the arguments by hand, but that time is over! Please welcome my first substantial vim plugin: it defines a <code class="command">GNOMEAlignArguments</code> command to help you in that task. All you have to do is to <a title="GNOME-align-args.vim" href="http://git.lespiau.name/cgit/sk/plain/dotfiles/vim/plugin/GNOME-align-args.vim">add this file</a> in your <code class="filename">~/.vim/plugin</code> directory and define a macro in your <code class="filename">~/.vimrc</code> to invoke it just like this:<br/><pre class="brush: text; gutter: true">&quot; Align arguments<br/>nmap ,a :GNOMEAlignArguments&lt;CR&gt;</pre><br/>HTH.
