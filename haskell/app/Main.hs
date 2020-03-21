module Main where

import Lib

main :: IO ()
main = do
    putStrLn "Testing gemara"
    putStrLn "This should produce a 400 response."
    putStrLn $ show $ spec Request{
        path = [PString("pets")],
        method = GET,
        headers = RequestHeaders{
            x_next = Nothing,
            x_signature = Nothing,
            authorization = Nothing
        },
        requestBody = Nothing
    }
    putStrLn "This should produce a 200 response."
    putStrLn $ show $ spec $ Request{
        path = [PString("pets")],
        method = GET,
        headers = RequestHeaders{
            x_next = Nothing,
            x_signature = Just "foo",
            authorization = Just "bar"
        },
        requestBody = Nothing
    }
