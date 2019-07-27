# ArmA 3 Linux Server Installer
A script that installs an ArmA 3 server onto a Linux machine.

## Current Features
* Automatically check for any required dependencies.
* Download, install, and configure SteamCMD.
* Download and install the ArmA 3 server.
* Create various instances symlinked to the main server install.

## Planned Features
* Implement default server configurations.
* Implement a start script into every server instance.
* Automatically load mods loaded into the instances `mods/` folder upon server launch.
* Automatic creation of a `systemd` service for each instance.
