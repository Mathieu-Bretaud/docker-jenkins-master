/**
 * deal with github template
 * @param body groovy script to execute
 * @return nothing
 */
def call(mybody) {
    def config = [:]
    mybody.resolveStrategy = Closure.DELEGATE_FIRST
    mybody.delegate = config
    mybody()

    currentBuild.result = "SUCCESS"

    def gitBranch = config.branch ?: "${env.GIT_BRANCH}"

    try {
        /**
        * Get project from Github of the specified branch
        **/
        datascienceGit(config.project, gitBranch)

        /**
        * Call the body
        **/
        config.body.call()

        if (gitBranch == "${env.GIT_BRANCH}" ){
            sh 'git config --global user.email "mathieu_bretaud@carrefour.com"'
            sh 'git config --global user.name "Mathieu Bretaud"'
            sh "git checkout ${env.GIT_BRANCH}"
            sh "git push origin ${env.GIT_BRANCH}:${env.GIT_BRANCH_TO_PUSH}"
        }
    } catch (error) {
        currentBuild.result = "FAILURE"
        throw error;
    } finally {
        try{
            config.finallyBody.call()
        } catch (error) {
            //AH?
        }
    }
}
