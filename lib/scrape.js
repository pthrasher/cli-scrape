(function() {
  'use strict';

  var CSS_LIBS, XPATH_LIBS, domParse, elToString, executeCSSQuery, executeXPath, fetchHTML, getArgs, jsdom, log, main, request, useXPath;

  request = require('request');

  jsdom = require('jsdom');

  log = require('npmlog');

  XPATH_LIBS = ['wgxpath.install.js'];

  CSS_LIBS = ['qwery.min.js', 'qwery-pseudos.min.js'];

  useXPath = function(query) {
    return query.indexOf('/') === 0;
  };

  getArgs = function() {
    var argv, loglevel, optimist, query, url, _ref;
    optimist = require('optimist');
    argv = optimist.usage('Usage: $0 [url] [xpath|css]').alias('l', 'loglevel')["default"]('l', 'silent').demand(2).argv;
    _ref = argv._, url = _ref[0], query = _ref[1];
    url = url.trim();
    query = query.trim();
    loglevel = argv.loglevel.trim();
    return {
      url: url,
      query: query,
      loglevel: loglevel
    };
  };

  fetchHTML = function(url, cb) {
    return request.get(url, function(err, response, body) {
      if (err != null) {
        log.err('http', "[" + response.statusCode + "] " + err);
        return cb(err, response, body);
      }
      log.verbose('http', "[" + response.statusCode + "] Fetched '" + url + "' successfully.");
      return cb(err, response, body);
    });
  };

  domParse = function(html, libs, cb) {
    return jsdom.env(html, libs, function(err, window) {
      if (err != null) {
        log.err('parse', "Error processing DOM with libs: [ '" + (libs.join('\', \'')) + "' ]. (" + err + ")");
        return cb(err, window);
      }
      log.verbose('parse', "DOM parse successful with libs: [ '" + (libs.join('\', \'')) + "' ].");
      return cb(err, window);
    });
  };

  elToString = function(el) {
    if (el.innerHTML != null) {
      log.verbose('elToString', "Fetching innerHTML from '" + el + "'.");
      return el.innerHTML.trim();
    } else if (el.textContent != null) {
      log.verbose('elToString', "Fetching textContent from '" + el + "'.");
      return el.textContent.trim();
    } else if (Object.prototype.toString.call(el) === '[object String]') {
      log.verbose('elToString', "Content already a string: '" + el + "'.");
      return el.trim();
    }
  };

  executeXPath = function(query, window) {
    var document, els, i, len, result;
    if (window.wgxpath == null) {
      log.err('xpath', 'xpath selector engine not found!');
      return [];
    }
    window.wgxpath.install();
    document = window.document;
    els = [];
    log.verbose('xpath', "Evaluating query '" + query + "'.");
    result = document.evaluate(query, document, null, 7, null);
    len = result.snapshotLength;
    log.verbose('xpath', "Found " + len + " match(es).");
    if (len > 0) {
      els = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 0; 0 <= len ? _i < len : _i > len; i = 0 <= len ? ++_i : --_i) {
          _results.push(result.snapshotItem(i));
        }
        return _results;
      })();
    }
    return els;
  };

  executeCSSQuery = function(query, window) {
    var els;
    if (window.qwery == null) {
      log.err('css', 'qwery selector engine not found!');
      return [];
    }
    log.verbose('css', "Evaluating query '" + query + "'.");
    els = window.qwery(query);
    log.verbose('css', "Found " + els.length + " match(es).");
    return els;
  };

  main = function() {
    var loglevel, query, url, _ref;
    _ref = getArgs(), url = _ref.url, query = _ref.query, loglevel = _ref.loglevel;
    log.level = loglevel;
    return fetchHTML(url, function(err, response, body) {
      var libs, xpath;
      if (err != null) {
        return process.exit(1);
      }
      xpath = useXPath(query);
      libs = CSS_LIBS;
      if (xpath) {
        libs = XPATH_LIBS;
      }
      return domParse(body, libs, function(err, window) {
        var result, results, strings, _i, _len;
        if (err != null) {
          return process.exit(1);
        }
        if (xpath) {
          results = executeXPath(query, window);
        } else {
          results = executeCSSQuery(query, window);
        }
        if (!results || results.length < 1) {
          return process.exit(1);
        }
        strings = [];
        for (_i = 0, _len = results.length; _i < _len; _i++) {
          result = results[_i];
          strings.push(elToString(result));
        }
        return process.stdout.write(strings.join('\n'));
      });
    });
  };

  module.exports = {
    useXPath: useXPath,
    getArgs: getArgs,
    fetchHTML: fetchHTML,
    domParse: domParse,
    elToString: elToString,
    executeXPath: executeXPath,
    main: main
  };

}).call(this);
