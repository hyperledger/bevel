### Hyperledger Indy CLI Dockerfile

Add the file to the respective directory. Go to that directory.
###### Steps to run
1. Build the file
                    
        docker build -t <imagename>:<imagetag> .
2. To check the successful build. (It should list the images running)

        docker images
3. To run the cli container

        docker run -a stdin -a stdout -i -t <imageid>
4. Enter Indy CLI

        indy-cli
5. Test CLI
        
        help
This will execute the help command of Indy.