{
  playwright,
  symlinkJoin,
}:

assert playwright.version == "1.59.1";
symlinkJoin {
  name = "playwright-browsers-1217";
  paths = [ playwright.browsers ];
}
