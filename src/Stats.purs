module Stats where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)


newtype Stats = Stats
    { growth :: Int
    , price :: Int
    , seeds :: Int
    }
derive instance Eq Stats
derive instance Generic Stats _

instance Show Stats where
    show = genericShow

instance Semiring Stats where
    zero = Stats zero
    one = Stats one
    add (Stats a) (Stats b) = Stats (add a b)
    mul (Stats a) (Stats b) = Stats (mul a b)

growth :: Int -> Stats
growth n = Stats {growth: n, price: 0, seeds: 0}

price :: Int -> Stats
price n = Stats {growth: 0, price: n, seeds: 0}

seeds :: Int -> Stats
seeds n = Stats {growth: 0, price: 0, seeds: n}