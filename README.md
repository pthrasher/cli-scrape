# scrape

screen scrape from command line with xpath or css selectors

## Getting Started
Install the module with: `npm install scrape`

```javascript
var scrape = require('scrape');
scrape.awesome(); // "awesome"
```

## Documentation
_(Coming soon)_

## Examples

```
$ scrape http://whatthecommit.com/ '//p[0]/text()'
$ scrape http://whatthecommit.com/ 'p:first-child'
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [grunt](https://github.com/gruntjs/grunt).

## Release History
_(Nothing yet)_

## License
Copyright (c) 2012 pthrasher  
Licensed under the MIT license.
