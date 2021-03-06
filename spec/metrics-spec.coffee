{WorkspaceView} = require 'atom'
Reporter = require '../lib/reporter'

describe "Metrics", ->
  beforeEach ->
    atom.workspaceView = new WorkspaceView

  it "reports event", ->
    spyOn(Reporter, 'request')

    waitsForPromise ->
      atom.packages.activatePackage('metrics')

    waitsFor ->
      Reporter.request.callCount is 2

    runs ->
      Reporter.request.reset()
      atom.packages.deactivatePackage('metrics')

    waitsForPromise ->
      atom.packages.activatePackage('metrics')

    waitsFor ->
      Reporter.request.callCount is 3

    runs ->
      [requestArgs] = Reporter.request.calls[0].args
      expect(requestArgs.method).toBe 'POST'
      expect(requestArgs.hostname).toBe 'www.google-analytics.com'
      expect(requestArgs.headers).toBeDefined()
      expect(requestArgs.path).toBeDefined()
