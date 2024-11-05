# Add a new TIL post named 'name'.
add-til name +title:
  echo "+++\n\
  title = \"{{title}}\"\n\
  date = {{datetime("%Y-%m-%d")}}\n\
  +++\n\
  " > content/til/{{name}}.md

add-blog name +title:
  echo "+++\n\
  title = \"{{title}}\"\n\
  date = {{datetime("%Y-%m-%d")}}\n\
  +++\n\
  " > content/blog/{{name}}.md
