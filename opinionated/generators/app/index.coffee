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

    @log "looking good, lets add the package.json scripts"

    try
      packagejson = @fs.readJSON 'package.json'

      @log "your JSON file have: #{JSON.stringify(packagejson)}"

      packagejson.scripts['pug'] = 'coffee --compile --bare opinionated/src && pug --pretty opinionated/src'
      packagejson.scripts['fix'] = "find ./opinionated/src/ -name \"*.html\" -exec perl -pi -e \"s/(is|properties|observers)\\(/static get \\1\\(/g\" '{}' \\;"
      packagejson.scripts['transpile'] = "npm run pug && npm run fix && find ./opinionated/src -name '*.html' -exec mv {} src \\;"

      @fs.writeJSON 'package.json', packagejson

      @log "pug, fix and transpile scripts have been added to your package.json file"

    catch error
      @log "there was a problem reading your package.json file #{error}"



  install: ->
    @npmInstall(['pug', 'stylus','coffeescript@next', 'jstransformer-stylus'], { 'save-dev': true })
    @npmInstall(['pug-cli'], {"global": true})
    # @installDependencies()
    @log "now you can run:"
    @log "coffee --compile --bare opinionated/ && pug --pretty opinionated/src --out src/"
    @log "to compile your stuff"
