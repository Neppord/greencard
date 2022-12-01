module Game where

import Prelude

import AppM (AppM)
import Control.Monad.Trans.Class (lift)
import Data.Array (length, mapMaybe, replicate, (..))
import Data.Array as Array
import Data.Foldable (sum)
import Data.List as List
import Data.Map (Map, values)
import Data.Map as Map
import Data.Map.Internal (fromFoldable)
import Data.Maybe (Maybe(..))
import Data.Traversable (for)
import Data.Tuple (Tuple(..))
import Plants (Plant(..), age, plant, shouldHarvest)
import Seeds (Seed, baseSeed, weedSeed)
import Stats (Stats(..))
import Util (shuffle)

data Land a = Grass | Dirt | Planting a

derive instance Functor Land
derive instance Eq a => Eq (Land a)

type Coordinate = Tuple Int Int
type Field = Map Coordinate (Land Plant)

newtype Game = Game
  { land :: Field
  , seeds :: Array Seed
  , money :: Int
  , day :: Int
  , width :: Int
  , height :: Int
  }

instance Show Game where
  show (Game game) =
    "Money: " <> show game.money <> "\n"
      <> "Grass: "
      <> show (grass)
      <> "\n"
      <> "Plants: "
      <> show (plants)
      <> "\n"
      <> "Free: "
      <> show (free)
      <> "\n"
      <> "Seeds: "
      <> show (length game.seeds)
    where
    grass = game.land
      # values
      # List.filter case _ of
          Grass -> true
          _ -> false
      # List.length
    plants = game.land
      # values
      # List.filter case _ of
          Planting _ -> true
          _ -> false
      # List.length
    free = game.land
      # values
      # List.filter case _ of
          Dirt -> true
          _ -> false
      # List.length

agePlants :: Game -> AppM Game
agePlants (Game game) = do
  pure $ Game $ game
    { land = game.land
        # map case _ of
            Dirt -> Dirt
            Grass -> Grass
            Planting p -> case age p of
              Nothing -> Dirt
              Just p' -> Planting p'
    }

harvestPlants :: Game -> AppM Game
harvestPlants (Game game) = do
  pure $ Game $ game
    { land = game.land
        # map case _ of
            Planting p ->
              if shouldHarvest p then Dirt
              else Planting p
            x -> x
    , money = game.money + revenue
    , seeds = game.seeds <> seeds'
    }
  where
  harvested = game.land
    # Map.values
    # Array.fromFoldable
    # mapMaybe case _ of
        Planting p ->
          if shouldHarvest p then Just p
          else Nothing
        _ -> Nothing
  revenue = harvested
    # map (\(Plant { stats }) -> stats)
    # map (\(Stats { price }) -> price)
    # sum
  seeds' = do
    (Plant { seed, stats: (Stats { seeds }) }) <- harvested
    replicate seeds seed

plantSeeds :: Game -> AppM Game
plantSeeds (Game game) = do
  dirtPositions <- game.land
    # Map.filter (_ == Dirt)
    # Map.keys
    # Array.fromFoldable
    # shuffle
    # lift
  seeds <- game.seeds # shuffle # lift
  let pairs = (Array.zip dirtPositions seeds)
  maps <- for pairs \(Tuple cord seed) -> do
    p <- plant seed # lift
    pure $ Map.singleton cord (Planting p)
  pure $ Game $ game
    { land = Map.union (Map.unions maps) game.land
    , seeds = Array.drop (Array.length pairs) seeds
    }

cost :: Int
cost = 100

clearGrass :: Game -> AppM Game
clearGrass (Game game) = do
  let times = game.money / cost
  cordsToClear <- game.land
    # Map.filter (_ == Grass)
    # Map.keys
    # Array.fromFoldable
    # shuffle
    # map (Array.take times)
    # lift
  pure $ Game $ game
    { land = Array.foldr (Map.update (\_ -> Just Dirt)) game.land cordsToClear
    , money = game.money - (cost * Array.length cordsToClear)
    }

tick :: Game -> AppM Game
tick =
  addOneDay
    >=> clearGrass
    >=> plantSeeds
    >=> agePlants
    >=> harvestPlants

addOneDay :: Game -> AppM Game
addOneDay (Game game) = do
  pure $ Game game { day = game.day + 1 }

start :: Game
start = Game
  { day: 0
  , land: fromFoldable do
      x <- 0 .. width
      y <- 0 .. height
      pure $ Tuple (Tuple x y) Grass
  , seeds: [ baseSeed, baseSeed, weedSeed, weedSeed ]
  , money: 400
  , width
  , height
  }
  where
  width = 16
  height = 16