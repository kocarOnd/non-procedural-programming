{- HLINT ignore "Use camelCase" -}
{-Task: a) Write a Haskell type class Queue that represents an abstract data type for a functional 
queue. Any type that is an instance of Queue should have kind * -> * (in other words, it should be 
polymorphic with a single type argument).

An instance of Queue should support these operations:

    emptyQueue - an empty queue
    isEmpty - tests whether a queue is empty, returning a Bool
    enqueue - enqueue a value, returning a new queue
    dequeue - dequeue a value, returning the value plus a new queue

For example, if MyQueue is a type that's an instance of Queue, then I can write

let q = emptyQueue :: MyQueue Int
    q1 = enqueue 5 q
    q2 = enqueue 10 q1
    e = isEmpty q2
    (x, q3) = dequeue q2
    (y, q4) = dequeue q3
    f = isEmpty q4
in (e, x, y, f)

which will evaluate to

(False,5,10,True)

b) Write a Haskell type SQueue that implements a functional queue efficiently using two stacks as 
described in these notes. SQueue should be an instance of the Queue type class.

c) Make (SQueue a) be an instance of the type class Eq, assuming that 'a' itself belongs to Eq. Two 
queues should be considered equal if they contain the same values in the same order.

> (enqueue 2 emptyQueue) == ((enqueue 5 emptyQueue) :: SQueue Int)
False

d) Make (Squeue a) be an instance of the type class Show, assuming that 'a' belongs to Show. The 
printed representation of an SQueue should look like e.g. "q[3,5,7]", where 3 is at the head of 
the queue and 7 is at the tail:

> enqueue 7 (enqueue 5 (enqueue 3 emptyQueue)) :: SQueue Int
q[3,5,7]

e) Make SQueue be an instance of the Functor type class:

> fmap (+3) (enqueue 2 (enqueue 4 emptyQueue)) :: SQueue Int
q[7,5]

f) Write a function

queue_of_nums :: Queue q => Int -> Int -> q Int

that takes integers a and b and produces a Queue containing the integers a..b, where a is at the 
head of the queue:

> queue_of_nums 1 5 :: (SQueue Int)
q[1,2,3,4,5]

Note that queue_of_nums is not specific to SQueue; it can produce any type of Queue. So it will 
have to call 'enqueue' repeatedly (either recursively, or using a fold).-}
class Queue q where
    emptyQueue :: q a
    isEmpty    :: q a -> Bool
    enqueue    :: a -> q a -> q a
    dequeue    :: q a -> (a, q a)

data SQueue a = SQueue [a] [a]

instance Queue SQueue where
  emptyQueue = SQueue [] []

  isEmpty (SQueue front back) = null front && null back

  enqueue x (SQueue front back) = SQueue front (x:back)

  dequeue (SQueue (x:xs) back) = (x, SQueue xs back)

  dequeue (SQueue [] back) = (x, SQueue front [])
    where x:front = reverse back

instance Eq a => Eq (SQueue a) where
    (SQueue f1 b1) == (SQueue f2 b2) = (f1 ++ reverse b1) == (f2 ++ reverse b2)

instance Show a => Show (SQueue a) where
    show (SQueue front back) = 'q' : show (front ++ reverse back)

instance Functor SQueue where
  fmap f (SQueue front back) = SQueue (map f front) (map f back)

queue_of_nums :: Queue q => Int -> Int -> q Int
queue_of_nums a b = foldl (flip enqueue) emptyQueue [a..b]
