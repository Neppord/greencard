module Render where

import Prelude

import Data.Array (length, zip)
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Data.Array as Array
import Data.Map as Map
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Event (Event)
import Game (Game(..), Land(..))
import Plants (Plant(..))
import Seeds (Seed(..))
import Stats (Stats(..))
import Web.DOM.Document (Document)
import Web.DOM.Document (createElement, getElementsByClassName) as DOM
import Web.DOM.Element (setClassName, toNode) as DOM
import Web.DOM.HTMLCollection (toArray)
import Web.DOM.Internal.Types (Element, HTMLCollection)
import Web.DOM.Node (setTextContent)
import Web.DOM.Node (appendChild) as DOM
import Web.DOM.NonElementParentNode (getElementById) as DOM
import Web.HTML (window) as HTML
import Web.HTML.HTMLDocument (HTMLDocument)
import Web.HTML.HTMLDocument (toDocument, toNonElementParentNode) as HTML
import Web.HTML.Window (document) as HTML

getHTMLDocument :: Effect HTMLDocument
getHTMLDocument = do
  window <- HTML.window
  HTML.document window

getDocument :: Effect Document
getDocument = do
  htmlDocument <- getHTMLDocument
  pure $ HTML.toDocument htmlDocument

getElementById :: String -> Effect (Maybe Element)
getElementById id = do
  document <- getHTMLDocument
  DOM.getElementById id (HTML.toNonElementParentNode document)

getElementsByClassName :: String -> Effect HTMLCollection
getElementsByClassName className = do
  document <- getDocument
  DOM.getElementsByClassName className document

createTile :: Effect Element
createTile = do
  document <- getDocument
  element <- DOM.createElement "div" (document)
  DOM.setClassName "tile" element
  pure element

addTiles :: Game -> Effect Unit
addTiles (Game game) = do
  map <- getElementById "map"
  case DOM.toNode <$> map of
    Nothing -> pure unit
    Just mapNode -> for_ (Map.values game.land) \_ -> do
      tile <- createTile
      DOM.appendChild (DOM.toNode tile) mapNode
  pure unit

render :: Game -> Array Event -> Effect Unit
render (Game { day, land, money, seeds }) (_ :: (Array Event)) = do
  dayElement <- getElementById "day"
  case dayElement of
    Nothing -> pure unit
    Just element -> do
      DOM.toNode element # setTextContent (show day)
  moneyElement <- getElementById "money"
  case moneyElement of
    Nothing -> pure unit
    Just element -> do
      DOM.toNode element # setTextContent (show money)
  seedsElement <- getElementById "seeds"
  case seedsElement of
    Nothing -> pure unit
    Just element -> do
      DOM.toNode element # setTextContent (show $ length seeds)
  collection <- getElementsByClassName "tile"
  elements <- toArray collection
  void $ for_ (zip (Map.values land # Array.fromFoldable) elements) $ \(Tuple field element) ->
    element # DOM.setClassName case field of
      Grass -> "tile tile-grass"
      Dirt -> "tile tile-dirt"
      Planting
        ( Plant
            { stats: (Stats { growth })
            , seed: (Seed { daysToHarvest })
            }
        ) ->
        if growth * 2 < daysToHarvest then "tile tile-seedling"
        else "tile tile-plant"