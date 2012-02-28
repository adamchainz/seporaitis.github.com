---
layout: post
title: "Your frameworks and MVCs are wrong"
category: 
tags: [web]
---
{% include JB/setup %}

*__Disclaimer__: this is my first post after a two year _hibernation_, which did not
help my communication skills. So you are very welcome to slap my writing style in 
comments - I read them all.*

Having this shouting title for my first post might look as an arrogant shot, but 
bear with me here - this idea has been crystalizing in my head for about a half
year now, directly from experience with a different approach to things than I was 
used to.

Of course - if the post did not bore you, you happened to read it from A to Z
and if you share the same or contradictory beliefs - I urge you to share them and
raise a discussion. 

So, here goes...

## I have a problem with frameworks. 

They try to help me too much. One might see that as a good thing, but after working 
with two now _mainstream_ PHP frameworks and checking out couple of others, I 
noticed few things. 

Contrary to the "easy to use" slogans, shiny documentation and examples, frameworks do 
not let me prototype things fast, unless I know them inside-out. And even if I know them
I am constrained to its limitations.

For example: Missing a feature? I can search for a piece of code written by another 
great developer for that mutual purpose, and use it.  Nothing is wrong with that, but 
from my own experience - piece of code does not fit every purpose well enough - it always 
needs polishing to fit - be it a different code structure than your own or tiny bits of logic 
or something else. On the other hand, I can write that missing piece myself. While I am 
a fan of "do it yourself" _if understanding of the problem domain is good enough_, I am 
bound to do this task in the way the framework authors intended framework to be extended 
and not the way I might want to do it.

## I have problem with MVC, especially M.

During some of my latest projects I worked on, I had an awkward epiphany - Models 
in MVC are _like a fifth foot on a dog_. Short explanation is - I always need to 
come back and _fix_ it. Long explanation - requirements for (especially web) software 
are not carved in stone, requirements and their changes directly mirror on to data. 
Data that is represented by model code and controller logic. Naturally changes propagate 
there as well. Adding/removing properties of the data in database, changing the controller 
logic is okay, but then you end up opening Model class, adding/removing parameters to 
methods and changing various queries again and again. It fells unnatural to me now and 
actually this process came along unnoticed until I saw an approach disturbingly different 
from what I was used to. I will try to elaborate on this in my next post, but to put it short -
your data should be your model and not the model should constrain your data.

## Views are wrong

A thing commonly known as The View does not do what it should. Correct me if I am wrong - 
views are all about representing your data (model). Then why the spagheti of moustache 
braces? Look at it in this perspective - your view should be, in one way or another, the 
same data you have in your database, except that it was presented in the way the human eye 
and mind could make sense of it. Lets call it The Transformation. And although they might
seem as the same thing, they actualy are not.

A View usually is a template with some placeholders to put the data into. A Transformation
is [_a thorough dramatic change in form or appearance_](http://www.google.com/search?q=define:+transformation). 
First is like looking into something through a fancy key-hole, second is like seeing the 
same thing, but in a way that is more viable to understand.

Once again, this crazy _sounding_ idea enlightened me when I saw a way to deal things in
a totally different way than I was used to.

## Putting it all together

What do I want then? Healthy abstractions. A healthy abstractions of _things_ that I _have_. 
And what _things_ do I _have_ in a web application backend?

1. Request
2. Response
3. Resource

Simplest of things and hey! You of course noticed how they fit HTTP protocol! Now doesn't the commonly
used MVC (or similar) abstraction seem unnatural fit/overengineering/unneccessary complexity?

Please share your opinion and meanwhile I will write what _terrifying_ experience I had, that 
changed my view so drastically and will try to reply to your comments.

Thanks for reading!

