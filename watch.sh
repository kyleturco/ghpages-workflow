#!/bin/sh

# clean and prepare public directory
rm -rf public
#mkdir public
cp -r src public

# compile jade to html
./node_modules/.bin/jade src -P
cd src
find . -name "*.html" | cpio -pdvm ../public
cd ..
rm -rf src/*.html  \
       src/**/*.html  \
       public/**/*.html \
       public/_partials

# compile sass to css
./node_modules/.bin/node-sass \
  --output-style compressed \
  --source-map-embed \
  --recursive \
  src/_styles/main.scss public/css/main.css


# convert ES^ JS to ES5
./node_modules/.bin/babel src --out-dir public -s inline

# concat bower_components to public/lib directory
if [ -d "bower_components" ]; then
  ./node_modules/.bin/bowcat . -o public/lib -m
fi

# clean unneeded files
rm -rf public/_styles \
       public/*.jade \
       public/**/*.jade \
       public**/*.scss \