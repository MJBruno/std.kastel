import std.thread
import std.sync.mutex
import std.sync.rwlock
import std.sync.semaphore
import std.sync.event
import std.sync.channel
import std.sync.condvar
import std.sync.wait_group
import std.sync.barrier

func worker(lock: Mutex, values: Channel<int>) -> int {
    lock.lock();
    values.send(42);
    lock.unlock();
    return 7;
}

let lock = mutex.create();
let read_write = rwlock.create();
let permits = semaphore.create(2);
let ready = event.create();
let values = channel.create();
let condition = condvar.create(lock);
let group = wait_group.create();
let rendezvous = barrier.create(1);

let task = thread.spawn(worker, lock, values);
let received = values.recv();
let result = task.join();

println("received = " + str(received));
println("result = " + str(result));
println("ready = " + str(ready.is_set()));
println("permits = " + str(permits.available()));
println("group_done = " + str(group.is_done()));
println("barrier = " + str(rendezvous.wait()));
