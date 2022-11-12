module Cards where

import Prelude

import Data.Generic.Rep (class Generic)
import Stats (Stats, growth, price, seeds)


newtype Card = Card
    { description :: String
    , name :: String
    , stats :: Stats
    , discard :: Int
    }
derive instance Eq Card
derive instance Generic Card _
instance Show Card where
    show (Card {name}) = name

basicGrowth :: Card
basicGrowth = Card
    { description: "Without growth your plants will die"
    , name: "Basic Growth"
    , stats: growth 1
    , discard: 0
    }

basicPrice :: Card
basicPrice = Card
    { description: "Money makes the world go round"
    , name: "Basic Money"
    , stats: price 1
    , discard: 0
    }

basicSeeds :: Card
basicSeeds = Card
    { description: "No seeds no... plants"
    , name: "Basic Seeds"
    , stats: seeds 1
    , discard: 0
    }

weedCard :: Card
weedCard = Card
    { description: "Weeds are dangerus to your plants but they grow well"
    , name: "Weeds"
    , stats: seeds 2 + growth 2
    , discard: 2
    }