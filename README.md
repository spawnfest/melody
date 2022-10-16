# Melody by Sandesh Soni - spawnfest

Partition Supervisor across nodes in a cluster.

Our Example.
We log some visitor visited a city.
At the end I want cumulative data for given period of time.
10,000 people visited this city in last one hour.

city data goes in one supervisor.
We Partition this. i.e few cities data will go to Partition 1, few to Partition 2, Partition 3, etc

## Instructions

```
cd Split
iex -S mix
iex(1)> Split.run_supervised
```


## Additional Example.
The Partition Supervisor example refers example by Alex Koutomos. [Code](https://github.com/BeamBasket/beam_basket_talk)
The Aim of participation is to try to create a Partition Supervisor that runs across nodes in cluster. If the Steps below are incomplete, then this experiment needs more time.


## Steps
- [x] Implement Partition Supervisor on single Node
- [ ] Create a cluster of nodes
- [ ] Test sending message across nodes. connect nodes by pg or global or whatever.
- [ ] Implement Partition Supervisor in a way that partitions run on different Nodes.


## About Me
- Myself Sandesh Soni
- India.
- Open to work (fulltime/part-time)
- contact - hello at myname dot com (h**o@sa*****s**i.com)
