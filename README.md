# 3D Chess for iPhone
[![Build Status](https://travis-ci.com/markypizz/Chess.svg?branch=master)](https://travis-ci.com/markypizz/Chess)

[![N|Solid](https://cdn4.iconfinder.com/data/icons/logos-3/1300/swift-seeklogo-128.png)](https://nodesource.com/products/nsolid)

3D Chess is a personal free-time project to develop a fully playable and functional Chess game for iOS, written in Swift. It started as a way for me to gain an introduction into some areas of iOS development I was not familiar with, such as SceneKit, but has blossomed into a fully-featured app with a focus on strong user-experience.

Background
----
At its core, this application uses a SceneKit front-end on top of a Chess logic backend known as [SwiftChess](https://github.com/SteveBarnegren/SwiftChess), which has been slightly modified to fit the needs of the application. The front-end is responsible for for translating user touches into logic for the back-end, and moving the pieces on screen  according to the back-end's response. 

I could go on and on about the incredibly rewarding challenges I've faced developing this app from a development/learning perspective. Areas such as API interfacing, basic multithreading & race-conditions, creating a "live" and polished user experience, SceneKit nodes/cameras/animations, working heavily with delegates and nested view controllers, and so much more.

Most of my specific tasks and overall workflow/progress can be seen from the [Projects](https://github.com/markypizz/Chess/projects) tab. Many of these tasks are likely not due to be completed any time soon, and many are just some bonus features if I happen to find a ton of time to waste on tackling them. Though I'm the only one really using this repository, I find the agile-esque kanban board for me to be a very effective way of keeping track of my progress.

Here's an WIP in-game shot:

<img src="https://i.imgur.com/nREbBsg.png" width="200">

Building the Project
----
Simply clone, open the workspace, and build! All necessary frameworks/Pods are included in the repository. If they don't work, ensuring CocoaPods is installed, run:
```sh
$ pod install
```
in the main project directory. This should download the necessary dependencies. If my development really hits a home run, I likely will publish this to the App Store.

License
----
My own code & app: All rights reserved.
See [LICENSE](https://github.com/markypizz/Chess/blob/master/LICENSE) for more information.

Other
----

I am always looking for suggestions on how I can make the app better, especially from a visual standpoint. Any thoughts/suggestions on my coding practices are very welcome. I am always looking for ways to improve.

I do hope you will take the time to check out some of my other work! I am especially proud of my project [MusicansToolkit](https://github.com/markypizz/MusiciansToolkit) a set of tools for musicians including a tuner, metronome, audio recorder, on-screen playable guitar, and more!
