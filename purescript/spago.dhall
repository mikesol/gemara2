{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies = [ "console", "effect", "maybe", "psci-support" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
