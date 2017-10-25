# jenkins-tools

contains all jenkins scripts used on jobs

To add new job/view with job dsl, we just need to add a .groovy script into this directory

# phenix-library
base on pipeline plugin (https://github.com/jenkinsci/pipeline-plugin/blob/master/TUTORIAL.md) and pipeline global library (https://github.com/jenkinsci/workflow-cps-global-lib-plugin) this project contains some groovy functions to use on Jenkinsfile.

Library are located on "vars" directory

workflow-cps-global-lib plugin share library script to all pipeline Jenkinsfile scripts. This plugin expose a git server on your jenkins instance. We should push our sharable scripts on this repo with a specific structure (see plugin doc https://github.com/jenkinsci/workflow-cps-global-lib-plugin). To synchronize files between the plugin repo and our github repo, a job called "jenkins-tools" take care of that task.

## Library

### commitStatus => commit status to github
```groovy
commitStatus("phenix", "JENKINS CHECK", "SUCCESS")
```

### sbt => use sbt tool to execute sbt tasks with specific confs and custom flags
```groovy
sbt {
  task = "clean test"
  sbtFlags="-J-XX:MaxMetaspaceSize=512m  -J-DHADOOP_USER_NAME=hdfs -Dphenix.pipeline.zookeeper.sessionTimeout=24000 -Dphenix.pipeline.zookeeper.connectionTimeout=24000"
  withTestReports = true
  infoEnv = false
}
```

### phenixGit => clean workspace and checkout repo from carrefour-group github  
```groovy
    phenixGit("je", "develop" )
```


### phenixJob => a job template

    - checkout from git
    - add pending commit status to github
    - call body closure
    - add job status as commit status to github

```groovy
phenixJob {
   project = "pipeline-archiver"
   recipient = "potokato@bobolawa.ga"
   branch = "SPECIAL-BRANCH"

   body = {
       stage 'nothing to do'
       echo 'sleeping'
    }
}
```

### sbtJob  => based on phenixJob, clean compile relaunch containers test integration tests stop containers and publish to nexus
```groovy
    sbtJob {
        project = "lahaie"
        recipient = "tata@tonon.fa"
        branch = "develop"
        sbtFlags = "-J-DMYENV"
        withItTest = true
        infoEnv = true
    }

```
### sbtAllJob => based on sbtJob with special flags to run it tests

### sbtAllLightJob => based on sbtJob with special flags to ignore it tests

### dcSbtAllJob => based on phenixJob  to run sbt commands on docker-compose. PS: docker-compose.yml is required

```groovy
  dcSbtAllJob {
      project = "transactions-extractor"
      recipient = "phenix_dev@carrefour.com"
      withItTest=true
      sbtFlags = "-J-DMYENV"
  }
```

### dockerSbtAllJob => based on phenixJob to run sbt command on docker

```groovy
  dockerSbtAllJob {
      project = "transactions-extractor"
      recipient = "phenix_dev@carrefour.com"
      withItTest=true
      sbtFlags = "-J-DMYENV"
  }

```
### swaggerJob => simple template to generate swagger. checkout source code and generate swagger

```groovy
    swaggerJob {
        project= "je"
        name="je"
        path="je-api/src/main/api/je_search-v*.yaml"
    }
```


## Depend on
To depend a job to another project builds we just have to add a comment like that:

```groovy
/*
 * @dependOn job1,job2,job3
*/

```

## Examples

## without integration test
```groovy
node("slave") {
    sbtAllLightJob {
        project="lahaie"
        recipient="phenix_dev@carrefour.com"
    }
}
```

## with integration test
```groovy
node("slave") {
    sbtAllJob {
        project="phenix"
        recipient="phenix_dev@carrefour.com"
        sbtFlags="-J-XX:MaxMetaspaceSize=512m  -J-DHADOOP_USER_NAME=hdfs -Dphenix.pipeline.zookeeper.sessionTimeout=24000 -Dphenix.pipeline.zookeeper.connectionTimeout=24000"
    }
}
```

## with dependencies
```groovy
/*
 * @dependOn job1,job2
*/
node("slave") {
   echo "something"
   sh "echo another thing"
}
```

## freestyle
```groovy
node("slave") {
   stage "on est bon! on est bon!"
   git url: "git@github.com:Carrefour-Group/lahaie.git", branch: "develop"
   sbt {
       task = "clean compile"
   }
   echo "chakalala!"
}
```
## generate swagger and build sbt

```groovy

    node("doc") {
        swaggerJob {
            project= "je"
            name="je"
            path="je-api/src/main/api/je_search-v*.yaml"
        }
    }

    node("slave") {
        sbtAllLightJob{
            project= "je"
            recipient= "bob_the_sponge@carrefour.com"
        }

    }
```
