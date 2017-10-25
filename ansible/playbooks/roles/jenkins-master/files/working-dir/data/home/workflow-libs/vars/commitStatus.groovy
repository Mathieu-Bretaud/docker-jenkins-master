/**
 * push the specified status to github as commit status
 * @param repo git repo
 * @param type type of check
 * @param status [success,failure]
 * @return
 */
def call(project, type, status) {
    def repo = "Carrefour-Group/${project}"
    def token= "${env.DATASCIENCE_GIT_TOKEN}"
    def url="https://api.github.com/repos/${repo}/statuses/`git rev-parse HEAD`?access_token=${token}"
    def json="{\\\"state\\\": \\\"${status}\\\", \\\"context\\\": \\\"${type}\\\", \\\"description\\\": \\\"${type}\\\", \\\"target_url\\\": \\\"${env.BUILD_URL}\\\"}"
    sh "curl --write-out %{http_code} --silent -x ${env.DATASCIENCE_HTTPS_PROXY} \"${url}\" -H \"Content-Type: application/json\"  -X POST -d \"${json}\" "
}
