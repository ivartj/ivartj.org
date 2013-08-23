-output: html
title: Untitled
lang: en
lang-other: no
lang-description: Homepage of Ivar Jarlsby.
lang-about-me: about me

<!doctype html>
<html lang="<[lang]>">
	<head>
		<meta charset="utf-8">
		<title><[title|html-escape]></title>
		<link rel="stylesheet"
		      href="/styles.css"
		      type="text/css">
		<meta name="viewport"
		      content="width=device-width, initial-scale=1.0">
		<meta name="description"
		      content="<[lang-description]>">
	</head>
	<body>
		<div class="siteinfo">
			<header>
				<div class="left menu">
					<a href="/<[lang]>/" class="sitetitle left">Ivar Trygve Jarlsby</a>
				</div>
				<div class="right menu">
					<a href="/<[lang]>/about.html">
						<[lang-about-me]>
					</a><!-- no space --><a class="lang" href="/<[lang-other]>/<[doc-path]>"><span class="nohover"><[lang]></span><span class="onhover"><[lang-other]></span></a>
				</div>
				<div class="clearboth"></div>
			</header>
		</div>
		<div class="content">
			<article>
				<h1><[title|html-escape]></h1>
				<[...]>
			</article>
		</div>
	</body>
</html>
