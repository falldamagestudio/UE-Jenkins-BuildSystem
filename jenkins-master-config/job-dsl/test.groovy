pipelineJob('default-agent') {
    definition {
        cps {
            script(readFileFromWorkspace("pipeline-scripts/test.groovy"))
        }
    }
}