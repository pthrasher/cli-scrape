#    cli-scrape
#
#    (c) 2012 Philip Thrasher
#
#    cli-scrape may be freely distributed under the MIT license.
#    For all details and documentation:
#
#    http://pthrasher.github.com/cli-scrape/

# Usage
# -----
#
# `scrape http://whatthecommit.com/ 'p:first-child'`
#
# `scrape http://whatthecommit.com/ '//p[0]'`

# use strict, yo!
'use strict'

request  = require 'request'
jsdom    = require 'jsdom'
log      = require 'npmlog'
path     = require 'path'

absPath = (relPath) ->
  path.resolve __dirname, relPath

# These are the libraries used to do the parsing on the page. If the query is
# an xpath query, XPATH\_LIBS is used. If not, CSS\_LIBS is used instead.
XPATH_LIBS = [absPath('wgxpath.install.js')]
CSS_LIBS = [absPath('qwery.min.js'), absPath('qwery-pseudos.min.js')]



# useXPath
# --------
#
# Determine whether or not the query passed in is an xpath query or a css query
useXPath = (query) ->
    query.indexOf('/') is 0


# getArgs
# -------
#
# Wrapper for optimise that allows us to clean up the args as they come in.
getArgs = ->
    optimist = require 'optimist'
    argv = optimist
        .usage('Usage: scrape [url] [xpath|css]')
        .alias('l', 'loglevel')
        .default('l', 'silent')
        .demand(2)
        .argv
    [ url, query ] = argv._
    url   = url.trim()
    query = query.trim()
    loglevel = argv.loglevel.trim()
    {
        url
        query
        loglevel
    }

# fetchHTML
# ---------
#
# This is essentially a simple logging wrapper around request.get
fetchHTML = (url, cb) ->
    request.get url, (err, response, body) ->
        if err?
            log.error 'http', "[#{response.statusCode}] #{err}"
            return cb err, response, body

        log.verbose 'http', "[#{response.statusCode}] Fetched '#{url}' successfully."
        cb err, response, body

# domParse
# --------
#
# This is essentially a simple logging wrapper around jsdom.env
domParse = (html, libs, cb) ->
    jsdom.env html, libs, (err, window) ->
        if err?
            log.error 'parse', "Error processing DOM with libs: [ '#{libs.join '\', \''}' ]. (#{err})"
            return cb err, window

        log.verbose 'parse', "DOM parse successful with libs: [ '#{libs.join '\', \''}' ]."
        cb err, window

# elToString
# ----------
#
# depending on the query given by the user, we will be getting an html element,
# or a plain old string. This should be handled elegantly.
elToString = (el) ->
    if el.innerHTML?
        log.verbose 'elToString', "Fetching innerHTML from '#{el}'."
        return el.innerHTML.trim()
    else if el.textContent?
        log.verbose 'elToString', "Fetching textContent from '#{el}'."
        return el.textContent.trim()
    else if Object.prototype.toString.call(el) is '[object String]'
        log.verbose 'elToString', "Content already a string: '#{el}'."
        return el.trim()

# executeXPath
# ---------------
#
# Executes the given xpath query against the given window.document object using
# google's wicked fast xpath
executeXPath = (query, window) ->
    unless window.wgxpath?
        log.error 'xpath', 'xpath selector engine not found!'
        return []
    window.wgxpath.install()
    document = window.document
    els = []
    log.verbose 'xpath', "Evaluating query '#{query}'."
    result = document.evaluate(query, document, null, 7, null)
    len = result.snapshotLength
    log.verbose 'xpath', "Found #{len} match(es)."
    if len > 0
        els = (result.snapshotItem(i) for i in [0...len])
    els

# executeCSSQuery
# ---------------
#
# Executes the given css query against the given window.document object using
# window.qwery
executeCSSQuery = (query, window) ->
    unless window.qwery?
        log.error 'css', 'qwery selector engine not found!'
        return []
    log.verbose 'css', "Evaluating query '#{query}'."
    els = window.qwery query
    log.verbose 'css', "Found #{els.length} match(es)."
    els

# Main
# ====
#
# Only run if we're executed directly.
if require.main == module
    # Get the args
    { url, query, loglevel } = getArgs()
    # Set our default logging level, only log items at this level and higher.
    # The default loglevel is err - only show errors
    log.level = loglevel
    fetchHTML url, (err, response, body) ->
        if err?
            # If we hit an error while fetching the page, return 1 so that our
            # command can be chained in the shell.
            return process.exit(1)

        # Determin if we're using xpath or not, and set the libs appropriately.
        xpath = useXPath query
        libs = CSS_LIBS
        if xpath
            libs = XPATH_LIBS

        domParse body, libs, (err, window) ->
            if err?
                # If we hit an error while parsing the document, return 1 so that our
                # command can be chained in the shell.
                return process.exit(1)

            if xpath
                results = executeXPath query, window
            else
                results = executeCSSQuery query, window

            if not results or results.length < 1
                # We had no results, so go ahead and exit 1 so that our command can be
                # chained in the shell.
                return process.exit(1)

            strings = []
            for result in results
                strings.push elToString(result)

            # Print the strings to stdout in such a way that they're all
            # separated by a newline, but the last line doesn't end in one.
            process.stdout.write strings.join '\n'


# Export everything for testing purposes.
#
# All of the jasmine BDD tests are in the spec folder.
module.exports = {
    useXPath
    getArgs
    fetchHTML
    domParse
    elToString
    executeXPath
    executeCSSQuery
}
