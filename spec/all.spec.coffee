scrape = require 'lib/scrape'

describe 'The source file', ->
    it 'has a function named useXPath', ->
        expect(scrape.useXPath).not.toBeNull()

    it 'has a function named getArgs', ->
        expect(scrape.getArgs).not.toBeNull()

    it 'has a function named fetchHTML', ->
        expect(scrape.fetchHTML).not.toBeNull()

    it 'has a function named domParse', ->
        expect(scrape.domParse).not.toBeNull()

    it 'has a function named elToString', ->
        expect(scrape.elToString).not.toBeNull()

    it 'has a function named executeXPath', ->
        expect(scrape.executeXPath).not.toBeNull()

    it 'has a function named executeCSSQuery', ->
        expect(scrape.executeCSSQuery).not.toBeNull()
