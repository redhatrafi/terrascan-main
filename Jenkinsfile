pipeline {
    agent any
    environment {
        GITHUB_USERNAME = credentials('GITHUB_USERNAME')
        GITHUB_TOKEN = credentials('GITHUB_TOKEN')
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/feature']],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[url: 'https://github.com/andalike/terrascan']]
                ])
            }
        }
        stage('Install Dependencies') {
            steps {
                sh "chmod +x install-tools.sh"
                sh 'yes | ./install-tools.sh ${WORKSPACE}/tools'
            }
        }
        stage('Install TfLint') {
            steps {
                sh "chmod +x tflint.sh"
                sh "./tflint.sh ${WORKSPACE}/tools"
            }
        }
        stage('Install TfScan') {
            steps {
                sh "chmod +x tfsec-scan.sh"
                sh "yes | ./tfsec-scan.sh ${WORKSPACE}/tools"
            }
        }
        stage('Raise Pull Request') {
            steps {
                script {
                    // Define your GitHub repository and branch names
                    def githubRepo = 'andalike/terrascan'
                    def baseBranch = 'main'
                    def featureBranch = 'feature'
                    
                    // Define a unique tag name based on the current timestamp
                    def timestamp = new Date().format('yyyyMMdd_HHmmss')
                    def tag = "Automated_PR_${timestamp}"
                    
                    // Define the pull request body with a title and body
                    def pullRequestBody = [
                        title: 'Automated Pull Request',
                        body: 'This pull request was created automatically.'
                    ]
                    
                    // Create a JSON payload for the API request to create a tag
                    def tagPayload = [
                        ref: "refs/tags/${tag}",
                        sha: sh(script: 'git rev-parse HEAD', returnStdout: true).trim(),
                        message: "Creating tag ${tag}",
                        tagger: [
                            name: GITHUB_USERNAME,
                            email: "${GITHUB_USERNAME}@users.noreply.github.com",
                            date: new Date().toString()
                        ]
                    ]
                    
                    // Convert the tag payload to JSON
                    def jsonTagPayload = groovy.json.JsonOutput.toJson(tagPayload)
                    
                    // Use curl to create the Git tag
                    sh """
                        curl -X POST -u ${GITHUB_USERNAME}:${GITHUB_TOKEN} \
                        -H 'Content-Type: application/json' \
                        -d '${jsonTagPayload}' \
                        https://api.github.com/repos/${githubRepo}/git/tags
                    """
                    
                    // Create a reference to the tag (GitHub tag)
                    sh "curl -X POST -u ${GITHUB_USERNAME}:${GITHUB_TOKEN} \
                        -d '{}' \
                        https://api.github.com/repos/${githubRepo}/git/refs -H 'Content-Type: application/json' \
                        --data '{\"ref\":\"refs/tags/${tag}\",\"sha\":\"${tagPayload.sha}\"}'"
                    
                    // Define the pull request body with the updated title
                    pullRequestBody.title = "Automated Pull Request with Tag: ${tag}"
                    
                    // Create a JSON payload for the API request to create the pull request
                    def pullRequestPayload = [
                        title: pullRequestBody.title,
                        body: pullRequestBody.body,
                        head: featureBranch,
                        base: baseBranch
                    ]
                    
                    // Convert the pull request payload to JSON
                    def jsonPullRequestPayload = groovy.json.JsonOutput.toJson(pullRequestPayload)
                    
                    // Use curl to create the pull request
                    sh """
                        curl -X POST -u ${GITHUB_USERNAME}:${GITHUB_TOKEN} \
                        -H 'Content-Type: application/json' \
                        -d '${jsonPullRequestPayload}' \
                        https://api.github.com/repos/${githubRepo}/pulls
                    """
                }
            }
        }
    }
}
