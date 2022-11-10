module Main where

import Prelude

import Cards (Card(..))
import Data.Array (drop, length, mapMaybe, partition, replicate, uncons)
import Data.Foldable (sum)
import Data.Maybe (Maybe(..))
import Data.Traversable (sequence)
import Effect (Effect)
import Effect.Console (log)
import Plants (Plant(..), plant)
import Seeds (Seed, baseSeed, weedSeed)
import Stats (Stats(..))
import Util (doX)

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

start :: Player
start = Player
    { plants: []
    , seeds: [baseSeed, baseSeed, baseSeed, weedSeed]
    , money: 0
    }

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