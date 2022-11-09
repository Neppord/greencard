module Main where

import Prelude

import Cards (Card(..), basicGrowth, basicPrice, basicSeeds, weedCard)
import Data.Array (drop, foldl, length, mapMaybe, partition, replicate, sortWith, uncons, zip, (..))
import Data.Foldable (sum)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Traversable (for, sequence)
import Data.Tuple (fst, snd)
import Effect (Effect)
import Effect.Console (log)
import Effect.Random (random)
import Seeds (Seed(..))
import Stats (Stats(..))

newtype Plant = Plant
    { daysToHarvest :: Int
    , cards :: Array Card
    , stats :: Stats
    , seed :: Seed
    }
derive instance Generic Plant _
instance Show Plant where
    show (Plant p) = show p.stats


shuffle :: forall a. Array a -> Effect (Array a)
shuffle a = do
    let actions = replicate (length a) random
    numbers <- for actions identity
    pure $ snd <$> sortWith fst (zip numbers a)

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
        { cards = drop card.discard tail
        , stats = p.stats + card.stats
        }

shouldHarvest :: Plant -> Boolean
shouldHarvest (Plant {stats: (Stats {growth}), daysToHarvest}) =
    growth >= daysToHarvest

newtype Player = Player
    { plants :: Array Plant
    , seeds :: Array Seed
    , money :: Int
    }
instance Show Player where
    show (Player player) =
        "Money: " <> show player.money <> "\n"
        <> "plants: " <> show (length player.plants) <> "\n"
        <> "seeds: " <> show (length player.seeds)

agePlants :: Player -> Player
agePlants (Player player) = Player $ player
    { plants = mapMaybe drawCard player.plants
    }

harvestPlants :: Player -> Player
harvestPlants (Player player) = Player $ player
    { plants = harvested.no
    , money = player.money + revenue
    , seeds = player.seeds <> seeds'
    }
    where
        harvested = partition shouldHarvest player.plants
        revenue = harvested.yes
            # map (\(Plant {stats}) -> stats)
            # map (\(Stats {price}) -> price)
            # sum
        seeds' = do
            (Plant {seed, stats: (Stats {seeds})}) <- harvested.yes
            replicate seeds seed

plantSeeds :: Player -> Effect Player
plantSeeds (Player player) = do
    plants <- sequence $ plant <$> player.seeds
    pure $ Player $ player
        { plants = player.plants <> plants
        , seeds = []
        }

tick :: Player -> Effect Player
tick player = do
    player' <- plantSeeds player
    pure $ harvestPlants $ agePlants player'

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

start :: Player
start = Player
    { plants: []
    , seeds: [baseSeed, baseSeed, baseSeed, weedSeed]
    , money: 0
    }

doX :: forall a. Int -> (Int -> a -> Effect a) -> a -> Effect a
doX x f = chain ticks
    where
        chain :: Array (a -> Effect a) -> a -> Effect a
        chain = foldl (>=>) pure
        ticks :: Array (a -> Effect a)
        ticks =  f <$> 0..x

main :: Effect Unit
main = do
    let numberOfDays = 20
    player <- start # doX numberOfDays \ d player -> do
      log $ "Day " <> show d
      log $ show player
      log ""
      tick player
    log $ "Day " <> show numberOfDays
    log $ show player
    log ""