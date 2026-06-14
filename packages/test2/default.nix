{
  buildPythonApplication,
  lib,
  numpy,
  setuptools,
}:

buildPythonApplication {
  pname = "test2";
  version = "0.1.0";
  pyproject = true;
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./main.py
      ./pyproject.toml
    ];
  };
  build-system = [ setuptools ];
  dependencies = [ numpy ];
}
