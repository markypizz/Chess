# 3D Chess for iPhone

[![N|Solid](https://cdn4.iconfinder.com/data/icons/logos-3/1300/swift-seeklogo-128.png)](https://nodesource.com/products/nsolid)

3D Chess is a personal free-time project to develop a fully playable and functional Chess game for iOS, written in Swift. It started as a way for me to gain an introduction into some areas of iOS development I was not familiar with, such as SceneKit, but has blossomed into a fully-featured app with a focus on strong user-experience.

Background
----
At its core, this application uses a SceneKit front-end on top of a Chess logic backend known as [SwiftChess](https://github.com/SteveBarnegren/SwiftChess), which has been slightly modified to fit the needs of the application. A central Chess class is the hub of communication across modules, as it contains some static constants, image name references, references to the two scenes (the intro background scene, and the in-game scene), and the user preferences for board and material type.

Much of this project's time has been spent tackling problems I haven't faced before, especially communicating with nodes in SceneKit. More recently, a huge subject of my time has been spent trying to find a way to integrate Stockfish to provide a stronger, more reliable AI. Stockfish, written in C++ won't play nicely with Swift, and is generally only compatible (though still barely) with Objective-C. I have since turned my sights to a [javascript port of Stockfish](https://github.com/exoticorn/stockfish-js), and I have been investigating ways to bridge javascript and Swift. Attempts to instantiate a JSContext worker object with this javascript binary have been unsuccessful so far, (though I haven't given up yet). If I can manage to work this out, I may have a heck of an app on my hands.

Most of my workflow and progress can be seen from the [Projects](https://github.com/markypizz/Chess/projects) tab. Many of these tasks are likely not due to be completed any time soon, and many are just some bonus features if I happen to find a ton of time to waste on tackling them, including online play.

Here's a WIP photo of the main menu. The board in the background rotates slowly:

<img src="https://i.imgur.com/vvCIIS7.png" width="200">

Building the Project
----
Simply clone, open the workspace, and build! All necessary frameworks/Pods are included in the repository. If they don't work, ensuring CocoaPods is installed, run:
```sh
$ pod install
```
in the main project directory. This should download the necessary dependencies. If my development really hits a home run, I likely will publish this to the App Store.

License
----
Chess piece models are royalty free, created by Polylel from cgtrader.com  
All images and graphics are public domain.  
I claim ownership of my own code. All rights reserved.  
No permission granted to sell this work or sell any modifications without permission.

Other
----
I do hope you will take the time to check out some of my other work! I am especially proud of my project [MusicansToolkit](https://github.com/markypizz/MusiciansToolkit) a set of tools for musicians including a tuner, metronome, audio recorder, on-screen playable guitar, and more!
