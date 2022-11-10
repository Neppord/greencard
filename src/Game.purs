module Game where

import Prelude

import Data.Array (length, mapMaybe, partition, replicate)
import Data.Foldable (sum)
import Data.Traversable (sequence)
import Effect (Effect)
import Plants (Plant(..), age, plant, shouldHarvest)
import Seeds (Seed, baseSeed, weedSeed)
import Stats (Stats(..))

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