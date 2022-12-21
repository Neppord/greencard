module Examples.BehaviorsVersusFlapping where

import Prelude

import Deku.Control (text)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Random (random)
import FRP.Behavior (behavior, sample)
import FRP.Event.Effect (bindToEffect)
import FRP.Event.Time (interval)

main :: Effect Unit
main = runInBody do
    text
        ( show <$> sample
            (behavior (flip bindToEffect (random <#> _)))
            (interval 250 $> add 42.0)
        )