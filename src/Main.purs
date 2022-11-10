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

age :: Plant -> Maybe Plant
age (Plant p) = case uncons p.cards of
    Nothing -> Nothing
    Just {head: (Card card), tail} -> Just $ Plant $ p
        { cards = drop card.discard tail
        , stats = p.stats + card.stats
        }

shouldHarvest :: Plant -> Boolean
shouldHarvest (Plant {stats: (Stats {growth}), daysToHarvest}) =
    growth >= daysToHarvest

newtype Game = Game
    { plants :: Array Plant
    , seeds :: Array Seed
    , money :: Int
    }
instance Show Game where
    show (Game game) =
        "Money: " <> show game.money <> "\n"
        <> "plants: " <> show (length game.plants) <> "\n"
        <> "seeds: " <> show (length game.seeds)

agePlants :: Game -> Game
agePlants (Game game) = Game $ game
    { plants = mapMaybe age game.plants
    }

harvestPlants :: Game -> Game
harvestPlants (Game game) = Game $ game
    { plants = harvested.no
    , money = game.money + revenue
    , seeds = game.seeds <> seeds'
    }
    where
        harvested = partition shouldHarvest game.plants
        revenue = harvested.yes
            # map (\(Plant {stats}) -> stats)
            # map (\(Stats {price}) -> price)
            # sum
        seeds' = do
            (Plant {seed, stats: (Stats {seeds})}) <- harvested.yes
            replicate seeds seed

plantSeeds :: Game -> Effect Game
plantSeeds (Game game) = do
    plants <- sequence $ plant <$> game.seeds
    pure $ Game $ game
        { plants = game.plants <> plants
        , seeds = []
        }

tick :: Game -> Effect Game
tick game = do
    game' <- plantSeeds game
    pure $ harvestPlants $ agePlants game'

start :: Game
start = Game
    { plants: []
    , seeds: [baseSeed, baseSeed, baseSeed, weedSeed]
    , money: 0
    }

main :: Effect Unit
main = do
    let numberOfDays = 20
    game <- start # doX numberOfDays \ d game -> do
      log $ "Day " <> show d
      log $ show game
      log ""
      tick game
    log $ "Day " <> show numberOfDays
    log $ show game
    log ""