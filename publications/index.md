---
layout: default
title:  Julia Publications
---

For citing Julia, we recommend:

{% assign beks14 = site.publications | where:"path","_publications/BEKS14.md" | first %}
<div>{% include citation.html pub=beks14 %}</div>

The following is a list of publications about the Julia language, its
standard library, Julia packages, and technical computing applications
using code written in Julia. This list is by no means complete, and
only includes publications submitted by the authors.

We welcome additions to this list in the form of [pull requests](https://github.com/JuliaLang/julialang.github.com/tree/master/_publications).

{% assign pubs_grouped = site.publications | group_by: 'year' | sort: 'name' | reverse %}
<ul class="publist">
{% for eachyear in pubs_grouped  %}
  <h2> {{ eachyear.name }} </h2>
  {% for pub in eachyear.items %}
  <li id="{{ pub.path | remove: "_publications/" | remove: ".md"  }}">{% include citation.html pub=pub %}</li>
  {% endfor %}
{% endfor %}
</ul>
