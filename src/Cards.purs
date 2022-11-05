module Cards where

import Prelude

import Data.Generic.Rep (class Generic)
import Stats (Stats, growth, price, seeds)

newtype Card = Card
    { description :: String
    , name :: String
    , stats :: Stats
    }
derive instance Generic Card _
instance Show Card where
    show (Card {name}) = name

basicGrowth :: Card
basicGrowth = Card
    { description: "Without growth your plants will die"
    , name: "Basic Growth"
    , stats: growth 1
    }

basicPrice :: Card
basicPrice = Card
    { description: "Money makes the world go round"
    , name: "Basic Money"
    , stats: price 1
    }

basicSeeds :: Card
basicSeeds = Card
    { description: "No seeds no... plants"
    , name: "Basic Seeds"
    , stats: seeds 1
    }