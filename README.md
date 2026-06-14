# uv-test

This is a demonstration of how multiple (conflicting) versions of the same dependency across two projects works with uv versus nixpkgs.

## uv

```console
$ uv run --preview-features package-conflicts --package test1 packages/test1/main.py
$ uv run --preview-features package-conflicts --package test2 packages/test2/main.py
# notice two different numpy versions printed
```

## nix
```console
$ nix run .#test1
$ nix run .#test2
# notice two different numpy versions printed
```
