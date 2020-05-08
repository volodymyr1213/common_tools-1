@Library('CommonLib@feature/cluster-common') _
def common = new com.lib.JenkinsClusterCommonDeploy()
common.runPipeline()