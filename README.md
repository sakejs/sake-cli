# sake-cli
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

[npm-docs]: https://docs.npmjs.com/misc/scripts
