module Main where

import Prelude

import Cards (Card(..), basicGrowth, basicPrice, basicSeeds)
import Data.Array (mapMaybe, uncons)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Show.Generic (genericShow)
import Effect (Effect)
import Effect.Console (log)
import Stats (Stats(..))

newtype Seed = Seed
    { daysToHarvest :: Int
    , genome :: Array Card
    , stats :: Stats
    }

derive instance Generic Seed _
instance Show Seed where
    show = genericShow

newtype Plant = Plant
    { daysToHarvest :: Int
    , cards :: Array Card
    , stats :: Stats
    , seed :: Seed
    }
derive instance Generic Plant _
instance Show Plant where
    show (Plant p) = show p.stats

baseSeed :: Seed
baseSeed = Seed
    { daysToHarvest: 3
    , genome:
        [ basicGrowth
        , basicGrowth
        , basicGrowth
        , basicSeeds
        , basicPrice
        ]
    , stats: Stats { growth: 0, price: 0, seeds: 0}
    }



plant :: Seed -> Plant
plant (Seed seed) = Plant
    { cards: seed.genome
    , stats: seed.stats
    , daysToHarvest : seed.daysToHarvest
    , seed : Seed seed
    }

drawCard :: Plant -> Maybe Plant
drawCard (Plant p) = case uncons p.cards of
    Nothing -> Nothing
    Just {head: (Card card), tail} -> Just $ Plant $ p
        { cards = tail
        , stats = p.stats + card.stats
        }

tick :: Array Plant -> Effect (Array Plant)
tick plants = do
    log $ show plants
    pure $ mapMaybe drawCard plants

main :: Effect Unit
main = do
    log "day 1"
    newPlants <- tick [ plant baseSeed ]
    log ""
    log "day 2"
    newerPlants <- tick newPlants
    log ""
    log "day 3"
    log $ show newerPlants
    pure unit