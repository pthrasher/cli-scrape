scrape = require '../lib/scrape.js'

describe 'The source file', ->
    it 'has a function named useXPath', ->
        expect(scrape.useXPath).not.toBeNull()
        expect(scrape.useXPath).toBeDefined()

    it 'has a function named getArgs', ->
        expect(scrape.getArgs).not.toBeNull()
        expect(scrape.getArgs).toBeDefined()

    it 'has a function named fetchHTML', ->
        expect(scrape.fetchHTML).not.toBeNull()
        expect(scrape.fetchHTML).toBeDefined()

    it 'has a function named domParse', ->
        expect(scrape.domParse).not.toBeNull()
        expect(scrape.domParse).toBeDefined()

    it 'has a function named elToString', ->
        expect(scrape.elToString).not.toBeNull()
        expect(scrape.elToString).toBeDefined()

    it 'has a function named executeXPath', ->
        expect(scrape.executeXPath).not.toBeNull()
        expect(scrape.executeXPath).toBeDefined()

    it 'has a function named executeCSSQuery', ->
        expect(scrape.executeCSSQuery).not.toBeNull()
        expect(scrape.executeCSSQuery).toBeDefined()
