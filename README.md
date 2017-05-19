# sake-cli

[![npm][npm-img]][npm-url]
[![build][build-img]][build-url]
[![dependencies][dependencies-img]][dependencies-url]
[![downloads][downloads-img]][downloads-url]
[![license][license-img]][license-url]
[![chat][chat-img]][chat-url]

> The Sake command line interface.

Install this globally and you'll have access to the `sake` command anywhere on
your system.

```bash
npm install -g sake-cli
```

Note: The job of the `sake` command is to load and run the version of Sake you
have installed locally to your project, irrespective of its version.

## Installing sake locally

If you prefer the idiomatic Node.js method to get started with a project (`npm
install && npm test`) then install `sake` locally with `npm install sake-cli
--save-dev`. Then add a script to your `package.json` to run the associated Sake
task: `"scripts": { "test": "sake test" }`. Now `npm test` will use the locally
installed `./node_modules/.bin/sake` executable to run your Sake tasks.

To read more about npm scripts, please visit the [npm docs][npm-docs].

## Autocompletion
Sake ships with a simple [completion function for zsh][compdef] which can
autocomplete available task names:

```bash
fpath=( path/to/comp/_sake $fpath )
comdef _sake sake
```

## License
[BSD][license-url]

[npm-docs]: https://docs.npmjs.com/misc/scripts
[compdef]:  https://github.com/sakejs/sake-cli/blob/master/comp/_sake

[build-img]:        https://img.shields.io/travis/sakejs/sake-cli.svg
[build-url]:        https://travis-ci.org/sakejs/sake-cli
[chat-img]:         https://badges.gitter.im/join-chat.svg
[chat-url]:         https://gitter.im/sakejs/chat
[coverage-img]:     https://coveralls.io/repos/sakejs/sake-cli/badge.svg?branch=master&service=github
[coverage-url]:     https://coveralls.io/github/sakejs/sake-cli?branch=master
[dependencies-img]: https://david-dm.org/sakejs/sake-cli.svg
[dependencies-url]: https://david-dm.org/sakejs/sake-cli
[downloads-img]:    https://img.shields.io/npm/dm/sake-cli.svg
[downloads-url]:    http://badge.fury.io/js/sake-cli
[license-img]:      https://img.shields.io/npm/l/sake-cli.svg
[license-url]:      https://github.com/sakejs/sake-cli/blob/master/LICENSE
[npm-img]:          https://img.shields.io/npm/v/sake-cli.svg
[npm-url]:          https://www.npmjs.com/package/sake-cli
