module Seeds where

import Prelude

import Cards (Card(..))
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Stats (Stats(..))

newtype Seed = Seed
    { daysToHarvest :: Int
    , genome :: Array Card
    , stats :: Stats
    }

derive instance Generic Seed _
instance Show Seed where
    show = genericShow