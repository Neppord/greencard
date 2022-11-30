module Game where

import Prelude

import Data.Array (filter, length, mapMaybe, replicate, reverse, uncons, (:))
import Data.Foldable (sum)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Plants (Plant(..), age, plant, shouldHarvest)
import Seeds (Seed, baseSeed, weedSeed)
import Stats (Stats(..))
import AppM (AppM)
import Control.Monad.Trans.Class (lift)
import Data.Tuple (Tuple(..))
import Data.Map.Internal (Map)

data Land a = Grass | Dirt | Planting a

derive instance Functor Land
derive instance Eq a => Eq (Land a)

type Field = Array (Land Plant)
type Coordinate = Tuple Int Int
type MapField = Map Coordinate (Land Plant)

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
      # filter case _ of
          Grass -> true
          _ -> false
      # length
    plants = game.land
      # filter case _ of
          Planting _ -> true
          _ -> false
      # length
    free = game.land
      # filter case _ of
          Dirt -> true
          _ -> false
      # length

agePlants :: Game -> Game
agePlants (Game game) = Game $ game
  { land = game.land
      # map case _ of
          Dirt -> Dirt
          Grass -> Grass
          Planting p -> case age p of
            Nothing -> Dirt
            Just p' -> Planting p'
  }

harvestPlants :: Game -> Game
harvestPlants (Game game) = Game $ game
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

plantSeeds :: Game -> Effect Game
plantSeeds (Game game) = do
  { land, seeds } <- go game.land game.seeds
  pure $ Game $ game { land = land, seeds = seeds }
  where
  go :: Field -> Array Seed -> Effect { land :: Field, seeds :: Array Seed }
  go land seeds = case Tuple (uncons land) (uncons seeds) of
    Tuple Nothing _ -> pure { land, seeds } -- no land left
    Tuple _ Nothing -> pure { land, seeds } -- no seeds left
    Tuple (Just { head: Dirt, tail }) (Just { head: seed, tail: seedTail }) -> do
      plant' <- plant seed
      { land: land', seeds: seeds' } <- go tail seedTail
      pure $ { land: Planting plant' : land', seeds: seeds' }
    Tuple (Just { head, tail }) _ -> do -- can't plant in this land
      { land: land', seeds: seeds' } <- go tail seeds
      pure { land: head : land', seeds: seeds' }

clearGrass :: Game -> Game
clearGrass (Game game) = Game $ game
  { land = reverse result.acc <> result.land
  , money = result.money
  }
  where
  cost = 100
  result = go { acc: [], land: game.land, money: game.money }
  go { acc, land, money } =
    if money < cost then { acc, land, money }
    else case uncons land of
      Nothing -> { acc, land, money }
      Just { head: Grass, tail } -> go
        { acc: Dirt : acc
        , land: tail
        , money: money - cost
        }
      Just { head, tail } ->
        go { acc: head : acc, land: tail, money }

tick :: Game -> AppM Game
tick game = do
  game' <- lift $ plantSeeds $ clearGrass $ addOneDay game
  pure $ harvestPlants $ agePlants game'

addOneDay :: Game -> Game
addOneDay (Game game) = Game game { day = game.day + 1 }

start :: Game
start = Game
  { day: 0
  , land: replicate (width * height) Grass
  , seeds: [ baseSeed, baseSeed, weedSeed, weedSeed ]
  , money: 400
  , width
  , height
  }
  where
  width = 16
  height = 16