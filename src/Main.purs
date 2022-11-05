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


shuffle :: forall a. Array a -> Effect (Array a)
shuffle a = do
    pure a

plant :: Seed -> Effect Plant
plant (Seed seed) = do
    cards <- shuffle seed.genome
    pure $ Plant
        { cards
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
    p <- plant baseSeed
    log "day 1"
    newPlants <- tick [ p ]
    log ""
    log "day 2"
    newerPlants <- tick newPlants
    log ""
    log "day 3"
    log $ show newerPlants
    pure unit