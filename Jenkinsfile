node {

    def application='citibank'
    def dockerhubaccountid = 'tridevg'

    // prepare jar file and run docker steps
    stage('clone repo') {
      git branch: 'main', url: 'https://github.com/adsnjhfyeqw231eas/Banking-Microservices-app.git'
    }
    stage('maven test') {
      sh 'mvn test'
    }
    stage('maven build') {
      sh 'mvn install'
    }
    stage('build image') {
      application=docker.build("${dockerhubaccountid}/${application}:${BUILD_NUMBER}")
    }
    stage('push image') {
      withDockerRegistry([credentialsId: 'dockercred', url:'']) {
        application.push()
        application.push('latest')
      }
    }

    // connect to k8s cluster
    kubeconfig(credentialsId: 'kubernetes', serverUrl: 'https://b086740de9fa6c56d0617b18dab94eed.gr7.us-east-1.eks.amazonaws.com/') {
      stage('create Deployment,service,ingress') {
        sh "kubectl apply -f bankapp.yaml"
      }
      stage('verify deployment') {
        sh "echo 'wait for ALB to completly provision in AWS..' && sleep 60"
        sh 'kubectl get deploy -n citibank'
        sh 'kubectl describe ingress ingress-citibank -n citibank'
      }
    }  // end of k8s credentials block

} // end of jenkinsfile
