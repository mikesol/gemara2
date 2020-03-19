type request_headers = {
  authorization: option(string),
  x_signature: option(string),
  x_next: option(string),
};

type method =
  | GET
  | POST
  | PUT
  | DELETE;

type pet = {
  id: int,
  name: string,
};

type pathPiece =
  | PString(string)
  | PInt(int);

type requestBody =
  | RBPet(pet)
  | RBEcho(string);

type request = {
  headers: request_headers,
  method,
  path: list(pathPiece),
  requestBody: option(requestBody),
};

type pets200 = {
  code: int,
  body: list(pet),
};

type pet200 = {
  code: int,
  body: pet
}

type pets201 = {
  code: int,
  body: pet,
};

type all400 = {
  code: int,
  body: string,
};

type echo200 = {
  code: int,
  body: string,
};

type all401 = {
  code: int,
  body: string,
};

type all500 = {
  code: int,
  body: string,
};

type response =
  | Pets200(pets200)
  | Pets201(pets201)
  | Pet200(pet200)
  | Echo200(echo200)
  | All400(all400)
  | All401(all401)
  | All500(all500);

let spec = req =>
  switch (req) {
  | {
      path: [PString("pets")],
      method: GET,
      headers: {authorization: Some(_), x_signature: Some(_)},
    } =>
    Pets200({code: 200, body: [{id: 1, name: "Fluffy"}]})
  | {
      path: [PString("pets")],
      method: GET,
      headers: {x_signature: None},
    } =>
    All400({code: 400, body: "Bad request."})
  | {
      path: [PString("pets")],
      method: GET,
      headers: {authorization: None},
    } =>
    All401({code: 401, body: "Not authorized."})
  | {
      path: [PString("pets")],
      method: POST,
      headers: {authorization: Some(_), x_signature: Some(_)},
      requestBody: Some(RBPet(p))
    } =>
    Pets201({code: 201, body: p})
  | {
      path: [PString("pets")],
      method: POST,
      headers: {x_signature: None},
    } =>
    All400({code: 400, body: "Bad request."})
  | {
      path: [PString("pets")],
      method: POST,
      headers: {authorization: None},
    } =>
    All401({code: 401, body: "Not authorized."})
  | {
      path: [PString("pets")],
      method: POST
    } =>
    All400({code: 400, body: "Bad request."})
  | {
      path: [PString("pets"), PInt(_)],
      method: GET,
      headers: {authorization: Some(_), x_signature: Some(_)},
    } =>
    Pets200({code: 200, body: [{id: 1, name: "Fluffy"}]})
  | {
      path: [PString("pets"), PInt(_)],
      method: GET,
      headers: {x_signature: None},
    }=>
    All400({code: 400, body: "Bad request."})
  | {
      path: [PString("pets"), PInt(_)],
      method: GET,
      headers: {authorization: None},
    }=>
    All401({code: 401, body: "Not authorized."})
  | {
      path: [PString("echo")],
      method: POST,
      requestBody: Some(RBEcho(b))
    } =>
    Echo200({code: 200, body: b})
  | _ => All500({code: 500, body: "Internal error"})
  };

Js.log("Testing gemara");
Js.log("This should produce a 400 response.");
Js.log(spec({
  path: [PString("pets")],
  method: GET,
  headers: {
    x_next: None,
    x_signature: None,
    authorization: None
  },
  requestBody: None
}));
Js.log("This should produce a 200 response.");
Js.log(spec({
  path: [PString("pets")],
  method: GET,
  headers: {
    x_next: None,
    x_signature: Some("signature"),
    authorization: Some("token")
  },
  requestBody: None
}));
