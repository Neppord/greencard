module Main where

import Deku.Control
import Prelude

import Control.Monad.Writer.Trans (runWriterT)
import Data.Array as Array
import Data.Map as Map
import Data.Tuple (Tuple(..), fst)
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=))
import Deku.Attributes (id_)
import Deku.Core (Nut, fixed)
import Deku.DOM (text__)
import Deku.DOM as D
import Deku.Toplevel (runInBody)
import Effect (Effect)
import FRP (foldE)
import FRP.Event (Event)
import FRP.Event.Time (interval)
import Game (Game(..), Land(..), start, tick)
import QualifiedDo.Alt as Alt

f :: forall a. Tuple (Tuple Int Int) (Land a) -> Nut
f (Tuple (x /\ y) land) =
  D.image
    Alt.do
      D.X !:= show (x * 32)
      D.Y !:= show (y * 32)
      D.Href !:= case land of
        Grass -> "images/grass_nogrow.png"
        Dirt -> "images/soil_yesgrow.png"
        Planting _ -> "images/flower1_sprout.png"
    []

main :: Effect Unit
main = runInBody Deku.do
  let
    (gameEvent :: Event Game) = foldE
      (\s _ -> tick s # runWriterT <#> fst)
      start
      (interval 500)
  gameEvent <#~> \(Game game) -> fixed
    [ D.p (id_ "stats")
        [ text_ "Day: "
        , D.span (id_ "day") [ text_ $ show game.day ]
        , text_ "Money: "
        , D.span (id_ "money") [ text_ $ show game.money ]
        , text_ "Seeds: "
        , D.span (id_ "seeds") [ text_ $ show $ Array.length game.seeds ]
        ]
    , D.svg
          Alt.do
            D.Width !:= "100vw"
            D.Height !:= "100vh"
          (game.land # Map.toUnfoldable <#> f)
    ]