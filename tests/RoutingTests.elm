module RoutingTests exposing (fragment, fromUrl, testUrl, usernameFromStr)

import Expect exposing (Expectation)
import Json.Decode as Decode exposing (decodeString)
import Route exposing (Route(..))
import Test exposing (..)
import Url exposing (Url)
import Username exposing (Username)



-- TODO need to add lots more tests!


fromUrl : Test
fromUrl =
    describe "Route.fromUrl"
        [ testUrl "" Root
        , testUrl "#login" Login
        , testUrl "#logout" Logout
        , testUrl "#register" Register
        , testUrl "#settings" Settings
        ]



-- HELPERS


testUrl : String -> Route -> Test
testUrl hash route =
    test ("Parsing hash: \"" ++ hash ++ "\"") <|
        \() ->
            fragment hash
                |> Route.fromUrl
                |> Expect.equal (Just route)


fragment : String -> Url
fragment frag =
    { protocol = Url.Http
    , host = "foo.com"
    , port_ = Nothing
    , path = "bar"
    , query = Nothing
    , fragment = Just frag
    }



-- CONSTRUCTING UNEXPOSED VALUES
-- By decoding values that are not intended to be exposed directly - and erroring
-- if they cannot be decoded, since this is harmless in tests - we can let
-- our internal modules continue to expose only the intended ways of
-- constructing those, while still being able to test them.


usernameFromStr : String -> Username
usernameFromStr str =
    case decodeString Username.decoder ("\"" ++ str ++ "\"") of
        Ok username ->
            username

        Err err ->
            Debug.todo ("Error decoding Username from \"" ++ str ++ "\": " ++ Decode.errorToString err)
