# Gemara

Hello!
This is a sketch for a new internal representation of API schemas for mocking.

## Motivation

OpenAPI was never meant as a mocking spec. Only a documentation spec. As a result:

- Difficult to do matching
- Difficult to choose right response
- Difficult to implement logic
- Difficult to store data

Gemara seeks to solve these problems while keeping the main great things about OpenAPI (and even improving them if possible):

- Human readable
- Human writeable
- Unambiguous
- Small surface area

## So what is Gemara?

I have no idea. Basically, I've taken an OpenAPI spec and built something that kinda looks like a "standard" in three different languages - ReasonML, Clojure, and Purescript.  The thought experiment is "Is this a useful representation of an API for mocking?"  All three specs are *applications*, meaning in addition to being a spec, they do a small proof-of-concept as a mock when executed.

## Original OpenAPI spec

[Look here](./openapi/index.yml).

## ReasonML Experiment

[Here it is](./reasonml/src/Spec.re).

ReasonML has a nice pattern matcher and type safety, making it a good candidate. There are no union types though, so you have to use variants, which leads to the annoying `type pathString = PString(string) | PInt(int);` instead of something more compact like `string | int`.

### Build

First, install ReasonML and build the spec.

```bash
cd reasonml
npm install -g bs-platform
npm run build
```

### Execute

```
cd reasonml
node src/Spec.bs.js
```

## Purescript Experiment

[Here it is](./purescript/src/Spec.purs).

Purescript is basically the same as ReasonML. Slightly less modern looking, but the language allows you to do a lot more.

### Build

First, install purescript and build the spec.

```bash
cd purescript
npm install -g purescript
npm install -g spago
spago install
spago build
```

### Execute

Note that this file was written by hand using the Purescript spec, whereas the ReasonML `Spec.bs.js` is entirely self-contained and doesn't use any hand-wrtten javascript. I could have done the same thing here in Purescript, but I created my own JS file to call the Purescript function `spec` just to see if I could call Purescript from JavaScript. Turns out to be pretty straightforward - see [./src/Spec.purs.js](./src/Spec.purs.js).

```
cd purescript
node src/Spec.purs.js   
```

## Haskell experiment

### Build

First, install stak:

```bash
curl -sSL https://get.haskellstack.org/ | sh
```

Then:

```bash
cd haskell
stack setup
stack build
```

### Execute

```
cd haskell
stack exec gemara-exe
```
