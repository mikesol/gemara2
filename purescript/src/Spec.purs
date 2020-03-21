module Spec where
import Data.Maybe (Maybe(..))

type RequestHeaders =
  { authorization :: Maybe String
  , x_signature :: Maybe String
  , x_next :: Maybe String
  }

data Method = GET | POST | PUT | DELETE

type Pet =
  { id :: Int
  , name :: String
  }

data PathPiece = PString String | PInt Int

data RequestBody = RBPet Pet | RBString String

type Request =
  { headers :: RequestHeaders
  , method :: Method
  , path :: Array PathPiece
  , requestBody :: Maybe RequestBody
  }

data ResponseBody = PetsResponse (Array Pet) | PetResponse Pet | StringResponse String

type Response =
  { code :: Int
  , body :: ResponseBody
  }

spec :: Request -> Response
spec {
  path: [(PString "pets")],
  method: GET,
  headers: {
    authorization: Just(_),
    x_signature: Just(_)
  }
} = { code: 200, body: PetsResponse([{ id: 1, name: "Fluffy" }])}
spec {
  path: [(PString "pets")],
  headers: {
    x_signature: Nothing
  }
} = { code: 400, body: StringResponse("Bad request.")}
spec {
  path: [(PString "pets")],
  headers: {
    authorization: Nothing
  }
} = { code: 401, body: StringResponse("Not authorized.")}
spec {
  path: [(PString "pets")],
  method: POST,
  headers: {
    authorization: Just(_),
    x_signature: Just(_)
  },
  requestBody: Just(RBPet p)
} = { code: 200, body: PetResponse(p)}
spec {
  path: [(PString "pets")],
  method: POST
} = { code: 400, body: StringResponse("Bad request.")}
spec {
  path: [(PString "pets"), (PInt _)],
  method: GET,
  headers: {
    authorization: Just(_),
    x_signature: Just(_)
  }
} = { code: 200, body: PetResponse({ id: 1, name: "Fluffy" })}
spec {
  path: [(PString "pets"), (PInt _)],
  headers: {
    x_signature: Nothing
  }
} = { code: 400, body: StringResponse("Bad request.")}
spec {
  path: [(PString "pets"), (PInt _)],
  headers: {
    authorization: Nothing
  }
} = { code: 401, body: StringResponse("Not authorized.")}
spec {
  path: [(PString "echo")],
  method: POST,
  requestBody: Just(RBString b)
} = { code: 200, body: StringResponse(b)}
spec _ = { code: 500, body: StringResponse("Internal error.") }
