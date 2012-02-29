---
layout: post
title: "There is a problem with web frameworks"
tags: [web]
---
{% include JB/setup %}

This is an essay about my long time experience with a web framework
 X. Names are not important, because ideas I will present you are
 common among all major web frameworks nowadays. I will even dare to
 say that MVC that is a de facto standard nowadays is a
 [leaky abstraction](http://en.wikipedia.org/wiki/Leaky_abstraction). Sounds
 scary, right? No worries - I will try to present you a possible
 solution - a totally different way to do things, which actually
 works. Well, at least there is one working example running in
 production.

<!--more-->

First things first. In the summer of 2011 I was working, among couple
of other things, on a website called
[Wulffmorgenthaler](http://wulffmorgenthaler.com). There is a
different story behind the english version (just in case you have
questions), but today I will concentrate on a Danish website and its 
successor - [HeltNormalt](http://heltnormalt.dk). So, around the 
middle 2011, owner of the website decided to
do rebranding - new website with a LOT of new kinds of content.

The old codebase was terrible piece of craftsmanship, part of which,
sadly, involves me too. The rebreanding meant green light to a fresh
start on the codebase. Oh boy, was I happy about it! No more dealing
with [_Other People Code_](http://abstrusegoose.com/432) and also I
was anxious to not repeat my previous mistakes and make my code even
better.

At the same time there happened to be Symfony2 Beta. I haven't used
Symfony before, but decided to take a look - especially as some of my
good developer friends were buzzing about it. I downloaded the
sandbox, read the documentation and some blog posts. Symfony2 looked
as a fresh breeze after years with Zend Framework. I liked the
structure of the code, I liked their approach to
development/production environments and asset management. "I shall
push to use it for our fresh start!" - I thought. Early adoption all
the way.

But then again, I was not alone in this. We were three coders and I
happened not to be a lead. I had a voice. Oh man, did I preached
"Symfony2! Symfony2!", but the final word was in another mans hands.

The lead - Martynas, who had a long time and never ending interest
about a technology called the
[_Semantic Web_](http://en.wikipedia.org/wiki/Semantic_Web). And he
deserves a credit, because of what happened in the upcoming
months. So decision was made to use his approach and make any tools
neccessary along the way (there isn't much of them for PHP anyways). Then -
all hell break loose. I and another colleague, Aleksandras, loudly
objected, argued, discussed, SHOUTED IN CAPS LOCK and so on. But
decision was immovable and as future showed - in the benefit of our own
experience, code quality and a different perspective about things.

The coding began... And during those months of development I saw that
there is a drastically different approach to do things. I will not
lie - it took maybe three months to grasp all this myself. Sometimes I
didn't even know what I was coding! Luckily, Martynas had a clear
vision and lead us through, though there were still some discussions
up until the end.

So what did I grasp?

## I had a problem with frameworks.

They try to help me too much. I started to hate the idea of using any MVC
Based framework. _Why?_ is a good question. Here's an answer:

Contrary to the "easy to learn" slogans, shiny documentation and easy
examples, frameworks do not let me prototype things fast, unless I
know them inside-out. And even if I do - I am constrained.

Consider this: a framework is missing a feature. There are two ways to
solve this. I can search for a piece of code written for that mutual
purpose by another great developer, and use it. But 9 out of 10 times
that piece of code does not fit my exact needs - I will need to
"polish" it. Or it fits my requirements, but the code structure is
totally different. Or it has no tests, but _seem to work_. I might
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

## Models are _a fifth foot on a dog_.

I have long since heard that
[ORM is an anti-pattern](http://www.google.com/search?q=orm+antipattern)
and I agree to that. But I always thought the problem is with
implementations - no one created that _right one_ yet.

But I was horrified at first when I came to a conclusion that Models
in MVC are totally worthless piece of code. &lt;irony&gt;_They are
needed only for bugs to hide somewhere._&lt;/irony&gt; This comes from
experience that mostly I opened Model code to _fix_ something.

Consider this mindflow: Requirements of (especially web) software are
constantly changing and these changes mirror directly to on to the
data structure. So when an unavoidable change to the data and logic
arrives - you update them and in the end open up Model class,
add/remove methods/parameters, change various queries to use those 
methods/parameters. It feels so unnatural that when you change your 
data and your queries, you have to change something _more_. This is a 
constraint on data. There is a better way.

Your data should be your model - it should be self contained. Your
code shouldn't bother about internal representation, rather -
presentation. Which brings me to my next idea.

## Views are impostors!

Yes, Views do not do what they should. Views are all about
representing your data. I was shocked again, when I grasped this.

The view should be, in one way or another, the same data I have in my
database, except that it is presented in the way the human eye or a 
browser script, could make sense of it. Now the commonly known View
mocks itself as the data, when actually it is a spaghetti of
moustaches that shows only what you allowed yourself to see, not what the
data wants to tell you!

But there is a man in the mask, hidden and forgotten somewhere in 
basement, I call it The Transformation -
[_a thorough dramatic change in form or appearance_](http://www.google.com/search?q=define:+transformation).

Maybe it is hard to grasp the difference, but look at it in this
metaphoric way: view is like looking into something through a fancy
key-hole; transformation is like seeing the same thing but _presented_
to you in a more understandable way.

## Putting it all together

What do I want then from a framework? A _healthy abstractions_ of the
low level stuff that I _need_ for a webapp. For example, I argue _now_
(I wouldn't have believed half a year ago), that the most simplest
abstractions needed for a website are:

1. _Request_ - something that comes from the client.
2. _Response_ - something that goes back to the client.
3. _Resource_ - the data.

And indeed after months of work, last year, we finished the rebranded
Danish entertainment website called
[HeltNormalt](http://heltnormalt.dk/). Believe it or not, this website
holds more than ten different types of content compared just to two in
the old one. And behind the scenes there are those three things
mentioned above with one additional:

4. _Repository_ - a place to store, retrieve and update data.

--- WORK IN PROGRESS ---
