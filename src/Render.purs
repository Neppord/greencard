module Render where

import Prelude

import Data.Traversable (for)
import Effect (Effect)
import Event (Event)
import Game (Game)
import Web.DOM.Document (getElementsByClassName)
import Web.DOM.HTMLCollection (toArray)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.Window (document)

render :: Game -> Array Event -> Effect Unit
render ( _ :: Game) ( _ :: (Array Event)) = do
     w <- window
     d <- document w
     collection <- getElementsByClassName "tile" (toDocument d)
     elements <- toArray collection
     void $ for elements $ \ _ ->
        pure unit
     pure unit