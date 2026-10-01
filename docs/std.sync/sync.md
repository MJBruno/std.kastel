# `std.sync`

Kastel expose les primitives de synchronisation sous des modules qualifiés `std.sync.*`.

Les modules sont des façades minces autour des primitives runtime existantes. Ils n'introduisent pas de deuxième implémentation des verrous, canaux ou mécanismes d'attente.

## Mutex

```kastel
import std.sync.mutex

let lock = mutex.create();

func worker() {
    lock.lock();
    // section critique
    lock.unlock();
}
```

`lock()` et `unlock()` sont coopératifs et doivent être utilisés dans le contexte de tâche prévu par le runtime.

## RwLock

```kastel
import std.sync.rwlock

let lock = rwlock.create();
```

Le verrou fournit les opérations de lecture et d'écriture définies par `RwLock`.

## Semaphore

```kastel
import std.sync.semaphore

let permits = semaphore.create(3);
```

La capacité doit être strictement positive.

## Event

```kastel
import std.sync.event

let ready = event.create();
```

Un événement peut être signalé, attendu et réinitialisé selon son API runtime.

## Channel

```kastel
import std.sync.channel

let values: Channel<int> = channel.create();
let bounded = channel.create_bounded(16);
```

Le canal reste coopératif et partage le scheduler existant. Les opérations `send`, `recv`, `try_send`, `try_recv`, `close` et `select` utilisent les mêmes primitives runtime que l'API native actuelle.

## Condvar

```kastel
import std.sync.mutex
import std.sync.condvar

let lock = mutex.create();
let condition = condvar.create(lock);
```

Une `Condvar` est toujours associée à un `Mutex`.

## WaitGroup

```kastel
import std.sync.wait_group

let group = wait_group.create();
group.add(2);
```

Le `WaitGroup` sert à coordonner l'achèvement de plusieurs tâches.

## Barrier

```kastel
import std.sync.barrier

let barrier = barrier.create(4);
```

Une barrière attend que le nombre requis de participants soit atteint.

## Avec `std.thread`

Les responsabilités restent séparées :

```kastel
import std.thread
import std.sync.mutex

let lock = mutex.create();
let task = thread.spawn(worker, lock);

let result = task.join();
```

`std.thread` gère l'exécution des tâches et les points coopératifs. `std.sync.*` gère la coordination entre tâches.

## API native conservée

Les primitives globales historiques (`mutex()`, `rwlock()`, `semaphore(...)`, etc.) restent disponibles pour compatibilité. Les modules `std.sync.*` fournissent l'API qualifiée destinée au code moderne.
