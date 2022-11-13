module Render where

import Prelude

import Data.Array (zip)
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Event (Event)
import Game (Game(..), Land(..))
import Web.DOM.Document (getElementsByClassName)
import Web.DOM.Element (setClassName)
import Web.DOM.HTMLCollection (toArray)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.Window (document)
import Plants (Plant(..))
import Stats (Stats(..))
import Seeds (Seed(..))

render :: Game -> Array Event -> Effect Unit
render (Game game) ( _ :: (Array Event)) = do
    w <- window
    d <- document w
    collection <- getElementsByClassName "tile" (toDocument d)
    elements <- toArray collection
    void $ for_ (zip game.land elements) $ \ (Tuple field element) ->
        element # setClassName case field of
            Grass -> "tile tile-grass"
            Dirt (Nothing) -> "tile tile-dirt"
            Dirt (Just (Plant
                { stats: (Stats {growth})
                , seed: (Seed {daysToHarvest
                }
            )})) ->
                if growth * 2 < daysToHarvest
                then "tile tile-seedling"
                else "tile tile-plant"