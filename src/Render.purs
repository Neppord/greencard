module Render where

import Prelude

import Data.Array (length, zip)
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Event (Event)
import Game (Game(..), Land(..))
import Plants (Plant(..))
import Seeds (Seed(..))
import Stats (Stats(..))
import Web.DOM.Document (getElementsByClassName)
import Web.DOM.Element (setClassName, toNode)
import Web.DOM.HTMLCollection (toArray)
import Web.DOM.Node (setTextContent)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toDocument, toNonElementParentNode)
import Web.HTML.Window (document)

render :: Game -> Array Event -> Effect Unit
render (Game {land, money, seeds}) ( _ :: (Array Event)) = do
    w <- window
    d <- document w
    moneyElement <- getElementById "money" (toNonElementParentNode d)
    case moneyElement of
        Nothing -> pure unit
        Just element -> do
            toNode element # setTextContent (show money)
    seedsElement <- getElementById "seeds" (toNonElementParentNode d)
    case seedsElement of
        Nothing -> pure unit
        Just element -> do
            toNode element # setTextContent (show $ length seeds)
    collection <- getElementsByClassName "tile" (toDocument d)
    elements <- toArray collection
    void $ for_ (zip land elements) $ \ (Tuple field element) ->
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