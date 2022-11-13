module Util where

import Prelude

import Data.Array (foldl, length, replicate, sortWith, zip, (..))
import Data.Traversable (for)
import Data.Tuple (fst, snd)
import Effect (Effect)
import Effect.Random (random)
import Effect.Timer (setTimeout)


doX :: forall a. Int -> (Int -> a -> Effect a) -> a -> Effect a
doX x f = chain ticks
    where
        chain :: Array (a -> Effect a) -> a -> Effect a
        chain = foldl (>=>) pure
        ticks :: Array (a -> Effect a)
        ticks =  f <$> 0..x

doEvery :: forall a. Int -> (a -> Effect a) -> a -> Effect Unit
doEvery t f a = do
    a' <- f a
    void $ setTimeout t $ doEvery t f a'



shuffle :: forall a. Array a -> Effect (Array a)
shuffle a = do
    let actions = replicate (length a) random
    numbers <- for actions identity
    pure $ snd <$> sortWith fst (zip numbers a)
