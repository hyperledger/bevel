## ROLE: configtx
These tasks create the configtx.yaml file as the requirements mentioned in network.yaml 
file. The configtx.yaml file is consumed by the configtxgen binary to generate the 
genesis block and channels.

### Tasks
(Variables with * are fetched from the playbook which is calling this role)
#### 1. Remove old configtx file
This task removes the old configtc file.
##### Input Variables

    *config_file: The path of file.
    state: touch( i.e. It should be deleted if found)
#### 2. Create configtx file
This task removes the old configtx file.
##### Input Variables

    *config_file: The path of file.
    state: absent( i.e. It will create a new empty file)
    
#### 3. Adding init patch to configtx.yaml
This task adds initial path to configtx.
##### Input Variables

    *config_file: The path of file.
**blockinfile**: Adds a block in file
**dest**: The destination path for file
**block**: Defines a block
**marker**: Adds a marker after patch. Here '#'

#### 4. Adding organization patch to configtx.yaml
This task Adds organization patch to configtx.yaml.
##### Input Variables

    *config_file: The path of file.
    component_name: The name of resource
    component_ns: The namespace of resource
    component_type: The type of resource
**blockinfile**: Adds a block in file
**dest**: The destination path for file
**block**: Defines a block
**marker**: Adds a marker after patch. Here '#'
**loop**: Specify loop condition, here it loops over organisation patch in network.yaml 

#### 5. Adding orderer patch to configtx.yaml
This task Adds organization patch to configtx.yaml.
##### Input Variables

    *config_file: The path of file.
    orderer: The name of orderer
    component_ns: The namespace of resource
    consensus: The details of consensus
**blockinfile**: Adds a block in file
**dest**: The destination path for file
**block**: Defines a block
**marker**: Adds a marker after patch. Here '#'
**loop**: Specify loop condition, here it loops over organisation patch in network.yaml 
**when**: It runs when *organisation type*is orderer.

#### 6. Adding profile patch to configtx.yaml
This task adds profile patch to configtx.
##### Input Variables

    *config_file: The path of file.
**blockinfile**: Adds a block in file
**dest**: The destination path for file
**block**: Defines a block
**marker**: Adds a marker after patch. Here '#'
**when**: It runs when *network.channels* is defined.