+++
title = "g_object_notify_by_pspec()"
date = 2010-01-28T14:30:00Z
updated = 2015-03-07T21:16:22Z
tags = ["GNOME"]
blogimport = true 
[author]
	name = "Damien Lespiau"
	uri = "https://plus.google.com/114288295280403017038"
+++

Now that  GLib 2.26.0 is out, it's time to talk about a little patch to GObject I've written (well, the original idea was born while looking at it with <a href="http://www.busydoingnothing.co.uk/blog/">Neil</a>): add a new <a href="http://library.gnome.org/devel/gobject/stable/gobject-The-Base-Object-Type.html#g-object-notify-by-pspec"><code>g_object_notify_by_pspec()</code></a> symbol to GObject. As shown <a href="https://bugzilla.gnome.org/show_bug.cgi?id=615425">in the bug </a>it can improve the notification of GObject properties by 10-15% (the test case tested was without any handler connected to the notify signal).<br/><br/>If you can depend on GLib 2.26, consider using it!
