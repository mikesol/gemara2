module Lib
    ( spec,
      RequestHeaders(..),
      Method(..),
      Request(..),
      PathPiece(..)
    ) where

import Prelude hiding (id)

data RequestHeaders = RequestHeaders { authorization :: Maybe String
                                     , x_signature :: Maybe String
                                     , x_next :: Maybe String
                                     } deriving (Show)

data Method = GET | POST | PUT | DELETE deriving (Show)

data Pet = Pet { id :: Int
               , name :: String
               } deriving (Show)

data PathPiece = PString String | PInt Int deriving (Show)

data RequestBody = RBPet Pet | RBString String deriving (Show)

data Request = Request { headers :: RequestHeaders
                       , method :: Method
                       , path :: [PathPiece]
                       , requestBody :: Maybe RequestBody
                       } deriving (Show)

data ResponseBody = PetsResponse [Pet] | PetResponse Pet | StringResponse String deriving(Show)

data Response = Response { code :: Int
                         , body :: ResponseBody
                         } deriving (Show)

spec :: Request -> Response
spec Request{
  path = [PString "pets"],
  method = GET,
  headers = RequestHeaders{
    authorization = Just _,
    x_signature = Just _
  }
} = Response{ code = 200, body = PetsResponse [Pet{ id = 1, name = "Fluffy" }]}
spec Request{
  path = [PString "pets"],
  headers = RequestHeaders{
    x_signature = Nothing
  }
} = Response{ code = 400, body = StringResponse "Bad request." }
spec Request{
  path = [PString "pets"],
  headers = RequestHeaders{
    authorization = Nothing
  }
} = Response{ code = 401, body = StringResponse "Not authorized."}
spec Request{
  path = [PString "pets"],
  method = POST,
  headers = RequestHeaders{
    authorization = Just _,
    x_signature = Just _
  },
  requestBody = Just(RBPet p)
} = Response{ code = 200, body = PetResponse p}
spec Request{
  path = [PString "pets"],
  method = POST
} = Response{ code = 400, body = StringResponse "Bad request." }
spec Request{
  path = [PString "pets", PInt _],
  method = GET,
  headers = RequestHeaders{
    authorization = Just _,
    x_signature = Just _
  }
} = Response{ code = 200, body = PetResponse Pet{ id = 1, name = "Fluffy" } }
spec Request{
  path = [PString "pets", PInt _],
  headers = RequestHeaders{
    x_signature = Nothing
  }
} = Response{ code = 400, body = StringResponse "Bad request." }
spec Request{
  path = [PString "pets", PInt _],
  headers = RequestHeaders{
    authorization = Nothing
  }
} = Response{ code = 401, body = StringResponse "Not authorized." }
spec Request{
  path = [PString "echo"],
  method = POST,
  requestBody = Just(RBString b)
} = Response{ code = 200, body =  StringResponse b }
spec _ = Response{ code = 500, body = StringResponse "Internal error." }
