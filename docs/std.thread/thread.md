# `std.thread`

`std.thread` exposes Kastel's cooperative task scheduler through a qualified module namespace.

It provides the high-level task operations while reusing the same VM scheduler and concurrency opcodes already used by the unqualified `spawn()`, `yield()` and `sleep()` intrinsics.

## Import

```kastel
import std.thread
```

After the import, the module is available as `thread`:

```kastel
thread.spawn(...)
thread.yield()
thread.sleep(10)
```

## `thread.spawn()`

Creates a cooperative task and returns a `Task<T>` handle.

```kastel
func worker(value: int) -> int {
    return value * 2;
}

let task: Task<int> = thread.spawn(worker, 21);
let result = task.join();
```

The first argument is the function executed by the task. Remaining arguments are passed to that function.

```kastel
func add(a: int, b: int) -> int {
    return a + b;
}

let task = thread.spawn(add, 20, 22);
let result = task.join();
```

`spawn()` is cooperative: tasks are scheduled by Kastel's scheduler rather than creating an operating-system thread for every task.

## `thread.yield()`

Voluntarily gives another ready task an opportunity to run.

```kastel
func worker() -> int {
    println("before");
    thread.yield();
    println("after");
    return 42;
}

let task = thread.spawn(worker);
let result = task.join();
```

`yield()` takes no arguments and returns `none`.

## `thread.sleep(milliseconds)`

Suspends the current task for the requested number of milliseconds and allows other ready tasks to continue.

```kastel
func worker() -> int {
    thread.sleep(10);
    return 42;
}

let task = thread.spawn(worker);
let result = task.join();
```

The argument must be an `int` (or `dynamic`). `thread.sleep(0)` is also a valid cooperative scheduling point.

## `Task<T>`

`thread.spawn()` returns a `Task<T>` where `T` is the task function's return type.

### `join()`

Waits for the task to finish and returns its result.

```kastel
func worker() -> int {
    return 42;
}

let task: Task<int> = thread.spawn(worker);
let value = task.join();
```

A failed task propagates its failure through `join()`.

### `cancel()`

Requests cancellation of a task.

```kastel
let task = thread.spawn(worker);
task.cancel();
```

Cancellation is cooperative and follows the scheduler's normal cancellation and cleanup rules.

### `status()`

Returns the current task state as a string.

The scheduler exposes these states:

| Status | Meaning |
| --- | --- |
| `ready` | The task is ready to run. |
| `running` | The task is currently executing. |
| `waiting` | The task is blocked on a cooperative wait/synchronization point. |
| `done` | The task completed successfully. |
| `failed` | The task terminated with an error. |
| `cancelled` | The task was cancelled. |

Example:

```kastel
let task = thread.spawn(worker);
let value = task.join();

println(task.status());
```

After a successful `join()`, the task status is `done`.

### `is_done()`

Returns `true` when the task is terminal (`done`, `failed`, or `cancelled`).

```kastel
let task = thread.spawn(worker);
let value = task.join();

let finished = task.is_done();
```

## `async` / `await`

`std.thread` and `async`/`await` use the same cooperative scheduler but serve different purposes.

Use `thread.spawn()` when you want to explicitly start an independent task and keep a `Task<T>` handle.

```kastel
func compute() -> int {
    thread.sleep(10);
    return 42;
}

let task = thread.spawn(compute);
let result = task.join();
```

Use `async`/`await` when asynchronous functions are part of the function interface and the caller wants to await their `Task<T>` result.

```kastel
async func compute() -> int {
    thread.sleep(10);
    return 42;
}

let task = compute();
let result = await task;
```

Both mechanisms remain cooperative; `std.thread` does not introduce a second scheduler.

## Synchronization

`std.thread` is intentionally limited to task execution and task control.

Synchronization primitives remain separate from it:

```text
std.channel
std.sync.mutex
std.sync.rwlock
std.sync.semaphore
std.sync.event
std.sync.condvar
std.sync.wait_group
std.sync.barrier
```

This keeps task scheduling separate from coordination between tasks.

## Backward compatibility

The existing unqualified intrinsics remain available:

```kastel
spawn(worker);
yield();
sleep(10);
```

`std.thread` provides the qualified API without creating a second implementation of these operations.
