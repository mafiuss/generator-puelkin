'use strict'

Generator = require 'yeoman-generator'
chalk = require 'chalk'
yosay = require 'yosay'
mkdirp = require 'mkdirp'

module.exports = class extends Generator
  prompting: ->
    @log yosay(
      "Welcome to the #{chalk.red('puelkin')} generator!")

    prompts = [
      type: 'confirm'
      name: 'someAnswer'
      message: 'Would you like to enable this option?'
      default: true
    ,
      type: 'input'
      name: 'componentName'
      message: 'Do we start with a custom component? say the name'
      default: 'my-componente'
    ,
      type: 'input'
      name: 'componentNameCamel'
      message: 'I am somhow stupid right now, can you camel case it for me?'
      default: 'myComponente'
    ]

    @prompt(prompts).then (props) =>
      @props = props

  writing: ->
    mkdirp.sync @destinationPath('opinionated/src')
    @log " componente #{@props['componentName']}"
    mkdirp.sync @destinationPath("opinionated/src/#{@props['componentName']}")
    @log "yes!"
    @fs.copyTpl(
      @templatePath('component.pug.ejs'),
      @destinationPath("opinionated/src/#{@props['componentName']}/#{@props['componentName']}.pug"),
      @props
    )
    @fs.copyTpl(
      @templatePath('component.styl.ejs'),
      @destinationPath("opinionated/src/#{@props['componentName']}/#{@props['componentName']}.styl"),
      @props
    )
    @fs.copyTpl(
      @templatePath('component.coffee.ejs'),
      @destinationPath("opinionated/src/#{@props['componentName']}/#{@props['componentName']}.coffee"),
      @props
    )

  install: ->
    # @npmInstall(['pug','stylus','coffeescript@next', 'jstransformer-stylus'], { 'save-dev': true });
    # @installDependencies()
    @log "now you can run:"
    @log "coffee --compile --bare opinionated/ && pug --pretty opinionated/src --out src/"
    @log "to compile your stuff"
