[//]: # (##############################################################################################)
[//]: # (Copyright Accenture. All Rights Reserved.)
[//]: # (SPDX-License-Identifier: Apache-2.0)
[//]: # (##############################################################################################)

# Networkmap Stats Site

This is a rough and ready example of the network map

## Issues

* Styling - some prettier colors
* Clusters and zoom, a click on the cluster should not zoom in too far
* Possible select box to choose your network
* Login page

## Building

Please replace *REPLACE_ME_GMAPS_KEY* with appropriate google maps API key in the following files before building
    
    - ./app/scripts/geoCode.js
    - ./app/components/Map/MyMap.js

This sub project gets built when running `mvn install` in the `networkmap` folder.
Alternatively, you can build this using following commands: 

```bash
npm install
npm run build
```