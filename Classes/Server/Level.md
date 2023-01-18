Level Class
===========

The `Level` class is used to handle the creation and spawning of obstacles for a specific level in the game. It contains methods for getting the markers for a specific set of obstacles (e.g. logs, trains, vehicles), adding a random amount of milliseconds to a given time, creating an obstacle at a specific marker, and getting all markers for the current level.

Properties
----------

-   `GameService`: a reference to the game's service.
-   `PlayerService`: a reference to the game's player service.
-   `CreateObstacleSignal`: a signal used to create obstacles for clients.
-   `CurrentLevel`: the current level number.
-   `CurrentLevelFolder`: the folder containing the assets for the current level.
-   `Players`: a table of players currently in the level.
-   `DelayRanges`: a table of delay ranges for each set of obstacles.
-   `TimeRanges`: a table of time ranges for each set of obstacles.
-   `Markers`: a table of markers for each set of obstacles.
-   `Spawned`: a table of booleans indicating if an obstacle has been spawned at a specific marker.
-   `Obstacles`: a table of obstacles for each set of markers.
-   `Connections`: a table of connections for the level.

Methods
-------

### `Level.new(GameService, CurrentLevel: number)`

This method creates a new instance of the `Level` class and sets its properties according to the provided `GameService` and `CurrentLevel` parameters.

### `Level:GetMarkerSet(SetName: string)`

This method gets all markers for a specific set of obstacles (e.g. logs, trains, vehicles) and adds them to the `Markers` property for that set. It also initializes the corresponding entry in the `Spawned` property as `false`.

### `Level:AddMillisecondsToTime(Time, TimeRange: TimeRange)`

This method adds a random amount of milliseconds (between 0 and 200) to the provided `Time` parameter. If the resulting time is less than the maximum time in the provided `TimeRange`, the new time is returned. Otherwise, a random amount of milliseconds is subtracted from the time.

### `Level:CreateObstacle(SetName: string, Marker: Model)`

This method creates an obstacle at the specified marker for a specific set of obstacles (e.g. logs, trains, vehicles). It first checks if an obstacle has already been spawned at the marker, and if not, it chooses a random obstacle from the set's obstacle folder, calculates a random time and delay within the set's specified time and delay ranges, and then signals clients to create the obstacle.

### `Level:GetAllMarkers()`

This method calls the `GetMarkerSet()` method for each set of obstacles (logs, trains, vehicles).