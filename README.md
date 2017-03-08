# Swift Cron (Scheduled & Repeating Functions in Swift)

<p align="center">
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift 3.0">
    </a>
</p>

Welcome! This project will hopefully help you run scheduled and repeating functions in Swift! This is a very basic start to having a robust cron application in pure Swift. There is still a lot of work to be done. Pull requests are encouraged and welcomed... 😃

## Setup

To Add Cron to your Project, you first need to add this repository as a dependency in Package.swift:

```
.Package(url: "https://github.com/rymcol/SwiftCron.git", majorVersion: 0)
```

Second, you need to add a new executable target in Sources, and in Package.swift. You should end up with a directory structure that is at minimum like this:

Example-Project
├── Sources
│   ├── main.swift
└── Package.swift

And a corresponding Package.swift that looks similar to this:

```
let package = Package(
    name: "Swift-Cron-Test",
    targets: [],
    dependencies: [
    .Package(url: "git@github.com:rymcol/SwiftCron.git", majorVersion: 0)
    ]
)
```

## Usage

### Required Executable

Your main.swift will need some boilerplate code. You can grab this from the example repository, but you will need an absolute minimum of:

```
import Foundation
import SwiftCron

var shouldKeepRunning = true        // change this `false` to stop the application from running
let theRL = RunLoop.current         // Need a reference to the current run loop

// Welcome to Cron!
// If you add frequency: X to the intializer here, cron will attempt to run your jobs every X seconds
// If you do not add a frequency, it defaults to 60 (every minute)
let cron = Cron()


//Define Functions to Run Here, Elsewhere in your project, or import your own frameworks 


//Make jobs
let job = CronJob(funcNameHere)

//Add jobs to queue
cron.add(job)

//Start Cron So the Jobs Run
cron.start()

//Start and Keep Running the Run Loop
while shouldKeepRunning && theRL.run(mode: .defaultRunLoopMode, before: .distantFuture) {  }

```

Everything should go in the order it is in the example. You may also import functions from another Framework or write your own inside new files in your project. Cron will accept any valid functions that have no return and no parameters. 

There are several things going on in this example, so I will break them down, and Cron has a lot more built in that is shown, which is handled by default values. 

First, we create a reference to the run loop, as well as `var shouldKeepRunning`. To terminate the application at any time, you can set this to false. 

#### The Magical Cron Class

Next, we initialize SwiftCron with `let cron = Cron()`. This initializer actually takes two parameters, but has defaults set for them. The actual initializer is declared as `public init(frequency: TimeInterval = 60, cronStorage: CronStore = MemoryCronStore())`. The `frequency:` accepts a double and is used to define how often (in seconds) that cron checks for jobs and runs them. The default is every minute, but you can change this to suit your needs. The `CronStore:` accepts any class that conforms to the `CronStore` protocol and is responsible for storing cron jobs. The default implementation is in-memory storage and if this value is not passed will be created for you. 

##### A note about CronStore (making your own job store)

If you want more persistent storage, some is in development. If you don't want to wait for that, you can create your own. The protocol you need to follow is: 

//Storage Protocol
public protocol CronStore {
    var jobs: [CronJob] { get }
    
    func add(_ job: CronJob)
    func remove(_ job: CronJob)
}

i.e. your class needs to give Cron a way to add new jobs, remove old jobs, and you must give it a way to access the jobs in your store, by way of an array. Make sure that you load jobs from your database or other persistent storage during your class initializer to make sure they're ready to go for the next part. 

#### Making Cron Jobs

After cron is initialized, you need to make jobs. The model is provided for you, and the important part is its initializer: `public init(_ method: @escaping () -> (), executeAfter date: Date = Date(), allowsSimultaneous: Bool = false, repeats: Bool = false, repeatEvery interval: TimeInterval? = nil)`. There are (again) a lot of defaults here to make things easy, but robust. 

The simplest way to make a job is `let job = CronJob(funcNameHere)` where `funcNameHere` is the method you'd like to run. Again, this must take no params and have no return (-> Void). What this does is creates a single job to run right now. If that's all you need, great, but most of you are probably here for more. 

The `executeAfter:` parameter accepts a Date. The default is right now. When passed a date in the future, this will prevent the job from running until after that date has passed and the Cron class checks for jobs to run (see `interval:` in the Cron init above). 

The `allowsSimultaneous:` parameter is a boolean that defaults to false. If this value is false, this will prevent repeating jobs from running if the exact same job is already running. This is useful if you want to make sure that a method does not start if it's currently running, regardless to it being set to repeat. If you set this value to true, it will allow cron to start the same job over even if it is already running. 

The `repeats:` parameter is also a boolean. When set to true, this value will cause the job to repeat. Be careful, if set along with `allowsSimultaneous`, you can get a lot of the same thing running at once, because it will repeat immediately. 

The `repeatEvery:` parameter takes a TimeInterval (double) and sets repeats to true. If you pass this, `repeats:` will always be true, even if you pass it as false or don't include it at all. Passing a value in seconds to this will cause it to repeat in that number of seconds. For example, if you were to pass `repeatEvery: 86400` your job would run on start, and then 24 hours later after the next cron interval checks for jobs. More robust functionality here will hopefully come later. 

#### Adding Jobs

After defining jobs, `cron.add(job)` will add that job to cron. You can also call this method at any time, even after cron has started in order to add new jobs. 

#### Starting Cron

`cron.start()` will start the Cron machine running, thus running any jobs added, assuming they're beyond their `executeAfter:` Date. 

#### Keeping it all Running

Last, but certainly not least is:

```
//Start and Keep Running the Run Loop
while shouldKeepRunning && theRL.run(mode: .defaultRunLoopMode, before: .distantFuture) {  }
```

This **MUST** be at the **END** of main.swift, because it keeps the application running. Without this line at the end, the application would simply terminate on launch. 

Hopefully there is more to come. For now, please enjoy. 