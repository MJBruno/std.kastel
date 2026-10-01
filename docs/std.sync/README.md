# std.sync next

Files to add to the Kastel repository:

- `std/sync/mutex.ks`
- `std/sync/rwlock.ks`
- `std/sync/semaphore.ks`
- `std/sync/event.ks`
- `std/sync/channel.ks`
- `std/sync/condvar.ks`
- `std/sync/wait_group.ks`
- `std/sync/barrier.ks`
- `docs/sync.md`
- `docs/examples/std_sync_complete_demo.ks`

API convention:

- `mutex.create()`
- `rwlock.create()`
- `semaphore.create(capacity)`
- `event.create()`
- `channel.create()`
- `channel.create_bounded(capacity)`
- `condvar.create(mutex)`
- `wait_group.create()`
- `barrier.create(parties)`
