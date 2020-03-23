// Learn more about F# at http://fsharp.org

open System

type RequestHeaders = {
  Authorization : string option
  X_Signature : string option
  X_Next : string option
}

type Method =
  | GET
  | POST
  | PUT
  | DELETE

type Pet = {
  id : int
  name : string
}

type PathPiece =
  | PString of string
  | PInt of int

type RequestBody =
  | RBPet of Pet
  | RBString of string

type Request = {
  headers : RequestHeaders
  method : Method
  path : PathPiece List
  requestBody : RequestBody option
}

type ResponseBody =
  | PetsResponse of Pet List
  | PetResponse of Pet
  | StringResponse of string

type Response = {
  code : int
  body : ResponseBody
}

let spec (request: Request) =
  match request with
  | {
      path = [PString "pets"]
      method = GET
      headers = {
        Authorization = Some _
        X_Signature = Some _
      } 
    } -> { code = 200; body = PetsResponse [{ id = 1; name = "Fluffy" }]}
  | {
      path = [PString "pets"]
      headers = {
        X_Signature = None
      } 
    } -> { code = 400; body = StringResponse "Bad request." }
  | {
      path = [PString "pets"]
      headers = {
        Authorization = None
      } 
    } -> { code = 401; body = StringResponse "Not authorized." }
  | {
      path = [ PString "pets" ]
      method = POST
      headers = {
        Authorization = Some _
        X_Signature = Some _
      }
      requestBody = Some (RBPet p)
    } -> { code = 201; body = PetResponse p }
  | {
      path = [ PString "pets" ]
      method = POST
    } -> { code = 400; body = StringResponse "Bad request." }
  | {
      path = [PString "pets"; PInt _]
      method = GET
      headers = {
        Authorization = Some _
        X_Signature = Some _
      } 
    } -> { code = 200; body = PetResponse { id = 1; name = "Fluffy" }}
  | {
      path = [PString "pets"; PInt _]
      headers = {
        X_Signature = None
      } 
    } -> { code = 400; body = StringResponse "Bad request." }
  | {
      path = [PString "pets"; PInt _]
      headers = {
        Authorization = None
      } 
    } -> { code = 401; body = StringResponse "Not authorized." }
  | {
      path = [PString "echo"]
      method = POST
      requestBody = Some (RBString b)
    } -> { code = 200; body = StringResponse b }
  | _ -> { code = 500; body = StringResponse "Internal error." }


[<EntryPoint>]
let main argv =
  printfn "Testing gemara"
  printfn "This should produce a 400 response."
  printfn "%A" (spec {
    path = [PString "pets"]
    method = GET
    headers = {
      X_Next = None
      X_Signature = None
      Authorization = None
    }
    requestBody = None
  })
  printfn "This should produce a 200 response."
  printfn "%A" (spec {
    path = [PString "pets"]
    method = GET
    headers = {
      X_Next = None
      X_Signature = Some "signature"
      Authorization = Some "token"
    }
    requestBody = None
  })
  0 // return an integer exit code
