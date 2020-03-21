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
  | RBString(string);

type request = {
  headers: request_headers,
  method,
  path: list(pathPiece),
  requestBody: option(requestBody),
};

type responseBody =
  | PetsResponse(list(pet))
  | PetResponse(pet)
  | StringResponse(string);

type response = {
  code: int,
  body: responseBody
};

let spec = req =>
  switch (req) {
  | {
      path: [PString("pets")],
      method: GET,
      headers: {authorization: Some(_), x_signature: Some(_)},
    } =>
    {code: 200, body: PetsResponse([{id: 1, name: "Fluffy"}])}
  | {
      path: [PString("pets")],
      headers: {x_signature: None},
    } =>
    {code: 400, body: StringResponse("Bad request.")}
  | {
      path: [PString("pets")],
      headers: {authorization: None},
    } =>
    {code: 401, body: StringResponse("Not authorized.")}
  | {
      path: [PString("pets")],
      method: POST,
      headers: {authorization: Some(_), x_signature: Some(_)},
      requestBody: Some(RBPet(p))
    } =>
    {code: 201, body: PetResponse(p)}
  | {
      path: [PString("pets")],
      method: POST
    } =>
    {code: 400, body: StringResponse("Bad request.")}
  | {
      path: [PString("pets"), PInt(_)],
      method: GET,
      headers: {authorization: Some(_), x_signature: Some(_)},
    } =>
    {code: 200, body: PetsResponse([{id: 1, name: "Fluffy"}])}
  | {
      path: [PString("pets"), PInt(_)],
      method: GET,
      headers: {x_signature: None},
    }=>
    {code: 400, body: StringResponse("Bad request.")}
  | {
      path: [PString("pets"), PInt(_)],
      method: GET,
      headers: {authorization: None},
    }=>
    {code: 401, body: StringResponse("Not authorized.")}
  | {
      path: [PString("echo")],
      method: POST,
      requestBody: Some(RBString(b))
    } =>
    {code: 200, body: StringResponse(b)}
  | _ => {code: 500, body: StringResponse("Internal error.")}
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
