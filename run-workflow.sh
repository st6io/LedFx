#!/bin/bash

# Variables
WORKFLOW_ID="ci-build.yml"
BRANCH="main"

# Function to trigger a workflow and wait for its completion
trigger_and_wait_workflow() {
    # Trigger the workflow
    gh workflow run $WORKFLOW_ID --ref $BRANCH

    # Get the run ID of the last run for the workflow
    RUN_ID=$(gh run list -w $WORKFLOW_ID --limit 1 --json databaseId -q '.[0].databaseId')

    # Wait for the workflow to complete
    while [[ $(gh run view $RUN_ID --json status -q '.status') != "completed" ]]; do
        echo "Waiting for the workflow to complete..."
        sleep 10
    done

    # Check the conclusion of the workflow
    CONCLUSION=$(gh run view $RUN_ID --json conclusion -q '.conclusion')
    echo "Workflow completed with conclusion: $CONCLUSION"

    echo $CONCLUSION
}

# First workflow run
CONCLUSION=$(trigger_and_wait_workflow)

echo $CONCLUSION

# If the first run succeeded, trigger the workflow again
if [[ $CONCLUSION == "success" ]]; then
    echo "First workflow run succeeded, triggering the workflow again."
    trigger_and_wait_workflow
else
    echo "First workflow run did not succeed. Exiting."
fi
