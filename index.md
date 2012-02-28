---
layout: default
title: Backend.LT by Julius 'Sepa' Šėporaitis
---
{% include JB/setup %}

<div id="home">
    <ul class="posts">
        {% assign first_post = site.posts.first %}
        <li>
            <div id="post">
                <h1>{{ first_post.title }}</h1>
                <p class="meta">{{ first_post.date | date_to_string }}</p>
                <p> {{ first_post.preview }} </p>
                <a id="more" href="{{ first_post.url }}">Continue reading&raquo;</a>
            </div>
        </li>
    </ul>

    <h1>Archive</h1>
    <ul class="posts">
        {% for post in site.posts %}
            <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ post.url }}">{{ post.title }}</a></li>
        {% endfor %}
    </ul>
</div>

