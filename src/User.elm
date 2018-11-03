module User exposing (User, avatar, cred, decoder, minPasswordChars, store, username)

{-| The logged-in user currently viewing this page. It stores enough data to
be able to render the menu bar (username and avatar), along with Cred so it's
impossible to have a User if you aren't logged in.
-}

import Api exposing (Cred)
import Avatar exposing (Avatar)
import Email exposing (Email)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, required)
import Json.Encode as Encode exposing (Value)
import Username exposing (Username)



-- TYPES


type User
    = User Avatar Cred



-- INFO


cred : User -> Cred
cred (User _ val) =
    val


username : User -> Username
username (User _ val) =
    Api.username val


avatar : User -> Avatar
avatar (User val _) =
    val


{-| Passwords must be at least this many characters long!
-}
minPasswordChars : Int
minPasswordChars =
    6



-- SERIALIZATION


decoder : Decoder (Cred -> User)
decoder =
    Decode.succeed User
        |> custom (Decode.field "image" Avatar.decoder)


store : User -> Cmd msg
store (User avatarVal credVal) =
    Api.storeCredWith
        credVal
        avatarVal
