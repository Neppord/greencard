module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

data Growth = Dead | Growth Int
data PlantState = Germenation | Flower | Fruit

type CardEffect =  Plant -> Plant

newtype Card = Card
    { growth :: Growth
    , effect :: CardEffect
    }


newtype Seed = Seed
    { germination :: Int
    , flower :: Int
    , fruit :: Int
    , genome :: Array Card
    }

newtype Plant = Plant
    { cards :: Array Card
    , seed :: Seed
    , state :: PlantState
    , timeLeft :: Int
    }

baseSeed :: Seed
baseSeed = Seed
    { germination: 10 :: Int
    , flower: 10 :: Int
    , genome: [] :: Array Card
    , fruit: 10 :: Int
    }

main :: Effect Unit
main = do
    let seed = baseSeed
        plants =
            [ Plant
                  { cards: []
                  , seed: seed
                  , state: Germenation
                  , timeLeft: 10
                  }
            ]

    log "🍝"
