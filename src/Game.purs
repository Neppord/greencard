module Game where

import Prelude

import Data.Array (length, mapMaybe, replicate, uncons, (:))
import Data.Foldable (sum)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Plants (Plant(..), age, plant, shouldHarvest)
import Seeds (Seed, baseSeed, weedSeed)
import Stats (Stats(..))

data Land a = Grass | Dirt a
derive instance Functor Land

type Field = Array (Land (Maybe Plant))

newtype Game = Game
    { land :: Field
    , seeds :: Array Seed
    , money :: Int
    }
instance Show Game where
    show (Game game) =
        "Money: " <> show game.money <> "\n"
        <> "land: " <> show (length game.land) <> "\n"
        <> "seeds: " <> show (length game.seeds)

agePlants :: Game -> Game
agePlants (Game game) = Game $ game
    { land = game.land
        # \land -> do
        l <- land
        l # map case _ of
            Nothing -> Nothing
            Just p -> age p
          # pure
    }

harvestPlants :: Game -> Game
harvestPlants (Game game) = Game $ game
    { land = game.land
        # map case _ of
            Dirt (Just p) ->
                if shouldHarvest p
                then Dirt Nothing
                else Dirt (Just p)
            x -> x
    , money = game.money + revenue
    , seeds = game.seeds <> seeds'
    }
    where
        harvested = game.land
            # mapMaybe case _ of
                Dirt (Just p) ->
                    if shouldHarvest p
                    then Just p
                    else Nothing
                x -> Nothing
        revenue = harvested
            # map (\(Plant {stats}) -> stats)
            # map (\(Stats {price}) -> price)
            # sum
        seeds' = do
            (Plant {seed, stats: (Stats {seeds})}) <- harvested
            replicate seeds seed

plantSeeds :: Game -> Effect Game
plantSeeds (Game game) = do
    {land, seeds} <- go game.land game.seeds
    pure $ Game $ game { land = land , seeds = seeds }
    where
        go :: Field -> Array Seed -> Effect { land:: Field, seeds :: Array Seed}
        go land seeds = case uncons land of
            -- no land left
            Nothing -> pure {land, seeds}
            Just {head: Dirt (Nothing), tail} -> case uncons seeds of
                -- no seeds left
                Nothing -> pure {land, seeds}
                Just {head: seed, tail: seedTail} -> do
                    plant' <- plant seed
                    {land: land', seeds: seeds'} <- go tail seedTail
                    pure $ {land: (Dirt (Just plant')) : land' , seeds: seeds'}
            -- can't plant in this land
            Just {head, tail} -> do
                {land: land', seeds: seeds'} <- go tail seeds
                pure {land: head : land', seeds: seeds'}

tick :: Game -> Effect Game
tick game = do
    game' <- plantSeeds game
    pure $ harvestPlants $ agePlants game'

start :: Game
start = Game
    { land:
        [ Grass, Grass, Grass
        , Grass, Dirt Nothing, Grass
        , Grass, Grass, Grass
        ]
    , seeds: [baseSeed, baseSeed, baseSeed, weedSeed]
    , money: 0
    }