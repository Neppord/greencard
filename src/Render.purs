module Render where

import Prelude

import Data.Array (zip)
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Console (log)
import Event (Event)
import Game (Game(..), Land(..))
import Web.DOM.Document (getElementsByClassName)
import Web.DOM.Element (setClassName)
import Web.DOM.HTMLCollection (toArray)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.Window (document)

render :: Game -> Array Event -> Effect Unit
render (Game game) ( _ :: (Array Event)) = do
    log "Render"
    w <- window
    d <- document w
    collection <- getElementsByClassName "tile" (toDocument d)
    elements <- toArray collection
    void $ for_ (zip game.land elements) $ \ (Tuple field element) ->
       element # setClassName case field of
           Grass -> "tile tile-grass"
           Dirt (Nothing) -> "tile tile-dirt"
           Dirt (Just _) -> "tile tile-seedling"