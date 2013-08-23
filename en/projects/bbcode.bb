title: bbcode

[b]bbcode[/b] is a command-line tool I made in C to generate the HTML content of this website. It takes as input files written in the BBCode markup, used on many web forums, and writes HTML that can be included in a HTML document, like the one you are reading.

This was mostly a fun exercise as there already exist markup tools for the same purpose, although none for BBCode that I know of.

[b]Downloads[/b]
Source code tarball: [url=/files/bbcode-0.01.tar.gz]bbcode-0.01.tar.gz[/url]

You can get the latest code from the [url=https://github.com/ivartj/bbcode]Github repository[/url].

[b]Details[/b]
Unlike many other BBCode implementations, this tool does not use regular expressions, which tend to be limited in how they can interpret the structure of a text. It ensures that the written HTML is structured in a proper hierarchy even if the BBCode input is not.

As an example, to get the following:

[i]italic text, [b]bold and italic text[/i], bold text.[/b]

You can write this BBCode:
[code]
[i]italic text, [b]bold and italic text[/i], bold text.[/b]
[/code]
And get the following HTML output:
[code]
<em>italic text, <strong>bold and italic text</strong></em><strong>, bold text.</strong>
[/code]

