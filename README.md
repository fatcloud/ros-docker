# ROS Docker Packages

Docker Image wrappers and config scripts for various [ROS](http://www.ros.org/) (Robot Operating System) packages I have needed for my projects.  I tried to keep with Docker's simple-purpose image/container philosophy.  As such, you will need to use Docker's experimental networking to have the various containers play nicely together (more below).


## Use with Docker Compose

A sample Docker Compose file is included to show you how to launch each package, including a rosmaster image for running the roscore node.

Be sure you are running Docker Compose with Experimental Networking enabled. (For more information see my post: [Docker Experimental Networking and ROS](http://toddsampson.com/post/131227320927/docker-experimental-networking-and-ros)):

`docker-compose --x-networking up -d`


## Working Packages

* [ROS Master](http://wiki.ros.org/roscore) -- Simple laucch script around ROS's official roscore Docker Image.
* [ROS Tutorials](http://wiki.ros.org/ROS/Tutorials) -- Full tutorials are installed, Docker Compose only runs talker/listener
* [ROS Image View](http://wiki.ros.org/image_view) -- Full image-pipeline is installed, Docker Compose only launches image_view
* [ROS Leap Motion](http://wiki.ros.org/leap_motion)
* [ROS USB Camera](http://wiki.ros.org/libuvc_camera)


## Notes

* RVIS is not working yet -- it appears to be restarting the Linux display.  I would love ideas/code to help fix it.
* I am working on making each package available on Docker Hub as an automated build.  If one is missing because I haven't added it yet, use the `build: ros-package-name/.` in the docker-compose.yml to build it.
* I made these Docker Images as a fast way to spin-up ROS for my own projects.  As such, things are likely to change a lot.  I recommend forking the code for your own use.
* I'd love recommendations for updates and improvements/additional ROS packages as pull-requests.

Cheers,

- Todd