---
layout: post
title: "Most url dispatchers are redundant."
tags: [web, architecture]
---

Last week as I was reviewing a small snippet of code adding yet
another url pattern to application route table, I got struck by
this thought:

> wait a second, this url routing - it should not be part of
> application, but rather - of webserver. Application is responsible
> for _taking_ input and producing output, and url parsing and
> processing is not part of that process. Meanwhile, webservers are
> super efficient at taking a request and passing it to a correct
> handler functions, via gateways.

Immediately, I noted it to myself and over following days I began to
tinker this idea in my mind. Why did it suddenly pop in my head? Does
it make sense at all to do that? If it does - why it is not done and
how it should be done?  What would be some immediate problems if
suddenly I decided to switch all my application routing to webservers?

As to why it caught my attention, the answer is pretty easy: at my
startup I happen to be two-in-one person. As a software engineer I
work on the APIs our servers provide for mobile application; as a site
reliability engineer I make sure that our infrastructure is in perfect
shape to run the server code - part of which is configuring web
servers. So, as I am sharing my time between the two parts of the
whole picture, I suppose, the inception of this idea was a natural
thought process.

# Pros

Does it make sense? The more time I spend thinking about it, the more
I am convinced that it actually does. Hear me out:

**1. Web servers are more efficient at routing urls.**

Probably all modern day web frameworks or libraries implement a url
routing component. This component usually works by applying request
url to a list of patterns to find first most specific match. Some of
them do not even try to optimize this
process[\[1\]](#url-dispatch-footnotes), some of them -
do[\[2, 3\]](#url-dispatch-footnotes). But they are all bound by the
performance of the language they are implemented in and the overhead
of request processing and initialization.

I may as well be an ignorant fool, but I think in this exact case a
compiled language solution would always win and so it happens that
modern production grade web servers are written in compiled
languages. Also they have more options for URL patterns, e.g. they can
be static, prefix based or regular expressions. This leads to my next
point...


**2. Web servers have better low-level[\[4\]](#url-dispatch-footnotes) http control options.**

After the routing is done, web frameworks require application to parse
request, either directly or with support from helpers, to give some
control over which HTTP methods are supported. Also, some of the
frameworks force you into doing response caching at application level.

Again, this could be done by webservers - they are good at low-level
http control as well as working as a proxy cache. It would free the
application of a lot of redundant code.


**3. Web servers are good at rudimentary url processing.**

Imagine, a webserver matches correct url pattern, extracts the
parameters and forwards them to the application
handler. Well... here's a snippet from Nginx
configuration[\[5\]](#url-dispatch-footnotes):

{% highlight nginx %}
    location ~ ^/api/1/resource/(?P<resource_id>\d+)/?$ {
        uwsgi_pass      app_server;
        include         /etc/nginx/uwsgi_params;
        uwsgi_param     SCRIPT_NAME /resource;
        uwsgi_param     PARAM_RESOURCE_ID $resource_id;
        uwsgi_modifier1 30;
    }
{% endhighlight %}

And a handler:

{% highlight python %}
    import uwsgi

    def resource(request, response):
        response('200 OK', [('Content-Type', 'text/plain')])
        yield "Resource Id: {resource_id}".format(
            resource_id=request['PARAM_RESOURCE_ID']
        )

    uwsgi.applications = {
        '/resource': resource,
    }
{% endhighlight %}


Notice how `resource_id` is captured[7] and passed along to uWsgi handler (upstream).

Now the framework/application is doing what it actually is supposed to
be doing: given input - generate output.


**4. Url patterns are inherently static.**

Emphasis on the word **patterns**.

Any time a new website view (function) or resource (for API) is
created - url pattern to access it is born, and it shouldn't[\[6\]](#url-dispatch-footnotes)
change. In essence, meaning it is a static content. Gentlemans rule of
thumb in web development is that serving static content (js, css,
images) should never reach the execution path of your application and
so - most of the static files on the internet are served directly by
web servers[\[7\]](#url-dispatch-footnotes).

Wouldn't it make more sense to _somehow_ deploy the mapping of
patterns-handlers to webserver, rather than process them on every
request?


**5. Url routing becomes reduced to to a well defined interface.**

I think this is the most impactful thing that comes out of the
previous 4 points.

The single black-box component, that ties together all different
pieces of many web frameworks together, is gone. A component, which
more often than not forces the developer to a specific mindset or code
architecture, is gone and suddenly - nothing stands in between a
request and application code.

Please, give yourself a minute for this idea to sink in - a web
framework is reduced to a well defined, standardized and transparent
interface[\[8\]](#url-dispatch-footnotes) that is plugged into a
webserver. To me this sounds like liberating.


## Cons

Thinking further, I tried to come up with countering ideas - what
immediate problems this practice would cause. _Disclaimer: I am very
high about this idea right now, so most likely I am doing very bad job
at countering it. More ideas are welcome._


First, url patterns are used two ways - to resolve request into a
handler, and also a reverse - given parameters generate url. Wouldn't
this immediately force into duplication - in application and in web
server? A dubious answer is - it depends. Obviously, if application
needs them and web server needs them and you type them in both by
hand - it is of course a duplication.

But then again, if one place is promoted as authority - let's say
application level - a tool that generates web server url pattern
configuration file, that can be deployed together with code, would
reduce the effect of duplication by automating it.


Second - testing. Some of the frameworks provide a testing facility,
that allows to mimick url requests in unit tests or integration
tests. At first thought - this would require to implement a url
dispatcher nonetheless, just to make it work, but...

On second thought, does that testing facility actually test the url?
No way - there's a webserver in production which can drastically
change the behaviour of any url, as often is the case. What that
facility is doing - is just testing web frameworks url routing
component. Does this test belong to unit or integration tests?
No. More like acceptance or smoke tests.

So with urls in webserver, fake testing client becomes redundant and
can (must!) be exchanged with a real http requests library. Further,
acceptance tests are in their correct place and test the actual thing,
rather than faking it.

Third - what's the point? Well, with this I can not argue, but I can
express my position, which is: I am a huge fan of clean and simple
interfaces. I am a huge fan of being able to control the structure of
the code as it fits the application and not a framework or a
library.

Some might say, that there's no point even thinking about it, because
url resolving takes very little time wherever it happens. True!
But... I am a huge fan of less code - if this allows me to shave a
huge chunk (all) of code standing between my code and the web server -
for the better!

Also, I am curious how one would benchmark url router under heavy
load? I think benchmarks are hard and I haven't done anything more
except for a simple proof of concept that such setup could work, but
my gut tells me that under stress - performance of non-webserver url
dispatcher would diverge to the worse. (_This is my speculation._)


## History

As to why would it seem so ubiquitous for everyone to use a
framework/library embedded url dispatcher I came up with two
hypotheses:

**1. It is historical legacy.**

Long time ago web servers were configured to use one directory with
multiple `.html` files as an entry point to a website. In fact, people
were lazy to always enter `index.html` at the end of url, so there
were options like `DirectoryIndex`, which would tell web server which
file to load if none was specified. Then dynamic and template
languages emerged and suddenly websites became a bunch of `.py`,
`.php`, `.cgi` script files with HTML embedded between bits of logic,
representing a page of a website.

**2. Convenience.**

Before long someone noticed that with the help of dynamic languages it
is much easier to process all requests in one `index.php` file, rather
than repeat a lot of bootstrapping code throughout the files. Also,
web server management ten years ago was really cumbersome process,
that was mostly frowned upon and thought in terms of "yuck, let's
finish this quickly and move back to the real deal."


Fast forward to this day and adding a new url to application level code
seems normal, because hey - all the frameworks and libraries do that.


## Possibilities

_From here on I have Python & WSGI (or alternatives) in mind._


**1. Easy streaming with generators**

Consider this - WSGI standard (PEP333[\[9\]](#url-dispatch-footnotes))
incepted late 2003. Django started in 2005. Django "added" support for
`StreamingHTTPResponse` only since 1.5 (released February 26th,
2013[\[10\]](#url-dispatch-footnotes)). You had it for 10 years, but
didn't knew or hacked around it.

And it's not that I want to beat Django - I use it at work - but this
sort of mismatch between what you can do and what your framework
allows you to do is the biggest desease that any framework forces into
mindset of its users.

But yeah, maybe this is not an everyday usable feature.


**2. Horizontally reusable plugins.**

How many middlewares from framework/library X you can reuse in
framework Y? I thought so. You're locked in. With cleanly defined
interfaces and no code, however, you can have authentication
middleware that you can reuse anywhere. How it'd look? A plain
decorator.


## Summary


_Write summary_.





<a name="url-dispatch-footnotes"></a>
**Footnotes:**

[1]: Django url resolver.

[2]: I believe [Pyramid](https://github.com/Pylons/pyramid/blob/master/pyramid/traversal.py) traverse does that.

[3]: [JAX-RS Specification](https://jcp.org/aboutJava/communityprocess/final/jsr339/index.html).

[4]: By low-level I mean which HTTP
methods are supported and not Authorization or Authentication.

[5]: [Regular expressions names in Nginx](http://nginx.org/en/docs/http/server_names.html#regex_names)

[6]: [Cool URIs don't change](http://www.w3.org/Provider/Style/URI.html)

[7]: Unless the static content is compiled by application code, but
even then it is cached on webserver for performance reasons.

[8]: Be it WSGI or [Pump](http://adeel.github.io/pump/).

[9]: [PEP-0333](http://www.python.org/dev/peps/pep-0333/), revised [PEP-3333](http://www.python.org/dev/peps/pep-3333/)

[10]: [Django page on Wikipedia](http://en.wikipedia.org/wiki/Django_(web_framework\)#Versions)
