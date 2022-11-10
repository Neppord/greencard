module Plants where

import Prelude

import Cards (Card)
import Data.Generic.Rep (class Generic)
import Effect (Effect)
import Seeds (Seed(..))
import Stats (Stats)
import Util (shuffle)

newtype Plant = Plant
    { daysToHarvest :: Int
    , cards :: Array Card
    , stats :: Stats
    , seed :: Seed
    }
derive instance Generic Plant _
instance Show Plant where
    show (Plant p) = show p.stats


plant :: Seed -> Effect Plant
plant (Seed seed) = do
    cards <- shuffle seed.genome
    pure $ Plant
        { cards
        , stats: seed.stats
        , daysToHarvest : seed.daysToHarvest
        , seed : Seed seed
        }