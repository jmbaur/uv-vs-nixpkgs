# uv-test

This is a demonstration of how uv is incapable of using multiple versions of the same dependency across two projects within a workspace, whereas nixpkgs allows for this type of flexibility OOTB.

## uv

```console
$ nix develop -c uv lock
# notice error when uv tries to resolve conflicting numpy version specifiers
```

## nix
```console
$ nix run .#test1
$ nix run .#test2
# notice two different numpy versions printed
```
