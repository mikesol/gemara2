var { Nothing, Just } = require("../output/Data.Maybe/");
var { spec, PString, GET } = require('../output/Spec/');
console.log(spec({
    path: [new PString("pets")],
    method: new GET(),
    headers: {
        x_next: new Nothing(),
        x_signature: new Nothing(),
        authorization: new Nothing()
      },
    requestBody: new Nothing()
}));
console.log(spec({
  path: [new PString("pets")],
  method: new GET(),
  headers: {
      x_next: new Nothing(),
      x_signature: new Just("bar"),
      authorization: new Just("foo")
    }
}));