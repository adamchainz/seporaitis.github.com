---
layout: default
title: Julius 'Sepa' Šėporaitis
---
{% include JB/setup %}

{% assign first_post = site.posts.first %}

<ol id="posts">
    <li class="post">
        <div class="entry">
            <div class="header">
                <a class="date" href="{{ first_post.url }}" data-date="{{ first_post.date| date_to_xmlschema }}">
                    <div class="top ribbon">&nbsp;</div>
                    <div class="bottom ribbon">&nbsp;</div>
                    <div class="tail ribbon">
                        <div class="left ribbon">&nbsp;</div>
                        <div class="right ribbon">&nbsp;</div>
                    </div>
                </a>
                <h1 class="title">
                    <a href="{{first_post.url}}">{{ first_post.title }}</a>
                </h1>
            </div>
            <div class="content">
                {{ first_post.content }}
            </div>
            <div class="footer">
                <div class="info">
                    <p><a class="more" href="{{ first_post.url }}/#disqus">Discuss</a></p>
                    <p>Posted <abbr title="{{ first_post.date | date_to_long_string }}">
                            {{ first_post.date | date_to_long_string }}
                        </abbr>
                        by <span class="author">Julius Seporaitis</span></p>
                </div>
            </div>
        </div>
    </li>
    <li class="post">
        <div class="entry">
            <div class="footer">
                <p>
                    {{site.author.name}}</p>
                <p>
                    <a href="mailto:{{site.author.email}}"
                       class="icon-email">{{site.author.email}}</a></p>
                <p>
                    <a href="http://github.com/{{site.author.github}}/"
                    class="icon-github">github.com/{{site.author.github}}</a>
                    <a href="http://twitter.com/{{site.author.twitter}}"
                    class="icon-twitter">twitter.com/{{site.author.twitter}}</a>
                    <a href="http://feeds.feedburner.com/{{site.author.feedburner}}"
                    class="icon-rss">feeds.feedburner.com/{{site.author.twitter}}</a>
                </p>
            </div>
        </div>
    </li>
</ol>
