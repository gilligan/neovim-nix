<br />
<p align="center">
  <h2 align="center">neovim-nix</h2>
  <p align="center">
  My nixified neovim setup
  </p>
</p>

## About

You are looking at my nixified neovim setup. Nothing more nothing less. Maybe it can be useful to you somehow.

- Uses vim nixpkgs provided vim plugins.
- Builds additional plugins from source using `buildVimPlugin`.
- Adds global vim settings as another `buildVimPlugin` built plugin.
- Patches some plugins into submission.

## Building

```
$ nix-build
```

## Installing

Plug it into an overlay or just use `nix-env -i` if you prefer.
