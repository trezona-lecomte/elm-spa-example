module Session exposing (Session, changes, cred, fromUser, navKey, viewer)

import Api exposing (Cred)
import Avatar exposing (Avatar)
import Browser.Navigation as Nav
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, required)
import Json.Encode as Encode exposing (Value)
import Time
import User exposing (User)



-- TYPES


type Session
    = LoggedIn Nav.Key User
    | Guest Nav.Key



-- INFO


viewer : Session -> Maybe User
viewer session =
    case session of
        LoggedIn _ val ->
            Just val

        Guest _ ->
            Nothing


cred : Session -> Maybe Cred
cred session =
    case session of
        LoggedIn _ val ->
            Just (User.cred val)

        Guest _ ->
            Nothing


navKey : Session -> Nav.Key
navKey session =
    case session of
        LoggedIn key _ ->
            key

        Guest key ->
            key



-- CHANGES


changes : (Session -> msg) -> Nav.Key -> Sub msg
changes toMsg key =
    Api.userChanges (\maybeUser -> toMsg (fromUser key maybeUser)) User.decoder


fromUser : Nav.Key -> Maybe User -> Session
fromUser key maybeUser =
    -- It's stored in localStorage as a JSON String;
    -- first decode the Value as a String, then
    -- decode that String as JSON.
    case maybeUser of
        Just viewerVal ->
            LoggedIn key viewerVal

        Nothing ->
            Guest key
