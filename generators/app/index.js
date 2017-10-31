// Generated by CoffeeScript 2.0.1
'use strict';
var Generator, chalk, mkdirp, yosay;

Generator = require('yeoman-generator');

chalk = require('chalk');

yosay = require('yosay');

mkdirp = require('mkdirp');

module.exports = class extends Generator {
  prompting() {
    var prompts;
    this.log(yosay(`Welcome to the ${chalk.red('puelkin')} generator!`));
    prompts = [
      {
        type: 'confirm',
        name: 'someAnswer',
        message: 'Would you like to enable this option?',
        default: true
      },
      {
        type: 'input',
        name: 'componentName',
        message: 'Do we start with a custom component? say the name',
        default: 'my-componente'
      },
      {
        type: 'input',
        name: 'componentNameCamel',
        message: 'I am somhow stupid right now, can you camel case it for me?',
        default: 'myComponente'
      }
    ];
    return this.prompt(prompts).then((props) => {
      return this.props = props;
    });
  }

  writing() {
    var error, packagejson;
    mkdirp.sync(this.destinationPath('opinionated/src'));
    this.log(` componente ${this.props['componentName']}`);
    mkdirp.sync(this.destinationPath(`opinionated/src/${this.props['componentName']}`));
    this.log("yes!");
    this.fs.copyTpl(this.templatePath('component.pug.ejs'), this.destinationPath(`opinionated/src/${this.props['componentName']}/${this.props['componentName']}.pug`), this.props);
    this.fs.copyTpl(this.templatePath('component.styl.ejs'), this.destinationPath(`opinionated/src/${this.props['componentName']}/${this.props['componentName']}.styl`), this.props);
    this.fs.copyTpl(this.templatePath('component.coffee.ejs'), this.destinationPath(`opinionated/src/${this.props['componentName']}/${this.props['componentName']}.coffee`), this.props);
    this.log("looking good, lets add the package.json scripts");
    try {
      packagejson = this.fs.readJSON('package.json');
      this.log(`your JSON file have: ${JSON.stringify(packagejson)}`);
      packagejson.scripts['pug'] = 'coffee --compile --bare opinionated/src && pug --pretty opinionated/src';
      packagejson.scripts['fix'] = "find ./opinionated/src/ -name \"*.html\" -exec perl -pi -e \"s/(is|properties|observers)\\(/static get \\1\\(/g\" '{}' \\;";
      packagejson.scripts['transpile'] = "npm run pug && npm run fix && find ./opinionated/src -name '*.html' -exec mv {} src \\;";
      this.fs.writeJSON('package.json', packagejson);
      return this.log("pug, fix and transpile scripts have been added to your package.json file");
    } catch (error1) {
      error = error1;
      return this.log(`there was a problem reading your package.json file ${error}`);
    }
  }

  install() {
    this.npmInstall(['pug', 'stylus', 'coffeescript@next', 'jstransformer-stylus'], {
      'save-dev': true
    });
    this.npmInstall(['pug-cli'], {
      "global": true
    });
    // @installDependencies()
    this.log("now you can run:");
    this.log("coffee --compile --bare opinionated/ && pug --pretty opinionated/src --out src/");
    return this.log("to compile your stuff");
  }

};
