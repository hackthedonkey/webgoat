// Generate a random id for pod label to avoid waiting for executor. Just start create pod right away.
// See this workaround from issue: https://issues.jenkins.io/browse/JENKINS-39801
import static java.util.UUID.randomUUID
def uuid = randomUUID() as String
def myid = uuid.take(8)

pipeline {
  environment {
    APP_VER = "v1.0.${BUILD_ID}"
    // HARBOR_URL = ""
    DEPLOY_GITREPO_USER = "hackthedonkey"
    DEPLOY_GITREPO_URL = "github.com/${DEPLOY_GITREPO_USER}/spring-petclinic-helmchart.git"
    DEPLOY_GITREPO_BRANCH = "main"
    DEPLOY_GITREPO_TOKEN = credentials('github')
  }
  agent any
  stages {
    stage('Building Image') {
      steps{    
          sh """
            docker build -t harbor.lazydonkey.co.kr/webgoat/webgoat-8.0:v${env.BUILD_ID} .
            """    
      }
    }
    stage('Scan Local image') {
      steps {
        neuvector registrySelection: 'Local', repository: 'harbor.lazydonkey.co.kr/webgoat/webgoat-8.0', scanLayers: true, standaloneScanner: true, tag: 'v$BUILD_ID'
      }
    }
    stage('Docker Login') {
      steps{            
          sh """
            docker login harbor.lazydonkey.co.kr -u admin -p Root12345
            """
      }
    }
    stage('Docker Image Push') {
      steps{            
          sh """
            docker push harbor.lazydonkey.co.kr/webgoat/webgoat-8.0:v${env.BUILD_ID}
            """
      }
    }
    stage('Scan image') {
      steps {
        neuvector registrySelection: 'harbor', repository: 'webgoat/webgoat-8.0', scanLayers: true, tag: 'v$BUILD_ID'
      }
    }
  }
}
