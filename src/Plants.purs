module Plants where

import Prelude

import Cards (Card(..))
import Data.Array (drop, uncons)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Seeds (Seed(..))
import Stats (Stats(..))
import Util (shuffle)

newtype Plant = Plant
  { daysToHarvest :: Int
  , cards :: Array Card
  , stats :: Stats
  , seed :: Seed
  }

derive instance Eq Plant
derive instance Generic Plant _
instance Show Plant where
  show (Plant p) = show p.stats

plant :: Seed -> Effect Plant
plant (Seed seed) = do
  cards <- shuffle seed.genome
  pure $ Plant
    { cards
    , stats: seed.stats
    , daysToHarvest: seed.daysToHarvest
    , seed: Seed seed
    }

age :: Plant -> Maybe Plant
age (Plant p) = case uncons p.cards of
  Nothing -> Nothing
  Just { head: (Card card), tail } -> Just $ Plant $ p
    { cards = drop card.discard tail
    , stats = p.stats + card.stats
    }

shouldHarvest :: Plant -> Boolean
shouldHarvest (Plant { stats: (Stats { growth }), daysToHarvest }) =
  growth >= daysToHarvest
