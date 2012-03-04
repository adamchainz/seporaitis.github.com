---
layout: post
title: "There is a problem with web frameworks"
tags: [web]
---
{% include JB/setup %}

This is an essay about a new way to build websites, a way
completely different from what currently web frameworks (at least PHP) offer.
I will dare to say that they all are flawed and then
present you one way that to fix the problem, and will boast a little,
that this way was presented at one of W3C workshops for guys from W3C,
IBM, Nokia, Oracle and others. The way is also available for you to try out,
as an open source project. Although this post is long, I hope you
won't be frightened by that and will enjoy reading it as much as I enjoyed
writing it!

<!--more-->

However...

_TL;DR. Frameworks are bad because of
[object-relational impedance mismatch](http://en.wikipedia.org/wiki/Object-relational_impedance_mismatch)
and
[leaky abstractions](http://en.wikipedia.org/wiki/Leaky_abstraction). We
made [Graphity](http://github.com/graphity/graphity-core) - an
open-source project. Read our position paper for W3C workshop
[here](http://graphity.github.com/position_paper.pdf)._

First things first. In the summer of 2011 I was working, among couple
of other things, on a website called
[Wulffmorgenthaler](http://wulffmorgenthaler.com). There is a
different story behind the english version (just in case you have
questions), but today I will concentrate on a Danish website and its
successor - [HeltNormalt](http://heltnormalt.dk). So, around the
middle 2011, the owner of the website decided to
do rebranding - new website with a LOT of new kinds of content.
Its old codebase was terrible piece of craftsmanship, part of which,
sadly, involves me too, but the rebranding meant a green light to a fresh
start on the codebase. Oh boy, was I happy about it! No more whining
about [_Other People's Code_](http://abstrusegoose.com/432) and also I
was anxious to not repeat my past mistakes and make my code even
better this time.

At the same time there happened to be Symfony2 Beta. I had not used
Symfony, but decided to take a look - especially as some of my
good developer friends were buzzing about it. I downloaded the
sandbox, read the documentation and some blog posts. Symfony2 looked
as a fresh breeze after years with Zend Framework. I liked the
structure of the code, I liked their approach to
development/production environments and asset management. I thought, "I shall
push to use it for our fresh start!". Early adoption all
the way.

But then again, I was not in this alone. We were three coders and while I
happened not to be a lead, I did have a voice. Oh man, did I preach
"Symfony2! Symfony2!", but the final word was in other hands.

The lead - Martynas, had a long time and never ending interest
in a technology called the
[_Semantic Web_](http://en.wikipedia.org/wiki/Semantic_Web). He
deserves credit, for what happened in the following
months. So the decision was made, to use his approach and make any tools
neccessary along the way (there was not much of them for PHP anyway). Then -
all hell break loose. I and another colleague, Aleksandras, both loudly
objected, argued, discussed, SHOUTED IN CAPS LOCK and so on. But the
decision was immovable and as the future showed - it was to the benefit of our own
experience, the code quality and a different perspective about things.

The coding began... And during those months of development I saw that
there is a drastically different approach to do things. I do not
lie - it took maybe three months to grasp all this myself. Sometimes I
didn't even know what I was coding! Luckily, Martynas had a clear
vision and lead us through, though there were still some discussions
up until the end.

So, what did I grasp?

## There is a problem with frameworks, because

They try to help me too much. I started to hate the idea of using any
MVC Based framework. _Why?_ is a good question. Here's an answer:

Contrary to the "easy to learn" slogans, shiny documentation and easy
examples, frameworks do not let me prototype things fast, unless I
know them inside-out. And even if I am expert, I am constrained.

Consider this: a framework is missing a feature. There are two ways to
solve this. I can search for a piece of code written for that mutual
purpose by another great developer, and use it. But, 9 out of 10 times
that piece of code does not fit my exact needs - I will need to
"polish" it. Or, it fits my requirements, but the code structure is
totally different. Or, it has no tests, but _seems to work_. I might
end up writing it myself, hopefuly if I understand the problem domain
good enough, the code will be pretty good too. _However_, even in this
case I am constrained. I am bound to structure my code in the way the
framework authors intended the framework to be extended. What if I
want to be a free spirit and do things my way if I know I will do them
better?

P.S. As I am writing this -
["Linus Torvalds on C++"](http://harmful.cat-v.org/software/c++/linus)
appeared on Hacker News. And I totally relate to his ideas, in a
different domain though.


## models are _a fifth foot on a dog_, and

I have long since heard that
[ORM is an anti-pattern](http://www.google.com/search?q=orm+antipattern)
and I agree with that. But I had always thought the problem is with
implementations - no one created that _right one_ yet. Now i have
come to the horrifying conclusion, that Models
in MVC are totally worthless piece of code. &lt;irony&gt;_They are
needed only for bugs to hide somewhere._&lt;/irony&gt; This comes from realizing,
that mostly I opened Model code to _fix_ something.

Consider this mindflow: Requirements of (especially web) software are
constantly changing and these changes mirror directly onto the
data structure. When an unavoidable change to the data and logic
arrives, you update them and in the end open up Model class,
add/remove methods/parameters, change various queries to use those
methods/parameters. It feels so unnatural, that when you change your
data and your queries, you have to change something _more_. This is a
constraint on data. There is a better way.

Your data should be your model - it should be self contained. Your
code shouldn't bother about internal representation, rather it should
care about data transformation. Which brings me to my next idea.

## views are impostors!

Yes, Views do not do what they should. Views are all about
representing your data. When I grasped this, I was shocked yet again.

The view should be, in one way or another, the same data I have in my
database, except that it is presented in the way the human eye or a
browser script could make sense of it. Now the commonly known View
mocks itself as the data, when actually it is a spaghetti of
moustaches that shows only what you allowed yourself to see, not what the
data wants to tell you!

The alternative is The Transformation -
[_a thorough dramatic change in form or appearance_](http://www.google.com/search?q=define:+transformation).

Maybe it is hard to grasp the difference, but consider this
metaphor: a view is like looking into something through a fancy
key-hole; transformation is like seeing the same thing _presented_
to you or to a script (as in JSON)  at any
given moment in a more understandable way.

## How it should work.

What do I want from a framework, then? Primarily, _healthy abstractions_ of the
low level stuff that I _need_ for a webapp. For example, I _now_ argue
(I wouldn't have believed a year ago), that the simplest
abstractions needed for a website are:

1. _Request_ - something that comes from the client.
2. _Response_ - something that goes back to the client.
3. _Resource_ - the data.
4. _Repository_ - a place to store, retrieve and update _Resources_.

Do you see the difference? Instead of hiding the low-level stuff that
modern frameworks tend to hide, we embraced it!
Indeed, last year, after months of work, when we finished the rebranded
Danish entertainment website called
[HeltNormalt](http://heltnormalt.dk/), there
are just those four things behind the scenes. Yet, believe it or not, the new website
holds more than ten different types of content compared to just two in
the old one. Here are some statistics about code:

* Controller code in the old website, LOC (Lines-of-Code): 7625 _vs_ Resource code in new one,
LOC: 652.
* View code in the old website, LOC: 2528 _vs_ Transformations code in
new one, LOC: 1898.
* Model code in the old website, LOC: 19125 _vs_ Query code in the new
one, LOC: 614.
* Zend Framework behind old website, LOC: tens of thousands _vs_ Our
  framework (Graphity), LOC: ~5000.

Less code - fewer bugs.

The Model/Query difference comes mainly from our ORM. we used Propel,
which generated a lot of code. You might ask, what's the _Query_ thing?
Well, we don't have models - but we do query the data. The point is,
because our data is autonomous, we need only to query for the
_stuff_ (properties) that we need. We need not describe the data as
Models.

## Putting it all together (IRL).

Let me explain how it
all works _in real life_, on the [HeltNormalt](http://heltnormalt.dk/) website,
without diving deeply into what
[RDF](http://en.wikipedia.org/wiki/Resource_Description_Framework) and
[SPARQL](http://en.wikipedia.org/wiki/SPARQL) (the Semantic Web
technologies, behind the scenes)

_Resources_

Every resource in our datastore is comprises a number of triples, each of which is a
Resource URI, a property name, and a value. For simplicity sake, a
heavily striped down version of a resource looks like this:

{% highlight text %}
    @base <http://heltnormalt.dk> .

    @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
    @prefix dct: <http://purl.org/dc/terms/> .
    @prefix sioc: <http://rdfs.org/sioc/ns#> .
    @prefix foaf: <http://xmlns.com/foaf/0.1/> .

    </striben/2012/02/28> rdf:type Post .
    </striben/2012/02/28> dct:issued "2012-02-28T00:00:00"^^dateTime .
    </striben/2012/02/28> sioc:has_container </striben> .
    </striben/2012/02/28> foaf:thumbnail </img/strip/thumb/2012/02/28.jpg> .
    </striben/2012/02/28> foaf:depiction </img/strip/2012/02/28.jpg> .
{% endhighlight %}

It is pretty straightforward and natural - every resource has an
URL. Each URL (thus - resource too) can have named properties, where
each property also has a value. A value can be another URL (thus -
link to another Resource) or a string.

Remember, how I wrote that we don't need Models, because our data is
self-contained? This is what I meant.

P.S. The snippet above is a very helpful thing called
[Turtle syntax]( http://en.wikipedia.org/wiki/Turtle_(syntax) ), though
simplified here. Actual data is in RDF/XML.

_Queries_

Now, as we don't have Models and ORM as such, we still need to get our data
somehow. So imagine above triples as a graph - in the center there is
a resource with edges going out (properties). On the other part of the
edge there is a value - a string, or (surprise surprise) another
resource linked to this one. Now imagine hundreds of resources linked this
way. A web of _linked data_.

How do you retrieve information from this graph? By a thing similar to
pattern matching! In the query you say that you want to get some
triples with some properties and values, and leave some blanks that
should be filled up in results. Sounds vague, but here's an example:

{% highlight text %}
    PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX foaf: <http://xmlns.com/foaf/0.1>
    PREFIX sioc: <http://rdfs.org/sioc/ns#>

    CONSTRUCT {
        ?uri rdf:type sioc:Post .
        ?uri foaf:thumbnail ?thumbUrl .
    } WHERE {
        ?uri rdf:type sioc:Post .
        ?uri sioc:has_container <http://heltnormalt.dk/striben> .
        ?uri foaf:thumbnail ?thumbUrl .
    }
{% endhighlight %}

A very similar query is executed when you type in address:
http://heltnormalt.dk/striben - and you get the list of strips. In
simplified form results look like this:

{% highlight xml %}
    <?xml version="1.0" encoding="utf-8"?>
    <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns:foaf="http://xmlns.com/foaf/0.1">
        <rdf:Description rdf:about="http://heltnormalt.dk/striben/2012/02/28">
            <rdf:type rdf:resource="http://rdfs.com/sioc/ns#Post"/>
            <foaf:thumbnail rdf:resource="http://heltnormalt.dk/img/strip/thumb/2012/02/28.jpg"/>
        </rdf:Description>
        <rdf:Description rdf:about="http://heltnormalt.dk/striben/2012/02/29">
            <rdf:type rdf:resource="http://rdfs.com/sioc/ns#Post"/>
            <foaf:thumbnail rdf:resource="http://heltnormalt.dk/img/strip/thumb/2012/02/29.jpg"/>
        </rdf:Description>
    </rdf:RDF>
{% endhighlight %}

Sorry for the XML, but I promise - it is important. I hope you see how
the pattern matching worked here. Just in case: query said "find me
all resources (?uri) and their thumbnails (?thumbUrl), where resources
have _type Post_, _container </striben>_ and a property _thumbnail_."

_Transformation_

Time to live up the promise - why XML is important? Well, because for
transformations we used the most natural transformation tool available
for XML. The [XSLT](http://en.wikipedia.org/wiki/XSLT). I won't dive
into XSLT, the Wikipedia article has some examples, but suffice to say
that we can represent our data in any way we want - HTML, XML, JSON,
Plain Text, etc. just by using different XSL stylesheets. We could
even generate a valid SQL dump to import into MySQL database, but
seriously - we don't want to do that. :-) (But we did an exact
opposite! We had to import old data.)

That's one of the greatest outcomes of all this - logic is stripped
down (but still there is some logic), what's left for you is XML
transformations. The thing is, you greatly reduce a chance of bug -
your data can be incorrect but can not contain bugs or be invalid (as
long as validation in datastore works correctly). And when we did have
had issues when some properties were missing in resource, nothing
broke, we had our XSLTs set up in way that just the part where that
property value should be shown - it was not shown. No ifs, no template
logic. And you get this pretty much by default if you use XSLT
correctly.

## Embrace the Open Source version of this!

Early in the beginning, Martynas said that after we finish with the
website, we should extract the back bone system and present it as an
open-source framework. Behold fellow hackers - The
[Graphity](http://github.com/graphity/graphity-core).

At the end of the process, we felt that we did not invent anything new
- we just reused what was always there, but hidden. So sometimes we
like to call Graphity not a Framework, but instead - an Architecture!
In theory this approach should work in any language that is widely
used in web development today. Martynas has a working Java version of
the same thing, slightly more sophisticated because Java already has
some packages to work with _linked data_ / _semantic web_, so he did
not need to write everything from scratch as in PHP version. Python?
Ruby?  I hope there will be a version for those languages, and others,
too!

Oh, and by the way, you might be puzzled - where to store the data if
you decide to play with Graphity? Well, I happen to know one SaaS
company, [Dydra](http://dydra.com/) - just register and use it. In
fact we did and, oh boy!, how friendly and helpful they were
through the process of developing HeltNormalt! A perfect
example for me how customer care should look like. Seriously, check
them out.

## Adventures at M.I.T. and a paper about Graphity.

In fall 2011 Martynas found a call for participation in a
[Linked Enterprise Data Patterns Workshop](http://www.w3.org/2011/09/LinkedData/)
and said we should try to enter this event, by writing a short paper
about what we did and how and how this could benefit the Semantic Web
movement.

We did write the paper, we were accepted, and in early December flew
over _The Pond_ to Boston, MA to do a presentation! Actually, then I
felt that our presentation looked a little bit off (a Danish
entertainment company website) among enterprise grands like: IBM,
Nokia, Oracle, just to name a few! But then again, who cares about
being a little bit off, when sitting next to
[Tim Berners-Lee](http://en.wikipedia.org/wiki/Tim_Berners-Lee) and
listening to other bunch of great people talking about this great
technology and drafting the guidelines for it's future.

If someone had told me couple of years ago: "Dude, you gonna visit MIT
and present your stuff to TBL." - I would have slapped that someone
and said "Wake up!" :-) That how unbelievable it looked like.

If you are interested in the paper we wrote, it has more
comparative information how this approach differs from todays common
practice in web development. Read it here:
[_"Graphity - A Generic Linked Data Framework"_](http://graphity.github.com/position_paper.pdf).

## We invite you to collaborate!

I hope someone endured up until here :-) This is the most important part
actually!

We truly believe in Graphity, but as our ways with HeltNormalt have
parted - we can not spend a significant amount of time on it.

Although we do spend some hours per week improving it - more hands and
minds are always better, so if you feel interested - don't hesitate!
Try it out and contribute, we will be there for you on our Github
account, I also will try to write more about it on this new and shiny
blog and you can always drop an email for me directly or info@graphity.org

What are your thoughts on this - let's talk in comments!

The End :-)
