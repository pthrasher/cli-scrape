# cli-scrape
[![Build Status](https://travis-ci.org/pthrasher/cli-scrape.png)](https://travis-ci.org/pthrasher/cli-scrape)

screen scrape from command line with xpath or css selectors

## Getting Started
Install the module with: `npm install -g cli-scrape`

Then try out the following:
```
$ scrape http://whatthecommit.com/ '//p[0]/text()'
$ scrape http://whatthecommit.com/ 'p:first-child'
```

Or some of these:
```
# get a list of all of my public repos from github
$ scrape https://github.com/pthrasher 'li.public.source h3 a'

# Check if a website is down via down for everyone or just me:
$ scrape http://www.downforeveryoneorjustme.com/google.com '/html/body//div[@id="container"]/text()' | head -n 1
It's just you.
$ scrape http://www.downforeveryoneorjustme.com/lkjsdflkjsdf.com '/html/body//div[@id="container"]/text()' | head -n 1
It's not just you!

# Or make it a shell function:
function justme() {
    scrape http://www.downforeveryoneorjustme.com/$1 '/html/body//div[@id="container"]/text()' | head -n 1
}

# Then run it like so:
$ justme google.com
It's just you
$ justme lkjsdflkjsdf.com
It's not just you!
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt](https://github.com/gruntjs/grunt).

## Release History
* 0.1.10 - Bug fix release
    * Supports node 4.x
    * Updated to latest jsdom
    * Fix for #2
* 0.1.9 - Initial release
    * Supports XPath queries via google's wicked fast xpath library
    * Supports css selector queries using qwery

## License
Copyright (c) 2012 pthrasher
Licensed under the MIT license.
