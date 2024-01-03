# Build Component

This action will create a new build of a Nuon component.

This is a composite action that uses the [Nuon CLI](https://docs.nuon.co/quickstart#installing-the-cli-and-terraform-provider). If you need a more sophisticated integration, you can use the CLI directly from your Github Action workflows (or any other automation platform.)

Refer to [our docs](https://docs.nuon.co) for more information on builds, releases, and the Nuon platform generally.

## Inputs

- org_id: Your Nuon org ID.
- api_token: A valid Nuon API token for your org.
- component_id: The ID of the component you want to update and deploy.

## Outputs

- build_id: The ID of the build that was created.

## Example Usage

The typical use-case for this action is to run it when updates are made to your component config or source code. For example:

```yaml
on:
  push:
    branches:
      - main
    paths:
      - 'components/my-component/**'
      - 'nuon/my-component.tf'
jobs:
  deploy:
    runs-on: ubuntu-latest
    name: Deploy
    steps:
      - name: Checkout code
        id: checkout
        uses: actions/checkout@v2
      - name: Build component
        id: build
        uses: nuonco/actions-build@v1
        with:
          api_token: ${{ secrets.API_TOKEN }}
          org: orgzblonf9hol7jq92vkdriio4
          component_id: cmpurwbae16j02k55607o2k6wb
```
