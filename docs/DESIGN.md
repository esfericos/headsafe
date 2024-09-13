# System Architecture

## Components
The full system is made of three components: A computer node responsible for the image capturing routine; A web server that stores incoming images and a mobile application that displays them: 

```mermaid
flowchart TB
        subgraph Camera Node
            py[Image Detection Service - Thread 1]
            py --> no[Sender]
        end
        subgraph server
        no -- HTTP --> list[Http_Listener]
        list --> store[Write data routine]
        store -- oneshot ACK --> cv[Base64 conversion routine]
        end
        subgraph application
            cv -- HTTP --> Display
        end

```
