module Seeds where

import Prelude

import Cards (Card, basicGrowth, basicPrice, basicSeeds, weedCard)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)
import Stats (Stats(..))

newtype Seed = Seed
    { daysToHarvest :: Int
    , genome :: Array Card
    , stats :: Stats
    }
derive instance Eq Seed
derive instance Generic Seed _
instance Show Seed where
    show = genericShow

baseSeed :: Seed
baseSeed = Seed
    { daysToHarvest: 3
    , genome:
        [ basicGrowth
        , basicGrowth
        , basicGrowth
        , basicGrowth
        , basicSeeds
        , basicSeeds
        , basicPrice
        ]
    , stats: Stats { growth: 0, price: 0, seeds: 0}
    }

weedSeed :: Seed
weedSeed = Seed
    { daysToHarvest: 3
    , genome:
        [ basicGrowth
        , basicGrowth
        , weedCard
        , basicPrice
        , basicPrice
        ]
    , stats: Stats { growth: 0, price: 0, seeds: 0}
    }