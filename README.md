# Teleport to Apartments

A quick project for FiveM to teleport to apartments floor.

This script draw a marker on the floor outside of the building and then inside building for each floor.

**There is only 3 apartments in this script for only 1 building for exemple**
You have to setup other apartments.

### INSTALLATION

* Copy gk_appartements in your ressources folder.
* Add gk_appartements to your autostart ressources in citmp-server.yml file.
* You can edit appartements.lua file to add many positions to apartments following this format :


```LUA
appartements = {
	{ 
		ext = {name = "Milton Drive", x = -775.17, y = 312.01, z = 84.658, h = 183.14},
		appts = {
			{name = "Floor 1", x = -774.67, y = 331.566, z = 158.981, h = 351.82},
			{name = "Floor 2", x = -774.168, y = 331.165, z = 206.611, h = 351.82},
			{name = "Floor 3", x = -785.304, y = 323.667, z = 210.987, h = 268.62}
		}
	}
}
```

* **name** : Names will appear on the bottom right of the screen after teleport.
* **x, y, z** : Positions for teleporter markers.
* **h** : Heading direction of your player.


* **ext** : Outstide position for marker
* **appts** : Floors Marker position. One line by floor.

If there is **more than one floor**, a menu will show to chosse which floor you want to teleport to,
and if only one floor, you'll be teleported directly to appartment.

**You Don't Need to Edit Menu. It will automatically take names from 'name' fields.**

![Outside1](http://i.imgur.com/CTnD9ZH.jpg)
![Outside2](http://i.imgur.com/lAzczA2.jpg)
![Inside](http://i.imgur.com/nWnV4gT.jpg)
