{
  replacements = {
    python3 = "python39";
  };

  packages.python3.packages = {
    pandas.enable = true;
  };

  output = "python3";
}
