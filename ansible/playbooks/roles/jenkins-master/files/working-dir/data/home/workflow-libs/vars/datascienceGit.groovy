def call(project, branch) {

    def gitProject = project ?: "${env.REPO}"
    def repo = "Mathieu-Bretaud/${gitProject}"
    def gitBranch = branch ?: "${env.GIT_BRANCH}"

    sh 'find . -mindepth 1 -maxdepth 1 -exec rm -rf {} \\;'
    git url: "git@github.com:${repo}.git", branch: gitBranch

}
