declare namespace output = 'http://www.w3.org/2010/xslt-xquery-serialization';
declare boundary-space preserve;
declare option output:method 'html';
declare option output:version '5.0';
declare option output:html-version '5.0';
declare option output:indent 'no';
declare option output:item-separator ' ';

declare variable $default-meta-file-path external;
declare variable $meta-file-path external;
declare variable $root-path external;
declare variable $doc-path external;

let $default-meta := fn:json-doc($default-meta-file-path)
let $instance-meta := fn:json-doc($meta-file-path)
let $meta := map:merge(($instance-meta, $default-meta))

let $selected := map {
  "no" : if ($meta?lang = "no") then "selected" else "",
  "en" : if ($meta?lang = "en") then "selected" else "",
  "about" : if ($doc-path = "about.html") then "selected" else ""
}

return
<html lang="{$meta?lang}">
  <head>
    <meta charset="utf-8" />
    <title>{$meta?title}</title>
    <link rel="stylesheet"
          href="{$root-path}/styles.css"
          type="text/css" />
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0" />
    <meta name="description"
          content="{$meta?description}" />
  </head>
  <body>
    <div class="siteinfo">
      <header>
        <div class="left menu">
          <a href="{$root-path}/{$meta?lang}/index.html" class="sitetitle left">Ivar Trygve Jarlsby</a>
        </div>
        <div class="right menu">
          <a class="{$selected?about}" href="{$root-path}/{$meta?lang}/about.html">{$meta?lang-about-me}</a>
          <a lang="no" class="{$selected?no}" href="{$root-path}/no/{$doc-path}">norsk</a>
          <a lang="en" class="{$selected?en}" href="{$root-path}/en/{$doc-path}">english</a>
        </div>
        <div class="clearboth"></div>
      </header>
    </div>
    <div class="content">
      <article>
        <h1>{$meta?title}</h1>
        {
          for $part in /body/child::node()
          return $part
        }
      </article>
    </div>
  </body>
</html>

