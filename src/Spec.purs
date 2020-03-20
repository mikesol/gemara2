module Spec where
import Prelude
import Data.Maybe (Maybe)
import Data.List (List)
import Effect (Effect)
import Effect.Console (log)

data PathPiece = PString String | PInt Int

type RequestHeaders =
  { authorization :: Maybe String
  , x_next :: Maybe String
  , x_signature :: Maybe String
  }

type Request =
  { path :: List PathPiece
  , headers  :: RequestHeaders
  }

greet :: String -> String
greet name = "Hello, " <> name <> "!"

main :: Effect Unit
main = log (greet "World")

-- spec :: Request -> Response