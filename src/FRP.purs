module FRP where

import Prelude

import Control.Alt ((<|>))
import Effect (Effect)
import FRP.Event (Event)
import FRP.Event.Class (fix, sampleOnRight)
import FRP.Event.Effect (bindToEffect)

foldE :: forall a b. (b -> a -> Effect b) -> b -> Event a -> Event b
foldE f b e = fix \i -> flip bindToEffect identity
  (sampleOnRight (i <|> pure b) ((flip f) <$> e))

