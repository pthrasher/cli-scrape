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

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt](https://github.com/gruntjs/grunt).

## Release History
* 0.1.4 - Initial release
  * Supports XPath queries via google's wicked fast xpath library
  * Supports css selector queries using qwery

## License
Copyright (c) 2012 pthrasher  
Licensed under the MIT license.
